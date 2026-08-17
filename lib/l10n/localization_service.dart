import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'app_localizations.dart';
import 'core_messages.dart';

/// 全局本地化访问器。
///
/// 供无 BuildContext 的单例服务（如 GitService / FileService）在生成
/// 用户可见消息时使用。应用启动、或语言切换成功后，由外部调用
/// [L.initialize] 刷新当前 AppLocalizations 实例。
class L {
  static AppLocalizations? _l10n;

  static AppLocalizations get of {
    assert(_l10n != null, 'Localization not initialized');
    return _l10n!;
  }

  static void initialize(AppLocalizations l10n) {
    _l10n = l10n;
  }

  /// 测试辅助：直接注入本地化实例而不触发界面刷新。
  static void debugSetLocalization(AppLocalizations l10n) {
    _l10n = l10n;
  }
}

/// 当前生效的 Locale，供根 MaterialApp 监听以在运行时切换语言。
final ValueNotifier<Locale?> localeNotifier = ValueNotifier<Locale?>(null);

/// 根据语言代码应用语言：解析 Locale、更新全局本地化实例并通知界面刷新。
/// [code] 为 null 或 'system' 时跟随系统语言。
void applyLocale(String? code) {
  final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
  final locale = resolveLocale(code, systemLocale);
  localeNotifier.value = locale;
  final l10n = lookupAppLocalizations(locale);
  L.initialize(l10n);
  // 同步核心服务消息源（GitService / FileService），保持 GUI 文案一致。
  Msg.use(AppLocalizationsCoreMessages(l10n));
  // 同步原生窗口标题栏文本，使其随语言切换。
  windowManager.setTitle(L.of.appTitle);
}

/// 将 GUI 的 AppLocalizations 桥接为纯 Dart 核心服务消息源。
class AppLocalizationsCoreMessages implements CoreMessages {
  AppLocalizationsCoreMessages(this._l10n);

  final AppLocalizations _l10n;

  @override
  String get gitBackupDone => _l10n.gitBackupDone;

  @override
  String get sshBackupDone => _l10n.sshBackupDone;

  @override
  String get gitConfigUpdated => _l10n.gitConfigUpdated;

  @override
  String get gitConfigUpdateFailed => _l10n.gitConfigUpdateFailed;

  @override
  String get sshConfigUpdated => _l10n.sshConfigUpdated;

  @override
  String get sshConfigUpdateFailed => _l10n.sshConfigUpdateFailed;

  @override
  String get configRolledBack => _l10n.configRolledBack;

  @override
  String get sshNoIdentityFile => _l10n.sshNoIdentityFile;

  @override
  String get undoFailed => _l10n.undoFailed;

  @override
  String get verifyGitMismatch => _l10n.verifyGitMismatch;

  @override
  String get backupNothing => _l10n.backupNothing;

  @override
  String keyFileNotExist(Object path) => _l10n.keyFileNotExist(path);

  @override
  String keyPermissionIncorrect(Object permissions) =>
      _l10n.keyPermissionIncorrect(permissions);

  @override
  String get keyPermissionCheckFailed => _l10n.keyPermissionCheckFailed;

  @override
  String verifySshFailed(Object host) => _l10n.verifySshFailed(host);
}

/// 应用支持的语言代码（与 AppConfig.languageCode 及 ARB 文件名对应）。
/// 顺序即设置页语言下拉的展示顺序。
const List<String> kSupportedLanguageCodes = [
  'system',
  'zh',
  'zh_Hant',
  'en',
  'fr',
  'de',
  'es',
  'ja',
  'ko',
  'ru',
  'pt',
];

/// 将语言代码解析为 Locale。'system' 或 null 表示跟随系统。
Locale resolveLocale(String? code, Locale? systemLocale) {
  switch (code) {
    case 'zh':
      return const Locale('zh');
    case 'zh_Hant':
      return const Locale('zh', 'Hant');
    case 'en':
      return const Locale('en');
    case 'fr':
      return const Locale('fr');
    case 'de':
      return const Locale('de');
    case 'es':
      return const Locale('es');
    case 'ja':
      return const Locale('ja');
    case 'ko':
      return const Locale('ko');
    case 'ru':
      return const Locale('ru');
    case 'pt':
      return const Locale('pt');
    default:
      // 跟随系统：使用系统语言，若系统语言不支持则回退到中文（模板语言）。
      return localizedLocale(systemLocale);
  }
}

/// 从系统语言中挑选一个受支持的语言；系统语言未支持时回退到中文。
Locale localizedLocale(Locale? systemLocale) {
  if (systemLocale == null) return const Locale('zh');
  final languageCode = systemLocale.languageCode.toLowerCase();
  switch (languageCode) {
    case 'zh':
      // 繁体区域（台湾/香港等）使用繁体，其余使用简体。
      final script = systemLocale.countryCode?.toUpperCase();
      if (script == 'TW' || script == 'HK' || script == 'MO') {
        return const Locale('zh', 'Hant');
      }
      return const Locale('zh');
    case 'en':
    case 'fr':
    case 'de':
    case 'es':
    case 'ja':
    case 'ko':
    case 'ru':
    case 'pt':
      return Locale(languageCode);
    default:
      return const Locale('zh');
  }
}