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
