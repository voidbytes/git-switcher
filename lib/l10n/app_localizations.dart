import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh, this message translates to:
  /// **'Git账号切换器'**
  String get appTitle;

  /// No description provided for @trayShowWindow.
  ///
  /// In zh, this message translates to:
  /// **'显示主窗口'**
  String get trayShowWindow;

  /// No description provided for @trayAbout.
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get trayAbout;

  /// No description provided for @trayExit.
  ///
  /// In zh, this message translates to:
  /// **'退出'**
  String get trayExit;

  /// No description provided for @aboutTitle.
  ///
  /// In zh, this message translates to:
  /// **'关于 Git Switcher'**
  String get aboutTitle;

  /// No description provided for @aboutAuthor.
  ///
  /// In zh, this message translates to:
  /// **'作者: voidbytes'**
  String get aboutAuthor;

  /// No description provided for @aboutAuthorHomepage.
  ///
  /// In zh, this message translates to:
  /// **'作者主页:'**
  String get aboutAuthorHomepage;

  /// No description provided for @aboutProjectUrl.
  ///
  /// In zh, this message translates to:
  /// **'项目地址:'**
  String get aboutProjectUrl;

  /// No description provided for @close.
  ///
  /// In zh, this message translates to:
  /// **'关闭'**
  String get close;

  /// No description provided for @switchFailedWithError.
  ///
  /// In zh, this message translates to:
  /// **'切换失败: {error}'**
  String switchFailedWithError(Object error);

  /// No description provided for @sshConfigConflictTitle.
  ///
  /// In zh, this message translates to:
  /// **'SSH 配置冲突'**
  String get sshConfigConflictTitle;

  /// No description provided for @sshConfigConflictContent.
  ///
  /// In zh, this message translates to:
  /// **'检测到当前系统中针对主机 \"{host}\" 的 SSH 私钥路径为:\n\n{conflictPath}\n\n您希望将其更改为:\n\n{identityFile}\n\n是否继续？'**
  String sshConfigConflictContent(
    Object conflictPath,
    Object host,
    Object identityFile,
  );

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @continueSwitch.
  ///
  /// In zh, this message translates to:
  /// **'继续切换'**
  String get continueSwitch;

  /// No description provided for @switchSuccess.
  ///
  /// In zh, this message translates to:
  /// **'切换成功'**
  String get switchSuccess;

  /// No description provided for @switchFailedWithMessages.
  ///
  /// In zh, this message translates to:
  /// **'切换失败\n{messages}'**
  String switchFailedWithMessages(Object messages);

  /// No description provided for @refreshTooltip.
  ///
  /// In zh, this message translates to:
  /// **'刷新当前配置状态'**
  String get refreshTooltip;

  /// No description provided for @activeProfileTitle.
  ///
  /// In zh, this message translates to:
  /// **'当前激活: {name}'**
  String activeProfileTitle(Object name);

  /// No description provided for @activeProfileSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'系统配置与所选配置一致'**
  String get activeProfileSubtitle;

  /// No description provided for @configMismatchTitle.
  ///
  /// In zh, this message translates to:
  /// **'配置不一致提醒'**
  String get configMismatchTitle;

  /// No description provided for @configMismatchSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'当前系统配置与本软件中的配置不匹配，建议先备份当前配置并查看差异。'**
  String get configMismatchSubtitle;

  /// No description provided for @backupCurrentConfig.
  ///
  /// In zh, this message translates to:
  /// **'备份当前配置'**
  String get backupCurrentConfig;

  /// No description provided for @viewDiff.
  ///
  /// In zh, this message translates to:
  /// **'查看差异'**
  String get viewDiff;

  /// No description provided for @noConfigsToCompare.
  ///
  /// In zh, this message translates to:
  /// **'暂无配置可对比'**
  String get noConfigsToCompare;

  /// No description provided for @viewConfigDiffTitle.
  ///
  /// In zh, this message translates to:
  /// **'查看配置差异'**
  String get viewConfigDiffTitle;

  /// No description provided for @configMatches.
  ///
  /// In zh, this message translates to:
  /// **'与当前配置一致'**
  String get configMatches;

  /// No description provided for @profileDiffTitle.
  ///
  /// In zh, this message translates to:
  /// **'{name} 配置差异'**
  String profileDiffTitle(Object name);

  /// No description provided for @configMatchesFull.
  ///
  /// In zh, this message translates to:
  /// **'该配置与当前配置一致'**
  String get configMatchesFull;

  /// No description provided for @noTargetConfig.
  ///
  /// In zh, this message translates to:
  /// **'（无目标配置）'**
  String get noTargetConfig;

  /// No description provided for @diffItems.
  ///
  /// In zh, this message translates to:
  /// **'差异项:'**
  String get diffItems;

  /// No description provided for @currentConfigTab.
  ///
  /// In zh, this message translates to:
  /// **'当前配置'**
  String get currentConfigTab;

  /// No description provided for @targetConfigTab.
  ///
  /// In zh, this message translates to:
  /// **'目标配置'**
  String get targetConfigTab;

  /// No description provided for @noCurrentGitConfig.
  ///
  /// In zh, this message translates to:
  /// **'（无当前Git配置）'**
  String get noCurrentGitConfig;

  /// No description provided for @noProfiles.
  ///
  /// In zh, this message translates to:
  /// **'暂无配置'**
  String get noProfiles;

  /// No description provided for @clickToCreateProfile.
  ///
  /// In zh, this message translates to:
  /// **'点击右下角按钮创建第一个配置'**
  String get clickToCreateProfile;

  /// No description provided for @platformLabel.
  ///
  /// In zh, this message translates to:
  /// **'平台: {host}'**
  String platformLabel(Object host);

  /// No description provided for @sshEnabledStatus.
  ///
  /// In zh, this message translates to:
  /// **'SSH: 启用'**
  String get sshEnabledStatus;

  /// No description provided for @sshDisabledStatus.
  ///
  /// In zh, this message translates to:
  /// **'SSH: 禁用'**
  String get sshDisabledStatus;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In zh, this message translates to:
  /// **'确认删除'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteContent.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除配置 \"{name}\" 吗？'**
  String confirmDeleteContent(Object name);

  /// No description provided for @delete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get delete;

  /// No description provided for @deleteSuccess.
  ///
  /// In zh, this message translates to:
  /// **'删除成功'**
  String get deleteSuccess;

  /// No description provided for @deleteFailed.
  ///
  /// In zh, this message translates to:
  /// **'删除失败'**
  String get deleteFailed;

  /// No description provided for @settingsTitle.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settingsTitle;

  /// No description provided for @generalSettings.
  ///
  /// In zh, this message translates to:
  /// **'通用设置'**
  String get generalSettings;

  /// No description provided for @minimizeToTray.
  ///
  /// In zh, this message translates to:
  /// **'最小化到托盘'**
  String get minimizeToTray;

  /// No description provided for @minimizeToTraySubtitle.
  ///
  /// In zh, this message translates to:
  /// **'关闭窗口时，最小化到系统托盘而非退出应用'**
  String get minimizeToTraySubtitle;

  /// No description provided for @backupSettings.
  ///
  /// In zh, this message translates to:
  /// **'备份设置'**
  String get backupSettings;

  /// No description provided for @enableAutoBackup.
  ///
  /// In zh, this message translates to:
  /// **'启用自动备份'**
  String get enableAutoBackup;

  /// No description provided for @enableAutoBackupSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'切换配置时自动备份当前配置'**
  String get enableAutoBackupSubtitle;

  /// No description provided for @maxBackupCount.
  ///
  /// In zh, this message translates to:
  /// **'最大备份数量'**
  String get maxBackupCount;

  /// No description provided for @maxBackupCountHelper.
  ///
  /// In zh, this message translates to:
  /// **'超出此数量将自动删除最旧的备份 (1-50)'**
  String get maxBackupCountHelper;

  /// No description provided for @enterBackupCount.
  ///
  /// In zh, this message translates to:
  /// **'请输入备份数量'**
  String get enterBackupCount;

  /// No description provided for @backupCountRange.
  ///
  /// In zh, this message translates to:
  /// **'请输入1-50之间的数字'**
  String get backupCountRange;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @enterMaxBackupCount.
  ///
  /// In zh, this message translates to:
  /// **'请输入最大备份数量'**
  String get enterMaxBackupCount;

  /// No description provided for @maxBackupCountRange.
  ///
  /// In zh, this message translates to:
  /// **'最大备份数量必须在1-50之间'**
  String get maxBackupCountRange;

  /// No description provided for @settingsSaved.
  ///
  /// In zh, this message translates to:
  /// **'设置已保存'**
  String get settingsSaved;

  /// No description provided for @saveFailed.
  ///
  /// In zh, this message translates to:
  /// **'保存失败'**
  String get saveFailed;

  /// No description provided for @saveFailedWithError.
  ///
  /// In zh, this message translates to:
  /// **'保存失败: {error}'**
  String saveFailedWithError(Object error);

  /// No description provided for @language.
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get languageSystem;

  /// No description provided for @langZhSimplified.
  ///
  /// In zh, this message translates to:
  /// **'简体中文'**
  String get langZhSimplified;

  /// No description provided for @langZhTraditional.
  ///
  /// In zh, this message translates to:
  /// **'繁體中文'**
  String get langZhTraditional;

  /// No description provided for @langEnglish.
  ///
  /// In zh, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langFrench.
  ///
  /// In zh, this message translates to:
  /// **'Français'**
  String get langFrench;

  /// No description provided for @langGerman.
  ///
  /// In zh, this message translates to:
  /// **'Deutsch'**
  String get langGerman;

  /// No description provided for @langSpanish.
  ///
  /// In zh, this message translates to:
  /// **'Español'**
  String get langSpanish;

  /// No description provided for @langJapanese.
  ///
  /// In zh, this message translates to:
  /// **'日本語'**
  String get langJapanese;

  /// No description provided for @langKorean.
  ///
  /// In zh, this message translates to:
  /// **'한국어'**
  String get langKorean;

  /// No description provided for @langRussian.
  ///
  /// In zh, this message translates to:
  /// **'Русский'**
  String get langRussian;

  /// No description provided for @langPortuguese.
  ///
  /// In zh, this message translates to:
  /// **'Português'**
  String get langPortuguese;

  /// No description provided for @newProfile.
  ///
  /// In zh, this message translates to:
  /// **'新建配置'**
  String get newProfile;

  /// No description provided for @editProfile.
  ///
  /// In zh, this message translates to:
  /// **'修改配置'**
  String get editProfile;

  /// No description provided for @configName.
  ///
  /// In zh, this message translates to:
  /// **'配置名称'**
  String get configName;

  /// No description provided for @configNameHelper.
  ///
  /// In zh, this message translates to:
  /// **'例如：工作账号、个人账号'**
  String get configNameHelper;

  /// No description provided for @enterConfigName.
  ///
  /// In zh, this message translates to:
  /// **'请输入配置名称'**
  String get enterConfigName;

  /// No description provided for @gitConfigContent.
  ///
  /// In zh, this message translates to:
  /// **'Git 配置内容'**
  String get gitConfigContent;

  /// No description provided for @importExistingConfig.
  ///
  /// In zh, this message translates to:
  /// **'导入现有配置'**
  String get importExistingConfig;

  /// No description provided for @gitconfigHelper.
  ///
  /// In zh, this message translates to:
  /// **'粘贴 .gitconfig 内容或配置片段'**
  String get gitconfigHelper;

  /// No description provided for @enterGitConfig.
  ///
  /// In zh, this message translates to:
  /// **'请输入Git配置内容'**
  String get enterGitConfig;

  /// No description provided for @enableSsh.
  ///
  /// In zh, this message translates to:
  /// **'启用 SSH'**
  String get enableSsh;

  /// No description provided for @enableSshSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'为此配置启用SSH密钥认证'**
  String get enableSshSubtitle;

  /// No description provided for @hostname.
  ///
  /// In zh, this message translates to:
  /// **'主机名'**
  String get hostname;

  /// No description provided for @hostnameHelper.
  ///
  /// In zh, this message translates to:
  /// **'例如：github.com, gitlab.com'**
  String get hostnameHelper;

  /// No description provided for @hostnameRequired.
  ///
  /// In zh, this message translates to:
  /// **'启用SSH时必须指定主机名'**
  String get hostnameRequired;

  /// No description provided for @sshPort.
  ///
  /// In zh, this message translates to:
  /// **'SSH 端口'**
  String get sshPort;

  /// No description provided for @sshPortHelper.
  ///
  /// In zh, this message translates to:
  /// **'预填 443；留空则使用 SSH 默认端口 22'**
  String get sshPortHelper;

  /// No description provided for @portRange.
  ///
  /// In zh, this message translates to:
  /// **'请输入 1-65535 之间的端口号'**
  String get portRange;

  /// No description provided for @sshPrivateKeyPath.
  ///
  /// In zh, this message translates to:
  /// **'SSH 私钥路径'**
  String get sshPrivateKeyPath;

  /// No description provided for @privateKeyHelper.
  ///
  /// In zh, this message translates to:
  /// **'例如：~/.ssh/id_rsa_work'**
  String get privateKeyHelper;

  /// No description provided for @privateKeyRequired.
  ///
  /// In zh, this message translates to:
  /// **'启用SSH时必须指定私钥路径'**
  String get privateKeyRequired;

  /// No description provided for @pickPrivateKeyTooltip.
  ///
  /// In zh, this message translates to:
  /// **'选择私钥文件'**
  String get pickPrivateKeyTooltip;

  /// No description provided for @importGitConfigSuccess.
  ///
  /// In zh, this message translates to:
  /// **'成功导入当前 .gitconfig 配置'**
  String get importGitConfigSuccess;

  /// No description provided for @importGitConfigFailed.
  ///
  /// In zh, this message translates to:
  /// **'未找到 .gitconfig 文件或读取失败'**
  String get importGitConfigFailed;

  /// No description provided for @pickFileFailed.
  ///
  /// In zh, this message translates to:
  /// **'选择文件失败: {error}'**
  String pickFileFailed(Object error);

  /// No description provided for @saveSuccess.
  ///
  /// In zh, this message translates to:
  /// **'保存成功'**
  String get saveSuccess;

  /// No description provided for @backupManagement.
  ///
  /// In zh, this message translates to:
  /// **'备份管理'**
  String get backupManagement;

  /// No description provided for @restoreSelectedBackup.
  ///
  /// In zh, this message translates to:
  /// **'恢复选中的备份'**
  String get restoreSelectedBackup;

  /// No description provided for @noBackups.
  ///
  /// In zh, this message translates to:
  /// **'暂无备份'**
  String get noBackups;

  /// No description provided for @backupTime.
  ///
  /// In zh, this message translates to:
  /// **'备份时间: {date}'**
  String backupTime(Object date);

  /// No description provided for @fileCount.
  ///
  /// In zh, this message translates to:
  /// **'{count} 个文件'**
  String fileCount(Object count);

  /// No description provided for @gitConfigType.
  ///
  /// In zh, this message translates to:
  /// **'Git 配置'**
  String get gitConfigType;

  /// No description provided for @sshConfigType.
  ///
  /// In zh, this message translates to:
  /// **'SSH 配置'**
  String get sshConfigType;

  /// No description provided for @backupPreviewTitle.
  ///
  /// In zh, this message translates to:
  /// **'{type} 备份预览'**
  String backupPreviewTitle(Object type);

  /// No description provided for @noContent.
  ///
  /// In zh, this message translates to:
  /// **'无内容'**
  String get noContent;

  /// No description provided for @confirmRestore.
  ///
  /// In zh, this message translates to:
  /// **'确认恢复'**
  String get confirmRestore;

  /// No description provided for @confirmRestoreContent.
  ///
  /// In zh, this message translates to:
  /// **'确定要恢复选中的{type}配置吗？\n\n这将覆盖当前配置。'**
  String confirmRestoreContent(Object type);

  /// No description provided for @restore.
  ///
  /// In zh, this message translates to:
  /// **'恢复'**
  String get restore;

  /// No description provided for @restoreSuccess.
  ///
  /// In zh, this message translates to:
  /// **'恢复成功'**
  String get restoreSuccess;

  /// No description provided for @restoreFailed.
  ///
  /// In zh, this message translates to:
  /// **'恢复失败'**
  String get restoreFailed;

  /// No description provided for @restoreFailedWithError.
  ///
  /// In zh, this message translates to:
  /// **'恢复失败: {error}'**
  String restoreFailedWithError(Object error);

  /// No description provided for @loadBackupsFailed.
  ///
  /// In zh, this message translates to:
  /// **'加载备份列表失败: {error}'**
  String loadBackupsFailed(Object error);

  /// No description provided for @gitBackupDone.
  ///
  /// In zh, this message translates to:
  /// **'已备份当前Git配置'**
  String get gitBackupDone;

  /// No description provided for @sshBackupDone.
  ///
  /// In zh, this message translates to:
  /// **'已备份当前SSH配置'**
  String get sshBackupDone;

  /// No description provided for @gitConfigUpdated.
  ///
  /// In zh, this message translates to:
  /// **'Git配置已更新'**
  String get gitConfigUpdated;

  /// No description provided for @gitConfigUpdateFailed.
  ///
  /// In zh, this message translates to:
  /// **'Git配置更新失败'**
  String get gitConfigUpdateFailed;

  /// No description provided for @sshConfigUpdated.
  ///
  /// In zh, this message translates to:
  /// **'SSH配置已更新'**
  String get sshConfigUpdated;

  /// No description provided for @sshConfigUpdateFailed.
  ///
  /// In zh, this message translates to:
  /// **'SSH配置更新失败'**
  String get sshConfigUpdateFailed;

  /// No description provided for @configRolledBack.
  ///
  /// In zh, this message translates to:
  /// **'已回滚配置'**
  String get configRolledBack;

  /// No description provided for @gitConfigMatches.
  ///
  /// In zh, this message translates to:
  /// **'Git配置一致'**
  String get gitConfigMatches;

  /// No description provided for @gitConfigMismatch.
  ///
  /// In zh, this message translates to:
  /// **'Git配置不一致'**
  String get gitConfigMismatch;

  /// No description provided for @sshConfigMatches.
  ///
  /// In zh, this message translates to:
  /// **'SSH配置一致'**
  String get sshConfigMatches;

  /// No description provided for @sshConfigMismatch.
  ///
  /// In zh, this message translates to:
  /// **'SSH配置不一致'**
  String get sshConfigMismatch;

  /// No description provided for @diffUserName.
  ///
  /// In zh, this message translates to:
  /// **'Git user.name: 当前 \"{current}\" ≠ 配置 \"{profile}\"'**
  String diffUserName(Object current, Object profile);

  /// No description provided for @diffUserEmail.
  ///
  /// In zh, this message translates to:
  /// **'Git user.email: 当前 \"{current}\" ≠ 配置 \"{profile}\"'**
  String diffUserEmail(Object current, Object profile);

  /// No description provided for @diffSshHostNotFound.
  ///
  /// In zh, this message translates to:
  /// **'SSH: 未找到主机 \"{host}\" 的配置'**
  String diffSshHostNotFound(Object host);

  /// No description provided for @diffSshIdentityFile.
  ///
  /// In zh, this message translates to:
  /// **'SSH IdentityFile: 当前 \"{current}\" ≠ 配置 \"{profile}\"'**
  String diffSshIdentityFile(Object current, Object profile);

  /// No description provided for @keyFileNotExist.
  ///
  /// In zh, this message translates to:
  /// **'私钥文件不存在: {path}'**
  String keyFileNotExist(Object path);

  /// No description provided for @keyPermissionIncorrect.
  ///
  /// In zh, this message translates to:
  /// **'私钥权限不正确，应为600，当前为{permissions}'**
  String keyPermissionIncorrect(Object permissions);

  /// No description provided for @keyPermissionCheckFailed.
  ///
  /// In zh, this message translates to:
  /// **'无法检查私钥权限'**
  String get keyPermissionCheckFailed;

  /// No description provided for @backupNothing.
  ///
  /// In zh, this message translates to:
  /// **'没有可备份的配置'**
  String get backupNothing;

  /// No description provided for @sshNoIdentityFile.
  ///
  /// In zh, this message translates to:
  /// **'SSH 配置中未找到 IdentityFile 行'**
  String get sshNoIdentityFile;

  /// No description provided for @verifyGitMismatch.
  ///
  /// In zh, this message translates to:
  /// **'Git 身份验证未通过：user.name 或 user.email 与目标配置不一致'**
  String get verifyGitMismatch;

  /// No description provided for @verifySshFailed.
  ///
  /// In zh, this message translates to:
  /// **'SSH 验证未通过: {host}'**
  String verifySshFailed(Object host);

  /// No description provided for @undoFailed.
  ///
  /// In zh, this message translates to:
  /// **'撤销失败'**
  String get undoFailed;

  /// No description provided for @importSystemGit.
  ///
  /// In zh, this message translates to:
  /// **'导入系统 .gitconfig'**
  String get importSystemGit;

  /// No description provided for @importSystemSsh.
  ///
  /// In zh, this message translates to:
  /// **'导入系统 .ssh/config'**
  String get importSystemSsh;

  /// No description provided for @sshConfigContent.
  ///
  /// In zh, this message translates to:
  /// **'SSH 配置内容'**
  String get sshConfigContent;

  /// No description provided for @sshConfigHelper.
  ///
  /// In zh, this message translates to:
  /// **'粘贴 .ssh/config 内容（整文件切换）'**
  String get sshConfigHelper;

  /// No description provided for @enterSshConfig.
  ///
  /// In zh, this message translates to:
  /// **'启用 SSH 时必须填写配置内容'**
  String get enterSshConfig;

  /// No description provided for @quickCreateTitle.
  ///
  /// In zh, this message translates to:
  /// **'快捷创建'**
  String get quickCreateTitle;

  /// No description provided for @fromTemplate.
  ///
  /// In zh, this message translates to:
  /// **'从模板'**
  String get fromTemplate;

  /// No description provided for @fromExistingProfile.
  ///
  /// In zh, this message translates to:
  /// **'复制已有配置'**
  String get fromExistingProfile;

  /// No description provided for @generateKeyPair.
  ///
  /// In zh, this message translates to:
  /// **'生成密钥对'**
  String get generateKeyPair;

  /// No description provided for @sshPreviewTitle.
  ///
  /// In zh, this message translates to:
  /// **'将写入 ~/.ssh/config 的内容'**
  String get sshPreviewTitle;

  /// No description provided for @templateProviderTitle.
  ///
  /// In zh, this message translates to:
  /// **'选择服务商'**
  String get templateProviderTitle;

  /// No description provided for @providerGithub.
  ///
  /// In zh, this message translates to:
  /// **'GitHub'**
  String get providerGithub;

  /// No description provided for @providerGitlab.
  ///
  /// In zh, this message translates to:
  /// **'GitLab'**
  String get providerGitlab;

  /// No description provided for @providerGitee.
  ///
  /// In zh, this message translates to:
  /// **'Gitee'**
  String get providerGitee;

  /// No description provided for @providerBlank.
  ///
  /// In zh, this message translates to:
  /// **'空白'**
  String get providerBlank;

  /// No description provided for @templateModeTitle.
  ///
  /// In zh, this message translates to:
  /// **'连接方式'**
  String get templateModeTitle;

  /// No description provided for @modeDirect.
  ///
  /// In zh, this message translates to:
  /// **'直连'**
  String get modeDirect;

  /// No description provided for @modeProxy.
  ///
  /// In zh, this message translates to:
  /// **'代理'**
  String get modeProxy;

  /// No description provided for @proxyAddress.
  ///
  /// In zh, this message translates to:
  /// **'代理地址'**
  String get proxyAddress;

  /// No description provided for @proxyAddressHint.
  ///
  /// In zh, this message translates to:
  /// **'留空使用默认 127.0.0.1:7890'**
  String get proxyAddressHint;

  /// No description provided for @templateGenerated.
  ///
  /// In zh, this message translates to:
  /// **'已生成 SSH 配置模板'**
  String get templateGenerated;

  /// No description provided for @selectProfileToCopy.
  ///
  /// In zh, this message translates to:
  /// **'选择要复制的配置'**
  String get selectProfileToCopy;

  /// No description provided for @copyProfileSuffix.
  ///
  /// In zh, this message translates to:
  /// **'（副本）'**
  String get copyProfileSuffix;

  /// No description provided for @confirm.
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get confirm;

  /// No description provided for @importSshConfigSuccess.
  ///
  /// In zh, this message translates to:
  /// **'成功导入当前 .ssh/config 配置'**
  String get importSshConfigSuccess;

  /// No description provided for @importSshConfigFailed.
  ///
  /// In zh, this message translates to:
  /// **'未找到 .ssh/config 文件或读取失败'**
  String get importSshConfigFailed;

  /// No description provided for @onboardingWelcome.
  ///
  /// In zh, this message translates to:
  /// **'欢迎使用 Git Switcher'**
  String get onboardingWelcome;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'轻松管理并一键切换多个 Git / SSH 身份'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingNameHint.
  ///
  /// In zh, this message translates to:
  /// **'为该配置命名（如：工作账号）'**
  String get onboardingNameHint;

  /// No description provided for @onboardingImportDone.
  ///
  /// In zh, this message translates to:
  /// **'已导入当前系统配置，可修改后保存'**
  String get onboardingImportDone;

  /// No description provided for @onboardingImport.
  ///
  /// In zh, this message translates to:
  /// **'一键导入当前系统配置'**
  String get onboardingImport;

  /// No description provided for @onboardingSkip.
  ///
  /// In zh, this message translates to:
  /// **'跳过'**
  String get onboardingSkip;

  /// No description provided for @onboardingFinish.
  ///
  /// In zh, this message translates to:
  /// **'完成'**
  String get onboardingFinish;

  /// No description provided for @overwriteSshTitle.
  ///
  /// In zh, this message translates to:
  /// **'覆盖 SSH 配置确认'**
  String get overwriteSshTitle;

  /// No description provided for @overwriteSshContent.
  ///
  /// In zh, this message translates to:
  /// **'即将覆盖一个不是由本工具管理的 SSH 配置，是否继续？'**
  String get overwriteSshContent;

  /// No description provided for @switchVerified.
  ///
  /// In zh, this message translates to:
  /// **'切换成功，身份已验证'**
  String get switchVerified;

  /// No description provided for @switchWrittenNotVerified.
  ///
  /// In zh, this message translates to:
  /// **'配置已写入，但验证未通过'**
  String get switchWrittenNotVerified;

  /// No description provided for @undoSuccess.
  ///
  /// In zh, this message translates to:
  /// **'已撤销到之前的配置'**
  String get undoSuccess;

  /// No description provided for @undoNothing.
  ///
  /// In zh, this message translates to:
  /// **'没有可撤销的变更'**
  String get undoNothing;

  /// No description provided for @undoLastSwitch.
  ///
  /// In zh, this message translates to:
  /// **'撤销上次切换'**
  String get undoLastSwitch;

  /// No description provided for @keyManagementTitle.
  ///
  /// In zh, this message translates to:
  /// **'密钥管理'**
  String get keyManagementTitle;

  /// No description provided for @keyIdentifier.
  ///
  /// In zh, this message translates to:
  /// **'标识（英文）'**
  String get keyIdentifier;

  /// No description provided for @keyIdentifierHelper.
  ///
  /// In zh, this message translates to:
  /// **'仅限字母、数字、- 和 _，用于生成文件名'**
  String get keyIdentifierHelper;

  /// No description provided for @keyIdentifierInvalid.
  ///
  /// In zh, this message translates to:
  /// **'标识仅允许英文、数字、- 和 _'**
  String get keyIdentifierInvalid;

  /// No description provided for @keyEmail.
  ///
  /// In zh, this message translates to:
  /// **'邮箱（可选）'**
  String get keyEmail;

  /// No description provided for @keyEmailInvalid.
  ///
  /// In zh, this message translates to:
  /// **'邮箱格式不正确，应包含 @'**
  String get keyEmailInvalid;

  /// No description provided for @keyPassphrase.
  ///
  /// In zh, this message translates to:
  /// **'密码短语（可选）'**
  String get keyPassphrase;

  /// No description provided for @keyPassphraseHelper.
  ///
  /// In zh, this message translates to:
  /// **'留空表示无口令；填写后每次使用需输入'**
  String get keyPassphraseHelper;

  /// No description provided for @keyAlgorithmLabel.
  ///
  /// In zh, this message translates to:
  /// **'算法'**
  String get keyAlgorithmLabel;

  /// No description provided for @generateKey.
  ///
  /// In zh, this message translates to:
  /// **'生成密钥对'**
  String get generateKey;

  /// No description provided for @privateKeyPath.
  ///
  /// In zh, this message translates to:
  /// **'私钥路径'**
  String get privateKeyPath;

  /// No description provided for @publicKey.
  ///
  /// In zh, this message translates to:
  /// **'公钥'**
  String get publicKey;

  /// No description provided for @copyPublicKey.
  ///
  /// In zh, this message translates to:
  /// **'复制公钥'**
  String get copyPublicKey;

  /// No description provided for @fillIdentityFile.
  ///
  /// In zh, this message translates to:
  /// **'填入当前配置'**
  String get fillIdentityFile;

  /// No description provided for @keygenSuccess.
  ///
  /// In zh, this message translates to:
  /// **'密钥对生成成功'**
  String get keygenSuccess;

  /// No description provided for @keygenFailed.
  ///
  /// In zh, this message translates to:
  /// **'密钥生成失败: {message}'**
  String keygenFailed(Object message);

  /// No description provided for @keygenUnavailable.
  ///
  /// In zh, this message translates to:
  /// **'未检测到 ssh-keygen，请先安装 OpenSSH 客户端'**
  String get keygenUnavailable;

  /// No description provided for @keyExistsTitle.
  ///
  /// In zh, this message translates to:
  /// **'密钥已存在'**
  String get keyExistsTitle;

  /// No description provided for @keyExistsContent.
  ///
  /// In zh, this message translates to:
  /// **'已存在同名密钥：{path}\n是否覆盖？'**
  String keyExistsContent(Object path);

  /// No description provided for @passphraseReminder.
  ///
  /// In zh, this message translates to:
  /// **'已设置密码短语，每次使用将要求输入'**
  String get passphraseReminder;

  /// No description provided for @fillIdentityFileDone.
  ///
  /// In zh, this message translates to:
  /// **'已填入 IdentityFile 行'**
  String get fillIdentityFileDone;

  /// No description provided for @publicKeyCopied.
  ///
  /// In zh, this message translates to:
  /// **'公钥已复制到剪贴板'**
  String get publicKeyCopied;

  /// No description provided for @keygenDetecting.
  ///
  /// In zh, this message translates to:
  /// **'正在检测 ssh-keygen 可用性…'**
  String get keygenDetecting;

  /// No description provided for @keygenDetectedAt.
  ///
  /// In zh, this message translates to:
  /// **'已检测到 ssh-keygen：{path}'**
  String keygenDetectedAt(Object path);

  /// No description provided for @keygenNotFound.
  ///
  /// In zh, this message translates to:
  /// **'未检测到 ssh-keygen，请安装 OpenSSH 客户端或指定路径'**
  String get keygenNotFound;

  /// No description provided for @keygenPathLabel.
  ///
  /// In zh, this message translates to:
  /// **'自定义 ssh-keygen 路径'**
  String get keygenPathLabel;

  /// No description provided for @keygenPathHint.
  ///
  /// In zh, this message translates to:
  /// **'留空自动检测（PATH / 常见安装位置）'**
  String get keygenPathHint;

  /// No description provided for @keygenVerifyBtn.
  ///
  /// In zh, this message translates to:
  /// **'验证'**
  String get keygenVerifyBtn;

  /// No description provided for @keygenResetBtn.
  ///
  /// In zh, this message translates to:
  /// **'恢复自动检测'**
  String get keygenResetBtn;

  /// No description provided for @keygenBrowseBtn.
  ///
  /// In zh, this message translates to:
  /// **'浏览'**
  String get keygenBrowseBtn;

  /// No description provided for @keygenPathValid.
  ///
  /// In zh, this message translates to:
  /// **'ssh-keygen 路径有效：{path}'**
  String keygenPathValid(Object path);

  /// No description provided for @keygenPathInvalid.
  ///
  /// In zh, this message translates to:
  /// **'ssh-keygen 路径无效：{path}'**
  String keygenPathInvalid(Object path);

  /// No description provided for @logSettings.
  ///
  /// In zh, this message translates to:
  /// **'日志设置'**
  String get logSettings;

  /// No description provided for @logSettingsSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'日志级别与存储位置'**
  String get logSettingsSubtitle;

  /// No description provided for @logLevel.
  ///
  /// In zh, this message translates to:
  /// **'日志级别'**
  String get logLevel;

  /// No description provided for @logLevelTrace.
  ///
  /// In zh, this message translates to:
  /// **'TRACE（最详细）'**
  String get logLevelTrace;

  /// No description provided for @logLevelDebug.
  ///
  /// In zh, this message translates to:
  /// **'DEBUG（调试）'**
  String get logLevelDebug;

  /// No description provided for @logLevelInfo.
  ///
  /// In zh, this message translates to:
  /// **'INFO（信息，默认）'**
  String get logLevelInfo;

  /// No description provided for @logLevelWarn.
  ///
  /// In zh, this message translates to:
  /// **'WARN（警告）'**
  String get logLevelWarn;

  /// No description provided for @logLevelError.
  ///
  /// In zh, this message translates to:
  /// **'ERROR（仅错误）'**
  String get logLevelError;

  /// No description provided for @logFileLocation.
  ///
  /// In zh, this message translates to:
  /// **'日志目录'**
  String get logFileLocation;

  /// No description provided for @onboardingDemoButton.
  ///
  /// In zh, this message translates to:
  /// **'体验示例配置'**
  String get onboardingDemoButton;

  /// No description provided for @onboardingDemoHint.
  ///
  /// In zh, this message translates to:
  /// **'无需注册账号，一键导入 2 个示例配置即可体验全部功能'**
  String get onboardingDemoHint;

  /// No description provided for @onboardingDemoDone.
  ///
  /// In zh, this message translates to:
  /// **'示例配置已导入，点击“完成”开始体验'**
  String get onboardingDemoDone;

  /// No description provided for @demoProfileWorkName.
  ///
  /// In zh, this message translates to:
  /// **'示例-工作账号'**
  String get demoProfileWorkName;

  /// No description provided for @demoProfilePersonalName.
  ///
  /// In zh, this message translates to:
  /// **'示例-个人账号'**
  String get demoProfilePersonalName;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'ja',
    'ko',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
