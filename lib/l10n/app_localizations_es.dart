// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Cambiador de cuentas Git';

  @override
  String get trayShowWindow => 'Mostrar la ventana principal';

  @override
  String get trayAbout => 'Acerca de';

  @override
  String get trayExit => 'Salir';

  @override
  String get aboutTitle => 'Acerca de Git Switcher';

  @override
  String get aboutAuthor => 'Autor: voidbytes';

  @override
  String get aboutAuthorHomepage => 'Página del autor:';

  @override
  String get aboutProjectUrl => 'URL del proyecto:';

  @override
  String get close => 'Cerrar';

  @override
  String switchFailedWithError(Object error) {
    return 'Error al cambiar: $error';
  }

  @override
  String get sshConfigConflictTitle => 'Conflicto de configuración SSH';

  @override
  String sshConfigConflictContent(
    Object conflictPath,
    Object host,
    Object identityFile,
  ) {
    return 'La ruta de la clave privada SSH actualmente configurada para el host \"$host\" es:\n\n$conflictPath\n\nQuiere cambiarla a:\n\n$identityFile\n\n¿Continuar?';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get continueSwitch => 'Continuar el cambio';

  @override
  String get switchSuccess => 'Cambio exitoso';

  @override
  String switchFailedWithMessages(Object messages) {
    return 'Error al cambiar\n$messages';
  }

  @override
  String get refreshTooltip => 'Actualizar el estado de la configuración';

  @override
  String activeProfileTitle(Object name) {
    return 'Actualmente activo: $name';
  }

  @override
  String get activeProfileSubtitle =>
      'La configuración del sistema coincide con el perfil seleccionado';

  @override
  String get configMismatchTitle => 'Discrepancia de configuración';

  @override
  String get configMismatchSubtitle =>
      'La configuración actual del sistema no coincide con ningún perfil de esta aplicación. Considere hacer una copia de seguridad de la configuración y revisar las diferencias.';

  @override
  String get backupCurrentConfig => 'Respaldar configuración actual';

  @override
  String get viewDiff => 'Ver diferencias';

  @override
  String get noConfigsToCompare => 'No hay perfiles para comparar';

  @override
  String get viewConfigDiffTitle => 'Ver diferencias de configuración';

  @override
  String get configMatches => 'Coincide con la configuración actual';

  @override
  String profileDiffTitle(Object name) {
    return 'Diferencias de configuración de $name';
  }

  @override
  String get configMatchesFull =>
      'Este perfil coincide con la configuración actual';

  @override
  String get noTargetConfig => '(sin configuración de destino)';

  @override
  String get diffItems => 'Diferencias:';

  @override
  String get currentConfigTab => 'Configuración actual';

  @override
  String get targetConfigTab => 'Configuración de destino';

  @override
  String get noCurrentGitConfig => '(sin configuración Git actual)';

  @override
  String get noProfiles => 'Sin perfiles';

  @override
  String get clickToCreateProfile =>
      'Haz clic en el botón de abajo a la derecha para crear tu primer perfil';

  @override
  String platformLabel(Object host) {
    return 'Plataforma: $host';
  }

  @override
  String get sshEnabledStatus => 'SSH: habilitado';

  @override
  String get sshDisabledStatus => 'SSH: deshabilitado';

  @override
  String get confirmDeleteTitle => 'Confirmar eliminación';

  @override
  String confirmDeleteContent(Object name) {
    return '¿Seguro que quieres eliminar el perfil \"$name\"?';
  }

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteSuccess => 'Eliminado correctamente';

  @override
  String get deleteFailed => 'Error al eliminar';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get generalSettings => 'General';

  @override
  String get minimizeToTray => 'Minimizar a la bandeja del sistema';

  @override
  String get minimizeToTraySubtitle =>
      'Al cerrar la ventana, minimizar a la bandeja del sistema en lugar de salir de la aplicación';

  @override
  String get backupSettings => 'Configuración de copias de seguridad';

  @override
  String get enableAutoBackup => 'Habilitar copia de seguridad automática';

  @override
  String get enableAutoBackupSubtitle =>
      'Respaldar automáticamente la configuración actual al cambiar de perfil';

  @override
  String get maxBackupCount => 'Número máximo de copias de seguridad';

  @override
  String get maxBackupCountHelper =>
      'Las copias más antiguas se eliminan automáticamente al superar este número (1-50)';

  @override
  String get enterBackupCount => 'Introduce un número de copias de seguridad';

  @override
  String get backupCountRange => 'Introduce un número entre 1 y 50';

  @override
  String get save => 'Guardar';

  @override
  String get enterMaxBackupCount =>
      'Introduce el número máximo de copias de seguridad';

  @override
  String get maxBackupCountRange =>
      'El número máximo de copias debe estar entre 1 y 50';

  @override
  String get settingsSaved => 'Configuración guardada';

  @override
  String get saveFailed => 'Error al guardar';

  @override
  String saveFailedWithError(Object error) {
    return 'Error al guardar: $error';
  }

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Seguir el sistema';

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
  String get newProfile => 'Nuevo perfil';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get configName => 'Nombre del perfil';

  @override
  String get configNameHelper => 'p. ej. Cuenta de trabajo, Cuenta personal';

  @override
  String get enterConfigName => 'Introduce un nombre de perfil';

  @override
  String get gitConfigContent => 'Contenido de la configuración Git';

  @override
  String get importExistingConfig => 'Importar configuración existente';

  @override
  String get gitconfigHelper =>
      'Pega el contenido de .gitconfig o un fragmento de configuración';

  @override
  String get enterGitConfig => 'Introduce el contenido de la configuración Git';

  @override
  String get enableSsh => 'Habilitar SSH';

  @override
  String get enableSshSubtitle =>
      'Habilitar la autenticación por clave SSH para este perfil';

  @override
  String get hostname => 'Nombre de host';

  @override
  String get hostnameHelper => 'p. ej. github.com, gitlab.com';

  @override
  String get hostnameRequired =>
      'Se requiere un nombre de host cuando SSH está habilitado';

  @override
  String get sshPort => 'Puerto SSH';

  @override
  String get sshPortHelper =>
      'Prellenado con 443; déjalo vacío para usar el puerto predeterminado de SSH (22)';

  @override
  String get portRange => 'Introduce un puerto entre 1 y 65535';

  @override
  String get sshPrivateKeyPath => 'Ruta de la clave privada SSH';

  @override
  String get privateKeyHelper => 'p. ej. ~/.ssh/id_rsa_work';

  @override
  String get privateKeyRequired =>
      'Se requiere una ruta de clave privada cuando SSH está habilitado';

  @override
  String get pickPrivateKeyTooltip => 'Elegir archivo de clave privada';

  @override
  String get importGitConfigSuccess =>
      'Configuración .gitconfig actual importada correctamente';

  @override
  String get importGitConfigFailed =>
      'No se pudo encontrar .gitconfig o falló la lectura';

  @override
  String pickFileFailed(Object error) {
    return 'Error al elegir el archivo: $error';
  }

  @override
  String get saveSuccess => 'Guardado correctamente';

  @override
  String get backupManagement => 'Gestión de copias de seguridad';

  @override
  String get restoreSelectedBackup => 'Restaurar copia seleccionada';

  @override
  String get noBackups => 'Sin copias de seguridad';

  @override
  String backupTime(Object date) {
    return 'Hora de la copia: $date';
  }

  @override
  String fileCount(Object count) {
    return '$count archivos';
  }

  @override
  String get gitConfigType => 'Configuración Git';

  @override
  String get sshConfigType => 'Configuración SSH';

  @override
  String backupPreviewTitle(Object type) {
    return 'Vista previa de la copia $type';
  }

  @override
  String get noContent => 'Sin contenido';

  @override
  String get confirmRestore => 'Confirmar restauración';

  @override
  String confirmRestoreContent(Object type) {
    return '¿Seguro que quieres restaurar la configuración $type seleccionada?\n\nEsto sobrescribirá la configuración actual.';
  }

  @override
  String get restore => 'Restaurar';

  @override
  String get restoreSuccess => 'Restauración exitosa';

  @override
  String get restoreFailed => 'Error al restaurar';

  @override
  String restoreFailedWithError(Object error) {
    return 'Error al restaurar: $error';
  }

  @override
  String loadBackupsFailed(Object error) {
    return 'Error al cargar la lista de copias: $error';
  }

  @override
  String get gitBackupDone => 'Configuración Git actual respaldada';

  @override
  String get sshBackupDone => 'Configuración SSH actual respaldada';

  @override
  String get gitConfigUpdated => 'Configuración Git actualizada';

  @override
  String get gitConfigUpdateFailed =>
      'No se pudo actualizar la configuración Git';

  @override
  String get sshConfigUpdated => 'Configuración SSH actualizada';

  @override
  String get sshConfigUpdateFailed =>
      'No se pudo actualizar la configuración SSH';

  @override
  String get configRolledBack => 'Configuración revertida';

  @override
  String get gitConfigMatches => 'La configuración Git coincide';

  @override
  String get gitConfigMismatch => 'La configuración Git no coincide';

  @override
  String get sshConfigMatches => 'La configuración SSH coincide';

  @override
  String get sshConfigMismatch => 'La configuración SSH no coincide';

  @override
  String diffUserName(Object current, Object profile) {
    return 'Git user.name: actual \"$current\" ≠ perfil \"$profile\"';
  }

  @override
  String diffUserEmail(Object current, Object profile) {
    return 'Git user.email: actual \"$current\" ≠ perfil \"$profile\"';
  }

  @override
  String diffSshHostNotFound(Object host) {
    return 'SSH: no se encontró configuración para el host \"$host\"';
  }

  @override
  String diffSshIdentityFile(Object current, Object profile) {
    return 'SSH IdentityFile: actual \"$current\" ≠ perfil \"$profile\"';
  }

  @override
  String keyFileNotExist(Object path) {
    return 'El archivo de clave privada no existe: $path';
  }

  @override
  String keyPermissionIncorrect(Object permissions) {
    return 'Los permisos de la clave privada son incorrectos, deben ser 600, actuales: $permissions';
  }

  @override
  String get keyPermissionCheckFailed =>
      'No se pudieron verificar los permisos de la clave privada';

  @override
  String get backupNothing => 'Nada que respaldar';

  @override
  String get sshNoIdentityFile =>
      'No se encontró ninguna línea IdentityFile en la configuración de SSH';

  @override
  String get verifyGitMismatch =>
      'Falló la verificación de identidad de Git: user.name o user.email no coinciden con la configuración de destino';

  @override
  String verifySshFailed(Object host) {
    return 'Falló la verificación de SSH: $host';
  }

  @override
  String get undoFailed => 'No se pudo deshacer';

  @override
  String get importSystemGit => 'Importar .gitconfig del sistema';

  @override
  String get importSystemSsh => 'Importar .ssh/config del sistema';

  @override
  String get sshConfigContent => 'Contenido de configuración SSH';

  @override
  String get sshConfigHelper =>
      'Pegue el contenido de .ssh/config (cambio de archivo completo)';

  @override
  String get enterSshConfig =>
      'Se requiere contenido de configuración cuando SSH está habilitado';

  @override
  String get quickCreateTitle => 'Creación rápida';

  @override
  String get fromTemplate => 'Desde plantilla';

  @override
  String get fromExistingProfile => 'Copiar perfil existente';

  @override
  String get generateKeyPair => 'Generar par de claves';

  @override
  String get sshPreviewTitle => 'Contenido que se escribirá en ~/.ssh/config';

  @override
  String get templateProviderTitle => 'Seleccionar proveedor';

  @override
  String get providerGithub => 'GitHub';

  @override
  String get providerGitlab => 'GitLab';

  @override
  String get providerGitee => 'Gitee';

  @override
  String get providerBlank => 'En blanco';

  @override
  String get templateModeTitle => 'Modo de conexión';

  @override
  String get modeDirect => 'Directo';

  @override
  String get modeProxy => 'Proxy';

  @override
  String get proxyAddress => 'Dirección del proxy';

  @override
  String get proxyAddressHint =>
      'Déjelo vacío para usar el predeterminado 127.0.0.1:7890';

  @override
  String get templateGenerated => 'Plantilla de configuración SSH generada';

  @override
  String get selectProfileToCopy => 'Seleccionar perfil a copiar';

  @override
  String get copyProfileSuffix => ' (copia)';

  @override
  String get confirm => 'Confirmar';

  @override
  String get importSshConfigSuccess =>
      'Configuración .ssh/config actual importada correctamente';

  @override
  String get importSshConfigFailed =>
      'No se encontró .ssh/config o no se pudo leer';

  @override
  String get onboardingWelcome => 'Bienvenido a Git Switcher';

  @override
  String get onboardingSubtitle =>
      'Administre y cambie entre múltiples identidades Git / SSH con un clic';

  @override
  String get onboardingNameHint =>
      'Nombre este perfil (p. ej., cuenta de trabajo)';

  @override
  String get onboardingImportDone =>
      'Configuración del sistema actual importada, puede modificarla antes de guardar';

  @override
  String get onboardingImport => 'Importar configuración del sistema actual';

  @override
  String get onboardingSkip => 'Omitir';

  @override
  String get onboardingFinish => 'Finalizar';

  @override
  String get overwriteSshTitle =>
      'Confirmación de sobrescritura de configuración SSH';

  @override
  String get overwriteSshContent =>
      'Está a punto de sobrescribir una configuración SSH que no es gestionada por esta herramienta. ¿Continuar?';

  @override
  String get switchVerified => 'Cambio exitoso, identidad verificada';

  @override
  String get switchWrittenNotVerified =>
      'Configuración escrita, pero la verificación falló';

  @override
  String get undoSuccess => 'Deshecho a la configuración anterior';

  @override
  String get undoNothing => 'Nada que deshacer';

  @override
  String get undoLastSwitch => 'Deshacer último cambio';

  @override
  String get keyManagementTitle => 'Gestión de claves';

  @override
  String get keyIdentifier => 'Identificador (inglés)';

  @override
  String get keyIdentifierHelper =>
      'Solo letras, números, - y _ permitidos, usados para nombres de archivo';

  @override
  String get keyIdentifierInvalid =>
      'El identificador solo permite inglés, números, - y _';

  @override
  String get keyEmail => 'Correo electrónico (opcional)';

  @override
  String get keyEmailInvalid =>
      'Formato de correo electrónico no válido, debe contener @';

  @override
  String get keyPassphrase => 'Frase de contraseña (opcional)';

  @override
  String get keyPassphraseHelper =>
      'Déjelo vacío para no tener frase de contraseña; si se establece, se requiere en cada uso';

  @override
  String get keyAlgorithmLabel => 'Algoritmo';

  @override
  String get generateKey => 'Generar par de claves';

  @override
  String get privateKeyPath => 'Ruta de la clave privada';

  @override
  String get publicKey => 'Clave pública';

  @override
  String get copyPublicKey => 'Copiar clave pública';

  @override
  String get fillIdentityFile => 'Rellenar en la configuración actual';

  @override
  String get keygenSuccess => 'Par de claves generado correctamente';

  @override
  String keygenFailed(Object message) {
    return 'Falló la generación de claves: $message';
  }

  @override
  String get keygenUnavailable =>
      'No se encontró ssh-keygen. Instale el cliente OpenSSH';

  @override
  String get keyExistsTitle => 'La clave ya existe';

  @override
  String keyExistsContent(Object path) {
    return 'La clave ya existe: $path\n¿Sobrescribir?';
  }

  @override
  String get passphraseReminder =>
      'Frase de contraseña establecida; se requerirá en cada uso';

  @override
  String get fillIdentityFileDone => 'Línea IdentityFile rellenada';

  @override
  String get publicKeyCopied => 'Clave pública copiada al portapapeles';

  @override
  String get keygenDetecting => 'Comprobando disponibilidad de ssh-keygen…';

  @override
  String keygenDetectedAt(Object path) {
    return 'ssh-keygen detectado: $path';
  }

  @override
  String get keygenNotFound =>
      'No se encontró ssh-keygen. Instale el cliente OpenSSH o especifique una ruta';

  @override
  String get keygenPathLabel => 'Ruta personalizada de ssh-keygen';

  @override
  String get keygenPathHint =>
      'Dejar vacío para detección automática (PATH / ubicaciones comunes)';

  @override
  String get keygenVerifyBtn => 'Verificar';

  @override
  String get keygenResetBtn => 'Restablecer detección automática';

  @override
  String get keygenBrowseBtn => 'Examinar';

  @override
  String keygenPathValid(Object path) {
    return 'Ruta válida de ssh-keygen: $path';
  }

  @override
  String keygenPathInvalid(Object path) {
    return 'Ruta no válida de ssh-keygen: $path';
  }

  @override
  String get logSettings => 'Configuración de registro';

  @override
  String get logSettingsSubtitle =>
      'Nivel de registro y ubicación de almacenamiento';

  @override
  String get logLevel => 'Nivel de registro';

  @override
  String get logLevelTrace => 'TRACE (más detallado)';

  @override
  String get logLevelDebug => 'DEBUG (depuración)';

  @override
  String get logLevelInfo => 'INFO (predeterminado)';

  @override
  String get logLevelWarn => 'WARN (advertencias)';

  @override
  String get logLevelError => 'ERROR (solo errores)';

  @override
  String get logFileLocation => 'Directorio de registro';

  @override
  String get onboardingDemoButton => 'Probar perfiles de ejemplo';

  @override
  String get onboardingDemoHint =>
      'No se requiere cuenta: importe dos perfiles de ejemplo para probar todas las funciones sin registrarse';

  @override
  String get onboardingDemoDone =>
      'Perfiles de ejemplo importados — haga clic en Finalizar para comenzar';

  @override
  String get demoProfileWorkName => 'Cuenta de trabajo (ejemplo)';

  @override
  String get demoProfilePersonalName => 'Cuenta personal (ejemplo)';
}
