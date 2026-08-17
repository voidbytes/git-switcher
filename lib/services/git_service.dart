import 'dart:io';
import '../l10n/core_messages.dart';
import '../models/backup_item.dart';
import '../models/last_switch_snapshot.dart';
import '../models/profile.dart';
import '../services/file_service.dart';
import '../services/path_service.dart';
import '../services/ssh_config_service.dart';
import 'config_service.dart';
import 'log_service.dart';

/// 切换结果。
class SwitchResult {
  final bool success;
  final List<String> messages;

  /// 'green' / 'yellow' / 'red'，供 UI 决定 SnackBar 颜色。
  final String level;

  const SwitchResult({
    required this.success,
    required this.messages,
    required this.level,
  });
}

/// 行级差异项。
class ConfigDiffEntry {
  final int lineNumber;
  final String oldContent;
  final String newContent;

  const ConfigDiffEntry({
    required this.lineNumber,
    required this.oldContent,
    required this.newContent,
  });
}

/// Git/SSH 整文件切换服务。
///
/// 遵循产品技术规格 v1.0：一切写入前先备份，失败必回滚；活跃识别与差异
/// 展示基于整文件内容比对（trim + 换行符归一化）。
class GitService {
  static GitService? _instance;
  static GitService get instance => _instance ??= GitService._();
  GitService._();

  final _fileService = FileService.instance;
  final _pathService = PathService.instance;
  final _sshService = SshConfigService.instance;
  final _configService = ConfigService.instance;

  /// 一键切换（规格 6.1）。
  ///
  /// 流程固定为：校验 → 备份 → 记录现场 → 写入 → 成功标记 / 失败回滚。
  /// 返回 [SwitchResult]，其中 `success` 表示是否成功写入。
  Future<SwitchResult> switchProfile(
    Profile profile,
    bool enableBackup,
    int maxBackupCount,
  ) async {
    final messages = <String>[];
    Log.instance.info('开始切换 Profile: ${profile.name} (id=${profile.id})');

    // 1. 前置校验：私钥存在性（阻断）+ 权限非 600（警告，不中止）。
    if (profile.useSsh) {
      final keyCheck = await _checkAllKeys(profile.sshconfig);
      if (keyCheck['blocked'] == true) {
        messages.add(keyCheck['message'] as String);
        return SwitchResult(
          success: false,
          messages: messages,
          level: 'red',
        );
      }
      if (keyCheck['warning'] != null) {
        messages.add(keyCheck['warning'] as String);
      }
    }

    // 3. 自动备份。
    if (enableBackup) {
      final gitBackup = await _fileService.backupFile(
        _pathService.gitConfigPath,
        _pathService.gitBackupDir,
        'gitconfig',
      );
      if (gitBackup != null) messages.add(Msg.of.gitBackupDone);

      if (profile.useSsh) {
        final sshBackup = await _fileService.backupFile(
          _pathService.sshConfigPath,
          _pathService.sshBackupDir,
          'config',
        );
        if (sshBackup != null) messages.add(Msg.of.sshBackupDone);
      }

      await _fileService.cleanOldBackups(maxBackupCount);
    }

    // 4. 记录现场：切换前两份文件的全文（回滚 + 撤销快照共用）。
    final previousGitConfig = await _fileService.readFile(
      _pathService.gitConfigPath,
    );
    final previousSshConfig = profile.useSsh
        ? await _fileService.readFile(_pathService.sshConfigPath)
        : null;

    // 5. 写入（整文件覆盖）。
    final gitResult = await _fileService.writeFile(
      _pathService.gitConfigPath,
      profile.gitconfig,
    );
    if (gitResult) {
      messages.add(Msg.of.gitConfigUpdated);
    } else {
      messages.add(Msg.of.gitConfigUpdateFailed);
    }

    var sshResult = !profile.useSsh;
    if (profile.useSsh) {
      sshResult = await _fileService.writeFile(
        _pathService.sshConfigPath,
        profile.sshconfig,
      );
      if (sshResult) {
        messages.add(Msg.of.sshConfigUpdated);
      } else {
        messages.add(Msg.of.sshConfigUpdateFailed);
      }
    }

    if (gitResult && sshResult) {
      // 6. 全部成功：更新活跃标记 + 写入撤销快照。
      // 快照 profile_id 须为「切换前的活跃 Profile」，因此在更新活跃标记前读取。
      final previousActiveId = _previousActiveProfileId(profile);
      await _configService.updateActiveProfileId(profile.id);
      await _configService.updateLastSwitchSnapshot(
        LastSwitchSnapshot(
          profileId: previousActiveId,
          gitconfig: previousGitConfig,
          sshconfig: previousSshConfig,
          sshManaged: profile.useSsh,
          switchedAt: DateTime.now().toIso8601String(),
        ),
      );
      Log.instance.info('切换成功: ${profile.name}');
      return SwitchResult(
        success: true,
        messages: messages,
        level: 'green',
      );
    }

    // 任一失败 → 回滚已写入的文件，保持系统原状。
    // 切换前文件不存在（内容为 null）时必须删除本次新写入的文件，
    // 避免「git 已写入、ssh 写失败」场景残留半成品 .gitconfig。
    if (previousGitConfig != null) {
      await _fileService.writeFile(
        _pathService.gitConfigPath,
        previousGitConfig,
      );
    } else {
      await _fileService.deleteFileIfExists(_pathService.gitConfigPath);
    }
    if (profile.useSsh) {
      if (previousSshConfig != null) {
        await _fileService.writeFile(
          _pathService.sshConfigPath,
          previousSshConfig,
        );
      } else {
        await _fileService.deleteFileIfExists(_pathService.sshConfigPath);
      }
    }
    messages.add(Msg.of.configRolledBack);
    await _configService.updateActiveProfileId(null);
    Log.instance.warn('切换失败，已回滚: ${profile.name}');
    return SwitchResult(
      success: false,
      messages: messages,
      level: 'red',
    );
  }

