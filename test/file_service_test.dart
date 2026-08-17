import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:git_switcher/models/backup_item.dart';
import 'package:git_switcher/services/file_service.dart';
import 'package:git_switcher/services/path_service.dart';

import 'helpers.dart';

void main() {
  late Directory home;
  late PathService pathService;
  final fileService = FileService.instance;

  setUp(() async {
    home = await setUpIsolatedHome();
    pathService = PathService.instance;
  });

  tearDown(() async {
    await tearDownHome(home);
  });

  Future<void> seedBackup(String dir, String prefix, String ts, String content) async {
    final file = File('$dir/$prefix.$ts.bak');
    await file.parent.create(recursive: true);
    await file.writeAsString(content);
  }

  group('backupFile - 备份', () {
    test('源文件存在时生成 .bak 备份', () async {
      await writeHome(home, '.gitconfig', '[user]\n  name = old\n');
      final backup = await fileService.backupFile(
        pathService.gitConfigPath,
        pathService.gitBackupDir,
        'gitconfig',
      );
      expect(backup, isNotNull);
      expect(backup!.endsWith('.bak'), true);
      expect(File(backup).existsSync(), true);
      expect(File(backup).readAsStringSync(), contains('name = old'));
    });

    test('源文件不存在时返回 null', () async {
      final backup = await fileService.backupFile(
        '${home.path}/not_exists',
        pathService.gitBackupDir,
        'gitconfig',
      );
      expect(backup, isNull);
    });
  });

  group('getBackupList - 备份列表', () {
    test('按时间倒序返回 git / ssh 备份', () async {
      await seedBackup(pathService.gitBackupDir, 'gitconfig', '1000', 'git-old');
      await seedBackup(pathService.gitBackupDir, 'gitconfig', '3000', 'git-new');
      await seedBackup(pathService.sshBackupDir, 'config', '2000', 'ssh-mid');

      final items = await fileService.getBackupList();

      expect(items.length, 3);
      expect(items.map((i) => i.timestamp).toList(), ['3000', '2000', '1000']);
      final gitNew = items.firstWhere((i) => i.timestamp == '3000');
      expect(gitNew.type, 'git');
      expect(gitNew.content, 'git-new');
      expect(gitNew.filename, 'gitconfig.3000.bak');
      final sshMid = items.firstWhere((i) => i.timestamp == '2000');
      expect(sshMid.type, 'ssh');
      expect(sshMid.filename, 'config.2000.bak');
    });

    test('无备份时返回空列表', () async {
      final items = await fileService.getBackupList();
      expect(items, isEmpty);
    });
  });

  group('restoreBackup - 恢复', () {
    test('恢复 git 备份到 ~/.gitconfig', () async {
      await seedBackup(pathService.gitBackupDir, 'gitconfig', '1000', '[user]\n  name = restored\n');
      await writeHome(home, '.gitconfig', '[user]\n  name = current\n');
      final item = BackupItem(
        timestamp: '1000',
        type: 'git',
        filename: 'gitconfig.1000.bak',
      );

      final ok = await fileService.restoreBackup(item);
      expect(ok, true);
      expect(File(pathService.gitConfigPath).readAsStringSync(), contains('name = restored'));
    });

    test('恢复不存在的备份返回 false', () async {
      final item = BackupItem(
        timestamp: '1000',
        type: 'git',
        filename: 'gitconfig.1000.bak',
      );
      final ok = await fileService.restoreBackup(item);
      expect(ok, false);
    });
  });

  group('cleanOldBackups - 清理', () {
    test('超过上限时删除最旧的备份', () async {
      for (int i = 1; i <= 6; i++) {
        final file = File('${pathService.gitBackupDir}/gitconfig.$i.bak');
        await file.parent.create(recursive: true);
        await file.writeAsString('content-$i');
        await file.setLastModified(DateTime(2024, 1, i, 12, 0, 0));
      }

      await fileService.cleanOldBackups(3);

      final remaining = Directory(pathService.gitBackupDir)
          .listSync()
          .where((f) => f.path.endsWith('.bak'))
          .toList();
      expect(remaining.length, 3);
      final names = remaining.map((f) => f.path.split('/').last).toList();
      expect(names, containsAll(['gitconfig.4.bak', 'gitconfig.5.bak', 'gitconfig.6.bak']));
      expect(names, isNot(contains('gitconfig.1.bak')));
    });

    test('未超过上限时不做删除', () async {
      for (int i = 1; i <= 2; i++) {
        await seedBackup(pathService.gitBackupDir, 'gitconfig', '$i', 'content');
      }

      await fileService.cleanOldBackups(5);

      final remaining = Directory(pathService.gitBackupDir)
          .listSync()
          .where((f) => f.path.endsWith('.bak'))
          .toList();
      expect(remaining.length, 2);
    });
  });

  group('checkSshKeyFile - 私钥校验', () {
    test('私钥不存在', () async {
      final result = await fileService.checkSshKeyFile('${home.path}/.ssh/missing');
      expect(result['exists'], false);
      expect(result['message'], isNotNull);
    });

    test('权限为 600 时校验通过', () async {
      if (Platform.isWindows) return;
      final key = await writeHome(home, '.ssh/id_ok', 'key');
      await Process.run('chmod', ['600', key.path]);

      final result = await fileService.checkSshKeyFile(key.path);
      expect(result['exists'], true);
      expect(result['permissions'], true);
    });

    test('权限非 600 时报错', () async {
      if (Platform.isWindows) return;
      final key = await writeHome(home, '.ssh/id_bad', 'key');
      await Process.run('chmod', ['644', key.path]);

      final result = await fileService.checkSshKeyFile(key.path);
      expect(result['exists'], true);
      expect(result['permissions'], false);
      expect(result['message'], isNotNull);
    });

    test('符号链接指向 600 目标时校验通过（不误报链接自身权限）', () async {
      if (Platform.isWindows) return;
      final target = await writeHome(home, '.ssh/id_real', 'key');
      await Process.run('chmod', ['600', target.path]);
      final link = File('${home.path}/.ssh/id_link');
      await link.create(recursive: false);
      await link.delete();
      await Process.run('ln', ['-s', target.path, link.path]);

      final result = await fileService.checkSshKeyFile(link.path);
      expect(result['exists'], true);
      expect(result['permissions'], true);
    });
  });
}
