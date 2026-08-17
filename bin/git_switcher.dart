import 'dart:convert';
import 'dart:io';

import 'package:git_switcher/l10n/cli_messages.dart';
import 'package:git_switcher/l10n/core_messages.dart';
import 'package:git_switcher/models/profile.dart';
import 'package:git_switcher/services/config_service.dart';
import 'package:git_switcher/services/file_service.dart';
import 'package:git_switcher/services/git_service.dart';
import 'package:git_switcher/services/log_service.dart';
import 'package:git_switcher/services/path_service.dart';
import 'package:git_switcher/services/ssh_template_service.dart';

/// Git Switcher 命令行工具。
///
/// 面向仅使用命令行的用户与自动化（AI）测试，功能与 GUI 一致：
/// 整文件切换 Git/SSH 配置、备份、回滚、一键撤销、Profile 管理、验证等。
///
/// 用法：
/// ```
/// git-switcher list
/// git-switcher status
/// git-switcher switch <name>
/// git-switcher add <name> --git <file> [--ssh <file>]
/// git-switcher undo
/// ```
/// 全局选项：`--home <dir>`（隔离主目录）、`--lang en|zh`、`--json`。
Future<void> main(List<String> args) async {
  final parsed = _parseGlobalArgs(args);
  final lang = parsed['lang'] as String?;
  if (lang == 'zh') {
    Msg.use(const ZhCoreMessages());
    CliMsg.use(const ZhCliMessages());
  } else {
    CliMsg.use(const DefaultCliMessages());
  }

  // 初始化路径与配置服务（可注入 --home 隔离目录）。
  final homeDir = parsed['home'] as String?;
  if (homeDir != null && homeDir.trim().isEmpty) {
    _emitGlobalError(CliMsg.of.homeEmpty(), parsed['json'] as bool);
    exit(2);
  }
  try {
    await PathService.instance.initialize(homeDir: homeDir);
  } catch (e) {
    _emitGlobalError(
      CliMsg.of.homeInvalid(homeDir ?? '', e.toString()),
      parsed['json'] as bool,
    );
    exit(1);
  }
  final logLevel = LogLevel.fromString((parsed['logLevel'] as String?) ?? 'info');
  LogService.instance.initialize(
    logDir: PathService.instance.logsDir,
    level: logLevel,
  );
  LogService.instance.info('Git Switcher CLI 启动 (--home=$homeDir)', tag: 'App');
  await ConfigService.instance.initialize();

  final exitCode = await _dispatch(
    parsed['command'] as String,
    (parsed['rest'] as List<String>),
    json: parsed['json'] as bool,
  );
  exit(exitCode);
}

/// 解析全局参数（--home / --lang / --json / --log-level / --help / --version），
/// 返回 `{command, rest, home, lang, json, logLevel}`。
Map<String, dynamic> _parseGlobalArgs(List<String> args) {
  final rest = <String>[];
  String? command;
  String? home;
  String? lang;
  String? logLevel;
  var json = false;

  for (var i = 0; i < args.length; i++) {
    final a = args[i];
    if (a == '--home') {
      if (i + 1 >= args.length) {
        _emitGlobalError(CliMsg.of.missingOptionValue('--home'), json);
        exit(2);
      }
      home = args[++i];
    } else if (a == '--lang') {
      if (i + 1 >= args.length) {
        _emitGlobalError(CliMsg.of.missingOptionValue('--lang'), json);
        exit(2);
      }
      lang = args[++i];
    } else if (a == '--log-level') {
      if (i + 1 >= args.length) {
        _emitGlobalError(CliMsg.of.missingOptionValue('--log-level'), json);
        exit(2);
      }
      logLevel = args[++i];
    } else if (a == '--json') {
      json = true;
    } else if (a == '--help' || a == '-h') {
      command = 'help';
    } else if (a == '--version' || a == '-v') {
      command = 'version';
    } else if (a.startsWith('-')) {
      rest.add(a);
    } else if (command == null) {
      command = a;
    } else {
      rest.add(a);
    }
  }

  return {
    'command': command ?? 'help',
    'rest': rest,
    'home': home,
    'lang': lang,
    'json': json,
    'logLevel': logLevel,
  };
}

