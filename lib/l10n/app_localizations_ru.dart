// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Переключатель аккаунтов Git';

  @override
  String get trayShowWindow => 'Показать главное окно';

  @override
  String get trayAbout => 'О программе';

  @override
  String get trayExit => 'Выход';

  @override
  String get aboutTitle => 'О Git Switcher';

  @override
  String get aboutAuthor => 'Автор: voidbytes';

  @override
  String get aboutAuthorHomepage => 'Домашняя страница автора:';

  @override
  String get aboutProjectUrl => 'URL проекта:';

  @override
  String get close => 'Закрыть';

  @override
  String switchFailedWithError(Object error) {
    return 'Переключение не удалось: $error';
  }

  @override
  String get sshConfigConflictTitle => 'Конфликт конфигурации SSH';

  @override
  String sshConfigConflictContent(
    Object conflictPath,
    Object host,
    Object identityFile,
  ) {
    return 'Текущий путь к приватному ключу SSH для хоста \"$host\" в системе:\n\n$conflictPath\n\nВы хотите изменить его на:\n\n$identityFile\n\nПродолжить?';
  }

  @override
  String get cancel => 'Отмена';

  @override
  String get continueSwitch => 'Продолжить переключение';

  @override
  String get switchSuccess => 'Переключение успешно';

  @override
  String switchFailedWithMessages(Object messages) {
    return 'Переключение не удалось\n$messages';
  }

  @override
  String get refreshTooltip => 'Обновить состояние конфигурации';

  @override
  String activeProfileTitle(Object name) {
    return 'Активен: $name';
  }

  @override
  String get activeProfileSubtitle =>
      'Системная конфигурация соответствует выбранному профилю';

  @override
  String get configMismatchTitle => 'Несоответствие конфигурации';

  @override
  String get configMismatchSubtitle =>
      'Текущая системная конфигурация не соответствует ни одному профилю в этом приложении. Рекомендуется создать резервную копию и просмотреть различия.';

  @override
  String get backupCurrentConfig =>
      'Создать резервную копию текущей конфигурации';

  @override
  String get viewDiff => 'Показать различия';

  @override
  String get noConfigsToCompare => 'Нет профилей для сравнения';

  @override
  String get viewConfigDiffTitle => 'Просмотр различий конфигурации';

  @override
  String get configMatches => 'Соответствует текущей конфигурации';

  @override
  String profileDiffTitle(Object name) {
    return 'Различия конфигурации $name';
  }

  @override
  String get configMatchesFull =>
      'Этот профиль соответствует текущей конфигурации';

  @override
  String get noTargetConfig => '(нет целевой конфигурации)';

  @override
  String get diffItems => 'Различия:';

  @override
  String get currentConfigTab => 'Текущая конфигурация';

  @override
  String get targetConfigTab => 'Целевая конфигурация';

  @override
  String get noCurrentGitConfig => '(нет текущей конфигурации Git)';

  @override
  String get noProfiles => 'Нет профилей';

  @override
  String get clickToCreateProfile =>
      'Нажмите кнопку в правом нижнем углу, чтобы создать первый профиль';

  @override
  String platformLabel(Object host) {
    return 'Платформа: $host';
  }

  @override
  String get sshEnabledStatus => 'SSH: включено';

  @override
  String get sshDisabledStatus => 'SSH: выключено';

  @override
  String get confirmDeleteTitle => 'Подтверждение удаления';

  @override
  String confirmDeleteContent(Object name) {
    return 'Вы уверены, что хотите удалить профиль \"$name\"?';
  }

  @override
  String get delete => 'Удалить';

  @override
  String get deleteSuccess => 'Удаление успешно';

  @override
  String get deleteFailed => 'Не удалось удалить';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get generalSettings => 'Общие';

  @override
  String get minimizeToTray => 'Сворачивать в трей';

  @override
  String get minimizeToTraySubtitle =>
      'При закрытии окна сворачивать в системный трей вместо выхода из приложения';

  @override
  String get backupSettings => 'Настройки резервного копирования';

  @override
  String get enableAutoBackup =>
      'Включить автоматическое резервное копирование';

  @override
  String get enableAutoBackupSubtitle =>
      'Автоматически создавать резервную копию текущей конфигурации при переключении профиля';

  @override
  String get maxBackupCount => 'Максимальное количество резервных копий';

  @override
  String get maxBackupCountHelper =>
      'При превышении этого числа старые копии удаляются автоматически (1-50)';

  @override
  String get enterBackupCount => 'Введите количество резервных копий';

  @override
  String get backupCountRange => 'Введите число от 1 до 50';

  @override
  String get save => 'Сохранить';

  @override
  String get enterMaxBackupCount =>
      'Введите максимальное количество резервных копий';

  @override
  String get maxBackupCountRange =>
      'Максимальное количество резервных копий должно быть от 1 до 50';

  @override
  String get settingsSaved => 'Настройки сохранены';

  @override
  String get saveFailed => 'Не удалось сохранить';

  @override
  String saveFailedWithError(Object error) {
    return 'Не удалось сохранить: $error';
  }

  @override
  String get language => 'Язык';

  @override
  String get languageSystem => 'Следовать за системой';

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
  String get newProfile => 'Новый профиль';

  @override
  String get editProfile => 'Изменить профиль';

  @override
  String get configName => 'Имя профиля';

  @override
  String get configNameHelper => 'например: Рабочий аккаунт, Личный аккаунт';

  @override
  String get enterConfigName => 'Введите имя профиля';

  @override
  String get gitConfigContent => 'Содержимое конфигурации Git';

  @override
  String get importExistingConfig => 'Импортировать существующую конфигурацию';

  @override
  String get gitconfigHelper =>
      'Вставьте содержимое .gitconfig или фрагмент конфигурации';

  @override
  String get enterGitConfig => 'Введите содержимое конфигурации Git';

  @override
  String get enableSsh => 'Включить SSH';

  @override
  String get enableSshSubtitle =>
      'Включить аутентификацию по ключу SSH для этого профиля';

  @override
  String get hostname => 'Имя хоста';

  @override
  String get hostnameHelper => 'например: github.com, gitlab.com';

  @override
  String get hostnameRequired => 'Имя хоста обязательно, если SSH включен';

  @override
  String get sshPort => 'Порт SSH';

  @override
  String get sshPortHelper =>
      'Предзаполнено 443; оставьте пустым, чтобы использовать порт SSH по умолчанию 22';

  @override
  String get portRange => 'Введите порт от 1 до 65535';

  @override
  String get sshPrivateKeyPath => 'Путь к приватному ключу SSH';

  @override
  String get privateKeyHelper => 'например: ~/.ssh/id_rsa_work';

  @override
  String get privateKeyRequired =>
      'Путь к приватному ключу обязателен, если SSH включен';

  @override
  String get pickPrivateKeyTooltip => 'Выбрать файл приватного ключа';

  @override
  String get importGitConfigSuccess =>
      'Текущая конфигурация .gitconfig успешно импортирована';

  @override
  String get importGitConfigFailed =>
      'Не удалось найти .gitconfig или прочитать его';

  @override
  String pickFileFailed(Object error) {
    return 'Не удалось выбрать файл: $error';
  }

  @override
  String get saveSuccess => 'Сохранено успешно';

  @override
  String get backupManagement => 'Управление резервными копиями';

  @override
  String get restoreSelectedBackup => 'Восстановить выбранную копию';

  @override
  String get noBackups => 'Нет резервных копий';

  @override
  String backupTime(Object date) {
    return 'Время копии: $date';
  }

  @override
  String fileCount(Object count) {
    return '$count файлов';
  }

  @override
  String get gitConfigType => 'Конфигурация Git';

  @override
  String get sshConfigType => 'Конфигурация SSH';

  @override
  String backupPreviewTitle(Object type) {
    return 'Просмотр копии $type';
  }

  @override
  String get noContent => 'Нет содержимого';

  @override
  String get confirmRestore => 'Подтверждение восстановления';

  @override
  String confirmRestoreContent(Object type) {
    return 'Вы уверены, что хотите восстановить выбранную конфигурацию $type?\n\nЭто перезапишет текущую конфигурацию.';
  }

  @override
  String get restore => 'Восстановить';

  @override
  String get restoreSuccess => 'Восстановление успешно';

  @override
  String get restoreFailed => 'Не удалось восстановить';

  @override
  String restoreFailedWithError(Object error) {
    return 'Не удалось восстановить: $error';
  }

  @override
  String loadBackupsFailed(Object error) {
    return 'Не удалось загрузить список копий: $error';
  }

  @override
  String get gitBackupDone => 'Текущая конфигурация Git сохранена';

  @override
  String get sshBackupDone => 'Текущая конфигурация SSH сохранена';

  @override
  String get gitConfigUpdated => 'Конфигурация Git обновлена';

  @override
  String get gitConfigUpdateFailed => 'Не удалось обновить конфигурацию Git';

  @override
  String get sshConfigUpdated => 'Конфигурация SSH обновлена';

  @override
  String get sshConfigUpdateFailed => 'Не удалось обновить конфигурацию SSH';

  @override
  String get configRolledBack => 'Конфигурация откатена';

  @override
  String get gitConfigMatches => 'Конфигурация Git совпадает';

  @override
  String get gitConfigMismatch => 'Конфигурация Git не совпадает';

  @override
  String get sshConfigMatches => 'Конфигурация SSH совпадает';

  @override
  String get sshConfigMismatch => 'Конфигурация SSH не совпадает';

  @override
  String diffUserName(Object current, Object profile) {
    return 'Git user.name: текущее \"$current\" ≠ профиль \"$profile\"';
  }

  @override
  String diffUserEmail(Object current, Object profile) {
    return 'Git user.email: текущее \"$current\" ≠ профиль \"$profile\"';
  }

  @override
  String diffSshHostNotFound(Object host) {
    return 'SSH: конфигурация для хоста \"$host\" не найдена';
  }

  @override
  String diffSshIdentityFile(Object current, Object profile) {
    return 'SSH IdentityFile: текущее \"$current\" ≠ профиль \"$profile\"';
  }

  @override
  String keyFileNotExist(Object path) {
    return 'Файл приватного ключа не существует: $path';
  }

  @override
  String keyPermissionIncorrect(Object permissions) {
    return 'Права на приватный ключ неверны, должно быть 600, сейчас $permissions';
  }

  @override
  String get keyPermissionCheckFailed =>
      'Не удалось проверить права на приватный ключ';

  @override
  String get backupNothing => 'Нечего создавать резервную копию';

  @override
  String get sshNoIdentityFile =>
      'Строка IdentityFile не найдена в конфигурации SSH';

  @override
  String get verifyGitMismatch =>
      'Не удалось проверить личность Git: user.name или user.email не соответствуют целевой конфигурации';

  @override
  String verifySshFailed(Object host) {
    return 'Не удалось проверить SSH: $host';
  }

  @override
  String get undoFailed => 'Не удалось отменить';

  @override
  String get importSystemGit => 'Импортировать системный .gitconfig';

  @override
  String get importSystemSsh => 'Импортировать системный .ssh/config';

  @override
  String get sshConfigContent => 'Содержимое конфигурации SSH';

  @override
  String get sshConfigHelper =>
      'Вставьте содержимое .ssh/config (переключение всего файла)';

  @override
  String get enterSshConfig =>
      'Содержимое конфигурации обязательно, если SSH включен';

  @override
  String get quickCreateTitle => 'Быстрое создание';

  @override
  String get fromTemplate => 'Из шаблона';

  @override
  String get fromExistingProfile => 'Копировать существующий профиль';

  @override
  String get generateKeyPair => 'Создать пару ключей';

  @override
  String get sshPreviewTitle =>
      'Содержимое, которое будет записано в ~/.ssh/config';

  @override
  String get templateProviderTitle => 'Выберите провайдера';

  @override
  String get providerGithub => 'GitHub';

  @override
  String get providerGitlab => 'GitLab';

  @override
  String get providerGitee => 'Gitee';

  @override
  String get providerBlank => 'Пусто';

  @override
  String get templateModeTitle => 'Режим подключения';

  @override
  String get modeDirect => 'Прямое';

  @override
  String get modeProxy => 'Прокси';

  @override
  String get proxyAddress => 'Адрес прокси';

  @override
  String get proxyAddressHint =>
      'Оставьте пустым, чтобы использовать по умолчанию 127.0.0.1:7890';

  @override
  String get templateGenerated => 'Шаблон конфигурации SSH создан';

  @override
  String get selectProfileToCopy => 'Выберите профиль для копирования';

  @override
  String get copyProfileSuffix => ' (копия)';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get importSshConfigSuccess =>
      'Текущая конфигурация .ssh/config успешно импортирована';

  @override
  String get importSshConfigFailed =>
      '.ssh/config не найден или не может быть прочитан';

  @override
  String get onboardingWelcome => 'Добро пожаловать в Git Switcher';

  @override
  String get onboardingSubtitle =>
      'Управляйте и переключайтесь между несколькими личностями Git / SSH в один клик';

  @override
  String get onboardingNameHint =>
      'Назовите этот профиль (например, рабочая учетная запись)';

  @override
  String get onboardingImportDone =>
      'Текущая системная конфигурация импортирована, вы можете изменить ее перед сохранением';

  @override
  String get onboardingImport => 'Импортировать текущую системную конфигурацию';

  @override
  String get onboardingSkip => 'Пропустить';

  @override
  String get onboardingFinish => 'Готово';

  @override
  String get overwriteSshTitle => 'Подтверждение перезаписи конфигурации SSH';

  @override
  String get overwriteSshContent =>
      'Вы собираетесь перезаписать конфигурацию SSH, не управляемую этим инструментом. Продолжить?';

  @override
  String get switchVerified => 'Переключение успешно, личность проверена';

  @override
  String get switchWrittenNotVerified =>
      'Конфигурация записана, но проверка не удалась';

  @override
  String get undoSuccess => 'Возвращено к предыдущей конфигурации';

  @override
  String get undoNothing => 'Нечего отменять';

  @override
  String get undoLastSwitch => 'Отменить последнее переключение';

  @override
  String get keyManagementTitle => 'Управление ключами';

  @override
  String get keyIdentifier => 'Идентификатор (англ.)';

  @override
  String get keyIdentifierHelper =>
      'Разрешены только буквы, цифры, - и _, используются для имен файлов';

  @override
  String get keyIdentifierInvalid =>
      'Идентификатор допускает только английские буквы, цифры, - и _';

  @override
  String get keyEmail => 'Эл. почта (необязательно)';

  @override
  String get keyEmailInvalid => 'Неверный формат эл. почты, должен содержать @';

  @override
  String get keyPassphrase => 'Парольная фраза (необязательно)';

  @override
  String get keyPassphraseHelper =>
      'Оставьте пустым, чтобы не использовать парольную фразу; если задана, требуется при каждом использовании';

  @override
  String get keyAlgorithmLabel => 'Алгоритм';

  @override
  String get generateKey => 'Создать пару ключей';

  @override
  String get privateKeyPath => 'Путь к приватному ключу';

  @override
  String get publicKey => 'Публичный ключ';

  @override
  String get copyPublicKey => 'Скопировать публичный ключ';

  @override
  String get fillIdentityFile => 'Заполнить в текущей конфигурации';

  @override
  String get keygenSuccess => 'Пара ключей успешно создана';

  @override
  String keygenFailed(Object message) {
    return 'Не удалось создать ключи: $message';
  }

  @override
  String get keygenUnavailable =>
      'ssh-keygen не найден. Установите клиент OpenSSH';

  @override
  String get keyExistsTitle => 'Ключ уже существует';

  @override
  String keyExistsContent(Object path) {
    return 'Ключ уже существует: $path\nПерезаписать?';
  }

  @override
  String get passphraseReminder =>
      'Парольная фраза задана; она будет требоваться при каждом использовании';

  @override
  String get fillIdentityFileDone => 'Строка IdentityFile заполнена';

  @override
  String get publicKeyCopied => 'Публичный ключ скопирован в буфер обмена';

  @override
  String get keygenDetecting => 'Проверка доступности ssh-keygen…';

  @override
  String keygenDetectedAt(Object path) {
    return 'ssh-keygen обнаружен: $path';
  }

  @override
  String get keygenNotFound =>
      'ssh-keygen не найден. Установите клиент OpenSSH или укажите путь';

  @override
  String get keygenPathLabel => 'Пользовательский путь ssh-keygen';

  @override
  String get keygenPathHint =>
      'Оставьте пустым для автоматического обнаружения (PATH / стандартные места установки)';

  @override
  String get keygenVerifyBtn => 'Проверить';

  @override
  String get keygenResetBtn => 'Сбросить автоопределение';

  @override
  String get keygenBrowseBtn => 'Обзор';

  @override
  String keygenPathValid(Object path) {
    return 'Действительный путь ssh-keygen: $path';
  }

  @override
  String keygenPathInvalid(Object path) {
    return 'Недопустимый путь ssh-keygen: $path';
  }

  @override
  String get logSettings => 'Настройки журнала';

  @override
  String get logSettingsSubtitle => 'Уровень журнала и место хранения';

  @override
  String get logLevel => 'Уровень журнала';

  @override
  String get logLevelTrace => 'TRACE (самый подробный)';

  @override
  String get logLevelDebug => 'DEBUG (отладка)';

  @override
  String get logLevelInfo => 'INFO (по умолчанию)';

  @override
  String get logLevelWarn => 'WARN (предупреждения)';

  @override
  String get logLevelError => 'ERROR (только ошибки)';

  @override
  String get logFileLocation => 'Каталог журнала';

  @override
  String get onboardingDemoButton => 'Попробовать примеры профилей';

  @override
  String get onboardingDemoHint =>
      'Учётная запись не требуется — импортируйте два примера профилей, чтобы попробовать все функции без регистрации';

  @override
  String get onboardingDemoDone =>
      'Примеры профилей импортированы — нажмите «Готово», чтобы начать';

  @override
  String get demoProfileWorkName => 'Рабочая учётная запись (пример)';

  @override
  String get demoProfilePersonalName => 'Личная учётная запись (пример)';
}