  /// 切换前快照里的 profile_id 应为「切换前的活跃 Profile」。
  String? _previousActiveProfileId(Profile target) {
    final before = _configService.appConfig.activeProfileId;
    // 若目标之前本身就是活跃配置，则撤销目标应为 null（回到不匹配状态）。
    return before == target.id ? null : before;
  }

  /// 前置校验：校验 profile 的 sshconfig 中所有 IdentityFile。
  /// 返回 `{ blocked, message, warning }`。
  Future<Map<String, dynamic>> _checkAllKeys(String sshconfig) async {
    final keyPaths = _sshService.extractIdentityFiles(sshconfig);
    if (keyPaths.isEmpty) {
      return {
        'blocked': false,
        'message': null,
        'warning': Msg.of.sshNoIdentityFile,
      };
    }
    for (final keyPath in keyPaths) {
      final check = await _fileService.checkSshKeyFile(keyPath);
      if (!check['exists']) {
        return {
          'blocked': true,
          'message': check['message'],
          'warning': null,
        };
      }
      if (check['permissions'] == false) {
        return {
          'blocked': false,
          'message': null,
          'warning': check['message'],
        };
      }
    }
    return {
      'blocked': false,
      'message': null,
      'warning': null,
    };
  }

  /// 切换后自动验证（规格 6.2）。
  ///
  /// 验证失败**不回滚**（配置本身正确，可能是网络/代理问题）。
  Future<Map<String, dynamic>> verifyAfterSwitch(Profile profile) async {
    // 1. 校验 git user.name / user.email。
    final gitVerified = await _verifyGitUser(profile);
    if (!gitVerified) {
      return {
        'verified': false,
        'reason': Msg.of.verifyGitMismatch,
      };
    }

    // 2. use_ssh 时执行 ssh -T。
    if (profile.useSsh) {
      final host = _sshService.firstConcreteHost(profile.sshconfig);
      if (host != null) {
        final sshOk = await _sshT(host);
        if (!sshOk) {
          return {
            'verified': false,
            'reason': Msg.of.verifySshFailed(host),
          };
        }
      }
    }

    return {'verified': true, 'reason': ''};
  }