Future<int> _dispatch(String command, List<String> args,
    {required bool json}) async {
  switch (command) {
    case 'help':
      _printHelp();
      return 0;
    case 'version':
      _printVersion(json);
      return 0;
    case 'list':
      return _cmdList(json);
    case 'status':
      return _cmdStatus(json);
    case 'show':
      return _cmdShow(args, json);
    case 'switch':
      return _cmdSwitch(args, json);
    case 'undo':
      return _cmdUndo(json);
    case 'backup':
      return _cmdBackup(json);
    case 'add':
      return _cmdAdd(args, json);
    case 'update':
      return _cmdUpdate(args, json);
    case 'remove':
    case 'delete':
      return _cmdRemove(args, json);
    case 'restore':
      return _cmdRestore(args, json);
    case 'verify':
      return _cmdVerify(args, json);
    case 'templates':
      return _cmdTemplates(json);
    default:
      _emitError(CliMsg.of.unknownCommand(command), json: json);
      return 2;
  }
}

// ---------------------------------------------------------------------------
// 子命令实现
// ---------------------------------------------------------------------------

int _cmdList(bool json) {
  final profiles = ConfigService.instance.profiles;
  if (json) {
    stdout.writeln(jsonEncode(
      profiles.map((p) => _profileJson(p)).toList(),
    ));
    return 0;
  }
  if (profiles.isEmpty) {
    stdout.writeln(CliMsg.of.listEmpty());
    return 0;
  }
  final activeId = ConfigService.instance.appConfig.activeProfileId;
  stdout.writeln(CliMsg.of.listCount(profiles.length));
  for (final p in profiles) {
    stdout.writeln(
      CliMsg.of.listItem(
        p.name,
        active: p.id == activeId,
        ssh: p.useSsh,
      ),
    );
  }
  return 0;
}

Future<int> _cmdStatus(bool json) async {
  final config = ConfigService.instance.appConfig;
  final gitService = GitService.instance;
  final active = await gitService.findActiveProfile();

  final status = <String, dynamic>{
    'activeProfileId': config.activeProfileId,
    'activeProfileName': active?.name,
    'profiles': ConfigService.instance.profiles.length,
    'readOnly': ConfigService.instance.isReadOnly,
    'gitConfigExists': File(PathService.instance.gitConfigPath).existsSync(),
    'sshConfigExists': File(PathService.instance.sshConfigPath).existsSync(),
    'hasUndoSnapshot': config.lastSwitchSnapshot != null,
  };

  if (json) {
    stdout.writeln(jsonEncode(status));
    return 0;
  }
  stdout.writeln(CliMsg.of.statusActive(active?.name));
  stdout.writeln(CliMsg.of.statusProfileCount(status['profiles'] as int));
  final gitExist = status['gitConfigExists'] == true;
  final sshExist = status['sshConfigExists'] == true;
  stdout.writeln('~/.gitconfig: ${gitExist ? CliMsg.of.statusYes() : CliMsg.of.statusNo()}');
  stdout.writeln('~/.ssh/config: ${sshExist ? CliMsg.of.statusYes() : CliMsg.of.statusNo()}');
  stdout.writeln(CliMsg.of.statusUndo(status['hasUndoSnapshot'] == true));
  stdout.writeln(CliMsg.of.statusReadOnly(status['readOnly'] == true));
  return 0;
}

Future<int> _cmdShow(List<String> args, bool json) async {
  Profile? target;
  if (args.isNotEmpty) {
    final byName = _findByName(args.first);
    if (byName == null) {
      _emitError(CliMsg.of.profileNotFound(args.first), json: json);
      return 1;
    }
    target = byName;
  } else {
    target = await GitService.instance.findActiveProfile();
    if (target == null) {
      _emitError(CliMsg.of.profileNotFoundOrNoActive(), json: json);
      return 1;
    }
  }
  if (json) {
    stdout.writeln(jsonEncode(_profileJson(target)));
    return 0;
  }
  _printProfile(target);
  return 0;
}

