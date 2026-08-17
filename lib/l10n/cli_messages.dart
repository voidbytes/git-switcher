/// CLI 专用消息源（纯 Dart）。
///
/// 与 [CoreMessages]（服务层消息）分离，供 `bin/git_switcher.dart` 使用，
/// 保证 CLI 自带的提示/错误消息随 `--lang en|zh` 统一切换（避免中英混杂）。
///
/// 该文件**禁止**引入任何 Flutter 依赖，以保证纯 Dart 命令行工具可编译运行。
library;

/// CLI 所需的全部消息。
abstract class CliMessages {
  // 通用错误
  String missingOptionValue(String option);
  String unknownCommand(String command);
  String homeEmpty();
  String homeInvalid(String path, String error);

  // 用法
  String usageSwitch();
  String usageAdd();
  String usageUpdate();
  String usageRemove();
  String usageRestore();

  // list
  String listEmpty();
  String listCount(int count);
  String listItem(String name, {bool active = false, bool ssh = false});

  // status
  String statusActive(String? name);
  String statusProfileCount(int count);
  String statusYes();
  String statusNo();
  String statusUndo(bool has);
  String statusReadOnly(bool ro);

  // show
  String profileNotFoundOrNoActive();
  String profileNotFound(String name);
  String fieldName(String name);
  String fieldId(String id);
  String sshEnabled(bool enabled);
  String headerGitConfig();
  String headerSshConfig();

  // switch
  String switchSuccess(String name);
  String switchFailed(String name);
  String switchVerified(String name);
  String switchWrittenNotVerified(String reason);
  String overwriteSshWarning();
  String overwriteSshAbort();
  String overwriteSshHint();

  // undo
  String undoDone();
  String undoNothing();

  // backup
  String backupManualDone();

  // add
  String nameRequired();
  String nameInvalid(String name);
  String nameExists(String name);
  String missingGitFile();
  String gitFileUnreadable(String path);
  String gitFileEmpty(String path);
  String sshFileUnreadable(String path);
  String sshFileEmpty(String path);
  String addSuccess(String name, String id);
  String addFailed();

  // update
  String updateSuccess(String name);
  String updateFailed();
  String updateSshConflict();
  String updateNothing();

  // remove
  String removeSuccess(String name);
  String removeFailed();

  // verify
  String verifyPassed(String name);
  String verifyFailed(String reason);

  // restore
  String restoreSuccess(String filename);
  String restoreFailed();
  String restoreMissingArg();
  String restoreUnknownType(String type);
  String backupNotFound(String filename);

  // help / version
  String get helpText;
}

/// 全局 CLI 消息访问器。未注入时回退到英文。
class CliMsg {
  CliMsg._();

  static CliMessages? _impl;

  static CliMessages get of => _impl ?? const DefaultCliMessages();

  static void use(CliMessages impl) => _impl = impl;

  static void clear() => _impl = null;
}

/// 英文（默认）。
class DefaultCliMessages implements CliMessages {
  const DefaultCliMessages();

  @override
  String missingOptionValue(String option) => 'Option $option requires a value';

  @override
  String unknownCommand(String command) =>
      'Unknown command: $command (use help for usage)';

  @override
  String homeEmpty() => 'Home directory path is empty';

  @override
  String homeInvalid(String path, String error) =>
      'Invalid home directory "$path": $error';

  @override
  String usageSwitch() => 'Usage: git-switcher switch <name>';

  @override
  String usageAdd() =>
      'Usage: git-switcher add <name> --git <file> [--ssh <file>]';

  @override
  String usageUpdate() =>
      'Usage: git-switcher update <name> --git <file> [--ssh <file>] [--no-ssh]';

  @override
  String usageRemove() => 'Usage: git-switcher remove <name>';

  @override
  String usageRestore() =>
      'Usage: git-switcher restore <git|ssh> <filename>';

  @override
  String listEmpty() => 'No profiles yet. Add one with: git-switcher add';

  @override
  String listCount(int count) => '$count profile(s):';

