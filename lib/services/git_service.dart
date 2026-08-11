import 'dart:io';
import 'package:path/path.dart' as p;
import '../l10n/localization_service.dart';
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
          messages.add(L.of.gitBackupDone);
        }

        if (profile.useSsh) {
          final sshBackup = await _fileService.backupFile(
            _pathService.sshConfigPath,
            _pathService.sshBackupDir,
            'config',
          );
          if (sshBackup != null) {
            messages.add(L.of.sshBackupDone);
          }
        }

        await _fileService.cleanOldBackups(maxBackupCount);
      }

      // 切换前记录当前配置，切换失败时用于回滚，避免半切换状态
      final previousGitConfig = await _fileService.readFile(
        _pathService.gitConfigPath,
      );
      final previousSshConfig =
          profile.useSsh
              ? await _fileService.readFile(_pathService.sshConfigPath)
              : null;

      final gitResult = await _fileService.writeFile(
        _pathService.gitConfigPath,
        profile.gitconfig,
      );
      results['git'] = gitResult;
      if (gitResult) {
        messages.add(L.of.gitConfigUpdated);
      } else {
        messages.add(L.of.gitConfigUpdateFailed);
      }

      if (profile.useSsh &&
          profile.host.isNotEmpty &&
          profile.identityFile.isNotEmpty) {
        final sshResult = await _sshService.updateSshConfig(
          profile.host,
          profile.identityFile,
          sshPort: profile.sshPort,
        );
        results['ssh'] = sshResult;
        if (sshResult) {
          messages.add(L.of.sshConfigUpdated);
        } else {
          messages.add(L.of.sshConfigUpdateFailed);
        }
      } else {
        results['ssh'] = true;
      }

      if (results['git'] == true && results['ssh'] == true) {
        await _configService.updateActiveProfileId(profile.id);
      } else {
        // 任一配置写入失败，回滚已写入的配置，避免处于半切换状态
        if (previousGitConfig != null) {
          await _fileService.writeFile(
            _pathService.gitConfigPath,
            previousGitConfig,
          );
        }
        if (previousSshConfig != null) {
          await _fileService.writeFile(
            _pathService.sshConfigPath,
            previousSshConfig,
          );
        }
        messages.add(L.of.configRolledBack);
        await _configService.updateActiveProfileId(null);
      }
    } catch (e) {
      messages.add(L.of.switchFailedWithError(e.toString()));
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

  Map<String, String> _parseGitUser(String content) {
    final name = RegExp(
      r'^\s*name\s*=\s*(.+)$',
      multiLine: true,
    ).firstMatch(content)?.group(1)?.trim();
    final email = RegExp(
      r'^\s*email\s*=\s*(.+)$',
      multiLine: true,
    ).firstMatch(content)?.group(1)?.trim();
    return {'name': name ?? '', 'email': email ?? ''};
  }

  Future<Profile?> findActiveProfile() async {
    final profiles = _configService.profiles;
    final currentGitConfig = await _fileService.readFile(
      _pathService.gitConfigPath,
    );

    if (currentGitConfig == null) return null;

    final currentUser = _parseGitUser(currentGitConfig);

    for (final profile in profiles) {
      final profileUser = _parseGitUser(profile.gitconfig);
      if (currentUser['name'] != profileUser['name'] ||
          currentUser['email'] != profileUser['email']) {
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
    if (currentGitConfig != null) {
      final currentUser = _parseGitUser(currentGitConfig);
      final profileUser = _parseGitUser(profile.gitconfig);
      if (currentUser['name'] == profileUser['name'] &&
          currentUser['email'] == profileUser['email']) {
        results['git'] = true;
        messages.add(L.of.gitConfigMatches);
      } else {
        messages.add(L.of.gitConfigMismatch);
      }
    } else {
      messages.add(L.of.gitConfigMismatch);
    }

    if (profile.useSsh) {
      final isValid = await _sshService.validateSshConfig(
        profile.host,
        profile.identityFile,
      );
      results['ssh'] = isValid;
      if (isValid) {
        messages.add(L.of.sshConfigMatches);
      } else {
        messages.add(L.of.sshConfigMismatch);
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

  /// 计算当前系统配置与指定配置的差异，用于"查看不同的配置"。
  Future<Map<String, dynamic>> getConfigDiff(Profile profile) async {
    final differences = <String>[];

    final currentGitConfig = await _fileService.readFile(
      _pathService.gitConfigPath,
    );
    final profileUser = _parseGitUser(profile.gitconfig);
    String? currentName;
    String? currentEmail;
    if (currentGitConfig != null) {
      final currentUser = _parseGitUser(currentGitConfig);
      currentName = currentUser['name'];
      currentEmail = currentUser['email'];
    }

    if (currentName != profileUser['name']) {
      differences.add(
        L.of.diffUserName(currentName ?? '(无)', profileUser['name'] ?? ''),
      );
    }
    if (currentEmail != profileUser['email']) {
      differences.add(
        L.of.diffUserEmail(currentEmail ?? '(无)', profileUser['email'] ?? ''),
      );
    }

    if (profile.useSsh) {
      final parsed = await _sshService.parseConfig(profile.host);
      final currentIdentityFile = parsed['identityFile'] as String?;
      final profileIdentityFile = profile.identityFile;
      final expected = _pathService.resolvePath(profileIdentityFile);
      if (currentIdentityFile == null) {
        differences.add(L.of.diffSshHostNotFound(profile.host));
      } else if (p.normalize(currentIdentityFile) != p.normalize(expected)) {
        differences.add(
          L.of.diffSshIdentityFile(currentIdentityFile, profileIdentityFile),
        );
      }
    }

    return {
      'differences': differences,
      'currentGitConfig': currentGitConfig,
      'profileGitConfig': profile.gitconfig,
    };
  }

  /// 用户主动备份当前 Git / SSH 配置，返回备份结果消息。
  Future<List<String>> backupCurrentConfig() async {
    final messages = <String>[];
    final gitBackup = await _fileService.backupFile(
      _pathService.gitConfigPath,
      _pathService.gitBackupDir,
      'gitconfig',
    );
    if (gitBackup != null) {
      messages.add(L.of.gitBackupDone);
    }

    final sshConfigExists =
        await _fileService.readFile(_pathService.sshConfigPath) != null;
    if (sshConfigExists) {
      final sshBackup = await _fileService.backupFile(
        _pathService.sshConfigPath,
        _pathService.sshBackupDir,
        'config',
      );
      if (sshBackup != null) {
        messages.add(L.of.sshBackupDone);
      }
    }

    if (messages.isEmpty) {
      messages.add(L.of.backupNothing);
    }
    return messages;
  }
}