Future<int> _cmdSwitch(List<String> args, bool json) async {
  if (args.isEmpty) {
    _emitError(CliMsg.of.usageSwitch(), json: json);
    return 2;
  }
  final force = args.contains('--force');
  final nameArgs = args.where((a) => a != '--force').toList();
  if (nameArgs.isEmpty) {
    _emitError(CliMsg.of.usageSwitch(), json: json);
    return 2;
  }
  final profile = _findByName(nameArgs.first);
  if (profile == null) {
    _emitError(CliMsg.of.profileNotFound(nameArgs.first), json: json);
    return 1;
  }

  // 覆盖确认（规格 6.1）：仅 use_ssh 且当前 ~/.ssh/config 非本工具管理时。
  if (profile.useSsh && await GitService.instance.isUnmanagedSshConfig()) {
    if (!force) {
      if (json) {
        stdout.writeln(jsonEncode({
          'success': false,
          'blocked': true,
          'reason': CliMsg.of.overwriteSshWarning(),
        }));
      } else {
        stderr.writeln(CliMsg.of.overwriteSshWarning());
        stderr.writeln(CliMsg.of.overwriteSshAbort());
        stderr.writeln(CliMsg.of.overwriteSshHint());
      }
      return 1;
    }
  }

  final config = ConfigService.instance.appConfig;
  final result = await GitService.instance.switchProfile(
    profile,
    config.enableBackup,
    config.maxBackupCount,
  );

  if (!result.success) {
    if (json) {
      stdout.writeln(jsonEncode({
        'success': false,
        'level': result.level,
        'messages': result.messages,
      }));
      return 1;
    }
    for (final m in result.messages) {
      stdout.writeln('  $m');
    }
    stderr.writeln(CliMsg.of.switchFailed(profile.name));
    return 1;
  }

  // 切换成功后自动验证（规格 6.2）；验证失败不回滚。
  final verify = await GitService.instance.verifyAfterSwitch(profile);
  final verified = verify['verified'] == true;

  if (json) {
    stdout.writeln(jsonEncode({
      'success': true,
      'level': verified ? 'green' : 'yellow',
      'messages': result.messages,
      'verified': verified,
      'verifyReason': verified ? '' : verify['reason'],
    }));
    return 0;
  }

  for (final m in result.messages) {
    stdout.writeln('  $m');
  }
  if (verified) {
    stdout.writeln(CliMsg.of.switchVerified(profile.name));
  } else {
    stdout.writeln(CliMsg.of.switchWrittenNotVerified(verify['reason']));
  }
  return 0;
}

Future<int> _cmdUndo(bool json) async {
  final (done, error) = await GitService.instance.undoLastSwitch();
  if (json) {
    stdout.writeln(jsonEncode({'done': done, 'error': error}));
    return 0;
  }
  if (done) {
    stdout.writeln(CliMsg.of.undoDone());
    return 0;
  }
  stdout.writeln(error ?? CliMsg.of.undoNothing());
  return 0;
}

Future<int> _cmdBackup(bool json) async {
  final messages = await GitService.instance.backupCurrentConfig();
  if (json) {
    stdout.writeln(jsonEncode({'messages': messages}));
    return 0;
  }
  for (final m in messages) {
    stdout.writeln('  $m');
  }
  return 0;
}