  @override
  String listItem(String name, {bool active = false, bool ssh = false}) {
    final buf = StringBuffer('  - $name');
    if (active) buf.write(' [active]');
    if (ssh) buf.write(' [SSH]');
    return buf.toString();
  }

  @override
  String statusActive(String? name) => 'Active profile: ${name ?? 'none'}';

  @override
  String statusProfileCount(int count) => 'Profile count: $count';

  @override
  String statusYes() => 'yes';

  @override
  String statusNo() => 'no';

  @override
  String statusUndo(bool has) => 'Undo available: ${has ? statusYes() : statusNo()}';

  @override
  String statusReadOnly(bool ro) =>
      'Read-only mode: ${ro ? statusYes() : statusNo()}';

  @override
  String profileNotFoundOrNoActive() =>
      'Profile not found or no active configuration';

  @override
  String profileNotFound(String name) => 'Profile not found: $name';

  @override
  String fieldName(String name) => 'Name: $name';

  @override
  String fieldId(String id) => 'id: $id';

  @override
  String sshEnabled(bool enabled) =>
      'SSH switching: ${enabled ? 'enabled' : 'disabled'}';

  @override
  String headerGitConfig() => '--- gitconfig ---';

  @override
  String headerSshConfig() => '--- sshconfig ---';

  @override
  String switchSuccess(String name) => 'Switch successful: $name';

  @override
  String switchFailed(String name) => 'Switch failed: $name';

  @override
  String switchVerified(String name) =>
      'Switch successful, identity verified: $name';

  @override
  String switchWrittenNotVerified(String reason) =>
      'Config written, but verification failed: $reason';

  @override
  String overwriteSshWarning() =>
      'The current ~/.ssh/config is not managed by this tool and will be overwritten.';

  @override
  String overwriteSshAbort() =>
      'Switch aborted to avoid overwriting unmanaged SSH config.';

  @override
  String overwriteSshHint() =>
      'Use --force to override this check.';

  @override
  String undoDone() => 'Last switch undone';

  @override
  String undoNothing() => 'Nothing to undo';

  @override
  String backupManualDone() => 'Current config backed up';

  @override
  String nameRequired() => 'Name cannot be empty';

  @override
  String nameInvalid(String name) =>
      'Invalid profile name "$name" (must not start with "-")';

  @override
  String nameExists(String name) => 'Name already exists: $name';

  @override
  String missingGitFile() =>
      'Missing --git <file> (source of .gitconfig content)';

  @override
  String gitFileUnreadable(String path) =>
      'Cannot read Git config file: $path';

  @override
  String gitFileEmpty(String path) =>
      'Git config file is empty (gitconfig requires non-empty content): $path';

  @override
  String sshFileUnreadable(String path) =>
      'Cannot read SSH config file: $path';

  @override
  String sshFileEmpty(String path) =>
      'SSH config file is empty (use_ssh requires non-empty sshconfig): $path';

  @override
  String addSuccess(String name, String id) =>
      'Profile added: $name (id=$id)';

  @override
  String addFailed() => 'Failed to add profile';

  @override
  String updateSuccess(String name) => 'Profile updated: $name';

  @override
  String updateFailed() => 'Failed to update profile';

  @override
  String updateSshConflict() =>
      'Cannot combine --ssh with --no-ssh (choose one)';

  @override
  String updateNothing() =>
      'Nothing to update (use --git <file>, --ssh <file> or --no-ssh)';

  @override
  String removeSuccess(String name) => 'Profile removed: $name';

  @override
  String removeFailed() => 'Failed to remove profile';

  @override
  String verifyPassed(String name) => 'Verification passed: $name';

  @override
  String verifyFailed(String reason) => 'Verification failed: $reason';

  @override
  String restoreSuccess(String filename) => 'Restored: $filename';

  @override
  String restoreFailed() => 'Restore failed';

  @override
  String restoreMissingArg() =>
      'Usage: git-switcher restore <git|ssh> <filename>';

  @override
  String restoreUnknownType(String type) =>
      'Unknown backup type: $type (expected git or ssh)';

  @override
  String backupNotFound(String filename) =>
      'Backup not found: $filename';

