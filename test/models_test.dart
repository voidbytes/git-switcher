import 'package:flutter_test/flutter_test.dart';
import 'package:git_switcher/models/app_config.dart';
import 'package:git_switcher/models/backup_item.dart';
import 'package:git_switcher/models/last_switch_snapshot.dart';
import 'package:git_switcher/models/profile.dart';

void main() {
  group('Profile.copyWith', () {
    test('仅覆盖传入字段，其余保持不变', () {
      final p = Profile(
        name: 'a',
        gitconfig: 'g1',
        useSsh: true,
        sshconfig: 's1',
      );
      final p2 = p.copyWith(name: 'b');
      expect(p2.id, p.id);
      expect(p2.name, 'b');
      expect(p2.gitconfig, 'g1');
      expect(p2.useSsh, true);
      expect(p2.sshconfig, 's1');
    });
  });

  group('Profile.buildSshConfigFromLegacy', () {
    test('github + 443 → HostName ssh.github.com', () {
      final content = Profile.buildSshConfigFromLegacy(
        host: 'github.com',
        identityFile: '~/.ssh/id_work',
        sshPort: 443,
      );
      expect(content, contains('Host github.com'));
      expect(content, contains('HostName ssh.github.com'));
      expect(content, contains('User git'));
      expect(content, contains('Port 443'));
      expect(content, contains('IdentityFile ~/.ssh/id_work'));
    });

    test('非 github 端口不改变 HostName', () {
      final content = Profile.buildSshConfigFromLegacy(
        host: 'gitlab.com',
        identityFile: '~/.ssh/id_work',
        sshPort: 22,
      );
      expect(content, contains('HostName gitlab.com'));
      expect(content, contains('Port 22'));
    });

    test('无端口时不生成 Port 行', () {
      final content = Profile.buildSshConfigFromLegacy(
        host: 'github.com',
        identityFile: '~/.ssh/id_work',
      );
      expect(content, isNot(contains('Port')));
    });
  });

  group('Profile.toString', () {
    test('包含 id 与 name', () {
      final p = Profile(name: 'work', gitconfig: '[user]');
      expect(p.toString(), contains('work'));
      expect(p.toString(), contains(p.id));
    });
  });

  group('AppConfig.copyWith', () {
    test('clearSnapshot 清除快照并保留其他字段', () {
      const config = AppConfig(
        activeProfileId: 'p1',
        lastSwitchSnapshot: LastSwitchSnapshot(switchedAt: 't'),
      );
      final cleared = config.copyWith(clearSnapshot: true);
      expect(cleared.lastSwitchSnapshot, isNull);
      expect(cleared.activeProfileId, 'p1');
      expect(cleared.enableBackup, true);
    });

    test('activeProfileId 可显式置空', () {
      const config = AppConfig(activeProfileId: 'p1');
      final cleared = config.copyWith(activeProfileId: null);
      expect(cleared.activeProfileId, isNull);
    });

    test('非 clearSnapshot 时保留原快照', () {
      const snap = LastSwitchSnapshot(switchedAt: 't');
      const config = AppConfig(lastSwitchSnapshot: snap);
      expect(config.copyWith().lastSwitchSnapshot, snap);
      expect(
        config.copyWith(lastSwitchSnapshot: null).lastSwitchSnapshot,
        isNull,
      );
    });

    test('logLevel 与 sshKeygenPath 可更新', () {
      const config = AppConfig(
        logLevel: 'info',
        sshKeygenPath: '/usr/bin/ssh-keygen',
      );
      final updated = config.copyWith(
        logLevel: 'debug',
        sshKeygenPath: '/custom/ssh-keygen',
      );
      expect(updated.logLevel, 'debug');
      expect(updated.sshKeygenPath, '/custom/ssh-keygen');
    });
  });

  group('AppConfig 序列化', () {
    test('toJson / fromJson 往返一致（含 logLevel/sshKeygenPath）', () {
      const config = AppConfig(
        enableBackup: true,
        maxBackupCount: 10,
        minimizeToTray: true,
        languageCode: 'en',
        sshKeygenPath: '/custom/bin/ssh-keygen',
        logLevel: 'warn',
        onboarded: true,
      );
      final restored = AppConfig.fromJson(config.toJson());
      expect(restored.enableBackup, true);
      expect(restored.maxBackupCount, 10);
      expect(restored.minimizeToTray, true);
      expect(restored.languageCode, 'en');
      expect(restored.sshKeygenPath, '/custom/bin/ssh-keygen');
      expect(restored.logLevel, 'warn');
      expect(restored.onboarded, true);
    });

    test('缺失字段回退默认值', () {
      final config = AppConfig.fromJson(const {});
      expect(config.logLevel, isNull);
      expect(config.sshKeygenPath, isNull);
      expect(config.enableBackup, true);
      expect(config.onboarded, false);
    });
  });

  group('BackupItem 序列化', () {
    test('toJson / fromJson 往返一致', () {
      final item = BackupItem(
        timestamp: '123',
        type: 'git',
        filename: 'gitconfig.123.bak',
        content: 'abc',
      );
      final restored = BackupItem.fromJson(item.toJson());
      expect(restored.timestamp, '123');
      expect(restored.type, 'git');
      expect(restored.filename, 'gitconfig.123.bak');
      expect(restored.content, 'abc');
    });

    test('缺失 content 时为 null', () {
      final restored = BackupItem.fromJson({
        'timestamp': '1',
        'type': 'ssh',
        'filename': 'config.1.bak',
      });
      expect(restored.content, isNull);
    });
  });

  group('LastSwitchSnapshot 序列化', () {
    test('toJson / fromJson 往返一致', () {
      const snap = LastSwitchSnapshot(
        profileId: 'p1',
        gitconfig: 'git',
        sshconfig: 'ssh',
        switchedAt: '2026-01-01T00:00:00',
      );
      final restored = LastSwitchSnapshot.fromJson(snap.toJson());
      expect(restored.profileId, 'p1');
      expect(restored.gitconfig, 'git');
      expect(restored.sshconfig, 'ssh');
      expect(restored.switchedAt, '2026-01-01T00:00:00');
    });

    test('缺失字段使用默认值', () {
      final restored = LastSwitchSnapshot.fromJson(const {});
      expect(restored.profileId, isNull);
      expect(restored.gitconfig, isNull);
      expect(restored.sshconfig, isNull);
      expect(restored.switchedAt, '');
    });
  });
}
