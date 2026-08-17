import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:git_switcher/models/profile.dart';
import 'package:git_switcher/services/config_service.dart';
import 'package:git_switcher/services/file_service.dart';
import 'package:git_switcher/services/git_service.dart';
import 'package:git_switcher/services/path_service.dart';

import 'helpers.dart';

void main() {
  late Directory home;
  late PathService pathService;
  final gitService = GitService.instance;
  final configService = ConfigService.instance;

  setUp(() async {
    home = await setUpIsolatedHome();
    pathService = PathService.instance;
  });

  tearDown(() async {
    await tearDownHome(home);
  });

  Profile gitOnlyProfile({String name = 'new', String email = 'new@x.com'}) {
    return Profile(
      name: name,
      gitconfig: '[user]\n  name = $name\n  email = $email',
      useSsh: false,
    );
  }

  Future<File> createKey(String relPath) async {
    final key = await writeHome(home, relPath, 'test private key');
    await Process.run('chmod', ['600', key.path]);
    return key;
  }

  group('switchProfile - 切换配置（整文件）', () {
    test('纯 Git 配置切换成功并标记活跃', () async {
      await writeHome(
        home,
        '.gitconfig',
        '[user]\n  name = old\n  email = old@x.com\n',
      );
      final profile = gitOnlyProfile(name: 'Alice', email: 'alice@x.com');

      final result = await gitService.switchProfile(profile, false, 5);

      expect(result.success, true);
      expect(configService.appConfig.activeProfileId, profile.id);
      final written = await File(pathService.gitConfigPath).readAsString();
      expect(written, contains('name = Alice'));
      expect(written, contains('email = alice@x.com'));
    });

    test('SSH 配置整文件写入成功', () async {
      await writeHome(home, '.gitconfig', '[user]\n  name = old\n');
      final key = await createKey('.ssh/id_work');
      final profile = Profile(
        name: 'work',
        gitconfig: '[user]\n  name = work\n  email = work@x.com',
        useSsh: true,
        sshconfig: '''
Host github.com
  HostName ssh.github.com
  User git
  Port 443
  IdentityFile ${key.path}
''',
      );

      final result = await gitService.switchProfile(profile, false, 5);

      expect(result.success, true);
      expect(configService.appConfig.activeProfileId, profile.id);
      final sshContent = await File(pathService.sshConfigPath).readAsString();
      expect(sshContent, contains('Host github.com'));
      expect(sshContent, contains('IdentityFile ${key.path}'));
    });

    test('SSH 私钥不存在时中止切换', () async {
      await writeHome(home, '.gitconfig', '[user]\n  name = old\n');
      final profile = Profile(
        name: 'work',
        gitconfig: '[user]\n  name = work\n',
        useSsh: true,
        sshconfig: 'Host github.com\n  IdentityFile ${home.path}/.ssh/nonexistent',
      );

      final result = await gitService.switchProfile(profile, false, 5);

      expect(result.success, false);
      expect(result.messages.any((m) => m.contains('nonexistent')), true);
      final gitContent = await File(pathService.gitConfigPath).readAsString();
      expect(gitContent, contains('name = old'));
      expect(configService.appConfig.activeProfileId, isNull);
    });

    test('SSH 写入失败时回滚已写入的 Git 配置', () async {
      // Windows 无 Unix 目录只读权限语义，无法模拟写入失败，跳过。
      if (Platform.isWindows) return;
      await writeHome(home, '.gitconfig', '[user]\n  name = old\n');
      final key = await createKey('.ssh_key');
      final sshDir = Directory('${home.path}/.ssh');
      await sshDir.create();
      await Process.run('chmod', ['0555', sshDir.path]);

      final profile = Profile(
        name: 'work',
        gitconfig: '[user]\n  name = work\n',
        useSsh: true,
        sshconfig: 'Host github.com\n  IdentityFile ${key.path}',
      );

      final result = await gitService.switchProfile(profile, false, 5);

      expect(result.success, false);
      final gitContent = await File(pathService.gitConfigPath).readAsString();
      expect(gitContent, contains('name = old'));
      expect(configService.appConfig.activeProfileId, isNull);
      expect(File(pathService.sshConfigPath).existsSync(), false);
    });

    test('启用备份时切换前生成 .bak 备份', () async {
      final oldGit = '[user]\n  name = old\n  email = old@x.com\n';
      await writeHome(home, '.gitconfig', oldGit);
      final profile = gitOnlyProfile();

      await gitService.switchProfile(profile, true, 5);

      final backupDir = Directory(pathService.gitBackupDir);
      final backups = backupDir
          .listSync()
          .where((f) => f.path.endsWith('.bak'))
          .toList();
      expect(backups.length, 1);
      expect(File(backups.first.path).readAsStringSync(), oldGit);
    });
  });

  group('findActiveProfile - 活跃配置识别', () {
    test('Git 配置匹配时返回对应 Profile', () async {
      await writeHome(
        home,
        '.gitconfig',
        '[user]\n  name = Alice\n  email = alice@x.com\n',
      );
      await configService.addProfile(
        gitOnlyProfile(name: 'Alice', email: 'alice@x.com'),
      );
      final active = await gitService.findActiveProfile();
      expect(active, isNotNull);
      expect(active!.name, 'Alice');
    });

    test('无 Git 配置时返回 null', () async {
      await configService.addProfile(gitOnlyProfile());
      final active = await gitService.findActiveProfile();
      expect(active, isNull);
    });

    test('Git 配置不匹配时返回 null', () async {
      await writeHome(home, '.gitconfig', '[user]\n  name = Bob\n');
      await configService.addProfile(gitOnlyProfile(name: 'Alice'));
      final active = await gitService.findActiveProfile();
      expect(active, isNull);
    });

    test('SSH 整文件匹配时返回 Profile', () async {
      await writeHome(home, '.gitconfig', '[user]\n  name = work\n');
      final sshconfig = 'Host github.com\n  IdentityFile ~/.ssh/id_work\n';
      await writeHome(home, '.ssh/config', sshconfig);
      await configService.addProfile(
        Profile(
          name: 'work',
          gitconfig: '[user]\n  name = work\n',
          useSsh: true,
          sshconfig: sshconfig,
        ),
      );
      final active = await gitService.findActiveProfile();
      expect(active, isNotNull);
      expect(active!.name, 'work');
    });

    test('SSH 整文件不匹配时返回 null', () async {
      await writeHome(home, '.gitconfig', '[user]\n  name = work\n');
      await writeHome(
        home,
        '.ssh/config',
        'Host github.com\n  IdentityFile ~/.ssh/id_other\n',
      );
      await configService.addProfile(
        Profile(
          name: 'work',
          gitconfig: '[user]\n  name = work\n',
          useSsh: true,
          sshconfig: 'Host github.com\n  IdentityFile ~/.ssh/id_work\n',
        ),
      );
      final active = await gitService.findActiveProfile();
      expect(active, isNull);
    });
  });

  group('undoLastSwitch - 一键撤销', () {
    test('撤销后恢复切换前内容并清除快照', () async {
      final oldGit = '[user]\n  name = old\n';
      await writeHome(home, '.gitconfig', oldGit);
      final profile = gitOnlyProfile(name: 'Alice');
      await gitService.switchProfile(profile, false, 5);
      expect(File(pathService.gitConfigPath).readAsStringSync(), contains('Alice'));

      final (done, _) = await gitService.undoLastSwitch();
      expect(done, true);
      expect(File(pathService.gitConfigPath).readAsStringSync(), oldGit);
      expect(configService.appConfig.lastSwitchSnapshot, isNull);
    });

    test('无快照时不做撤销', () async {
      final (done, error) = await gitService.undoLastSwitch();
      expect(done, false);
      expect(error, isNull);
    });
  });

  group('getConfigDiff - 行级差异', () {
    test('Git 差异包含修改行', () async {
      await writeHome(
        home,
        '.gitconfig',
        '[user]\n  name = Bob\n  email = bob@x.com\n',
      );
      final profile = gitOnlyProfile(name: 'Alice', email: 'alice@x.com');
      final result = await gitService.getConfigDiff(profile);
      final gitDiff = (result['gitDiff'] as List).cast<ConfigDiffEntry>();
      expect(gitDiff, isNotEmpty);
    });

    test('完全匹配时无差异', () async {
      await writeHome(
        home,
        '.gitconfig',
        '[user]\n  name = Alice\n  email = alice@x.com\n',
      );
      final profile = gitOnlyProfile(name: 'Alice', email: 'alice@x.com');
      final result = await gitService.getConfigDiff(profile);
      final gitDiff = (result['gitDiff'] as List).cast<ConfigDiffEntry>();
      expect(gitDiff, isEmpty);
    });
  });

  group('switchProfile - 权限警告与异常场景', () {
    test('私钥权限非 600 时仅警告且切换成功', () async {
      if (Platform.isWindows) return;
      await writeHome(home, '.gitconfig', '[user]\n  name = old\n');
      final key = await createKey('.ssh/id_perm');
      await Process.run('chmod', ['644', key.path]);
      final profile = Profile(
        name: 'work',
        gitconfig: '[user]\n  name = work\n',
        useSsh: true,
        sshconfig: 'Host github.com\n  IdentityFile ${key.path}',
      );

      final result = await gitService.switchProfile(profile, false, 5);

      expect(result.success, true);
      expect(result.messages.any((m) => m.contains('600')), true);
    });

    test('无 .gitconfig 时也能成功写入', () async {
      final profile = gitOnlyProfile(name: 'Alice');

      final result = await gitService.switchProfile(profile, false, 5);

      expect(result.success, true);
      expect(File(pathService.gitConfigPath).existsSync(), true);
      expect(
        File(pathService.gitConfigPath).readAsStringSync(),
        contains('Alice'),
      );
    });

    test('useSsh=false 时不影响现有 SSH 配置', () async {
      await writeHome(home, '.gitconfig', '[user]\n  name = old\n');
      await writeHome(
        home,
        '.ssh/config',
        'Host github.com\n  User git\n  IdentityFile ~/.ssh/id_keep\n',
      );
      final profile = gitOnlyProfile(name: 'Alice');

      await gitService.switchProfile(profile, false, 5);

      final sshContent = await File(pathService.sshConfigPath).readAsString();
      expect(sshContent, contains('id_keep'));
    });
  });

  group('verifyAfterSwitch - 切换后验证', () {
    test('Git 用户信息匹配时通过', () async {
      final profile = gitOnlyProfile(name: 'Alice', email: 'alice@x.com');
      await writeHome(
        home,
        '.gitconfig',
        '[user]\n  name = Alice\n  email = alice@x.com\n',
      );

      final result = await gitService.verifyAfterSwitch(profile);

      expect(result['verified'], true);
    });

    test('Git 用户信息不匹配时失败', () async {
      final profile = gitOnlyProfile(name: 'Alice', email: 'alice@x.com');
      await writeHome(
        home,
        '.gitconfig',
        '[user]\n  name = Bob\n  email = bob@x.com\n',
      );

      final result = await gitService.verifyAfterSwitch(profile);

      expect(result['verified'], false);
      expect(result['reason'], isNotEmpty);
    });

    test('useSsh 且无具体 Host 时跳过网络验证并放行', () async {
      final profile = Profile(
        name: 'work',
        gitconfig: '[user]\n  name = work\n  email = work@x.com',
        useSsh: true,
        sshconfig: 'Host *\n  User git\n  IdentityFile ~/.ssh/id_work',
      );
      await writeHome(
        home,
        '.gitconfig',
        '[user]\n  name = work\n  email = work@x.com\n',
      );

      final result = await gitService.verifyAfterSwitch(profile);

      expect(result['verified'], true);
    });
  });

  group('backupCurrentConfig - 手动备份', () {
    test('Git 与 SSH 均存在时备份两者', () async {
      await writeHome(home, '.gitconfig', '[user]');
      await writeHome(home, '.ssh/config', 'Host github.com\n');

      final messages = await gitService.backupCurrentConfig();

      expect(messages.any((m) => m.contains('Git')), true);
      expect(messages.any((m) => m.contains('SSH')), true);
    });

    test('无配置可备份时提示', () async {
      final messages = await gitService.backupCurrentConfig();
      expect(messages.any((m) => m.contains('Nothing')), true);
    });
  });

  group('isUnmanagedSshConfig - 非工具管理判断', () {
    test('当前 SSH 配置不在任何 Profile 中时返回 true', () async {
      await writeHome(home, '.ssh/config', 'Host something\n  User git\n');
      await configService.addProfile(
        Profile(
          name: 'a',
          gitconfig: '[user]',
          useSsh: true,
          sshconfig: 'Host github.com\n  User git\n',
        ),
      );

      expect(await gitService.isUnmanagedSshConfig(), true);
    });

    test('与某个 Profile 匹配时返回 false', () async {
      final sshconfig = 'Host github.com\n  User git\n';
      await writeHome(home, '.ssh/config', sshconfig);
      await configService.addProfile(
        Profile(
          name: 'a',
          gitconfig: '[user]',
          useSsh: true,
          sshconfig: sshconfig,
        ),
      );

      expect(await gitService.isUnmanagedSshConfig(), false);
    });

    test('无 SSH 配置时返回 false', () async {
      expect(await gitService.isUnmanagedSshConfig(), false);
    });
  });

  group('getConfigDiff - SSH 差异', () {
    test('useSsh 时返回 SSH 差异', () async {
      await writeHome(home, '.ssh/config', 'Host github.com\n  User old\n');
      final profile = Profile(
        name: 'a',
        gitconfig: '[user]',
        useSsh: true,
        sshconfig: 'Host github.com\n  User new\n',
      );

      final result = await gitService.getConfigDiff(profile);

      final sshDiff = (result['sshDiff'] as List).cast<ConfigDiffEntry>();
      expect(sshDiff, isNotEmpty);
      expect(result['currentSshConfig'], contains('User old'));
      expect(result['profileSshConfig'], contains('User new'));
    });
  });

  group('undoLastSwitch - 撤销含 SSH 快照', () {
    test('撤销后同时恢复 Git 与 SSH 配置', () async {
      final oldGit = '[user]\n  name = old\n';
      final oldSsh = 'Host github.com\n  User git\n  IdentityFile ~/.ssh/id_old\n';
      await writeHome(home, '.gitconfig', oldGit);
      await writeHome(home, '.ssh/config', oldSsh);
      final key = await createKey('.ssh/id_old');
      final newSsh = 'Host github.com\n  User git\n  IdentityFile ${key.path}\n';
      final profile = Profile(
        name: 'work',
        gitconfig: '[user]\n  name = work\n',
        useSsh: true,
        sshconfig: newSsh,
      );
      await gitService.switchProfile(profile, false, 5);
      expect(
        File(pathService.sshConfigPath).readAsStringSync(),
        contains('IdentityFile ${key.path}'),
      );

      final (done, _) = await gitService.undoLastSwitch();

      expect(done, true);
      expect(
        File(pathService.sshConfigPath).readAsStringSync(),
        contains('id_old'),
      );
      expect(configService.appConfig.lastSwitchSnapshot, isNull);
    });
  });

  group('switchProfile - 快照指向切换前活跃 Profile', () {
    test('从 A 切到 B 后撤销恢复 A', () async {
      await writeHome(home, '.gitconfig', '[user]\n  name = Alice\n');
      final profileA = gitOnlyProfile(name: 'Alice');
      final profileB = gitOnlyProfile(name: 'Bob');
      await gitService.switchProfile(profileA, false, 5);
      await gitService.switchProfile(profileB, false, 5);
      expect(configService.appConfig.activeProfileId, profileB.id);

      final (done, _) = await gitService.undoLastSwitch();

      expect(done, true);
      expect(
        File(pathService.gitConfigPath).readAsStringSync(),
        contains('Alice'),
      );
      expect(configService.appConfig.activeProfileId, profileA.id);
    });
  });

  group('restoreBackupAndRecompute - 恢复备份并重算活跃', () {
    test('恢复后清除撤销快照并重算活跃', () async {
      await writeHome(home, '.gitconfig', '[user]\n  name = Alice\n');
      final profileA = gitOnlyProfile(name: 'Alice');
      final profileB = gitOnlyProfile(name: 'Bob');
      await configService.addProfile(profileA);
      await configService.addProfile(profileB);
      await gitService.switchProfile(profileA, false, 5);
      await gitService.switchProfile(profileB, false, 5);
      expect(configService.appConfig.lastSwitchSnapshot, isNotNull);

      await gitService.backupCurrentConfig();
      final items = await FileService.instance.getBackupList();
      expect(items, isNotEmpty);

      final ok = await gitService.restoreBackupAndRecompute(items.first);

      expect(ok, true);
      expect(configService.appConfig.lastSwitchSnapshot, isNull);
      // 最近备份是切换后 B 的内容，恢复后活跃应重算为 B。
      expect(configService.appConfig.activeProfileId, profileB.id);
      expect(
        File(pathService.gitConfigPath).readAsStringSync(),
        contains('Bob'),
      );
    });
  });
}