Future<int> _cmdAdd(List<String> args, bool json) async {
  if (args.isEmpty) {
    _emitError(CliMsg.of.usageAdd(), json: json);
    return 2;
  }
  final name = args.first.trim();
  final gitFile = _optValue(args, '--git');
  final sshFile = _optValue(args, '--ssh');
  final useSsh = sshFile != null;

  if (name.isEmpty) {
    _emitError(CliMsg.of.nameRequired(), json: json);
    return 1;
  }
  if (name.startsWith('-')) {
    // 防止把 --git/--force 等选项误当名称（如 `add --git file`）。
    _emitError(CliMsg.of.nameInvalid(name), json: json);
    return 1;
  }
  for (final p in ConfigService.instance.profiles) {
    if (p.name == name) {
      _emitError(CliMsg.of.nameExists(name), json: json);
      return 1;
    }
  }

  // 选项出现但缺值（末尾缺值、或值被写成了下一个 --xxx 选项）→ 报缺值错误，
  // 而非静默忽略（此前 `--ssh` 缺值会静默降级为 git-only）。
  if (args.contains('--git') && gitFile == null) {
    _emitError(CliMsg.of.missingOptionValue('--git'), json: json);
    return 2;
  }
  if (args.contains('--ssh') && sshFile == null) {
    _emitError(CliMsg.of.missingOptionValue('--ssh'), json: json);
    return 2;
  }
  if (gitFile == null) {
    _emitError(CliMsg.of.missingGitFile(), json: json);
    return 2;
  }
  final gitContent = _readFileOrNull(gitFile);
  if (gitContent == null) {
    _emitError(CliMsg.of.gitFileUnreadable(gitFile), json: json);
    return 1;
  }
  if (gitContent.trim().isEmpty) {
    // 与 ssh 空文件策略对齐：gitconfig 不允许空内容。
    _emitError(CliMsg.of.gitFileEmpty(gitFile), json: json);
    return 1;
  }
  String? sshContent;
  if (useSsh) {
    sshContent = _readFileOrNull(sshFile);
    if (sshContent == null) {
      _emitError(CliMsg.of.sshFileUnreadable(sshFile), json: json);
      return 1;
    }
    if (sshContent.trim().isEmpty) {
      _emitError(CliMsg.of.sshFileEmpty(sshFile), json: json);
      return 1;
    }
  }

  final profile = Profile(
    name: name,
    gitconfig: gitContent.trim(),
    useSsh: useSsh,
    sshconfig: (sshContent ?? '').trim(),
  );
  final ok = await ConfigService.instance.addProfile(profile);
  if (json) {
    stdout.writeln(jsonEncode({'success': ok, 'id': profile.id}));
    return ok ? 0 : 1;
  }
  if (ok) {
    stdout.writeln(CliMsg.of.addSuccess(name, profile.id));
    return 0;
  }
  _emitError(CliMsg.of.addFailed(), json: json);
  return 1;
}

Future<int> _cmdUpdate(List<String> args, bool json) async {
  if (args.isEmpty) {
    _emitError(CliMsg.of.usageUpdate(), json: json);
    return 2;
  }
  final existing = _findByName(args.first);
  if (existing == null) {
    _emitError(CliMsg.of.profileNotFound(args.first), json: json);
    return 1;
  }
  final gitFile = _optValue(args, '--git');
  final sshFile = _optValue(args, '--ssh');
  final noSsh = args.contains('--no-ssh');

  if (noSsh && sshFile != null) {
    _emitError(CliMsg.of.updateSshConflict(), json: json);
    return 2;
  }
  // 选项出现但缺值 → 报缺值错误（与 add 一致）。
  if (args.contains('--git') && gitFile == null) {
    _emitError(CliMsg.of.missingOptionValue('--git'), json: json);
    return 2;
  }
  if (args.contains('--ssh') && sshFile == null) {
    _emitError(CliMsg.of.missingOptionValue('--ssh'), json: json);
    return 2;
  }
  // 什么都没提供 → 明确报错，避免"成功"地空更新。
  if (gitFile == null && sshFile == null && !noSsh) {
    _emitError(CliMsg.of.updateNothing(), json: json);
    return 2;
  }

  final gitContent = gitFile != null ? _readFileOrNull(gitFile) : null;
  if (gitFile != null && gitContent == null) {
    _emitError(CliMsg.of.gitFileUnreadable(gitFile), json: json);
    return 1;
  }
  if (gitContent != null && gitContent.trim().isEmpty) {
    _emitError(CliMsg.of.gitFileEmpty(gitFile!), json: json);
    return 1;
  }
  String? sshContent;
  if (sshFile != null) {
    sshContent = _readFileOrNull(sshFile);
    if (sshContent == null) {
      _emitError(CliMsg.of.sshFileUnreadable(sshFile), json: json);
      return 1;
    }
    if (sshContent.trim().isEmpty) {
      _emitError(CliMsg.of.sshFileEmpty(sshFile), json: json);
      return 1;
    }
  }

  final updated = existing.copyWith(
    gitconfig: gitContent?.trim() ?? existing.gitconfig,
    // --no-ssh 关闭 SSH 切换并清空 sshconfig；否则仅当传入 --ssh 时启用。
    useSsh: noSsh ? false : (sshContent != null ? true : existing.useSsh),
    sshconfig: noSsh ? '' : (sshContent?.trim() ?? existing.sshconfig),
  );
  final ok = await ConfigService.instance.updateProfile(updated);
  if (json) {
    stdout.writeln(jsonEncode({'success': ok, 'id': updated.id}));
    return ok ? 0 : 1;
  }
  if (ok) {
    stdout.writeln(CliMsg.of.updateSuccess(updated.name));
    return 0;
  }
  _emitError(CliMsg.of.updateFailed(), json: json);
  return 1;
}

