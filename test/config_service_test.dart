import 'dart:io';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:git_switcher/models/app_config.dart';
import 'package:git_switcher/models/last_switch_snapshot.dart';
import 'package:git_switcher/models/profile.dart';
import 'package:git_switcher/services/config_service.dart';
import 'package:git_switcher/services/path_service.dart';

import 'helpers.dart';

void main() {
  late Directory home;
  late PathService pathService;

  setUp(() async {
    home = await setUpIsolatedHome();
    pathService = PathService.instance;
  });

  tearDown(() async {
    await tearDownHome(home);
  });

  group('Profile.fromJson - 新格式与旧格式迁移', () {
    test('新格式 sshconfig 字段完整解析', () {
      final profile = Profile.fromJson({
        'id': 'p1',
        'name': 'work',
        'gitconfig': '[user]\n  name = work',
        'use_ssh': true,
        'sshconfig': 'Host github.com\n  IdentityFile ~/.ssh/id_work',
      });
      expect(profile.id, 'p1');
      expect(profile.name, 'work');
      expect(profile.useSsh, true);
      expect(
        profile.sshconfig,
        'Host github.com\n  IdentityFile ~/.ssh/id_work',
      );
    });

    test('旧格式 host/identity_file 迁移为 sshconfig', () {
      final profile = Profile.fromJson({
        'name': 'work',
        'gitconfig': '[user]',
        'use_ssh': true,
        'host': 'github.com',
        'identity_file': '~/.ssh/id_work',
      });
      expect(profile.useSsh, true);
      expect(profile.sshconfig, contains('Host github.com'));
      expect(profile.sshconfig, contains('IdentityFile ~/.ssh/id_work'));
    });

    test('旧格式带 ssh_port 时生成 Port 与 ssh.github.com', () {
      final profile = Profile.fromJson({
        'name': 'work',
        'gitconfig': '[user]',
        'use_ssh': true,
        'host': 'github.com',
        'identity_file': '~/.ssh/id_work',
        'ssh_port': 443,
      });
      expect(profile.sshconfig, contains('HostName ssh.github.com'));
      expect(profile.sshconfig, contains('Port 443'));
    });

    test('use_port_443 布尔迁移为 Port 443', () {
      final profile = Profile.fromJson({
        'name': 'work',
        'gitconfig': '[user]',
        'use_ssh': true,
        'host': 'github.com',
        'identity_file': '~/.ssh/id_work',
        'use_port_443': true,
      });
      expect(profile.sshconfig, contains('Port 443'));
    });

    test('use_ssh=true 但迁移后 sshconfig 为空时按 false 兜底', () {
      final profile = Profile.fromJson({
        'name': 'work',
        'gitconfig': '[user]',
        'use_ssh': true,
      });
      expect(profile.useSsh, false);
    });

    test('缺失字段使用默认值', () {
      final profile = Profile.fromJson({'name': 'work', 'gitconfig': '[user]'});
      expect(profile.useSsh, false);
      expect(profile.sshconfig, '');
      expect(profile.id, isNotEmpty);
    });

    test('toJson / fromJson 往返一致', () {
      final original = Profile(
        name: 'work',
        gitconfig: '[user]',
        useSsh: true,
        sshconfig: 'Host github.com\n  IdentityFile ~/.ssh/id_work',
      );
      final restored = Profile.fromJson(original.toJson());
      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.useSsh, original.useSsh);
      expect(restored.sshconfig, original.sshconfig);
    });
  });

  group('AppConfig.fromJson', () {
    test('完整字段解析', () {
      final config = AppConfig.fromJson({
        'enable_backup': false,
        'max_backup_count': 10,
        'active_profile_id': 'p1',
        'minimize_to_tray': true,
        'language_code': 'zh',
        'onboarded': true,
      });
      expect(config.enableBackup, false);
      expect(config.maxBackupCount, 10);
      expect(config.activeProfileId, 'p1');
      expect(config.minimizeToTray, true);
      expect(config.languageCode, 'zh');
      expect(config.onboarded, true);
    });

    test('缺失字段使用默认值', () {
      final config = AppConfig.fromJson(const {});
      expect(config.enableBackup, true);
      expect(config.maxBackupCount, 5);
      expect(config.activeProfileId, isNull);
      expect(config.minimizeToTray, false);
      expect(config.languageCode, isNull);
      expect(config.onboarded, false);
    });
  });

  group('ConfigService - 版本与持久化', () {
    test('新增 Profile 后写入 config.json（含 version 与 settings）', () async {
      final configService = ConfigService.instance;
      final profile = Profile(
        name: 'work',
        gitconfig: '[user]\n  name = work',
        useSsh: true,
        sshconfig: 'Host github.com\n  IdentityFile ~/.ssh/id_work',
      );

      final ok = await configService.addProfile(profile);
      expect(ok, true);

      final raw = jsonDecode(
        File(pathService.configFilePath).readAsStringSync(),
      ) as Map<String, dynamic>;
      expect(raw['version'], 1);
      expect(raw['settings'], isA<Map<String, dynamic>>());
      final profiles = (raw['profiles'] as List).cast<Map<String, dynamic>>();
      expect(profiles.length, 1);
      expect(profiles.first['name'], 'work');
      expect(profiles.first['sshconfig'], contains('Host github.com'));
    });

    test('加载已有 config.json（缺失 version 按 1 兜底）', () async {
      await writeHome(
        home,
        '.git_switcher/config.json',
        jsonEncode({
          'settings': {'active_profile_id': 'p9', 'max_backup_count': 7},
          'profiles': [
            {'id': 'p9', 'name': 'saved', 'gitconfig': '[user]'},
          ],
        }),
      );

      await ConfigService.instance.initialize();

      expect(ConfigService.instance.isReadOnly, false);
      expect(ConfigService.instance.appConfig.activeProfileId, 'p9');
      expect(ConfigService.instance.appConfig.maxBackupCount, 7);
      expect(ConfigService.instance.profiles.length, 1);
      expect(ConfigService.instance.profiles.first.name, 'saved');
    });

    test('版本过高时进入只读模式并拒绝写入', () async {
      await writeHome(
        home,
        '.git_switcher/config.json',
        jsonEncode({
          'version': 99,
          'settings': <String, dynamic>{},
          'profiles': <dynamic>[],
        }),
      );

      await ConfigService.instance.initialize();

      expect(ConfigService.instance.isReadOnly, true);
      final ok = await ConfigService.instance.addProfile(
        Profile(name: 'x', gitconfig: '[user]'),
      );
      expect(ok, false);
    });

    test('更新活跃配置并持久化', () async {
      final configService = ConfigService.instance;
      final profile = Profile(name: 'a', gitconfig: '[user]');
      await configService.addProfile(profile);

      await configService.updateActiveProfileId(profile.id);

      final raw = jsonDecode(
        File(pathService.configFilePath).readAsStringSync(),
      ) as Map<String, dynamic>;
      final settings = (raw['settings'] as Map<String, dynamic>);
      expect(settings['active_profile_id'], profile.id);
    });

    test('删除活跃 Profile 时清空活跃标记', () async {
      final configService = ConfigService.instance;
      final profile = Profile(name: 'a', gitconfig: '[user]');
      await configService.addProfile(profile);
      await configService.updateActiveProfileId(profile.id);

      await configService.deleteProfile(profile.id);

      expect(configService.appConfig.activeProfileId, isNull);
      expect(configService.profiles, isEmpty);
    });
  });

  group('ConfigService - Profile 管理', () {
    test('addProfile 拒绝空名称', () async {
      final configService = ConfigService.instance;
      final ok = await configService.addProfile(
        Profile(name: '   ', gitconfig: '[user]'),
      );
      expect(ok, false);
      expect(configService.profiles, isEmpty);
    });

    test('addProfile 拒绝重复名称', () async {
      final configService = ConfigService.instance;
      await configService.addProfile(
        Profile(name: 'work', gitconfig: '[user]'),
      );
      final ok = await configService.addProfile(
        Profile(name: 'work', gitconfig: '[user]\n  name = x'),
      );
      expect(ok, false);
      expect(configService.profiles.length, 1);
    });

    test('addProfile 允许不同名称', () async {
      final configService = ConfigService.instance;
      await configService.addProfile(
        Profile(name: 'work', gitconfig: '[user]'),
      );
      final ok = await configService.addProfile(
        Profile(name: 'Work', gitconfig: '[user]'),
      );
      expect(ok, true);
      expect(configService.profiles.length, 2);
    });

    test('updateProfile 更新已有 Profile 并持久化', () async {
      final configService = ConfigService.instance;
      final profile = Profile(
        name: 'a',
        gitconfig: '[user]',
        useSsh: true,
        sshconfig: 'Host github.com\n  User git',
      );
      await configService.addProfile(profile);

      final ok = await configService.updateProfile(
        profile.copyWith(name: 'b', gitconfig: '[user]\n  name = b'),
      );

      expect(ok, true);
      expect(configService.profiles.single.name, 'b');
      expect(configService.profiles.single.sshconfig, contains('Host github.com'));
      final raw = jsonDecode(
        File(pathService.configFilePath).readAsStringSync(),
      ) as Map<String, dynamic>;
      final profiles = (raw['profiles'] as List).cast<Map<String, dynamic>>();
      expect(profiles.single['name'], 'b');
    });

    test('updateProfile 不存在的 id 返回 false', () async {
      final configService = ConfigService.instance;
      final ok = await configService.updateProfile(
        Profile(name: 'x', gitconfig: '[user]'),
      );
      expect(ok, false);
    });

    test('getProfileById 命中与未命中', () async {
      final configService = ConfigService.instance;
      final profile = Profile(name: 'a', gitconfig: '[user]');
      await configService.addProfile(profile);

      expect(configService.getProfileById(profile.id)?.name, 'a');
      expect(configService.getProfileById('missing'), isNull);
    });
  });

  group('ConfigService - 设置与快照', () {
    test('updateOnboarded 持久化', () async {
      final configService = ConfigService.instance;
      await configService.updateOnboarded(true);
      expect(configService.appConfig.onboarded, true);

      final raw = jsonDecode(
        File(pathService.configFilePath).readAsStringSync(),
      ) as Map<String, dynamic>;
      final settings = raw['settings'] as Map<String, dynamic>;
      expect(settings['onboarded'], true);
    });

    test('updateAppConfig 持久化', () async {
      final configService = ConfigService.instance;
      await configService.updateAppConfig(
        configService.appConfig.copyWith(
          enableBackup: false,
          maxBackupCount: 8,
        ),
      );
      expect(configService.appConfig.enableBackup, false);
      expect(configService.appConfig.maxBackupCount, 8);

      final raw = jsonDecode(
        File(pathService.configFilePath).readAsStringSync(),
      ) as Map<String, dynamic>;
      final settings = raw['settings'] as Map<String, dynamic>;
      expect(settings['enable_backup'], false);
      expect(settings['max_backup_count'], 8);
    });

    test('快照写入与清除持久化', () async {
      final configService = ConfigService.instance;
      await configService.updateLastSwitchSnapshot(
        LastSwitchSnapshot(
          profileId: 'p1',
          gitconfig: 'git',
          sshconfig: null,
          switchedAt: 't1',
        ),
      );
      expect(configService.appConfig.lastSwitchSnapshot?.gitconfig, 'git');

      var raw = jsonDecode(
        File(pathService.configFilePath).readAsStringSync(),
      ) as Map<String, dynamic>;
      var settings = raw['settings'] as Map<String, dynamic>;
      final snapshotJson =
          settings['last_switch_snapshot'] as Map<String, dynamic>;
      expect(snapshotJson['gitconfig'], 'git');
      expect(snapshotJson['profile_id'], 'p1');

      await configService.clearLastSwitchSnapshot();
      expect(configService.appConfig.lastSwitchSnapshot, isNull);

      raw = jsonDecode(
        File(pathService.configFilePath).readAsStringSync(),
      ) as Map<String, dynamic>;
      settings = raw['settings'] as Map<String, dynamic>;
      expect(settings['last_switch_snapshot'], isNull);
    });

    test('删除 Profile 时若快照指向它则清除快照', () async {
      final configService = ConfigService.instance;
      final profile = Profile(name: 'a', gitconfig: '[user]');
      await configService.addProfile(profile);
      await configService.updateLastSwitchSnapshot(
        LastSwitchSnapshot(
          profileId: profile.id,
          gitconfig: 'git',
          switchedAt: 't',
        ),
      );

      await configService.deleteProfile(profile.id);

      expect(configService.appConfig.lastSwitchSnapshot, isNull);
      expect(configService.appConfig.activeProfileId, isNull);
    });
  });

  group('ConfigService - 异常与只读', () {
    test('加载非法 JSON 时重置为默认状态', () async {
      await writeHome(home, '.git_switcher/config.json', 'not-json{{{');

      await ConfigService.instance.initialize();

      expect(ConfigService.instance.isReadOnly, false);
      expect(ConfigService.instance.profiles, isEmpty);
      expect(ConfigService.instance.appConfig.activeProfileId, isNull);
    });

    test('加载非对象 JSON 时忽略并保持默认状态', () async {
      await writeHome(home, '.git_switcher/config.json', '[1, 2, 3]');

      await ConfigService.instance.initialize();

      expect(ConfigService.instance.profiles, isEmpty);
      expect(ConfigService.instance.isReadOnly, false);
    });

    test('只读模式拒绝所有写操作', () async {
      await writeHome(
        home,
        '.git_switcher/config.json',
        jsonEncode({
          'version': 99,
          'settings': <String, dynamic>{},
          'profiles': <dynamic>[],
        }),
      );
      await ConfigService.instance.initialize();
      final configService = ConfigService.instance;

      expect(
        await configService.addProfile(Profile(name: 'x', gitconfig: '[user]')),
        false,
      );
      expect(
        await configService.updateProfile(Profile(name: 'x', gitconfig: '[user]')),
        false,
      );
      expect(await configService.deleteProfile('any'), false);
      expect(await configService.updateActiveProfileId('p'), false);
      expect(await configService.updateOnboarded(true), false);
      expect(
        await configService.updateAppConfig(const AppConfig()),
        false,
      );
      expect(
        await configService.updateLastSwitchSnapshot(null),
        false,
      );
    });
  });
}
