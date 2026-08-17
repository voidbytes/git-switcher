import 'dart:io';

import 'package:path/path.dart' as p;

import '../l10n/core_messages.dart';
import '../models/backup_item.dart';
import 'log_service.dart';
import 'path_service.dart';

class FileService {
  static FileService? _instance;
  static FileService get instance => _instance ??= FileService._();
  FileService._();

  final _pathService = PathService.instance;

  Future<String?> readFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        return await file.readAsString();
      }
      return null;
    } catch (e) {
      Log.instance.error('读取文件失败: $path, 错误: $e');
      return null;
    }
  }

  Future<bool> writeFile(String path, String content) async {
    try {
      final file = File(path);
      await file.parent.create(recursive: true);
      await file.writeAsString(content);

      if (!Platform.isWindows && path.contains('.ssh/')) {
        await Process.run('chmod', ['600', path]);
      }

      return true;
    } catch (e) {
      Log.instance.error('写入文件失败: $path, 错误: $e');
      return false;
    }
  }

  /// 文件存在时删除（用于撤销：还原到切换前文件不存在/为空的状态）。
  Future<bool> deleteFileIfExists(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
      return true;
    } catch (e) {
      Log.instance.error('删除文件失败: $path, 错误: $e');
      return false;
    }
  }

  Future<String?> backupFile(
    String sourcePath,
    String backupDir,
    String prefix,
  ) async {
    try {
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        return null;
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final backupPath = '$backupDir/$prefix.$timestamp.bak';

      await sourceFile.copy(backupPath);
      return backupPath;
    } catch (e) {
      Log.instance.warn('备份文件失败: $sourcePath, 错误: $e');
      return null;
    }
  }

  Future<List<BackupItem>> getBackupList() async {
    final backupItems = <BackupItem>[];

    try {
      final gitBackupDir = Directory(_pathService.gitBackupDir);
      if (await gitBackupDir.exists()) {
        final gitFiles = await gitBackupDir.list().toList();
        for (final file in gitFiles) {
          if (file is File && file.path.endsWith('.bak')) {
            final filename = p.basename(file.path);
            final parts = filename.split('.');
            if (parts.length >= 3) {
              final timestamp = parts[parts.length - 2];
              final content = await readFile(file.path);
              backupItems.add(
                BackupItem(
                  timestamp: timestamp,
                  type: 'git',
                  filename: filename,
                  content: content,
                ),
              );
            }
          }
        }
      }

      final sshBackupDir = Directory(_pathService.sshBackupDir);
      if (await sshBackupDir.exists()) {
        final sshFiles = await sshBackupDir.list().toList();
        for (final file in sshFiles) {
          if (file is File && file.path.endsWith('.bak')) {
            final filename = p.basename(file.path);
            final parts = filename.split('.');
            if (parts.length >= 3) {
              final timestamp = parts[parts.length - 2];
              final content = await readFile(file.path);
              backupItems.add(
                BackupItem(
                  timestamp: timestamp,
                  type: 'ssh',
                  filename: filename,
                  content: content,
                ),
              );
            }
          }
        }
      }

      backupItems.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      Log.instance.warn('获取备份列表失败: $e');
    }

    return backupItems;
  }

  Future<bool> restoreBackup(BackupItem backup) async {
    try {
      final backupFile = File(
        backup.type == 'git'
            ? '${_pathService.gitBackupDir}/${backup.filename}'
            : '${_pathService.sshBackupDir}/${backup.filename}',
      );

      if (!await backupFile.exists()) {
        return false;
      }

      final targetPath = backup.type == 'git'
          ? _pathService.gitConfigPath
          : _pathService.sshConfigPath;

      await backupFile.copy(targetPath);
      return true;
    } catch (e) {
      Log.instance.error('恢复备份失败: $e');
      return false;
    }
  }

  Future<void> cleanOldBackups(int maxCount) async {
    await _cleanBackupsInDir(_pathService.gitBackupDir, maxCount);
    await _cleanBackupsInDir(_pathService.sshBackupDir, maxCount);
  }

  Future<void> _cleanBackupsInDir(String dirPath, int maxCount) async {
    try {
      final dir = Directory(dirPath);
      if (!await dir.exists()) return;

      final files = await dir
          .list()
          .where((f) => f is File && f.path.endsWith('.bak'))
          .toList();
      if (files.length <= maxCount) return;

      files.sort(
        (a, b) => File(
          a.path,
        ).lastModifiedSync().compareTo(File(b.path).lastModifiedSync()),
      );

      for (int i = 0; i < files.length - maxCount; i++) {
        await files[i].delete();
      }
    } catch (e) {
      Log.instance.warn('清理备份失败: $dirPath, 错误: $e');
    }
  }

  Future<Map<String, dynamic>> checkSshKeyFile(String keyPath) async {
    var resolvedPath = _pathService.resolvePath(keyPath);
    final file = File(resolvedPath);

    if (!await file.exists()) {
      return {
        'exists': false,
        'message': Msg.of.keyFileNotExist(resolvedPath),
      };
    }

    // 符号链接时解析到真实目标再检查权限（stat 默认显示链接自身 777，
    // 而 ssh 实际使用目标文件权限）。
    try {
      final realPath = await file.resolveSymbolicLinks();
      if (realPath.isNotEmpty) resolvedPath = realPath;
    } catch (_) {}

    if (!Platform.isWindows) {
      try {
        final args = Platform.isMacOS
            ? ['-f', '%Lp', resolvedPath]
            : ['-c', '%a', resolvedPath];
        final result = await Process.run('stat', args);
        final permissions = result.stdout.toString().trim();
        if (permissions != '600') {
          return {
            'exists': true,
            'permissions': false,
            'message': Msg.of.keyPermissionIncorrect(permissions),
          };
        }
      } catch (e) {
        Log.instance.warn('检查文件权限失败: $e');
        return {
          'exists': true,
          'permissions': false,
          'message': Msg.of.keyPermissionCheckFailed,
        };
      }
    }

    return {'exists': true, 'permissions': true, 'message': 'OK'};
  }
}