  Future<bool> _verifyGitUser(Profile profile) async {
    final result = await _fileService.readFile(_pathService.gitConfigPath);
    if (result == null) return false;
    final current = _parseGitUser(result);
    final target = _parseGitUser(profile.gitconfig);
    return current['name'] == target['name'] &&
        current['email'] == target['email'];
  }

  /// 执行 `ssh -T git@{host}`，超时 10s。无 ssh 命令时视为不可用（不报错）。
  Future<bool> _sshT(String host) async {
    try {
      final result = await Process.run(
        'ssh',
        ['-T', 'git@$host'],
      ).timeout(const Duration(seconds: 10));
      // ssh -T 成功时 exitCode 通常为 1（认证成功但无 shell），
      // 或 255（连接失败）。此处仅区分「能连上」（1）与「连不上」（255）。
      return result.exitCode == 1;
    } catch (e) {
      return false;
    }
  }

  /// 一键撤销（规格 6.3）。返回是否执行了撤销。
  Future<(bool, String?)> undoLastSwitch() async {
    final snapshot = _configService.appConfig.lastSwitchSnapshot;
    if (snapshot == null) {
      return (false, null);
    }
    Log.instance.info('开始撤销上次切换');

    // 写回快照中的 gitconfig / sshconfig。
    // git 总是被切换写入：gitconfig 为 null 表示切换前文件不存在 → 删除还原。
    final gitOk = snapshot.gitconfig != null
        ? await _fileService.writeFile(
            _pathService.gitConfigPath,
            snapshot.gitconfig!,
          )
        : await _fileService.deleteFileIfExists(_pathService.gitConfigPath);

    // ssh 仅在本次切换托管过（useSsh）时才还原：有先前内容写回，无先前内容则删除；
    // 未托管（git-only 切换）时绝不触碰 ~/.ssh/config。
    var sshOk = true;
    if (snapshot.sshManaged == true) {
      if (snapshot.sshconfig != null) {
        sshOk = await _fileService.writeFile(
          _pathService.sshConfigPath,
          snapshot.sshconfig!,
        );
      } else {
        sshOk = await _fileService.deleteFileIfExists(
          _pathService.sshConfigPath,
        );
      }
    }

    if (!gitOk || !sshOk) {
      return (false, Msg.of.undoFailed);
    }

    // 还原活跃标记为快照 profile_id（或 null）。
    await _configService.updateActiveProfileId(snapshot.profileId);
    // 单层撤销：撤销后清除快照。
    await _configService.clearLastSwitchSnapshot();
    return (true, null);
  }

  /// 活跃配置识别（规格 6.4）：整文件内容规范化后相等。
  ///
  /// 先优先匹配 `activeProfileId` 指向的 profile（若其内容也匹配），
  /// 避免多个 profile 内容相同时，`status` 的 id 与 name 不一致。
  Future<Profile?> findActiveProfile() async {
    final profiles = _configService.profiles;
    final currentGitConfig = await _fileService.readFile(
      _pathService.gitConfigPath,
    );
    if (currentGitConfig == null) return null;

    final activeId = _configService.appConfig.activeProfileId;
    if (activeId != null) {
      for (final profile in profiles) {
        if (profile.id == activeId &&
            await _contentMatches(profile, currentGitConfig)) {
          return profile;
        }
      }
    }

    for (final profile in profiles) {
      if (await _contentMatches(profile, currentGitConfig)) {
        return profile;
      }
    }
    return null;
  }

  /// 整文件内容匹配（git + 可选 ssh）。
  Future<bool> _contentMatches(Profile profile, String currentGitConfig) async {
    if (!_normalizeEquals(currentGitConfig, profile.gitconfig)) return false;
    if (profile.useSsh) {
      final currentSsh = await _fileService.readFile(
        _pathService.sshConfigPath,
      );
      if (currentSsh == null ||
          !_normalizeEquals(currentSsh, profile.sshconfig)) {
        return false;
      }
    }
    return true;
  }

