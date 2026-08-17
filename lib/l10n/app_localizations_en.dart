// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Git Account Switcher';

  @override
  String get trayShowWindow => 'Show main window';

  @override
  String get trayAbout => 'About';

  @override
  String get trayExit => 'Exit';

  @override
  String get aboutTitle => 'About Git Switcher';

  @override
  String get aboutAuthor => 'Author: voidbytes';

  @override
  String get aboutAuthorHomepage => 'Author homepage:';

  @override
  String get aboutProjectUrl => 'Project URL:';

  @override
  String get close => 'Close';

  @override
  String switchFailedWithError(Object error) {
    return 'Switch failed: $error';
  }

  @override
  String get sshConfigConflictTitle => 'SSH Config Conflict';

  @override
  String sshConfigConflictContent(
    Object conflictPath,
    Object host,
    Object identityFile,
  ) {
    return 'The SSH private key path currently configured on your system for host \"$host\" is:\n\n$conflictPath\n\nYou want to change it to:\n\n$identityFile\n\nContinue?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get continueSwitch => 'Continue switch';

  @override
  String get switchSuccess => 'Switch successful';

  @override
  String switchFailedWithMessages(Object messages) {
    return 'Switch failed\n$messages';
  }

  @override
  String get refreshTooltip => 'Refresh current config status';

  @override
  String activeProfileTitle(Object name) {
    return 'Currently active: $name';
  }

  @override
  String get activeProfileSubtitle =>
      'System configuration matches the selected profile';

  @override
  String get configMismatchTitle => 'Configuration Mismatch';

  @override
  String get configMismatchSubtitle =>
      'The current system configuration does not match any profile in this app. Consider backing up the current configuration and reviewing the differences.';

  @override
  String get backupCurrentConfig => 'Back up current config';

  @override
  String get viewDiff => 'View diff';

  @override
  String get noConfigsToCompare => 'No profiles to compare';

  @override
  String get viewConfigDiffTitle => 'View Config Differences';

  @override
  String get configMatches => 'Matches current configuration';

  @override
  String profileDiffTitle(Object name) {
    return '$name Config Differences';
  }

  @override
  String get configMatchesFull =>
      'This profile matches the current configuration';

  @override
  String get noTargetConfig => '(no target config)';

  @override
  String get diffItems => 'Differences:';

  @override
  String get currentConfigTab => 'Current config';

  @override
  String get targetConfigTab => 'Target config';

  @override
  String get noCurrentGitConfig => '(no current Git config)';

  @override
  String get noProfiles => 'No profiles';

  @override
  String get clickToCreateProfile =>
      'Click the button at the bottom right to create your first profile';

  @override
  String platformLabel(Object host) {
    return 'Platform: $host';
  }

  @override
  String get sshEnabledStatus => 'SSH: enabled';

  @override
  String get sshDisabledStatus => 'SSH: disabled';

  @override
  String get confirmDeleteTitle => 'Confirm Delete';

  @override
  String confirmDeleteContent(Object name) {
    return 'Are you sure you want to delete profile \"$name\"?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get deleteSuccess => 'Deleted successfully';

  @override
  String get deleteFailed => 'Delete failed';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get generalSettings => 'General';

  @override
  String get minimizeToTray => 'Minimize to tray';

  @override
  String get minimizeToTraySubtitle =>
      'When closing the window, minimize to the system tray instead of exiting the app';

  @override
  String get backupSettings => 'Backup Settings';

  @override
  String get enableAutoBackup => 'Enable auto backup';

  @override
  String get enableAutoBackupSubtitle =>
      'Automatically back up the current configuration when switching profiles';

  @override
  String get maxBackupCount => 'Max backup count';

  @override
  String get maxBackupCountHelper =>
      'Oldest backups are deleted automatically when this count is exceeded (1-50)';

  @override
  String get enterBackupCount => 'Please enter a backup count';

  @override
  String get backupCountRange => 'Please enter a number between 1 and 50';

  @override
  String get save => 'Save';

  @override
  String get enterMaxBackupCount => 'Please enter the max backup count';

  @override
  String get maxBackupCountRange => 'Max backup count must be between 1 and 50';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get saveFailed => 'Save failed';

  @override
  String saveFailedWithError(Object error) {
    return 'Save failed: $error';
  }

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'Follow system';

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
  String get newProfile => 'New profile';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get configName => 'Profile name';

  @override
  String get configNameHelper => 'e.g. Work account, Personal account';

  @override
  String get enterConfigName => 'Please enter a profile name';

  @override
  String get gitConfigContent => 'Git config content';

  @override
  String get importExistingConfig => 'Import existing config';

  @override
  String get gitconfigHelper => 'Paste .gitconfig contents or a config snippet';

  @override
  String get enterGitConfig => 'Please enter Git config content';

  @override
  String get enableSsh => 'Enable SSH';

  @override
  String get enableSshSubtitle =>
      'Enable SSH key authentication for this profile';

  @override
  String get hostname => 'Hostname';

  @override
  String get hostnameHelper => 'e.g. github.com, gitlab.com';

  @override
  String get hostnameRequired => 'A hostname is required when SSH is enabled';

  @override
  String get sshPort => 'SSH port';

  @override
  String get sshPortHelper =>
      'Prefilled with 443; leave empty to use the SSH default port 22';

  @override
  String get portRange => 'Please enter a port between 1 and 65535';

  @override
  String get sshPrivateKeyPath => 'SSH private key path';

  @override
  String get privateKeyHelper => 'e.g. ~/.ssh/id_rsa_work';

  @override
  String get privateKeyRequired =>
      'A private key path is required when SSH is enabled';

  @override
  String get pickPrivateKeyTooltip => 'Choose private key file';

  @override
  String get importGitConfigSuccess =>
      'Successfully imported the current .gitconfig';

  @override
  String get importGitConfigFailed =>
      'Could not find .gitconfig or failed to read it';

  @override
  String pickFileFailed(Object error) {
    return 'Failed to choose file: $error';
  }

  @override
  String get saveSuccess => 'Saved successfully';

  @override
  String get backupManagement => 'Backup Management';

  @override
  String get restoreSelectedBackup => 'Restore selected backup';

  @override
  String get noBackups => 'No backups';

  @override
  String backupTime(Object date) {
    return 'Backup time: $date';
  }

  @override
  String fileCount(Object count) {
    return '$count files';
  }

  @override
  String get gitConfigType => 'Git config';

  @override
  String get sshConfigType => 'SSH config';

  @override
  String backupPreviewTitle(Object type) {
    return '$type Backup Preview';
  }

  @override
  String get noContent => 'No content';

  @override
  String get confirmRestore => 'Confirm Restore';

  @override
  String confirmRestoreContent(Object type) {
    return 'Are you sure you want to restore the selected $type config?\n\nThis will overwrite the current config.';
  }

  @override
  String get restore => 'Restore';

  @override
  String get restoreSuccess => 'Restored successfully';

  @override
  String get restoreFailed => 'Restore failed';

  @override
  String restoreFailedWithError(Object error) {
    return 'Restore failed: $error';
  }

  @override
  String loadBackupsFailed(Object error) {
    return 'Failed to load backup list: $error';
  }

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
  String get gitConfigMatches => 'Git config matches';

  @override
  String get gitConfigMismatch => 'Git config does not match';

  @override
  String get sshConfigMatches => 'SSH config matches';

  @override
  String get sshConfigMismatch => 'SSH config does not match';

  @override
  String diffUserName(Object current, Object profile) {
    return 'Git user.name: current \"$current\" ≠ profile \"$profile\"';
  }

  @override
  String diffUserEmail(Object current, Object profile) {
    return 'Git user.email: current \"$current\" ≠ profile \"$profile\"';
  }

  @override
  String diffSshHostNotFound(Object host) {
    return 'SSH: no config found for host \"$host\"';
  }

  @override
  String diffSshIdentityFile(Object current, Object profile) {
    return 'SSH IdentityFile: current \"$current\" ≠ profile \"$profile\"';
  }

  @override
  String keyFileNotExist(Object path) {
    return 'Private key file does not exist: $path';
  }

  @override
  String keyPermissionIncorrect(Object permissions) {
    return 'Private key permissions are incorrect, should be 600, current is $permissions';
  }

  @override
  String get keyPermissionCheckFailed =>
      'Unable to check private key permissions';

  @override
  String get backupNothing => 'Nothing to back up';

  @override
  String get sshNoIdentityFile => 'No IdentityFile line found in SSH config';

  @override
  String get verifyGitMismatch =>
      'Git identity verification failed: user.name or user.email does not match the target config';

  @override
  String verifySshFailed(Object host) {
    return 'SSH verification failed: $host';
  }

  @override
  String get undoFailed => 'Undo failed';

  @override
  String get importSystemGit => 'Import system .gitconfig';

  @override
  String get importSystemSsh => 'Import system .ssh/config';

  @override
  String get sshConfigContent => 'SSH Config Content';

  @override
  String get sshConfigHelper =>
      'Paste the .ssh/config content (full-file switching)';

  @override
  String get enterSshConfig => 'Config content is required when SSH is enabled';

  @override
  String get quickCreateTitle => 'Quick Create';

  @override
  String get fromTemplate => 'From template';

  @override
  String get fromExistingProfile => 'Copy existing profile';

  @override
  String get generateKeyPair => 'Generate key pair';

  @override
  String get sshPreviewTitle => 'Content to be written to ~/.ssh/config';

  @override
  String get templateProviderTitle => 'Select provider';

  @override
  String get providerGithub => 'GitHub';

  @override
  String get providerGitlab => 'GitLab';

  @override
  String get providerGitee => 'Gitee';

  @override
  String get providerBlank => 'Blank';

  @override
  String get templateModeTitle => 'Connection mode';

  @override
  String get modeDirect => 'Direct';

  @override
  String get modeProxy => 'Proxy';

  @override
  String get proxyAddress => 'Proxy address';

  @override
  String get proxyAddressHint => 'Leave empty to use default 127.0.0.1:7890';

  @override
  String get templateGenerated => 'SSH config template generated';

  @override
  String get selectProfileToCopy => 'Select profile to copy';

  @override
  String get copyProfileSuffix => ' (copy)';

  @override
  String get confirm => 'Confirm';

  @override
  String get importSshConfigSuccess =>
      'Successfully imported current .ssh/config';

  @override
  String get importSshConfigFailed =>
      '.ssh/config not found or could not be read';

  @override
  String get onboardingWelcome => 'Welcome to Git Switcher';

  @override
  String get onboardingSubtitle =>
      'Manage and switch between multiple Git / SSH identities with one click';

  @override
  String get onboardingNameHint => 'Name this profile (e.g. Work account)';

  @override
  String get onboardingImportDone =>
      'Current system config imported, you can modify before saving';

  @override
  String get onboardingImport => 'Import current system config';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingFinish => 'Finish';

  @override
  String get overwriteSshTitle => 'Overwrite SSH config confirmation';

  @override
  String get overwriteSshContent =>
      'You are about to overwrite an SSH config not managed by this tool. Continue?';

  @override
  String get switchVerified => 'Switch successful, identity verified';

  @override
  String get switchWrittenNotVerified =>
      'Config written, but verification failed';

  @override
  String get undoSuccess => 'Undone to the previous config';

  @override
  String get undoNothing => 'Nothing to undo';

  @override
  String get undoLastSwitch => 'Undo last switch';

  @override
  String get keyManagementTitle => 'Key management';

  @override
  String get keyIdentifier => 'Identifier (English)';

  @override
  String get keyIdentifierHelper =>
      'Only letters, numbers, - and _ allowed, used for file names';

  @override
  String get keyIdentifierInvalid =>
      'Identifier only allows English, numbers, - and _';

  @override
  String get keyEmail => 'Email (optional)';

  @override
  String get keyEmailInvalid => 'Invalid email format, must contain @';

  @override
  String get keyPassphrase => 'Passphrase (optional)';

  @override
  String get keyPassphraseHelper =>
      'Leave empty for no passphrase; required on every use if set';

  @override
  String get keyAlgorithmLabel => 'Algorithm';

  @override
  String get generateKey => 'Generate key pair';

  @override
  String get privateKeyPath => 'Private key path';

  @override
  String get publicKey => 'Public key';

  @override
  String get copyPublicKey => 'Copy public key';

  @override
  String get fillIdentityFile => 'Fill into current config';

  @override
  String get keygenSuccess => 'Key pair generated successfully';

  @override
  String keygenFailed(Object message) {
    return 'Key generation failed: $message';
  }

  @override
  String get keygenUnavailable =>
      'ssh-keygen not found. Please install OpenSSH client';

  @override
  String get keyExistsTitle => 'Key already exists';

  @override
  String keyExistsContent(Object path) {
    return 'Key already exists: $path\nOverwrite?';
  }

  @override
  String get passphraseReminder =>
      'Passphrase set; it will be required on every use';

  @override
  String get fillIdentityFileDone => 'IdentityFile line filled';

  @override
  String get publicKeyCopied => 'Public key copied to clipboard';

  @override
  String get keygenDetecting => 'Checking ssh-keygen availability…';

  @override
  String keygenDetectedAt(Object path) {
    return 'ssh-keygen detected: $path';
  }

  @override
  String get keygenNotFound =>
      'ssh-keygen not found. Install OpenSSH client or specify a path';

  @override
  String get keygenPathLabel => 'Custom ssh-keygen path';

  @override
  String get keygenPathHint =>
      'Leave empty to auto-detect (PATH / common install locations)';

  @override
  String get keygenVerifyBtn => 'Verify';

  @override
  String get keygenResetBtn => 'Reset to auto-detect';

  @override
  String get keygenBrowseBtn => 'Browse';

  @override
  String keygenPathValid(Object path) {
    return 'Valid ssh-keygen path: $path';
  }

  @override
  String keygenPathInvalid(Object path) {
    return 'Invalid ssh-keygen path: $path';
  }

  @override
  String get logSettings => 'Log Settings';

  @override
  String get logSettingsSubtitle => 'Log level and storage location';

  @override
  String get logLevel => 'Log level';

  @override
  String get logLevelTrace => 'TRACE (most verbose)';

  @override
  String get logLevelDebug => 'DEBUG (debugging)';

  @override
  String get logLevelInfo => 'INFO (default)';

  @override
  String get logLevelWarn => 'WARN (warnings)';

  @override
  String get logLevelError => 'ERROR (errors only)';

  @override
  String get logFileLocation => 'Log directory';

  @override
  String get onboardingDemoButton => 'Try sample profiles';

  @override
  String get onboardingDemoHint =>
      'No account needed — import two sample profiles to explore all features without registering';

  @override
  String get onboardingDemoDone =>
      'Sample profiles imported — click Finish to start';

  @override
  String get demoProfileWorkName => 'Sample Work Account';

  @override
  String get demoProfilePersonalName => 'Sample Personal Account';
}
