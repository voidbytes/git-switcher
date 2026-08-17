// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Git アカウント切替';

  @override
  String get trayShowWindow => 'メインウィンドウを表示';

  @override
  String get trayAbout => 'バージョン情報';

  @override
  String get trayExit => '終了';

  @override
  String get aboutTitle => 'Git Switcher について';

  @override
  String get aboutAuthor => '作者: voidbytes';

  @override
  String get aboutAuthorHomepage => '作者ホームページ:';

  @override
  String get aboutProjectUrl => 'プロジェクト URL:';

  @override
  String get close => '閉じる';

  @override
  String switchFailedWithError(Object error) {
    return '切替に失敗しました: $error';
  }

  @override
  String get sshConfigConflictTitle => 'SSH 設定の競合';

  @override
  String sshConfigConflictContent(
    Object conflictPath,
    Object host,
    Object identityFile,
  ) {
    return 'ホスト \"$host\" に対して現在システムに設定されている SSH 秘密鍵のパスは:\n\n$conflictPath\n\nこれを次のように変更します:\n\n$identityFile\n\n続行しますか？';
  }

  @override
  String get cancel => 'キャンセル';

  @override
  String get continueSwitch => '切替を続行';

  @override
  String get switchSuccess => '切替に成功しました';

  @override
  String switchFailedWithMessages(Object messages) {
    return '切替に失敗しました\n$messages';
  }

  @override
  String get refreshTooltip => '現在の設定状態を更新';

  @override
  String activeProfileTitle(Object name) {
    return '現在有効: $name';
  }

  @override
  String get activeProfileSubtitle => 'システム設定は選択したプロファイルと一致しています';

  @override
  String get configMismatchTitle => '設定不一致の注意';

  @override
  String get configMismatchSubtitle =>
      '現在のシステム設定はこのアプリのどのプロファイルとも一致しません。現在の設定をバックアップし、差異を確認することをお勧めします。';

  @override
  String get backupCurrentConfig => '現在の設定をバックアップ';

  @override
  String get viewDiff => '差分を表示';

  @override
  String get noConfigsToCompare => '比較対象のプロファイルがありません';

  @override
  String get viewConfigDiffTitle => '設定差分を表示';

  @override
  String get configMatches => '現在の設定と一致';

  @override
  String profileDiffTitle(Object name) {
    return '$name の設定差分';
  }

  @override
  String get configMatchesFull => 'このプロファイルは現在の設定と一致しています';

  @override
  String get noTargetConfig => '（対象設定なし）';

  @override
  String get diffItems => '差分項目:';

  @override
  String get currentConfigTab => '現在の設定';

  @override
  String get targetConfigTab => '対象の設定';

  @override
  String get noCurrentGitConfig => '（現在の Git 設定なし）';

  @override
  String get noProfiles => 'プロファイルがありません';

  @override
  String get clickToCreateProfile => '右下のボタンをクリックして最初のプロファイルを作成します';

  @override
  String platformLabel(Object host) {
    return 'プラットフォーム: $host';
  }

  @override
  String get sshEnabledStatus => 'SSH: 有効';

  @override
  String get sshDisabledStatus => 'SSH: 無効';

  @override
  String get confirmDeleteTitle => '削除の確認';

  @override
  String confirmDeleteContent(Object name) {
    return 'プロファイル \"$name\" を削除してもよろしいですか？';
  }

  @override
  String get delete => '削除';

  @override
  String get deleteSuccess => '削除しました';

  @override
  String get deleteFailed => '削除に失敗しました';

  @override
  String get settingsTitle => '設定';

  @override
  String get generalSettings => '一般';

  @override
  String get minimizeToTray => 'トレイに最小化';

  @override
  String get minimizeToTraySubtitle => 'ウィンドウを閉じる際、アプリを終了せずにシステムトレイへ最小化します';

  @override
  String get backupSettings => 'バックアップ設定';

  @override
  String get enableAutoBackup => '自動バックアップを有効にする';

  @override
  String get enableAutoBackupSubtitle => 'プロファイル切替時に現在の設定を自動的にバックアップします';

  @override
  String get maxBackupCount => '最大バックアップ数';

  @override
  String get maxBackupCountHelper => 'この数を超えると最も古いバックアップが自動的に削除されます (1-50)';

  @override
  String get enterBackupCount => 'バックアップ数を入力してください';

  @override
  String get backupCountRange => '1 から 50 の間の数字を入力してください';

  @override
  String get save => '保存';

  @override
  String get enterMaxBackupCount => '最大バックアップ数を入力してください';

  @override
  String get maxBackupCountRange => '最大バックアップ数は 1 から 50 の間である必要があります';

  @override
  String get settingsSaved => '設定を保存しました';

  @override
  String get saveFailed => '保存に失敗しました';

  @override
  String saveFailedWithError(Object error) {
    return '保存に失敗しました: $error';
  }

  @override
  String get language => '言語';

  @override
  String get languageSystem => 'システムに従う';

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
  String get newProfile => '新規プロファイル';

  @override
  String get editProfile => 'プロファイルを編集';

  @override
  String get configName => 'プロファイル名';

  @override
  String get configNameHelper => '例: 仕事用アカウント、個人用アカウント';

  @override
  String get enterConfigName => 'プロファイル名を入力してください';

  @override
  String get gitConfigContent => 'Git 設定内容';

  @override
  String get importExistingConfig => '既存設定をインポート';

  @override
  String get gitconfigHelper => '.gitconfig の内容または設定の断片を貼り付けます';

  @override
  String get enterGitConfig => 'Git 設定内容を入力してください';

  @override
  String get enableSsh => 'SSH を有効にする';

  @override
  String get enableSshSubtitle => 'このプロファイルで SSH 鍵認証を有効にします';

  @override
  String get hostname => 'ホスト名';

  @override
  String get hostnameHelper => '例: github.com, gitlab.com';

  @override
  String get hostnameRequired => 'SSH を有効にする場合はホスト名が必要です';

  @override
  String get sshPort => 'SSH ポート';

  @override
  String get sshPortHelper => '443 が事前入力されます。空欄にすると SSH のデフォルトポート 22 を使用します';

  @override
  String get portRange => '1 から 65535 の間のポート番号を入力してください';

  @override
  String get sshPrivateKeyPath => 'SSH 秘密鍵のパス';

  @override
  String get privateKeyHelper => '例: ~/.ssh/id_rsa_work';

  @override
  String get privateKeyRequired => 'SSH を有効にする場合は秘密鍵のパスが必要です';

  @override
  String get pickPrivateKeyTooltip => '秘密鍵ファイルを選択';

  @override
  String get importGitConfigSuccess => '現在の .gitconfig をインポートしました';

  @override
  String get importGitConfigFailed => '.gitconfig が見つからないか、読み込みに失敗しました';

  @override
  String pickFileFailed(Object error) {
    return 'ファイルの選択に失敗しました: $error';
  }

  @override
  String get saveSuccess => '保存しました';

  @override
  String get backupManagement => 'バックアップ管理';

  @override
  String get restoreSelectedBackup => '選択したバックアップを復元';

  @override
  String get noBackups => 'バックアップがありません';

  @override
  String backupTime(Object date) {
    return 'バックアップ時刻: $date';
  }

  @override
  String fileCount(Object count) {
    return '$count ファイル';
  }

  @override
  String get gitConfigType => 'Git 設定';

  @override
  String get sshConfigType => 'SSH 設定';

  @override
  String backupPreviewTitle(Object type) {
    return '$type バックアップのプレビュー';
  }

  @override
  String get noContent => '内容なし';

  @override
  String get confirmRestore => '復元の確認';

  @override
  String confirmRestoreContent(Object type) {
    return '選択した $type 設定を復元してもよろしいですか？\n\n現在の設定が上書きされます。';
  }

  @override
  String get restore => '復元';

  @override
  String get restoreSuccess => '復元しました';

  @override
  String get restoreFailed => '復元に失敗しました';

  @override
  String restoreFailedWithError(Object error) {
    return '復元に失敗しました: $error';
  }

  @override
  String loadBackupsFailed(Object error) {
    return 'バックアップ一覧の読み込みに失敗しました: $error';
  }

  @override
  String get gitBackupDone => '現在の Git 設定をバックアップしました';

  @override
  String get sshBackupDone => '現在の SSH 設定をバックアップしました';

  @override
  String get gitConfigUpdated => 'Git 設定を更新しました';

  @override
  String get gitConfigUpdateFailed => 'Git 設定の更新に失敗しました';

  @override
  String get sshConfigUpdated => 'SSH 設定を更新しました';

  @override
  String get sshConfigUpdateFailed => 'SSH 設定の更新に失敗しました';

  @override
  String get configRolledBack => '設定をロールバックしました';

  @override
  String get gitConfigMatches => 'Git 設定は一致しています';

  @override
  String get gitConfigMismatch => 'Git 設定が一致しません';

  @override
  String get sshConfigMatches => 'SSH 設定は一致しています';

  @override
  String get sshConfigMismatch => 'SSH 設定が一致しません';

  @override
  String diffUserName(Object current, Object profile) {
    return 'Git user.name: 現在 \"$current\" ≠ 設定 \"$profile\"';
  }

  @override
  String diffUserEmail(Object current, Object profile) {
    return 'Git user.email: 現在 \"$current\" ≠ 設定 \"$profile\"';
  }

  @override
  String diffSshHostNotFound(Object host) {
    return 'SSH: ホスト \"$host\" の設定が見つかりません';
  }

  @override
  String diffSshIdentityFile(Object current, Object profile) {
    return 'SSH IdentityFile: 現在 \"$current\" ≠ 設定 \"$profile\"';
  }

  @override
  String keyFileNotExist(Object path) {
    return '秘密鍵ファイルが存在しません: $path';
  }

  @override
  String keyPermissionIncorrect(Object permissions) {
    return '秘密鍵の権限が正しくありません。600 であるべきで、現在は $permissions です';
  }

  @override
  String get keyPermissionCheckFailed => '秘密鍵の権限を確認できませんでした';

  @override
  String get backupNothing => 'バックアップする設定がありません';

  @override
  String get sshNoIdentityFile => 'SSH 設定に IdentityFile 行が見つかりません';

  @override
  String get verifyGitMismatch =>
      'Git の本人確認に失敗しました：user.name または user.email が対象設定と一致しません';

  @override
  String verifySshFailed(Object host) {
    return 'SSH 検証に失敗しました: $host';
  }

  @override
  String get undoFailed => '元に戻す操作に失敗しました';

  @override
  String get importSystemGit => 'システムの .gitconfig をインポート';

  @override
  String get importSystemSsh => 'システムの .ssh/config をインポート';

  @override
  String get sshConfigContent => 'SSH 設定の内容';

  @override
  String get sshConfigHelper => '.ssh/config の内容を貼り付け（ファイル全体の切り替え）';

  @override
  String get enterSshConfig => 'SSH を有効にする場合は設定内容が必要です';

  @override
  String get quickCreateTitle => 'クイック作成';

  @override
  String get fromTemplate => 'テンプレートから';

  @override
  String get fromExistingProfile => '既存のプロフィールをコピー';

  @override
  String get generateKeyPair => '鍵ペアを生成';

  @override
  String get sshPreviewTitle => '~/.ssh/config に書き込む内容';

  @override
  String get templateProviderTitle => 'プロバイダーを選択';

  @override
  String get providerGithub => 'GitHub';

  @override
  String get providerGitlab => 'GitLab';

  @override
  String get providerGitee => 'Gitee';

  @override
  String get providerBlank => '空白';

  @override
  String get templateModeTitle => '接続モード';

  @override
  String get modeDirect => '直接';

  @override
  String get modeProxy => 'プロキシ';

  @override
  String get proxyAddress => 'プロキシアドレス';

  @override
  String get proxyAddressHint => '空欄の場合はデフォルトの 127.0.0.1:7890 を使用';

  @override
  String get templateGenerated => 'SSH 設定テンプレートを生成しました';

  @override
  String get selectProfileToCopy => 'コピーするプロフィールを選択';

  @override
  String get copyProfileSuffix => '（コピー）';

  @override
  String get confirm => '確認';

  @override
  String get importSshConfigSuccess => '現在の .ssh/config 設定をインポートしました';

  @override
  String get importSshConfigFailed => '.ssh/config が見つからないか、読み取れませんでした';

  @override
  String get onboardingWelcome => 'Git Switcher へようこそ';

  @override
  String get onboardingSubtitle => '複数の Git / SSH アイデンティティをワンクリックで管理・切り替え';

  @override
  String get onboardingNameHint => 'このプロフィールに名前を付けます（例：仕事用アカウント）';

  @override
  String get onboardingImportDone => '現在のシステム設定をインポートしました。保存前に変更できます';

  @override
  String get onboardingImport => '現在のシステム設定をインポート';

  @override
  String get onboardingSkip => 'スキップ';

  @override
  String get onboardingFinish => '完了';

  @override
  String get overwriteSshTitle => 'SSH 設定の上書き確認';

  @override
  String get overwriteSshContent =>
      'このツールで管理されていない SSH 設定を上書きしようとしています。続行しますか？';

  @override
  String get switchVerified => '切り替え成功、本人確認済み';

  @override
  String get switchWrittenNotVerified => '設定は書き込まれましたが、検証に失敗しました';

  @override
  String get undoSuccess => '前の設定に戻しました';

  @override
  String get undoNothing => '元に戻す項目がありません';

  @override
  String get undoLastSwitch => '前回の切り替えを元に戻す';

  @override
  String get keyManagementTitle => '鍵の管理';

  @override
  String get keyIdentifier => '識別子（英語）';

  @override
  String get keyIdentifierHelper => '英字、数字、- 、_ のみ使用可能。ファイル名に使用されます';

  @override
  String get keyIdentifierInvalid => '識別子は英語、数字、- 、_ のみ使用できます';

  @override
  String get keyEmail => 'メール（任意）';

  @override
  String get keyEmailInvalid => 'メール形式が正しくありません。@ を含める必要があります';

  @override
  String get keyPassphrase => 'パスフレーズ（任意）';

  @override
  String get keyPassphraseHelper => '空欄でパスフレーズなし；設定した場合は毎回入力が必要です';

  @override
  String get keyAlgorithmLabel => 'アルゴリズム';

  @override
  String get generateKey => '鍵ペアを生成';

  @override
  String get privateKeyPath => '秘密鍵のパス';

  @override
  String get publicKey => '公開鍵';

  @override
  String get copyPublicKey => '公開鍵をコピー';

  @override
  String get fillIdentityFile => '現在の設定に記入';

  @override
  String get keygenSuccess => '鍵ペアの生成に成功しました';

  @override
  String keygenFailed(Object message) {
    return '鍵の生成に失敗しました: $message';
  }

  @override
  String get keygenUnavailable =>
      'ssh-keygen が見つかりません。OpenSSH クライアントをインストールしてください';

  @override
  String get keyExistsTitle => '鍵は既に存在します';

  @override
  String keyExistsContent(Object path) {
    return '鍵は既に存在します：$path\n上書きしますか？';
  }

  @override
  String get passphraseReminder => 'パスフレーズが設定されています。毎回入力が必要になります';

  @override
  String get fillIdentityFileDone => 'IdentityFile 行を記入しました';

  @override
  String get publicKeyCopied => '公開鍵をクリップボードにコピーしました';

  @override
  String get keygenDetecting => 'ssh-keygen の利用可否を確認中…';

  @override
  String keygenDetectedAt(Object path) {
    return 'ssh-keygen を検出しました：$path';
  }

  @override
  String get keygenNotFound =>
      'ssh-keygen が見つかりません。OpenSSH クライアントをインストールするかパスを指定してください';

  @override
  String get keygenPathLabel => 'カスタム ssh-keygen パス';

  @override
  String get keygenPathHint => '空欄で自動検出（PATH / 一般的なインストール場所）';

  @override
  String get keygenVerifyBtn => '確認';

  @override
  String get keygenResetBtn => '自動検出に戻す';

  @override
  String get keygenBrowseBtn => '参照';

  @override
  String keygenPathValid(Object path) {
    return '有効な ssh-keygen パス：$path';
  }

  @override
  String keygenPathInvalid(Object path) {
    return '無効な ssh-keygen パス：$path';
  }

  @override
  String get logSettings => 'ログ設定';

  @override
  String get logSettingsSubtitle => 'ログレベルと保存場所';

  @override
  String get logLevel => 'ログレベル';

  @override
  String get logLevelTrace => 'TRACE（最も詳細）';

  @override
  String get logLevelDebug => 'DEBUG（デバッグ）';

  @override
  String get logLevelInfo => 'INFO（情報，デフォルト）';

  @override
  String get logLevelWarn => 'WARN（警告）';

  @override
  String get logLevelError => 'ERROR（エラーのみ）';

  @override
  String get logFileLocation => 'ログディレクトリ';

  @override
  String get onboardingDemoButton => 'サンプル設定を試す';

  @override
  String get onboardingDemoHint =>
      'アカウント登録は不要 — サンプル設定を 2 つ読み込むだけで全機能をお試しいただけます';

  @override
  String get onboardingDemoDone => 'サンプル設定を読み込みました。「完了」をクリックして開始';

  @override
  String get demoProfileWorkName => 'サンプル-仕事用アカウント';

  @override
  String get demoProfilePersonalName => 'サンプル-個人用アカウント';
}
