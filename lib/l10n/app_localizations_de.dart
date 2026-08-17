// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Git-Kontowechsler';

  @override
  String get trayShowWindow => 'Hauptfenster anzeigen';

  @override
  String get trayAbout => 'Über';

  @override
  String get trayExit => 'Beenden';

  @override
  String get aboutTitle => 'Über Git Switcher';

  @override
  String get aboutAuthor => 'Autor: voidbytes';

  @override
  String get aboutAuthorHomepage => 'Autoren-Homepage:';

  @override
  String get aboutProjectUrl => 'Projekt-URL:';

  @override
  String get close => 'Schließen';

  @override
  String switchFailedWithError(Object error) {
    return 'Wechsel fehlgeschlagen: $error';
  }

  @override
  String get sshConfigConflictTitle => 'SSH-Konfigurationskonflikt';

  @override
  String sshConfigConflictContent(
    Object conflictPath,
    Object host,
    Object identityFile,
  ) {
    return 'Der für Host \"$host\" aktuell konfigurierte SSH-Privatschlüsselpfad ist:\n\n$conflictPath\n\nSie möchten ihn ändern auf:\n\n$identityFile\n\nFortfahren?';
  }

  @override
  String get cancel => 'Abbrechen';

  @override
  String get continueSwitch => 'Wechsel fortsetzen';

  @override
  String get switchSuccess => 'Wechsel erfolgreich';

  @override
  String switchFailedWithMessages(Object messages) {
    return 'Wechsel fehlgeschlagen\n$messages';
  }

  @override
  String get refreshTooltip => 'Konfigurationsstatus aktualisieren';

  @override
  String activeProfileTitle(Object name) {
    return 'Aktuell aktiv: $name';
  }

  @override
  String get activeProfileSubtitle =>
      'Die Systemkonfiguration entspricht dem ausgewählten Profil';

  @override
  String get configMismatchTitle => 'Konfigurationsabweichung';

  @override
  String get configMismatchSubtitle =>
      'Die aktuelle Systemkonfiguration entspricht keinem Profil in dieser App. Sichern Sie die aktuelle Konfiguration und prüfen Sie die Unterschiede.';

  @override
  String get backupCurrentConfig => 'Aktuelle Konfiguration sichern';

  @override
  String get viewDiff => 'Unterschiede anzeigen';

  @override
  String get noConfigsToCompare => 'Keine Profile zum Vergleichen';

  @override
  String get viewConfigDiffTitle => 'Konfigurationsunterschiede anzeigen';

  @override
  String get configMatches => 'Entspricht der aktuellen Konfiguration';

  @override
  String profileDiffTitle(Object name) {
    return 'Konfigurationsunterschiede von $name';
  }

  @override
  String get configMatchesFull =>
      'Dieses Profil entspricht der aktuellen Konfiguration';

  @override
  String get noTargetConfig => '(keine Zielkonfiguration)';

  @override
  String get diffItems => 'Unterschiede:';

  @override
  String get currentConfigTab => 'Aktuelle Konfiguration';

  @override
  String get targetConfigTab => 'Zielkonfiguration';

  @override
  String get noCurrentGitConfig => '(keine aktuelle Git-Konfiguration)';

  @override
  String get noProfiles => 'Keine Profile';

  @override
  String get clickToCreateProfile =>
      'Klicken Sie unten rechts, um Ihr erstes Profil zu erstellen';

  @override
  String platformLabel(Object host) {
    return 'Plattform: $host';
  }

  @override
  String get sshEnabledStatus => 'SSH: aktiviert';

  @override
  String get sshDisabledStatus => 'SSH: deaktiviert';

  @override
  String get confirmDeleteTitle => 'Löschen bestätigen';

  @override
  String confirmDeleteContent(Object name) {
    return 'Möchten Sie das Profil \"$name\" wirklich löschen?';
  }

  @override
  String get delete => 'Löschen';

  @override
  String get deleteSuccess => 'Erfolgreich gelöscht';

  @override
  String get deleteFailed => 'Löschen fehlgeschlagen';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get generalSettings => 'Allgemein';

  @override
  String get minimizeToTray => 'In Taskleiste minimieren';

  @override
  String get minimizeToTraySubtitle =>
      'Beim Schließen des Fensters in der Taskleiste minimieren statt die App zu beenden';

  @override
  String get backupSettings => 'Sicherungseinstellungen';

  @override
  String get enableAutoBackup => 'Automatische Sicherung aktivieren';

  @override
  String get enableAutoBackupSubtitle =>
      'Die aktuelle Konfiguration beim Profilwechsel automatisch sichern';

  @override
  String get maxBackupCount => 'Maximale Anzahl an Sicherungen';

  @override
  String get maxBackupCountHelper =>
      'Älteste Sicherungen werden automatisch gelöscht, wenn diese Anzahl überschritten wird (1-50)';

  @override
  String get enterBackupCount => 'Bitte geben Sie eine Sicherungsanzahl ein';

  @override
  String get backupCountRange =>
      'Bitte geben Sie eine Zahl zwischen 1 und 50 ein';

  @override
  String get save => 'Speichern';

  @override
  String get enterMaxBackupCount =>
      'Bitte geben Sie die maximale Sicherungsanzahl ein';

  @override
  String get maxBackupCountRange =>
      'Die maximale Sicherungsanzahl muss zwischen 1 und 50 liegen';

  @override
  String get settingsSaved => 'Einstellungen gespeichert';

  @override
  String get saveFailed => 'Speichern fehlgeschlagen';

  @override
  String saveFailedWithError(Object error) {
    return 'Speichern fehlgeschlagen: $error';
  }

  @override
  String get language => 'Sprache';

  @override
  String get languageSystem => 'System folgen';

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
  String get newProfile => 'Neues Profil';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get configName => 'Profilname';

  @override
  String get configNameHelper => 'z. B. Arbeitskonto, Persönliches Konto';

  @override
  String get enterConfigName => 'Bitte geben Sie einen Profilnamen ein';

  @override
  String get gitConfigContent => 'Git-Konfigurationsinhalt';

  @override
  String get importExistingConfig => 'Vorhandene Konfiguration importieren';

  @override
  String get gitconfigHelper =>
      'Inhalt von .gitconfig oder einen Konfigurationsausschnitt einfügen';

  @override
  String get enterGitConfig =>
      'Bitte geben Sie den Git-Konfigurationsinhalt ein';

  @override
  String get enableSsh => 'SSH aktivieren';

  @override
  String get enableSshSubtitle =>
      'SSH-Schlüsselauthentifizierung für dieses Profil aktivieren';

  @override
  String get hostname => 'Hostname';

  @override
  String get hostnameHelper => 'z. B. github.com, gitlab.com';

  @override
  String get hostnameRequired =>
      'Ein Hostname ist erforderlich, wenn SSH aktiviert ist';

  @override
  String get sshPort => 'SSH-Port';

  @override
  String get sshPortHelper =>
      'Mit 443 vorausgefüllt; leer lassen, um den SSH-Standardport 22 zu verwenden';

  @override
  String get portRange => 'Bitte geben Sie einen Port zwischen 1 und 65535 ein';

  @override
  String get sshPrivateKeyPath => 'Pfad des SSH-Privatschlüssels';

  @override
  String get privateKeyHelper => 'z. B. ~/.ssh/id_rsa_work';

  @override
  String get privateKeyRequired =>
      'Ein Privatschlüsselpfad ist erforderlich, wenn SSH aktiviert ist';

  @override
  String get pickPrivateKeyTooltip => 'Privatschlüsseldatei wählen';

  @override
  String get importGitConfigSuccess =>
      'Aktuelle .gitconfig erfolgreich importiert';

  @override
  String get importGitConfigFailed =>
      '.gitconfig nicht gefunden oder Lesen fehlgeschlagen';

  @override
  String pickFileFailed(Object error) {
    return 'Dateiauswahl fehlgeschlagen: $error';
  }

  @override
  String get saveSuccess => 'Erfolgreich gespeichert';

  @override
  String get backupManagement => 'Sicherungsverwaltung';

  @override
  String get restoreSelectedBackup => 'Ausgewählte Sicherung wiederherstellen';

  @override
  String get noBackups => 'Keine Sicherungen';

  @override
  String backupTime(Object date) {
    return 'Sicherungszeit: $date';
  }

  @override
  String fileCount(Object count) {
    return '$count Dateien';
  }

  @override
  String get gitConfigType => 'Git-Konfiguration';

  @override
  String get sshConfigType => 'SSH-Konfiguration';

  @override
  String backupPreviewTitle(Object type) {
    return 'Vorschau der Sicherung $type';
  }

  @override
  String get noContent => 'Kein Inhalt';

  @override
  String get confirmRestore => 'Wiederherstellung bestätigen';

  @override
  String confirmRestoreContent(Object type) {
    return 'Möchten Sie die ausgewählte $type-Konfiguration wirklich wiederherstellen?\n\nDies überschreibt die aktuelle Konfiguration.';
  }

  @override
  String get restore => 'Wiederherstellen';

  @override
  String get restoreSuccess => 'Wiederherstellung erfolgreich';

  @override
  String get restoreFailed => 'Wiederherstellung fehlgeschlagen';

  @override
  String restoreFailedWithError(Object error) {
    return 'Wiederherstellung fehlgeschlagen: $error';
  }

  @override
  String loadBackupsFailed(Object error) {
    return 'Laden der Sicherungsliste fehlgeschlagen: $error';
  }

  @override
  String get gitBackupDone => 'Aktuelle Git-Konfiguration gesichert';

  @override
  String get sshBackupDone => 'Aktuelle SSH-Konfiguration gesichert';

  @override
  String get gitConfigUpdated => 'Git-Konfiguration aktualisiert';

  @override
  String get gitConfigUpdateFailed =>
      'Git-Konfiguration konnte nicht aktualisiert werden';

  @override
  String get sshConfigUpdated => 'SSH-Konfiguration aktualisiert';

  @override
  String get sshConfigUpdateFailed =>
      'SSH-Konfiguration konnte nicht aktualisiert werden';

  @override
  String get configRolledBack => 'Konfiguration zurückgesetzt';

  @override
  String get gitConfigMatches => 'Git-Konfiguration stimmt überein';

  @override
  String get gitConfigMismatch => 'Git-Konfiguration stimmt nicht überein';

  @override
  String get sshConfigMatches => 'SSH-Konfiguration stimmt überein';

  @override
  String get sshConfigMismatch => 'SSH-Konfiguration stimmt nicht überein';

  @override
  String diffUserName(Object current, Object profile) {
    return 'Git user.name: aktuell \"$current\" ≠ Profil \"$profile\"';
  }

  @override
  String diffUserEmail(Object current, Object profile) {
    return 'Git user.email: aktuell \"$current\" ≠ Profil \"$profile\"';
  }

  @override
  String diffSshHostNotFound(Object host) {
    return 'SSH: keine Konfiguration für Host \"$host\" gefunden';
  }

  @override
  String diffSshIdentityFile(Object current, Object profile) {
    return 'SSH IdentityFile: aktuell \"$current\" ≠ Profil \"$profile\"';
  }

  @override
  String keyFileNotExist(Object path) {
    return 'Privatschlüsseldatei existiert nicht: $path';
  }

  @override
  String keyPermissionIncorrect(Object permissions) {
    return 'Berechtigungen des Privatschlüssels sind falsch, sollten 600 sein, aktuell: $permissions';
  }

  @override
  String get keyPermissionCheckFailed =>
      'Berechtigungen des Privatschlüssels können nicht geprüft werden';

  @override
  String get backupNothing => 'Nichts zu sichern';

  @override
  String get sshNoIdentityFile =>
      'Keine IdentityFile-Zeile in der SSH-Konfiguration gefunden';

  @override
  String get verifyGitMismatch =>
      'Git-Identitätsprüfung fehlgeschlagen: user.name oder user.email stimmen nicht mit der Zielkonfiguration überein';

  @override
  String verifySshFailed(Object host) {
    return 'SSH-Überprüfung fehlgeschlagen: $host';
  }

  @override
  String get undoFailed => 'Rückgängig machen fehlgeschlagen';

  @override
  String get importSystemGit => 'System-.gitconfig importieren';

  @override
  String get importSystemSsh => 'System-.ssh/config importieren';

  @override
  String get sshConfigContent => 'SSH-Konfigurationsinhalt';

  @override
  String get sshConfigHelper =>
      'Inhalt der .ssh/config einfügen (Ganzdatei-Wechsel)';

  @override
  String get enterSshConfig =>
      'Konfigurationsinhalt ist erforderlich, wenn SSH aktiviert ist';

  @override
  String get quickCreateTitle => 'Schnellerstellen';

  @override
  String get fromTemplate => 'Aus Vorlage';

  @override
  String get fromExistingProfile => 'Vorhandenes Profil kopieren';

  @override
  String get generateKeyPair => 'Schlüsselpaar generieren';

  @override
  String get sshPreviewTitle => 'Inhalt, der in ~/.ssh/config geschrieben wird';

  @override
  String get templateProviderTitle => 'Anbieter auswählen';

  @override
  String get providerGithub => 'GitHub';

  @override
  String get providerGitlab => 'GitLab';

  @override
  String get providerGitee => 'Gitee';

  @override
  String get providerBlank => 'Leer';

  @override
  String get templateModeTitle => 'Verbindungsmodus';

  @override
  String get modeDirect => 'Direkt';

  @override
  String get modeProxy => 'Proxy';

  @override
  String get proxyAddress => 'Proxy-Adresse';

  @override
  String get proxyAddressHint =>
      'Leer lassen, um Standard 127.0.0.1:7890 zu verwenden';

  @override
  String get templateGenerated => 'SSH-Konfigurationsvorlage generiert';

  @override
  String get selectProfileToCopy => 'Zu kopierendes Profil auswählen';

  @override
  String get copyProfileSuffix => ' (Kopie)';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get importSshConfigSuccess =>
      'Aktuelle .ssh/config erfolgreich importiert';

  @override
  String get importSshConfigFailed =>
      '.ssh/config nicht gefunden oder konnte nicht gelesen werden';

  @override
  String get onboardingWelcome => 'Willkommen bei Git Switcher';

  @override
  String get onboardingSubtitle =>
      'Verwalten und wechseln Sie mit einem Klick zwischen mehreren Git-/SSH-Identitäten';

  @override
  String get onboardingNameHint =>
      'Dieses Profil benennen (z. B. Arbeitskonto)';

  @override
  String get onboardingImportDone =>
      'Aktuelle Systemkonfiguration importiert, vor dem Speichern änderbar';

  @override
  String get onboardingImport => 'Aktuelle Systemkonfiguration importieren';

  @override
  String get onboardingSkip => 'Überspringen';

  @override
  String get onboardingFinish => 'Fertig';

  @override
  String get overwriteSshTitle =>
      'Bestätigung zum Überschreiben der SSH-Konfiguration';

  @override
  String get overwriteSshContent =>
      'Sie sind dabei, eine SSH-Konfiguration zu überschreiben, die nicht von diesem Tool verwaltet wird. Fortfahren?';

  @override
  String get switchVerified => 'Wechsel erfolgreich, Identität verifiziert';

  @override
  String get switchWrittenNotVerified =>
      'Konfiguration geschrieben, aber Überprüfung fehlgeschlagen';

  @override
  String get undoSuccess => 'Zur vorherigen Konfiguration zurückgesetzt';

  @override
  String get undoNothing => 'Nichts rückgängig zu machen';

  @override
  String get undoLastSwitch => 'Letzten Wechsel rückgängig machen';

  @override
  String get keyManagementTitle => 'Schlüsselverwaltung';

  @override
  String get keyIdentifier => 'Kennung (Englisch)';

  @override
  String get keyIdentifierHelper =>
      'Nur Buchstaben, Zahlen, - und _ erlaubt, für Dateinamen verwendet';

  @override
  String get keyIdentifierInvalid =>
      'Kennung erlaubt nur Englisch, Zahlen, - und _';

  @override
  String get keyEmail => 'E-Mail (optional)';

  @override
  String get keyEmailInvalid => 'Ungültiges E-Mail-Format, muss @ enthalten';

  @override
  String get keyPassphrase => 'Passphrase (optional)';

  @override
  String get keyPassphraseHelper =>
      'Leer lassen für keine Passphrase; wenn gesetzt, bei jeder Verwendung erforderlich';

  @override
  String get keyAlgorithmLabel => 'Algorithmus';

  @override
  String get generateKey => 'Schlüsselpaar generieren';

  @override
  String get privateKeyPath => 'Pfad zum privaten Schlüssel';

  @override
  String get publicKey => 'Öffentlicher Schlüssel';

  @override
  String get copyPublicKey => 'Öffentlichen Schlüssel kopieren';

  @override
  String get fillIdentityFile => 'In aktuelle Konfiguration einfügen';

  @override
  String get keygenSuccess => 'Schlüsselpaar erfolgreich generiert';

  @override
  String keygenFailed(Object message) {
    return 'Schlüsselgenerierung fehlgeschlagen: $message';
  }

  @override
  String get keygenUnavailable =>
      'ssh-keygen nicht gefunden. Bitte OpenSSH-Client installieren';

  @override
  String get keyExistsTitle => 'Schlüssel existiert bereits';

  @override
  String keyExistsContent(Object path) {
    return 'Schlüssel existiert bereits: $path\nÜberschreiben?';
  }

  @override
  String get passphraseReminder =>
      'Passphrase gesetzt; sie wird bei jeder Verwendung erforderlich sein';

  @override
  String get fillIdentityFileDone => 'IdentityFile-Zeile eingefügt';

  @override
  String get publicKeyCopied =>
      'Öffentlicher Schlüssel in die Zwischenablage kopiert';

  @override
  String get keygenDetecting => 'Prüfe ssh-keygen-Verfügbarkeit…';

  @override
  String keygenDetectedAt(Object path) {
    return 'ssh-keygen erkannt: $path';
  }

  @override
  String get keygenNotFound =>
      'ssh-keygen nicht gefunden. OpenSSH-Client installieren oder Pfad angeben';

  @override
  String get keygenPathLabel => 'Benutzerdefinierter ssh-keygen-Pfad';

  @override
  String get keygenPathHint =>
      'Leer lassen für Auto-Erkennung (PATH / übliche Installationsorte)';

  @override
  String get keygenVerifyBtn => 'Prüfen';

  @override
  String get keygenResetBtn => 'Auto-Erkennung zurücksetzen';

  @override
  String get keygenBrowseBtn => 'Durchsuchen';

  @override
  String keygenPathValid(Object path) {
    return 'Gültiger ssh-keygen-Pfad: $path';
  }

  @override
  String keygenPathInvalid(Object path) {
    return 'Ungültiger ssh-keygen-Pfad: $path';
  }

  @override
  String get logSettings => 'Protokolleinstellungen';

  @override
  String get logSettingsSubtitle => 'Protokollstufe und Speicherort';

  @override
  String get logLevel => 'Protokollstufe';

  @override
  String get logLevelTrace => 'TRACE (am ausführlichsten)';

  @override
  String get logLevelDebug => 'DEBUG (Debuggen)';

  @override
  String get logLevelInfo => 'INFO (Standard)';

  @override
  String get logLevelWarn => 'WARN (Warnungen)';

  @override
  String get logLevelError => 'ERROR (nur Fehler)';

  @override
  String get logFileLocation => 'Protokollverzeichnis';

  @override
  String get onboardingDemoButton => 'Beispielprofile ausprobieren';

  @override
  String get onboardingDemoHint =>
      'Kein Konto erforderlich — zwei Beispielprofile importieren und alle Funktionen ohne Registrierung ausprobieren';

  @override
  String get onboardingDemoDone =>
      'Beispielprofile importiert — klicken Sie auf „Fertig stellen“, um zu starten';

  @override
  String get demoProfileWorkName => 'Beispiel-Arbeitskonto';

  @override
  String get demoProfilePersonalName => 'Beispiel-Personalkonto';
}
