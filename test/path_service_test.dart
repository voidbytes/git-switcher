import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
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

  group('initialize - 初始化', () {
    test('创建 .git_switcher 及备份目录', () async {
      expect(Directory('${home.path}/.git_switcher').existsSync(), true);
      expect(
        Directory('${home.path}/.git_switcher/backup').existsSync(),
        true,
      );
      expect(
        Directory('${home.path}/.git_switcher/backup/git').existsSync(),
        true,
      );
      expect(
        Directory('${home.path}/.git_switcher/backup/ssh').existsSync(),
        true,
      );
    });

    test('已初始化后再次调用保留注入的主目录', () async {
      await pathService.initialize();
      expect(pathService.homeDir, home.path);
    });
  });

  group('路径 getter', () {
    test('各配置路径指向注入的主目录', () {
      expect(pathService.homeDir, home.path);
      expect(pathService.gitSwitcherDir, '${home.path}/.git_switcher');
      expect(
        pathService.configFilePath,
        '${home.path}/.git_switcher/config.json',
      );
      expect(pathService.gitConfigPath, '${home.path}/.gitconfig');
      expect(pathService.sshConfigPath, '${home.path}/.ssh/config');
      expect(pathService.sshDir, '${home.path}/.ssh');
      expect(
        pathService.gitBackupDir,
        '${home.path}/.git_switcher/backup/git',
      );
      expect(
        pathService.sshBackupDir,
        '${home.path}/.git_switcher/backup/ssh',
      );
    });
  });

  group('resolvePath - 路径解析', () {
    test('展开 ~/', () {
      expect(
        pathService.resolvePath('~/.ssh/id_work'),
        '${home.path}/.ssh/id_work',
      );
    });

    test('绝对路径保持不变', () {
      expect(pathService.resolvePath('/etc/hosts'), '/etc/hosts');
    });

    test('相对路径保持不变', () {
      expect(pathService.resolvePath('relative/path'), 'relative/path');
    });
  });

  group('ensureSshDirExists - SSH 目录', () {
    test('创建 ~/.ssh', () async {
      await pathService.ensureSshDirExists();
      expect(Directory('${home.path}/.ssh').existsSync(), true);
    });
  });
}