  @override
  String get helpText => '''
Git Switcher CLI - switch Git/SSH configs as a whole file

Usage:
  git-switcher <command> [options]

Commands:
  list                   List all profiles
  status                 Show current status (active profile, config files, etc.)
  show [name]            Show profile details (defaults to active profile)
  switch <name>          Switch config in one shot
  undo                   Undo the last switch
  backup                 Manually back up current Git/SSH config
  add <name> --git <file> [--ssh <file>]   Add a profile
  update <name> --git <file> [--ssh <file>] [--no-ssh] Update a profile
  remove <name>          Remove a profile
  restore <git|ssh> <filename>  Restore a backup
  verify [name]          Verify the current/target profile
  templates              List built-in SSH templates
  help                   Show this help

Global options:
  --home <dir>        Use given directory as home (defaults to system HOME, for test isolation)
  --lang <lang>       Output language: en | zh (default en)
  --log-level <level> Log level: trace | debug | info | warn | error (default info, logged to ~/.git_switcher/logs)
  --json              Emit structured JSON output (for automation/AI testing)
  -v, --version       Show version
  -h, --help          Show help

Examples:
  git-switcher list
  git-switcher status --json
  git-switcher add work --git /tmp/work.gitconfig --ssh /tmp/work.sshconfig
  git-switcher switch work
  git-switcher undo
''';
}

/// 中文。
class ZhCliMessages implements CliMessages {
  const ZhCliMessages();

  @override
  String missingOptionValue(String option) => '选项 $option 缺少参数值';

  @override
  String unknownCommand(String command) =>
      '未知命令: $command（使用 help 查看用法）';

  @override
  String homeEmpty() => '主目录路径为空';

  @override
  String homeInvalid(String path, String error) =>
      '无效的主目录 "$path": $error';

  @override
  String usageSwitch() => '用法: git-switcher switch <name>';

  @override
  String usageAdd() =>
      '用法: git-switcher add <name> --git <file> [--ssh <file>]';

  @override
  String usageUpdate() =>
      '用法: git-switcher update <name> --git <file> [--ssh <file>] [--no-ssh]';

  @override
  String usageRemove() => '用法: git-switcher remove <name>';

  @override
  String usageRestore() => '用法: git-switcher restore <git|ssh> <filename>';

  @override
  String listEmpty() => '（无 Profile，使用 add 添加）';

  @override
  String listCount(int count) => '共 $count 个 Profile：';

  @override
  String listItem(String name, {bool active = false, bool ssh = false}) {
    final buf = StringBuffer('  - $name');
    if (active) buf.write(' [活跃]');
    if (ssh) buf.write(' [SSH]');
    return buf.toString();
  }

  @override
  String statusActive(String? name) => '活跃 Profile: ${name ?? '无'}';

  @override
  String statusProfileCount(int count) => 'Profile 数量: $count';

  @override
  String statusYes() => '是';

  @override
  String statusNo() => '否';

  @override
  String statusUndo(bool has) => '可撤销: ${has ? statusYes() : statusNo()}';

  @override
  String statusReadOnly(bool ro) =>
      '只读模式: ${ro ? statusYes() : statusNo()}';

  @override
  String profileNotFoundOrNoActive() => '未找到 Profile 或当前无活跃配置';

  @override
  String profileNotFound(String name) => '未找到 Profile: $name';

  @override
  String fieldName(String name) => '名称: $name';

  @override
  String fieldId(String id) => 'id: $id';

  @override
  String sshEnabled(bool enabled) =>
      'SSH 切换: ${enabled ? '启用' : '禁用'}';

  @override
  String headerGitConfig() => '--- gitconfig ---';

  @override
  String headerSshConfig() => '--- sshconfig ---';

  @override
  String switchSuccess(String name) => '切换成功：$name';

  @override
  String switchFailed(String name) => '切换失败：$name';

  @override
  String switchVerified(String name) => '切换成功，身份已验证：$name';

  @override
  String switchWrittenNotVerified(String reason) =>
      '配置已写入，但验证未通过：$reason';

