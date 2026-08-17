/// 核心服务消息源（纯 Dart）。
///
/// GUI 与 CLI 共用的服务（GitService / FileService）在生成用户可见消息时
/// 通过 [Msg.of] 读取文案。GUI 侧在 `applyLocale` 时注入基于
/// AppLocalizations 的适配器；CLI 侧默认使用英文（[DefaultCoreMessages]），
/// 可通过 `--lang zh` 切换为 [ZhCoreMessages]。
///
/// 该文件**禁止**引入任何 Flutter 依赖，以保证纯 Dart 命令行工具可编译运行。
library;

/// 核心服务所需的全部消息。
abstract class CoreMessages {
  String get gitBackupDone;
  String get sshBackupDone;
  String get gitConfigUpdated;
  String get gitConfigUpdateFailed;
  String get sshConfigUpdated;
  String get sshConfigUpdateFailed;
  String get configRolledBack;
  String get sshNoIdentityFile;
  String get undoFailed;
  String get verifyGitMismatch;
  String get backupNothing;

  String keyFileNotExist(Object path);
  String keyPermissionIncorrect(Object permissions);
  String get keyPermissionCheckFailed;
  String verifySshFailed(Object host);
}

/// 全局消息访问器。未注入时回退到英文。
class Msg {
  Msg._();

  static CoreMessages? _impl;

  static CoreMessages get of => _impl ?? const DefaultCoreMessages();

  static void use(CoreMessages impl) => _impl = impl;

  static void clear() => _impl = null;
}

/// 英文（默认）。文案与 `app_localizations_en.dart` 保持一致。
class DefaultCoreMessages implements CoreMessages {
  const DefaultCoreMessages();

  @override
  String get gitBackupDone => 'Current Git config backed up';

  @override
  String get sshBackupDone => 'Current SSH config backed up';

  @override
  String get gitConfigUpdated => 'Git config updated';

  @override
  String get gitConfigUpdateFailed => 'Failed to update Git config';

  @override
  String get sshConfigUpdated => 'SSH config updated';

  @override
  String get sshConfigUpdateFailed => 'Failed to update SSH config';

  @override
  String get configRolledBack => 'Configuration rolled back';

  @override
  String get sshNoIdentityFile =>
      'No IdentityFile line found in SSH config';

  @override
  String get undoFailed => 'Undo failed';

  @override
  String get verifyGitMismatch =>
      'Git identity verification failed: user.name or user.email does not match the target config';

  @override
  String get backupNothing => 'Nothing to back up';

  @override
  String keyFileNotExist(Object path) =>
      'Private key file does not exist: $path';

  @override
  String keyPermissionIncorrect(Object permissions) =>
      'Private key permissions are incorrect, should be 600, current is $permissions';

  @override
  String get keyPermissionCheckFailed =>
      'Unable to check private key permissions';

  @override
  String verifySshFailed(Object host) => 'SSH verification failed: $host';
}

/// 中文。文案与 `app_zh.arb` 保持一致。
class ZhCoreMessages implements CoreMessages {
  const ZhCoreMessages();

  @override
  String get gitBackupDone => '已备份当前Git配置';

  @override
  String get sshBackupDone => '已备份当前SSH配置';

  @override
  String get gitConfigUpdated => 'Git配置已更新';

  @override
  String get gitConfigUpdateFailed => 'Git配置更新失败';

  @override
  String get sshConfigUpdated => 'SSH配置已更新';

  @override
  String get sshConfigUpdateFailed => 'SSH配置更新失败';

  @override
  String get configRolledBack => '已回滚配置';

  @override
  String get sshNoIdentityFile => 'SSH 配置中未找到 IdentityFile 行';

  @override
  String get undoFailed => '撤销失败';

  @override
  String get verifyGitMismatch =>
      'Git 身份验证未通过：user.name 或 user.email 与目标配置不一致';

  @override
  String get backupNothing => '没有可备份的配置';

  @override
  String keyFileNotExist(Object path) => '私钥文件不存在: $path';

  @override
  String keyPermissionIncorrect(Object permissions) =>
      '私钥权限不正确，应为600，当前为$permissions';

  @override
  String get keyPermissionCheckFailed => '无法检查私钥权限';

  @override
  String verifySshFailed(Object host) => 'SSH 验证未通过: $host';
}
