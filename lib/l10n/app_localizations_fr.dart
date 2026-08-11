// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Sélecteur de comptes Git';

  @override
  String get trayShowWindow => 'Afficher la fenêtre principale';

  @override
  String get trayAbout => 'À propos';

  @override
  String get trayExit => 'Quitter';

  @override
  String get aboutTitle => 'À propos de Git Switcher';

  @override
  String get aboutAuthor => 'Auteur : voidbytes';

  @override
  String get aboutAuthorHomepage => 'Page d\'accueil de l\'auteur :';

  @override
  String get aboutProjectUrl => 'URL du projet :';

  @override
  String get close => 'Fermer';

  @override
  String switchFailedWithError(Object error) {
    return 'Échec de la bascule : $error';
  }

  @override
  String get sshConfigConflictTitle => 'Conflit de configuration SSH';

  @override
  String sshConfigConflictContent(
    Object conflictPath,
    Object host,
    Object identityFile,
  ) {
    return 'Le chemin de clé privée SSH actuellement configuré pour l\'hôte \"$host\" est :\n\n$conflictPath\n\nVous souhaitez le remplacer par :\n\n$identityFile\n\nContinuer ?';
  }

  @override
  String get cancel => 'Annuler';

  @override
  String get continueSwitch => 'Continuer la bascule';

  @override
  String get switchSuccess => 'Bascule réussie';

  @override
  String switchFailedWithMessages(Object messages) {
    return 'Échec de la bascule\n$messages';
  }

  @override
  String get refreshTooltip => 'Actualiser l\'état de la configuration';

  @override
  String activeProfileTitle(Object name) {
    return 'Actuellement actif : $name';
  }

  @override
  String get activeProfileSubtitle =>
      'La configuration système correspond au profil sélectionné';

  @override
  String get configMismatchTitle => 'Incohérence de configuration';

  @override
  String get configMismatchSubtitle =>
      'La configuration système actuelle ne correspond à aucun profil de cette application. Envisagez de sauvegarder la configuration actuelle et de consulter les différences.';

  @override
  String get backupCurrentConfig => 'Sauvegarder la configuration actuelle';

  @override
  String get viewDiff => 'Voir les différences';

  @override
  String get noConfigsToCompare => 'Aucun profil à comparer';

  @override
  String get viewConfigDiffTitle => 'Voir les différences de configuration';

  @override
  String get configMatches => 'Correspond à la configuration actuelle';

  @override
  String profileDiffTitle(Object name) {
    return 'Différences de configuration de $name';
  }

  @override
  String get configMatchesFull =>
      'Ce profil correspond à la configuration actuelle';

  @override
  String get noTargetConfig => '(aucune configuration cible)';

  @override
  String get diffItems => 'Différences :';

  @override
  String get currentConfigTab => 'Configuration actuelle';

  @override
  String get targetConfigTab => 'Configuration cible';

  @override
  String get noCurrentGitConfig => '(aucune configuration Git actuelle)';

  @override
  String get noProfiles => 'Aucun profil';

  @override
  String get clickToCreateProfile =>
      'Cliquez sur le bouton en bas à droite pour créer votre premier profil';

  @override
  String platformLabel(Object host) {
    return 'Plateforme : $host';
  }

  @override
  String get sshEnabledStatus => 'SSH : activé';

  @override
  String get sshDisabledStatus => 'SSH : désactivé';

  @override
  String get confirmDeleteTitle => 'Confirmer la suppression';

  @override
  String confirmDeleteContent(Object name) {
    return 'Voulez-vous vraiment supprimer le profil \"$name\" ?';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteSuccess => 'Suppression réussie';

  @override
  String get deleteFailed => 'Échec de la suppression';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get generalSettings => 'Général';

  @override
  String get minimizeToTray => 'Réduire dans la barre d\'état système';

  @override
  String get minimizeToTraySubtitle =>
      'Lors de la fermeture de la fenêtre, réduire dans la barre d\'état système au lieu de quitter l\'application';

  @override
  String get backupSettings => 'Paramètres de sauvegarde';

  @override
  String get enableAutoBackup => 'Activer la sauvegarde automatique';

  @override
  String get enableAutoBackupSubtitle =>
      'Sauvegarder automatiquement la configuration actuelle lors du changement de profil';

  @override
  String get maxBackupCount => 'Nombre maximal de sauvegardes';

  @override
  String get maxBackupCountHelper =>
      'Les sauvegardes les plus anciennes sont supprimées automatiquement au-delà de ce nombre (1-50)';

  @override
  String get enterBackupCount => 'Veuillez saisir un nombre de sauvegardes';

  @override
  String get backupCountRange => 'Veuillez saisir un nombre entre 1 et 50';

  @override
  String get save => 'Enregistrer';

  @override
  String get enterMaxBackupCount =>
      'Veuillez saisir le nombre maximal de sauvegardes';

  @override
  String get maxBackupCountRange =>
      'Le nombre maximal de sauvegardes doit être entre 1 et 50';

  @override
  String get settingsSaved => 'Paramètres enregistrés';

  @override
  String get saveFailed => 'Échec de l\'enregistrement';

  @override
  String saveFailedWithError(Object error) {
    return 'Échec de l\'enregistrement : $error';
  }

  @override
  String get language => 'Langue';

  @override
  String get languageSystem => 'Suivre le système';

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
  String get newProfile => 'Nouveau profil';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get configName => 'Nom du profil';

  @override
  String get configNameHelper =>
      'p. ex. Compte professionnel, Compte personnel';

  @override
  String get enterConfigName => 'Veuillez saisir un nom de profil';

  @override
  String get gitConfigContent => 'Contenu de la configuration Git';

  @override
  String get importExistingConfig => 'Importer la configuration existante';

  @override
  String get gitconfigHelper =>
      'Collez le contenu de .gitconfig ou un extrait de configuration';

  @override
  String get enterGitConfig =>
      'Veuillez saisir le contenu de la configuration Git';

  @override
  String get enableSsh => 'Activer SSH';

  @override
  String get enableSshSubtitle =>
      'Activer l\'authentification par clé SSH pour ce profil';

  @override
  String get hostname => 'Nom d\'hôte';

  @override
  String get hostnameHelper => 'p. ex. github.com, gitlab.com';

  @override
  String get hostnameRequired =>
      'Un nom d\'hôte est requis lorsque SSH est activé';

  @override
  String get sshPort => 'Port SSH';

  @override
  String get sshPortHelper =>
      'Prérempli avec 443 ; laissez vide pour utiliser le port par défaut de SSH (22)';

  @override
  String get portRange => 'Veuillez saisir un port entre 1 et 65535';

  @override
  String get sshPrivateKeyPath => 'Chemin de la clé privée SSH';

  @override
  String get privateKeyHelper => 'p. ex. ~/.ssh/id_rsa_work';

  @override
  String get privateKeyRequired =>
      'Un chemin de clé privée est requis lorsque SSH est activé';

  @override
  String get pickPrivateKeyTooltip => 'Choisir le fichier de clé privée';

  @override
  String get importGitConfigSuccess =>
      'Configuration .gitconfig actuelle importée avec succès';

  @override
  String get importGitConfigFailed =>
      'Impossible de trouver .gitconfig ou de le lire';

  @override
  String pickFileFailed(Object error) {
    return 'Échec du choix du fichier : $error';
  }

  @override
  String get saveSuccess => 'Enregistré avec succès';

  @override
  String get backupManagement => 'Gestion des sauvegardes';

  @override
  String get restoreSelectedBackup => 'Restaurer la sauvegarde sélectionnée';

  @override
  String get noBackups => 'Aucune sauvegarde';

  @override
  String backupTime(Object date) {
    return 'Date de sauvegarde : $date';
  }

  @override
  String fileCount(Object count) {
    return '$count fichiers';
  }

  @override
  String get gitConfigType => 'Configuration Git';

  @override
  String get sshConfigType => 'Configuration SSH';

  @override
  String backupPreviewTitle(Object type) {
    return 'Aperçu de la sauvegarde $type';
  }

  @override
  String get noContent => 'Aucun contenu';

  @override
  String get confirmRestore => 'Confirmer la restauration';

  @override
  String confirmRestoreContent(Object type) {
    return 'Voulez-vous vraiment restaurer la configuration $type sélectionnée ?\n\nCela écrasera la configuration actuelle.';
  }

  @override
  String get restore => 'Restaurer';

  @override
  String get restoreSuccess => 'Restauration réussie';

  @override
  String get restoreFailed => 'Échec de la restauration';

  @override
  String restoreFailedWithError(Object error) {
    return 'Échec de la restauration : $error';
  }

  @override
  String loadBackupsFailed(Object error) {
    return 'Échec du chargement de la liste des sauvegardes : $error';
  }

  @override
  String get gitBackupDone => 'Configuration Git actuelle sauvegardée';

  @override
  String get sshBackupDone => 'Configuration SSH actuelle sauvegardée';

  @override
  String get gitConfigUpdated => 'Configuration Git mise à jour';

  @override
  String get gitConfigUpdateFailed =>
      'Échec de la mise à jour de la configuration Git';

  @override
  String get sshConfigUpdated => 'Configuration SSH mise à jour';

  @override
  String get sshConfigUpdateFailed =>
      'Échec de la mise à jour de la configuration SSH';

  @override
  String get configRolledBack => 'Configuration restaurée';

  @override
  String get gitConfigMatches => 'La configuration Git correspond';

  @override
  String get gitConfigMismatch => 'La configuration Git ne correspond pas';

  @override
  String get sshConfigMatches => 'La configuration SSH correspond';

  @override
  String get sshConfigMismatch => 'La configuration SSH ne correspond pas';

  @override
  String diffUserName(Object current, Object profile) {
    return 'Git user.name : actuel \"$current\" ≠ profil \"$profile\"';
  }

  @override
  String diffUserEmail(Object current, Object profile) {
    return 'Git user.email : actuel \"$current\" ≠ profil \"$profile\"';
  }

  @override
  String diffSshHostNotFound(Object host) {
    return 'SSH : aucune configuration trouvée pour l\'hôte \"$host\"';
  }

  @override
  String diffSshIdentityFile(Object current, Object profile) {
    return 'SSH IdentityFile : actuel \"$current\" ≠ profil \"$profile\"';
  }

  @override
  String keyFileNotExist(Object path) {
    return 'Le fichier de clé privée n\'existe pas : $path';
  }

  @override
  String keyPermissionIncorrect(Object permissions) {
    return 'Les permissions de la clé privée sont incorrectes, devraient être 600, actuelles : $permissions';
  }

  @override
  String get keyPermissionCheckFailed =>
      'Impossible de vérifier les permissions de la clé privée';

  @override
  String get backupNothing => 'Rien à sauvegarder';
}