  /// 配置差异展示（规格 6.5）：行级 diff。
  Future<Map<String, dynamic>> getConfigDiff(Profile profile) async {
    final currentGit = await _fileService.readFile(_pathService.gitConfigPath);
    final currentSsh = profile.useSsh
        ? await _fileService.readFile(_pathService.sshConfigPath)
        : null;

    return {
      'gitDiff': _lineDiff(currentGit ?? '', profile.gitconfig),
      'sshDiff': currentSsh != null
          ? _lineDiff(currentSsh, profile.sshconfig)
          : <ConfigDiffEntry>[],
      'currentGitConfig': currentGit,
      'profileGitConfig': profile.gitconfig,
      'currentSshConfig': currentSsh,
      'profileSshConfig': profile.sshconfig,
    };
  }

  /// 行级 diff：逐行对比，标记 +新增 / −删除 / ~修改。
  /// 简化实现，不做字符级 diff。
  List<ConfigDiffEntry> _lineDiff(String oldContent, String newContent) {
    final oldLines = _splitLines(oldContent);
    final newLines = _splitLines(newContent);

    final result = <ConfigDiffEntry>[];
    final maxLen = oldLines.length > newLines.length
        ? oldLines.length
        : newLines.length;
    for (int i = 0; i < maxLen; i++) {
      final oldLine = i < oldLines.length ? oldLines[i] : '';
      final newLine = i < newLines.length ? newLines[i] : '';
      if (oldLine == newLine) continue;
      result.add(
        ConfigDiffEntry(
          lineNumber: i + 1,
          oldContent: oldLine,
          newContent: newLine,
        ),
      );
    }
    return result;
  }

  List<String> _splitLines(String content) {
    return content
        .replaceAll('\r\n', '\n')
        .split('\n')
        .where((l) => l.isNotEmpty)
        .toList();
  }

  /// 规范化比较：trim 两端 + 换行符归一化为 \n + 忽略末尾空行。
  bool _normalizeEquals(String a, String b) {
    String norm(String s) {
      return s
          .replaceAll('\r\n', '\n')
          .replaceAll('\r', '\n')
          .trimRight();
    }

    // 去掉末尾所有空行后比较。
    List<String> nonEmptyLines(String s) {
      return s
          .split('\n')
          .where((l) => l.trim().isNotEmpty)
          .toList();
    }

    return nonEmptyLines(norm(a)).join('\n') ==
        nonEmptyLines(norm(b)).join('\n');
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

  /// 用户主动备份当前 Git / SSH 配置，返回备份结果消息。
  Future<List<String>> backupCurrentConfig() async {
    final messages = <String>[];
    final gitBackup = await _fileService.backupFile(
      _pathService.gitConfigPath,
      _pathService.gitBackupDir,
      'gitconfig',
    );
    if (gitBackup != null) {
      messages.add(Msg.of.gitBackupDone);
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
        messages.add(Msg.of.sshBackupDone);
      }
    }

    if (messages.isEmpty) {
      messages.add(Msg.of.backupNothing);
    }
    return messages;
  }

  /// 恢复备份并重算活跃配置（规格 6.6）。
  ///
  /// 恢复完成后清除撤销快照，避免残留快照被 undo 覆盖恢复结果。
  /// 返回是否成功恢复。
  Future<bool> restoreBackupAndRecompute(BackupItem backup) async {
    final ok = await _fileService.restoreBackup(backup);
    if (!ok) return false;
    final active = await findActiveProfile();
    await _configService.updateActiveProfileId(active?.id);
    await _configService.clearLastSwitchSnapshot();
    return true;
  }

  /// 判断目标 sshconfig 是否"非本工具管理"（覆盖确认用）：当前 ~/.ssh/config
  /// 内容与所有 Profile 的 sshconfig 均不相等时返回 true。
  Future<bool> isUnmanagedSshConfig() async {
    final current = await _fileService.readFile(_pathService.sshConfigPath);
    if (current == null) return false;
    for (final profile in _configService.profiles) {
      if (_normalizeEquals(current, profile.sshconfig)) return false;
    }
    return true;
  }
}