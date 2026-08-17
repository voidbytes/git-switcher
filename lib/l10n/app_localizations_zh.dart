// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Git账号切换器';

  @override
  String get trayShowWindow => '显示主窗口';

  @override
  String get trayAbout => '关于';

  @override
  String get trayExit => '退出';

  @override
  String get aboutTitle => '关于 Git Switcher';

  @override
  String get aboutAuthor => '作者: voidbytes';

  @override
  String get aboutAuthorHomepage => '作者主页:';

  @override
  String get aboutProjectUrl => '项目地址:';

  @override
  String get close => '关闭';

  @override
  String switchFailedWithError(Object error) {
    return '切换失败: $error';
  }

  @override
  String get sshConfigConflictTitle => 'SSH 配置冲突';

  @override
  String sshConfigConflictContent(
    Object conflictPath,
    Object host,
    Object identityFile,
  ) {
    return '检测到当前系统中针对主机 \"$host\" 的 SSH 私钥路径为:\n\n$conflictPath\n\n您希望将其更改为:\n\n$identityFile\n\n是否继续？';
  }

  @override
  String get cancel => '取消';

  @override
  String get continueSwitch => '继续切换';

  @override
  String get switchSuccess => '切换成功';

  @override
  String switchFailedWithMessages(Object messages) {
    return '切换失败\n$messages';
  }

  @override
  String get refreshTooltip => '刷新当前配置状态';

  @override
  String activeProfileTitle(Object name) {
    return '当前激活: $name';
  }

  @override
  String get activeProfileSubtitle => '系统配置与所选配置一致';

  @override
  String get configMismatchTitle => '配置不一致提醒';

  @override
  String get configMismatchSubtitle => '当前系统配置与本软件中的配置不匹配，建议先备份当前配置并查看差异。';

  @override
  String get backupCurrentConfig => '备份当前配置';

  @override
  String get viewDiff => '查看差异';

  @override
  String get noConfigsToCompare => '暂无配置可对比';

  @override
  String get viewConfigDiffTitle => '查看配置差异';

  @override
  String get configMatches => '与当前配置一致';

  @override
  String profileDiffTitle(Object name) {
    return '$name 配置差异';
  }

  @override
  String get configMatchesFull => '该配置与当前配置一致';

  @override
  String get noTargetConfig => '（无目标配置）';

  @override
  String get diffItems => '差异项:';

  @override
  String get currentConfigTab => '当前配置';

  @override
  String get targetConfigTab => '目标配置';

  @override
  String get noCurrentGitConfig => '（无当前Git配置）';

  @override
  String get noProfiles => '暂无配置';

  @override
  String get clickToCreateProfile => '点击右下角按钮创建第一个配置';

  @override
  String platformLabel(Object host) {
    return '平台: $host';
  }

  @override
  String get sshEnabledStatus => 'SSH: 启用';

  @override
  String get sshDisabledStatus => 'SSH: 禁用';

  @override
  String get confirmDeleteTitle => '确认删除';

  @override
  String confirmDeleteContent(Object name) {
    return '确定要删除配置 \"$name\" 吗？';
  }

  @override
  String get delete => '删除';

  @override
  String get deleteSuccess => '删除成功';

  @override
  String get deleteFailed => '删除失败';

  @override
  String get settingsTitle => '设置';

  @override
  String get generalSettings => '通用设置';

  @override
  String get minimizeToTray => '最小化到托盘';

  @override
  String get minimizeToTraySubtitle => '关闭窗口时，最小化到系统托盘而非退出应用';

  @override
  String get backupSettings => '备份设置';

  @override
  String get enableAutoBackup => '启用自动备份';

  @override
  String get enableAutoBackupSubtitle => '切换配置时自动备份当前配置';

  @override
  String get maxBackupCount => '最大备份数量';

  @override
  String get maxBackupCountHelper => '超出此数量将自动删除最旧的备份 (1-50)';

  @override
  String get enterBackupCount => '请输入备份数量';

  @override
  String get backupCountRange => '请输入1-50之间的数字';

  @override
  String get save => '保存';

  @override
  String get enterMaxBackupCount => '请输入最大备份数量';

  @override
  String get maxBackupCountRange => '最大备份数量必须在1-50之间';

  @override
  String get settingsSaved => '设置已保存';

  @override
  String get saveFailed => '保存失败';

  @override
  String saveFailedWithError(Object error) {
    return '保存失败: $error';
  }

  @override
  String get language => '语言';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get langZhSimplified => '简体中文';

  @override
  String get langZhTraditional => '繁體中文';

  @override
  String get langEnglish => 'English';

  @override
  String get langFrench => 'Français';

  @override
  String get langGerman => 'Deutsch';

  @override
  String get langSpanish => 'Español';

  @override
  String get langJapanese => '日本語';

  @override
  String get langKorean => '한국어';

  @override
  String get langRussian => 'Русский';

  @override
  String get langPortuguese => 'Português';

  @override
  String get newProfile => '新建配置';

  @override
  String get editProfile => '修改配置';

  @override
  String get configName => '配置名称';

  @override
  String get configNameHelper => '例如：工作账号、个人账号';

  @override
  String get enterConfigName => '请输入配置名称';

  @override
  String get gitConfigContent => 'Git 配置内容';

  @override
  String get importExistingConfig => '导入现有配置';

  @override
  String get gitconfigHelper => '粘贴 .gitconfig 内容或配置片段';

  @override
  String get enterGitConfig => '请输入Git配置内容';

  @override
  String get enableSsh => '启用 SSH';

  @override
  String get enableSshSubtitle => '为此配置启用SSH密钥认证';

  @override
  String get hostname => '主机名';

  @override
  String get hostnameHelper => '例如：github.com, gitlab.com';

  @override
  String get hostnameRequired => '启用SSH时必须指定主机名';

  @override
  String get sshPort => 'SSH 端口';

  @override
  String get sshPortHelper => '预填 443；留空则使用 SSH 默认端口 22';

  @override
  String get portRange => '请输入 1-65535 之间的端口号';

  @override
  String get sshPrivateKeyPath => 'SSH 私钥路径';

  @override
  String get privateKeyHelper => '例如：~/.ssh/id_rsa_work';

  @override
  String get privateKeyRequired => '启用SSH时必须指定私钥路径';

  @override
  String get pickPrivateKeyTooltip => '选择私钥文件';

  @override
  String get importGitConfigSuccess => '成功导入当前 .gitconfig 配置';

  @override
  String get importGitConfigFailed => '未找到 .gitconfig 文件或读取失败';

  @override
  String pickFileFailed(Object error) {
    return '选择文件失败: $error';
  }

  @override
  String get saveSuccess => '保存成功';

  @override
  String get backupManagement => '备份管理';

  @override
  String get restoreSelectedBackup => '恢复选中的备份';

  @override
  String get noBackups => '暂无备份';

  @override
  String backupTime(Object date) {
    return '备份时间: $date';
  }

  @override
  String fileCount(Object count) {
    return '$count 个文件';
  }

  @override
  String get gitConfigType => 'Git 配置';

  @override
  String get sshConfigType => 'SSH 配置';

  @override
  String backupPreviewTitle(Object type) {
    return '$type 备份预览';
  }

  @override
  String get noContent => '无内容';

  @override
  String get confirmRestore => '确认恢复';

  @override
  String confirmRestoreContent(Object type) {
    return '确定要恢复选中的$type配置吗？\n\n这将覆盖当前配置。';
  }

  @override
  String get restore => '恢复';

  @override
  String get restoreSuccess => '恢复成功';

  @override
  String get restoreFailed => '恢复失败';

  @override
  String restoreFailedWithError(Object error) {
    return '恢复失败: $error';
  }

  @override
  String loadBackupsFailed(Object error) {
    return '加载备份列表失败: $error';
  }

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
  String get gitConfigMatches => 'Git配置一致';

  @override
  String get gitConfigMismatch => 'Git配置不一致';

  @override
  String get sshConfigMatches => 'SSH配置一致';

  @override
  String get sshConfigMismatch => 'SSH配置不一致';

  @override
  String diffUserName(Object current, Object profile) {
    return 'Git user.name: 当前 \"$current\" ≠ 配置 \"$profile\"';
  }

  @override
  String diffUserEmail(Object current, Object profile) {
    return 'Git user.email: 当前 \"$current\" ≠ 配置 \"$profile\"';
  }

  @override
  String diffSshHostNotFound(Object host) {
    return 'SSH: 未找到主机 \"$host\" 的配置';
  }

  @override
  String diffSshIdentityFile(Object current, Object profile) {
    return 'SSH IdentityFile: 当前 \"$current\" ≠ 配置 \"$profile\"';
  }

  @override
  String keyFileNotExist(Object path) {
    return '私钥文件不存在: $path';
  }

  @override
  String keyPermissionIncorrect(Object permissions) {
    return '私钥权限不正确，应为600，当前为$permissions';
  }

  @override
  String get keyPermissionCheckFailed => '无法检查私钥权限';

  @override
  String get backupNothing => '没有可备份的配置';

  @override
  String get sshNoIdentityFile => 'SSH 配置中未找到 IdentityFile 行';

  @override
  String get verifyGitMismatch => 'Git 身份验证未通过：user.name 或 user.email 与目标配置不一致';

  @override
  String verifySshFailed(Object host) {
    return 'SSH 验证未通过: $host';
  }

  @override
  String get undoFailed => '撤销失败';

  @override
  String get importSystemGit => '导入系统 .gitconfig';

  @override
  String get importSystemSsh => '导入系统 .ssh/config';

  @override
  String get sshConfigContent => 'SSH 配置内容';

  @override
  String get sshConfigHelper => '粘贴 .ssh/config 内容（整文件切换）';

  @override
  String get enterSshConfig => '启用 SSH 时必须填写配置内容';

  @override
  String get quickCreateTitle => '快捷创建';

  @override
  String get fromTemplate => '从模板';

  @override
  String get fromExistingProfile => '复制已有配置';

  @override
  String get generateKeyPair => '生成密钥对';

  @override
  String get sshPreviewTitle => '将写入 ~/.ssh/config 的内容';

  @override
  String get templateProviderTitle => '选择服务商';

  @override
  String get providerGithub => 'GitHub';

  @override
  String get providerGitlab => 'GitLab';

  @override
  String get providerGitee => 'Gitee';

  @override
  String get providerBlank => '空白';

  @override
  String get templateModeTitle => '连接方式';

  @override
  String get modeDirect => '直连';

  @override
  String get modeProxy => '代理';

  @override
  String get proxyAddress => '代理地址';

  @override
  String get proxyAddressHint => '留空使用默认 127.0.0.1:7890';

  @override
  String get templateGenerated => '已生成 SSH 配置模板';

  @override
  String get selectProfileToCopy => '选择要复制的配置';

  @override
  String get copyProfileSuffix => '（副本）';

  @override
  String get confirm => '确定';

  @override
  String get importSshConfigSuccess => '成功导入当前 .ssh/config 配置';

  @override
  String get importSshConfigFailed => '未找到 .ssh/config 文件或读取失败';

  @override
  String get onboardingWelcome => '欢迎使用 Git Switcher';

  @override
  String get onboardingSubtitle => '轻松管理并一键切换多个 Git / SSH 身份';

  @override
  String get onboardingNameHint => '为该配置命名（如：工作账号）';

  @override
  String get onboardingImportDone => '已导入当前系统配置，可修改后保存';

  @override
  String get onboardingImport => '一键导入当前系统配置';

  @override
  String get onboardingSkip => '跳过';

  @override
  String get onboardingFinish => '完成';

  @override
  String get overwriteSshTitle => '覆盖 SSH 配置确认';

  @override
  String get overwriteSshContent => '即将覆盖一个不是由本工具管理的 SSH 配置，是否继续？';

  @override
  String get switchVerified => '切换成功，身份已验证';

  @override
  String get switchWrittenNotVerified => '配置已写入，但验证未通过';

  @override
  String get undoSuccess => '已撤销到之前的配置';

  @override
  String get undoNothing => '没有可撤销的变更';

  @override
  String get undoLastSwitch => '撤销上次切换';

  @override
  String get keyManagementTitle => '密钥管理';

  @override
  String get keyIdentifier => '标识（英文）';

  @override
  String get keyIdentifierHelper => '仅限字母、数字、- 和 _，用于生成文件名';

  @override
  String get keyIdentifierInvalid => '标识仅允许英文、数字、- 和 _';

  @override
  String get keyEmail => '邮箱（可选）';

  @override
  String get keyEmailInvalid => '邮箱格式不正确，应包含 @';

  @override
  String get keyPassphrase => '密码短语（可选）';

  @override
  String get keyPassphraseHelper => '留空表示无口令；填写后每次使用需输入';

  @override
  String get keyAlgorithmLabel => '算法';

  @override
  String get generateKey => '生成密钥对';

  @override
  String get privateKeyPath => '私钥路径';

  @override
  String get publicKey => '公钥';

  @override
  String get copyPublicKey => '复制公钥';

  @override
  String get fillIdentityFile => '填入当前配置';

  @override
  String get keygenSuccess => '密钥对生成成功';

  @override
  String keygenFailed(Object message) {
    return '密钥生成失败: $message';
  }

  @override
  String get keygenUnavailable => '未检测到 ssh-keygen，请先安装 OpenSSH 客户端';

  @override
  String get keyExistsTitle => '密钥已存在';

  @override
  String keyExistsContent(Object path) {
    return '已存在同名密钥：$path\n是否覆盖？';
  }

  @override
  String get passphraseReminder => '已设置密码短语，每次使用将要求输入';

  @override
  String get fillIdentityFileDone => '已填入 IdentityFile 行';

  @override
  String get publicKeyCopied => '公钥已复制到剪贴板';

  @override
  String get keygenDetecting => '正在检测 ssh-keygen 可用性…';

  @override
  String keygenDetectedAt(Object path) {
    return '已检测到 ssh-keygen：$path';
  }

  @override
  String get keygenNotFound => '未检测到 ssh-keygen，请安装 OpenSSH 客户端或指定路径';

  @override
  String get keygenPathLabel => '自定义 ssh-keygen 路径';

  @override
  String get keygenPathHint => '留空自动检测（PATH / 常见安装位置）';

  @override
  String get keygenVerifyBtn => '验证';

  @override
  String get keygenResetBtn => '恢复自动检测';

  @override
  String get keygenBrowseBtn => '浏览';

  @override
  String keygenPathValid(Object path) {
    return 'ssh-keygen 路径有效：$path';
  }

  @override
  String keygenPathInvalid(Object path) {
    return 'ssh-keygen 路径无效：$path';
  }

  @override
  String get logSettings => '日志设置';

  @override
  String get logSettingsSubtitle => '日志级别与存储位置';

  @override
  String get logLevel => '日志级别';

  @override
  String get logLevelTrace => 'TRACE（最详细）';

  @override
  String get logLevelDebug => 'DEBUG（调试）';

  @override
  String get logLevelInfo => 'INFO（信息，默认）';

  @override
  String get logLevelWarn => 'WARN（警告）';

  @override
  String get logLevelError => 'ERROR（仅错误）';

  @override
  String get logFileLocation => '日志目录';

  @override
  String get onboardingDemoButton => '体验示例配置';

  @override
  String get onboardingDemoHint => '无需注册账号，一键导入 2 个示例配置即可体验全部功能';

  @override
  String get onboardingDemoDone => '示例配置已导入，点击“完成”开始体验';

  @override
  String get demoProfileWorkName => '示例-工作账号';

  @override
  String get demoProfilePersonalName => '示例-个人账号';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => 'Git 帳號切換器';

  @override
  String get trayShowWindow => '顯示主視窗';

  @override
  String get trayAbout => '關於';

  @override
  String get trayExit => '退出';

  @override
  String get aboutTitle => '關於 Git Switcher';

  @override
  String get aboutAuthor => '作者: voidbytes';

  @override
  String get aboutAuthorHomepage => '作者主頁:';

  @override
  String get aboutProjectUrl => '專案位址:';

  @override
  String get close => '關閉';

  @override
  String switchFailedWithError(Object error) {
    return '切換失敗: $error';
  }

  @override
  String get sshConfigConflictTitle => 'SSH 設定衝突';

  @override
  String sshConfigConflictContent(
    Object conflictPath,
    Object host,
    Object identityFile,
  ) {
    return '偵測到目前系統中針對主機 \"$host\" 的 SSH 私鑰路徑為:\n\n$conflictPath\n\n您希望將其變更為:\n\n$identityFile\n\n是否繼續？';
  }

  @override
  String get cancel => '取消';

  @override
  String get continueSwitch => '繼續切換';

  @override
  String get switchSuccess => '切換成功';

  @override
  String switchFailedWithMessages(Object messages) {
    return '切換失敗\n$messages';
  }

  @override
  String get refreshTooltip => '重新整理目前設定狀態';

  @override
  String activeProfileTitle(Object name) {
    return '目前啟用: $name';
  }

  @override
  String get activeProfileSubtitle => '系統設定與所選設定一致';

  @override
  String get configMismatchTitle => '設定不一致提醒';

  @override
  String get configMismatchSubtitle => '目前系統設定與本軟體中的設定不匹配，建議先備份目前設定並檢視差異。';

  @override
  String get backupCurrentConfig => '備份目前設定';

  @override
  String get viewDiff => '檢視差異';

  @override
  String get noConfigsToCompare => '暫無設定可比對';

  @override
  String get viewConfigDiffTitle => '檢視設定差異';

  @override
  String get configMatches => '與目前設定一致';

  @override
  String profileDiffTitle(Object name) {
    return '$name 設定差異';
  }

  @override
  String get configMatchesFull => '該設定與目前設定一致';

  @override
  String get noTargetConfig => '（無目標設定）';

  @override
  String get diffItems => '差異項目:';

  @override
  String get currentConfigTab => '目前設定';

  @override
  String get targetConfigTab => '目標設定';

  @override
  String get noCurrentGitConfig => '（無目前 Git 設定）';

  @override
  String get noProfiles => '暫無設定';

  @override
  String get clickToCreateProfile => '點擊右下角按鈕建立第一個設定';

  @override
  String platformLabel(Object host) {
    return '平台: $host';
  }

  @override
  String get sshEnabledStatus => 'SSH: 啟用';

  @override
  String get sshDisabledStatus => 'SSH: 停用';

  @override
  String get confirmDeleteTitle => '確認刪除';

  @override
  String confirmDeleteContent(Object name) {
    return '確定要刪除設定 \"$name\" 嗎？';
  }

  @override
  String get delete => '刪除';

  @override
  String get deleteSuccess => '刪除成功';

  @override
  String get deleteFailed => '刪除失敗';

  @override
  String get settingsTitle => '設定';

  @override
  String get generalSettings => '一般設定';

  @override
  String get minimizeToTray => '最小化到託盤';

  @override
  String get minimizeToTraySubtitle => '關閉視窗時，最小化到系統託盤而非退出應用程式';

  @override
  String get backupSettings => '備份設定';

  @override
  String get enableAutoBackup => '啟用自動備份';

  @override
  String get enableAutoBackupSubtitle => '切換設定時自動備份目前設定';

  @override
  String get maxBackupCount => '最大備份數量';

  @override
  String get maxBackupCountHelper => '超出此數量將自動刪除最舊的備份 (1-50)';

  @override
  String get enterBackupCount => '請輸入備份數量';

  @override
  String get backupCountRange => '請輸入1-50之間的數字';

  @override
  String get save => '儲存';

  @override
  String get enterMaxBackupCount => '請輸入最大備份數量';

  @override
  String get maxBackupCountRange => '最大備份數量必須在1-50之間';

  @override
  String get settingsSaved => '設定已儲存';

  @override
  String get saveFailed => '儲存失敗';

  @override
  String saveFailedWithError(Object error) {
    return '儲存失敗: $error';
  }

  @override
  String get language => '語言';

  @override
  String get languageSystem => '跟隨系統';

  @override
  String get langZhSimplified => '简体中文';

  @override
  String get langZhTraditional => '繁體中文';

  @override
  String get langEnglish => 'English';

  @override
  String get langFrench => 'Français';

  @override
  String get langGerman => 'Deutsch';

  @override
  String get langSpanish => 'Español';

  @override
  String get langJapanese => '日本語';

  @override
  String get langKorean => '한국어';

  @override
  String get langRussian => 'Русский';

  @override
  String get langPortuguese => 'Português';

  @override
  String get newProfile => '新建設定';

  @override
  String get editProfile => '修改設定';

  @override
  String get configName => '設定名稱';

  @override
  String get configNameHelper => '例如：工作帳號、個人帳號';

  @override
  String get enterConfigName => '請輸入設定名稱';

  @override
  String get gitConfigContent => 'Git 設定內容';

  @override
  String get importExistingConfig => '匯入現有設定';

  @override
  String get gitconfigHelper => '貼上 .gitconfig 內容或設定片段';

  @override
  String get enterGitConfig => '請輸入 Git 設定內容';

  @override
  String get enableSsh => '啟用 SSH';

  @override
  String get enableSshSubtitle => '為此設定啟用 SSH 金鑰認證';

  @override
  String get hostname => '主機名稱';

  @override
  String get hostnameHelper => '例如：github.com, gitlab.com';

  @override
  String get hostnameRequired => '啟用 SSH 時必須指定主機名稱';

  @override
  String get sshPort => 'SSH 連接埠';

  @override
  String get sshPortHelper => '預填 443；留空則使用 SSH 預設連接埠 22';

  @override
  String get portRange => '請輸入 1-65535 之間的連接埠號';

  @override
  String get sshPrivateKeyPath => 'SSH 私鑰路徑';

  @override
  String get privateKeyHelper => '例如：~/.ssh/id_rsa_work';

  @override
  String get privateKeyRequired => '啟用 SSH 時必須指定私鑰路徑';

  @override
  String get pickPrivateKeyTooltip => '選擇私鑰檔案';

  @override
  String get importGitConfigSuccess => '成功匯入目前 .gitconfig 設定';

  @override
  String get importGitConfigFailed => '找不到 .gitconfig 檔案或讀取失敗';

  @override
  String pickFileFailed(Object error) {
    return '選擇檔案失敗: $error';
  }

  @override
  String get saveSuccess => '儲存成功';

  @override
  String get backupManagement => '備份管理';

  @override
  String get restoreSelectedBackup => '還原選取的備份';

  @override
  String get noBackups => '暫無備份';

  @override
  String backupTime(Object date) {
    return '備份時間: $date';
  }

  @override
  String fileCount(Object count) {
    return '$count 個檔案';
  }

  @override
  String get gitConfigType => 'Git 設定';

  @override
  String get sshConfigType => 'SSH 設定';

  @override
  String backupPreviewTitle(Object type) {
    return '$type 備份預覽';
  }

  @override
  String get noContent => '無內容';

  @override
  String get confirmRestore => '確認還原';

  @override
  String confirmRestoreContent(Object type) {
    return '確定要還原選取的$type設定嗎？\n\n這將覆蓋目前設定。';
  }

  @override
  String get restore => '還原';

  @override
  String get restoreSuccess => '還原成功';

  @override
  String get restoreFailed => '還原失敗';

  @override
  String restoreFailedWithError(Object error) {
    return '還原失敗: $error';
  }

  @override
  String loadBackupsFailed(Object error) {
    return '載入備份清單失敗: $error';
  }

  @override
  String get gitBackupDone => '已備份目前 Git 設定';

  @override
  String get sshBackupDone => '已備份目前 SSH 設定';

  @override
  String get gitConfigUpdated => 'Git 設定已更新';

  @override
  String get gitConfigUpdateFailed => 'Git 設定更新失敗';

  @override
  String get sshConfigUpdated => 'SSH 設定已更新';

  @override
  String get sshConfigUpdateFailed => 'SSH 設定更新失敗';

  @override
  String get configRolledBack => '已回滾設定';

  @override
  String get gitConfigMatches => 'Git 設定一致';

  @override
  String get gitConfigMismatch => 'Git 設定不一致';

  @override
  String get sshConfigMatches => 'SSH 設定一致';

  @override
  String get sshConfigMismatch => 'SSH 設定不一致';

  @override
  String diffUserName(Object current, Object profile) {
    return 'Git user.name: 目前 \"$current\" ≠ 設定 \"$profile\"';
  }

  @override
  String diffUserEmail(Object current, Object profile) {
    return 'Git user.email: 目前 \"$current\" ≠ 設定 \"$profile\"';
  }

  @override
  String diffSshHostNotFound(Object host) {
    return 'SSH: 找不到主機 \"$host\" 的設定';
  }

  @override
  String diffSshIdentityFile(Object current, Object profile) {
    return 'SSH IdentityFile: 目前 \"$current\" ≠ 設定 \"$profile\"';
  }

  @override
  String keyFileNotExist(Object path) {
    return '私鑰檔案不存在: $path';
  }

  @override
  String keyPermissionIncorrect(Object permissions) {
    return '私鑰權限不正確，應為600，目前為$permissions';
  }

  @override
  String get keyPermissionCheckFailed => '無法檢查私鑰權限';

  @override
  String get backupNothing => '沒有可備份的設定';

  @override
  String get sshNoIdentityFile => 'SSH 設定中找不到 IdentityFile 行';

  @override
  String get verifyGitMismatch => 'Git 身分驗證未通過：user.name 或 user.email 與目標設定不一致';

  @override
  String verifySshFailed(Object host) {
    return 'SSH 驗證未通過: $host';
  }

  @override
  String get undoFailed => '復原失敗';

  @override
  String get importSystemGit => '匯入系統 .gitconfig';

  @override
  String get importSystemSsh => '匯入系統 .ssh/config';

  @override
  String get sshConfigContent => 'SSH 設定內容';

  @override
  String get sshConfigHelper => '貼上 .ssh/config 內容（整檔切換）';

  @override
  String get enterSshConfig => '啟用 SSH 時必須填寫設定內容';

  @override
  String get quickCreateTitle => '快速建立';

  @override
  String get fromTemplate => '從範本';

  @override
  String get fromExistingProfile => '複製既有設定';

  @override
  String get generateKeyPair => '產生金鑰對';

  @override
  String get sshPreviewTitle => '將寫入 ~/.ssh/config 的內容';

  @override
  String get templateProviderTitle => '選擇服務商';

  @override
  String get providerGithub => 'GitHub';

  @override
  String get providerGitlab => 'GitLab';

  @override
  String get providerGitee => 'Gitee';

  @override
  String get providerBlank => '空白';

  @override
  String get templateModeTitle => '連線方式';

  @override
  String get modeDirect => '直連';

  @override
  String get modeProxy => '代理';

  @override
  String get proxyAddress => '代理位址';

  @override
  String get proxyAddressHint => '留空使用預設 127.0.0.1:7890';

  @override
  String get templateGenerated => '已產生 SSH 設定範本';

  @override
  String get selectProfileToCopy => '選擇要複製的設定';

  @override
  String get copyProfileSuffix => '（副本）';

  @override
  String get confirm => '確定';

  @override
  String get importSshConfigSuccess => '成功匯入目前 .ssh/config 設定';

  @override
  String get importSshConfigFailed => '找不到 .ssh/config 檔案或讀取失敗';

  @override
  String get onboardingWelcome => '歡迎使用 Git Switcher';

  @override
  String get onboardingSubtitle => '輕鬆管理並一鍵切換多個 Git / SSH 身分';

  @override
  String get onboardingNameHint => '為此設定命名（如：工作帳號）';

  @override
  String get onboardingImportDone => '已匯入目前系統設定，可修改後儲存';

  @override
  String get onboardingImport => '一鍵匯入目前系統設定';

  @override
  String get onboardingSkip => '略過';

  @override
  String get onboardingFinish => '完成';

  @override
  String get overwriteSshTitle => '覆寫 SSH 設定確認';

  @override
  String get overwriteSshContent => '即將覆寫一個不是由本工具管理的 SSH 設定，是否繼續？';

  @override
  String get switchVerified => '切換成功，身分已驗證';

  @override
  String get switchWrittenNotVerified => '設定已寫入，但驗證未通過';

  @override
  String get undoSuccess => '已復原到先前的設定';

  @override
  String get undoNothing => '沒有可復原的變更';

  @override
  String get undoLastSwitch => '復原上次切換';

  @override
  String get keyManagementTitle => '金鑰管理';

  @override
  String get keyIdentifier => '識別碼（英文）';

  @override
  String get keyIdentifierHelper => '僅限字母、數字、- 和 _，用於產生檔名';

  @override
  String get keyIdentifierInvalid => '識別碼僅允許英文、數字、- 和 _';

  @override
  String get keyEmail => '電子郵件（選填）';

  @override
  String get keyEmailInvalid => '電子郵件格式不正確，應包含 @';

  @override
  String get keyPassphrase => '密碼短語（選填）';

  @override
  String get keyPassphraseHelper => '留空表示無口令；填寫後每次使用需輸入';

  @override
  String get keyAlgorithmLabel => '演算法';

  @override
  String get generateKey => '產生金鑰對';

  @override
  String get privateKeyPath => '私鑰路徑';

  @override
  String get publicKey => '公鑰';

  @override
  String get copyPublicKey => '複製公鑰';

  @override
  String get fillIdentityFile => '填入目前設定';

  @override
  String get keygenSuccess => '金鑰對產生成功';

  @override
  String keygenFailed(Object message) {
    return '金鑰產生失敗: $message';
  }

  @override
  String get keygenUnavailable => '未偵測到 ssh-keygen，請先安裝 OpenSSH 用戶端';

  @override
  String get keyExistsTitle => '金鑰已存在';

  @override
  String keyExistsContent(Object path) {
    return '已存在同名金鑰：$path\n是否覆寫？';
  }

  @override
  String get passphraseReminder => '已設定密碼短語，每次使用將要求輸入';

  @override
  String get fillIdentityFileDone => '已填入 IdentityFile 行';

  @override
  String get publicKeyCopied => '公鑰已複製到剪貼簿';

  @override
  String get keygenDetecting => '正在偵測 ssh-keygen 可用性…';

  @override
  String keygenDetectedAt(Object path) {
    return '已偵測到 ssh-keygen：$path';
  }

  @override
  String get keygenNotFound => '未偵測到 ssh-keygen，請安裝 OpenSSH 用戶端或指定路徑';

  @override
  String get keygenPathLabel => '自訂 ssh-keygen 路徑';

  @override
  String get keygenPathHint => '留空自動偵測（PATH / 常見安裝位置）';

  @override
  String get keygenVerifyBtn => '驗證';

  @override
  String get keygenResetBtn => '恢復自動偵測';

  @override
  String get keygenBrowseBtn => '瀏覽';

  @override
  String keygenPathValid(Object path) {
    return 'ssh-keygen 路徑有效：$path';
  }

  @override
  String keygenPathInvalid(Object path) {
    return 'ssh-keygen 路徑無效：$path';
  }

  @override
  String get logSettings => '日誌設定';

  @override
  String get logSettingsSubtitle => '日誌級別與儲存位置';

  @override
  String get logLevel => '日誌級別';

  @override
  String get logLevelTrace => 'TRACE（最詳細）';

  @override
  String get logLevelDebug => 'DEBUG（偵錯）';

  @override
  String get logLevelInfo => 'INFO（資訊，預設）';

  @override
  String get logLevelWarn => 'WARN（警告）';

  @override
  String get logLevelError => 'ERROR（僅錯誤）';

  @override
  String get logFileLocation => '日誌目錄';

  @override
  String get onboardingDemoButton => '體驗範例設定';

  @override
  String get onboardingDemoHint => '無需註冊帳號，一鍵匯入 2 個範例設定即可體驗全部功能';

  @override
  String get onboardingDemoDone => '範例設定已匯入，點擊「完成」開始體驗';

  @override
  String get demoProfileWorkName => '範例-工作帳號';

  @override
  String get demoProfilePersonalName => '範例-個人帳號';
}