Future<int> _cmdRemove(List<String> args, bool json) async {
  if (args.isEmpty) {
    _emitError(CliMsg.of.usageRemove(), json: json);
    return 2;
  }
  final profile = _findByName(args.first);
  if (profile == null) {
    _emitError(CliMsg.of.profileNotFound(args.first), json: json);
    return 1;
  }
  final ok = await ConfigService.instance.deleteProfile(profile.id);
  if (json) {
    stdout.writeln(jsonEncode({'success': ok, 'id': profile.id}));
    return ok ? 0 : 1;
  }
  if (ok) {
    stdout.writeln(CliMsg.of.removeSuccess(profile.name));
    return 0;
  }
  _emitError(CliMsg.of.removeFailed(), json: json);
  return 1;
}

Future<int> _cmdRestore(List<String> args, bool json) async {
  if (args.length < 2) {
    _emitError(CliMsg.of.restoreMissingArg(), json: json);
    return 2;
  }
  final type = args[0];
  final filename = args[1];
  if (type != 'git' && type != 'ssh') {
    _emitError(CliMsg.of.restoreUnknownType(type), json: json);
    return 2;
  }

  final items = await FileService.instance.getBackupList();
  final matches = items
      .where((b) => b.type == type)
      .where((b) => b.filename == filename)
      .toList();
  final target = matches.isEmpty ? null : matches.first;

  if (target == null) {
    _emitError(CliMsg.of.backupNotFound(filename), json: json);
    return 1;
  }

  final ok = await GitService.instance.restoreBackupAndRecompute(target);

  if (json) {
    stdout.writeln(jsonEncode({'success': ok, 'filename': filename}));
    return ok ? 0 : 1;
  }
  if (ok) {
    stdout.writeln(CliMsg.of.restoreSuccess(filename));
    return 0;
  }
  _emitError(CliMsg.of.restoreFailed(), json: json);
  return 1;
}

Future<int> _cmdVerify(List<String> args, bool json) async {
  Profile? target;
  if (args.isNotEmpty) {
    final byName = _findByName(args.first);
    if (byName == null) {
      _emitError(CliMsg.of.profileNotFound(args.first), json: json);
      return 1;
    }
    target = byName;
  } else {
    target = await GitService.instance.findActiveProfile();
    if (target == null) {
      _emitError(CliMsg.of.profileNotFoundOrNoActive(), json: json);
      return 1;
    }
  }
  final result = await GitService.instance.verifyAfterSwitch(target);
  if (json) {
    stdout.writeln(jsonEncode(result));
    return result['verified'] == true ? 0 : 1;
  }
  if (result['verified'] == true) {
    stdout.writeln(CliMsg.of.verifyPassed(target.name));
    return 0;
  }
  stderr.writeln(CliMsg.of.verifyFailed(result['reason']));
  return 1;
}