  @override
  String overwriteSshWarning() =>
      '当前 ~/.ssh/config 非本工具管理，切换将覆盖它。';

  @override
  String overwriteSshAbort() => '已中止切换，避免覆盖非本工具管理的 SSH 配置。';

  @override
  String overwriteSshHint() => '如确认覆盖请使用 --force。';

  @override
  String undoDone() => '已撤销最近一次切换';

  @override
  String undoNothing() => '没有可撤销的切换';

  @override
  String backupManualDone() => '已备份当前配置';

  @override
  String nameRequired() => '名称不能为空';

  @override
  String nameInvalid(String name) =>
      '无效的 Profile 名称 "$name"（不能以 "-" 开头）';

  @override
  String nameExists(String name) => '名称已存在: $name';

  @override
  String missingGitFile() => '缺少 --git <file>（.gitconfig 内容来源）';

  @override
  String gitFileUnreadable(String path) => '无法读取 Git 配置文件: $path';

  @override
  String gitFileEmpty(String path) =>
      'Git 配置文件内容为空（gitconfig 需非空内容）: $path';

  @override
  String sshFileUnreadable(String path) => '无法读取 SSH 配置文件: $path';

  @override
  String sshFileEmpty(String path) =>
      'SSH 配置文件内容为空（use_ssh 需非空 sshconfig）: $path';

  @override
  String addSuccess(String name, String id) =>
      '已添加 Profile: $name（id=$id）';

  @override
  String addFailed() => '添加 Profile 失败';

  @override
  String updateSuccess(String name) => '已更新 Profile: $name';

  @override
  String updateFailed() => '更新 Profile 失败';

  @override
  String updateSshConflict() =>
      '不能同时使用 --ssh 和 --no-ssh（请二选一）';

  @override
  String updateNothing() =>
      '没有任何更新（请使用 --git <file>、--ssh <file> 或 --no-ssh）';

  @override
  String removeSuccess(String name) => '已删除 Profile: $name';

  @override
  String removeFailed() => '删除 Profile 失败';

  @override
  String verifyPassed(String name) => '验证通过：$name';

  @override
  String verifyFailed(String reason) => '验证失败：$reason';

  @override
  String restoreSuccess(String filename) => '恢复成功: $filename';

  @override
  String restoreFailed() => '恢复失败';

  @override
  String restoreMissingArg() => '用法: git-switcher restore <git|ssh> <filename>';

  @override
  String restoreUnknownType(String type) =>
      '未知备份类型: $type（应为 git 或 ssh）';

  @override
  String backupNotFound(String filename) => '未找到备份文件: $filename';

  @override
  String get helpText => '''
Git Switcher 命令行工具 — 整文件切换 Git/SSH 配置

用法:
  git-switcher <command> [options]

命令:
  list                  列出所有 Profile
  status                显示当前状态（活跃 Profile、配置文件等）
  show [name]           显示 Profile 详情（缺省为活跃 Profile）
  switch <name>         一键切换配置
  undo                  撤销最近一次切换
  backup                手动备份当前 Git/SSH 配置
  add <name> --git <file> [--ssh <file>]   新增 Profile
  update <name> --git <file> [--ssh <file>] [--no-ssh] 更新 Profile
  remove <name>         删除 Profile
  restore <git|ssh> <filename>  从备份恢复配置
  verify [name]         校验当前/目标 Profile
  templates             列出内置 SSH 模板
  help                  显示本帮助

全局选项:
  --home <dir>   使用指定目录作为主目录（默认取系统 HOME，便于测试隔离）
  --lang <lang>  输出语言: en | zh（默认 en）
  --log-level <level> 日志级别: trace | debug | info | warn | error（默认 info，写入 ~/.git_switcher/logs）
  --json         以 JSON 输出结构化结果（便于自动化/AI 测试）
  -v, --version  显示版本
  -h, --help     显示帮助

示例:
  git-switcher list
  git-switcher status --json
  git-switcher add work --git /tmp/work.gitconfig --ssh /tmp/work.sshconfig
  git-switcher switch work
  git-switcher undo
''';
}
