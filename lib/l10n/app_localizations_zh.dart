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
}