int _cmdTemplates(bool json) {
  final identity = '~/.ssh/id_ed25519_<identifier>';
  final templates = {
    'github_direct': SshTemplateService.instance.build(
      provider: SshProvider.github,
      mode: ProxyMode.direct,
      identityFile: identity,
    ),
    'github_proxy': SshTemplateService.instance.build(
      provider: SshProvider.github,
      mode: ProxyMode.proxy,
      identityFile: identity,
    ),
    'gitlab': SshTemplateService.instance.build(
      provider: SshProvider.gitlab,
      mode: ProxyMode.direct,
      identityFile: identity,
    ),
    'gitee': SshTemplateService.instance.build(
      provider: SshProvider.gitee,
      mode: ProxyMode.direct,
      identityFile: identity,
    ),
  };
  if (json) {
    stdout.writeln(jsonEncode(templates));
    return 0;
  }
  templates.forEach((name, content) {
    stdout.writeln('--- $name ---');
    stdout.writeln(content);
    stdout.writeln();
  });
  return 0;
}

// ---------------------------------------------------------------------------
// 工具方法
// ---------------------------------------------------------------------------

/// 取选项值。选项缺值、或值本身是另一个 `--xxx` 选项时返回 null，
/// 由调用方结合「选项是否出现」区分类别并报缺值错误。
String? _optValue(List<String> args, String key) {
  final i = args.indexOf(key);
  if (i == -1 || i + 1 >= args.length) return null;
  final value = args[i + 1];
  if (value.startsWith('--')) return null;
  return value;
}

Profile? _findByName(String name) {
  // 名称在 add 时会被 trim 存储，查找同样按 trim 匹配，
  // 避免 `add " work"` 成功后 `switch " work"` 却找不到的不一致。
  final trimmed = name.trim();
  for (final p in ConfigService.instance.profiles) {
    if (p.name.trim() == trimmed) return p;
  }
  return null;
}

String? _readFileOrNull(String path) {
  try {
    final f = File(path);
    if (!f.existsSync()) return null;
    return f.readAsStringSync();
  } catch (_) {
    return null;
  }
}

void _printProfile(Profile p) {
  stdout.writeln(CliMsg.of.fieldName(p.name));
  stdout.writeln(CliMsg.of.fieldId(p.id));
  stdout.writeln(CliMsg.of.sshEnabled(p.useSsh));
  stdout.writeln(CliMsg.of.headerGitConfig());
  stdout.writeln(p.gitconfig);
  if (p.useSsh) {
    stdout.writeln(CliMsg.of.headerSshConfig());
    stdout.writeln(p.sshconfig);
  }
}

Map<String, dynamic> _profileJson(Profile p) {
  return {
    'id': p.id,
    'name': p.name,
    'use_ssh': p.useSsh,
    'gitconfig': p.gitconfig,
    'sshconfig': p.sshconfig,
  };
}

void _printVersion(bool json) {
  if (json) {
    stdout.writeln(jsonEncode({'name': 'git-switcher', 'version': '1.0.0'}));
    return;
  }
  stdout.writeln('git-switcher 1.0.0');
}

/// 全局参数错误：`--json` 模式输出结构化 JSON，否则纯文本到 stderr。
void _emitGlobalError(String message, bool json) {
  if (json) {
    stdout.writeln(jsonEncode({'success': false, 'error': message}));
  } else {
    stderr.writeln(message);
  }
}

/// 输出命令错误：`--json` 模式输出结构化 JSON 到 stdout，否则纯文本到 stderr。
void _emitError(String message, {required bool json}) {
  if (json) {
    stdout.writeln(jsonEncode({'success': false, 'error': message}));
  } else {
    stderr.writeln(message);
  }
}

void _printHelp() {
  stdout.writeln(CliMsg.of.helpText);
}
