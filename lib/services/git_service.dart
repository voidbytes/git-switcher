import 'dart:io';
import '../models/profile.dart';
import '../services/file_service.dart';
import '../services/path_service.dart';
import '../services/ssh_config_service.dart';
import 'config_service.dart';

class GitService {
  static GitService? _instance;
  static GitService get instance => _instance ??= GitService._();
  GitService._();

  final _fileService = FileService.instance;
  final _pathService = PathService.instance;
  final _sshService = SshConfigService.instance;
  final _configService = ConfigService.instance;

  Future<Map<String, dynamic>> switchProfile(
    Profile profile,
    bool enableBackup,
    int maxBackupCount,
  ) async {
    final messages = <String>[];
    final results = {'git': false, 'ssh': false, 'messages': messages};

    try {
      if (profile.useSsh) {
        final keyCheck = await _fileService.checkSshKeyFile(
          profile.identityFile,
        );
        if (!keyCheck['exists']) {
          messages.add(keyCheck['message']);
          return results;
        }
        if (keyCheck['permissions'] == false) {
          messages.add(keyCheck['message'] + ' (已忽略)');
        }
      }

      if (enableBackup) {
        final gitBackup = await _fileService.backupFile(
          _pathService.gitConfigPath,
          _pathService.gitBackupDir,
          'gitconfig',
        );
        if (gitBackup != null) {
          messages.add('已备份当前Git配置');
        }

        if (profile.useSsh) {
          final sshBackup = await _fileService.backupFile(
            _pathService.sshConfigPath,
            _pathService.sshBackupDir,
            'config',
          );
          if (sshBackup != null) {
            messages.add('已备份当前SSH配置');
          }
        }

        await _fileService.cleanOldBackups(maxBackupCount);
      }

      final gitResult = await _fileService.writeFile(
        _pathService.gitConfigPath,
        profile.gitconfig,
      );
      results['git'] = gitResult;
      if (gitResult) {
        messages.add('Git配置已更新');
      } else {
        messages.add('Git配置更新失败');
      }

      if (profile.useSsh &&
          profile.host.isNotEmpty &&
          profile.identityFile.isNotEmpty) {
        final sshResult = await _sshService.updateSshConfig(
          profile.host,
          profile.identityFile,
        );
        results['ssh'] = sshResult;
        if (sshResult) {
          messages.add('SSH配置已更新');
        } else {
          messages.add('SSH配置更新失败');
        }
      } else {
        results['ssh'] = true;
      }

      if (results['git'] == true && results['ssh'] == true) {
        await _configService.updateActiveProfileId(profile.id);
      } else {
        await _configService.updateActiveProfileId(null);
      }
    } catch (e) {
      messages.add('切换失败: $e');
      await _configService.updateActiveProfileId(null);
    }

    return results;
  }

  Future<Map<String, String?>> testGitConfig() async {
    try {
      final nameResult = await Process.run('git', ['config', 'user.name']);
      final emailResult = await Process.run('git', ['config', 'user.email']);

      return {
        'name': nameResult.exitCode == 0
            ? nameResult.stdout.toString().trim()
            : null,
        'email': emailResult.exitCode == 0
            ? emailResult.stdout.toString().trim()
            : null,
      };
    } catch (e) {
      return {'name': null, 'email': null, 'error': e.toString()};
    }
  }

  Future<Profile?> findActiveProfile() async {
    final profiles = _configService.profiles;
    final currentGitConfig = await _fileService.readFile(
      _pathService.gitConfigPath,
    );

    if (currentGitConfig == null) return null;

    for (final profile in profiles) {
      if (currentGitConfig.trim() != profile.gitconfig.trim()) {
        continue;
      }

      if (profile.useSsh) {
        final sshConfigValid = await _sshService.validateSshConfig(
          profile.host,
          profile.identityFile,
        );
        if (!sshConfigValid) {
          continue;
        }
      }

      return profile;
    }

    return null;
  }

  Future<Map<String, dynamic>> validateProfile(Profile profile) async {
    final messages = <String>[];
    final results = {'git': false, 'ssh': false, 'messages': messages};

    final currentGitConfig = await _fileService.readFile(
      _pathService.gitConfigPath,
    );
    if (currentGitConfig != null &&
        currentGitConfig.trim() == profile.gitconfig.trim()) {
      results['git'] = true;
      messages.add('Git配置一致');
    } else {
      messages.add('Git配置不一致');
    }

    if (profile.useSsh) {
      final isValid = await _sshService.validateSshConfig(
        profile.host,
        profile.identityFile,
      );
      results['ssh'] = isValid;
      if (isValid) {
        messages.add('SSH配置一致');
      } else {
        messages.add('SSH配置不一致');
      }

      final keyCheck = await _fileService.checkSshKeyFile(profile.identityFile);
      if (!keyCheck['exists']) {
        final message = keyCheck['message'];
        if (message != null) messages.add(message);
      } else if (keyCheck['permissions'] == false) {
        final message = keyCheck['message'];
        if (message != null) messages.add(message);
      }
    } else {
      results['ssh'] = true;
    }

    return results;
  }
}
