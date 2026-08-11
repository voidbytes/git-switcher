// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Alternador de contas Git';

  @override
  String get trayShowWindow => 'Mostrar janela principal';

  @override
  String get trayAbout => 'Sobre';

  @override
  String get trayExit => 'Sair';

  @override
  String get aboutTitle => 'Sobre o Git Switcher';

  @override
  String get aboutAuthor => 'Autor: voidbytes';

  @override
  String get aboutAuthorHomepage => 'Página do autor:';

  @override
  String get aboutProjectUrl => 'URL do projeto:';

  @override
  String get close => 'Fechar';

  @override
  String switchFailedWithError(Object error) {
    return 'Falha ao alternar: $error';
  }

  @override
  String get sshConfigConflictTitle => 'Conflito de configuração SSH';

  @override
  String sshConfigConflictContent(
    Object conflictPath,
    Object host,
    Object identityFile,
  ) {
    return 'O caminho da chave privada SSH atualmente configurado para o host \"$host\" é:\n\n$conflictPath\n\nVocê deseja alterá-lo para:\n\n$identityFile\n\nContinuar?';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get continueSwitch => 'Continuar a alternância';

  @override
  String get switchSuccess => 'Alternância bem-sucedida';

  @override
  String switchFailedWithMessages(Object messages) {
    return 'Falha ao alternar\n$messages';
  }

  @override
  String get refreshTooltip => 'Atualizar o estado da configuração';

  @override
  String activeProfileTitle(Object name) {
    return 'Atualmente ativo: $name';
  }

  @override
  String get activeProfileSubtitle =>
      'A configuração do sistema corresponde ao perfil selecionado';

  @override
  String get configMismatchTitle => 'Inconsistência de configuração';

  @override
  String get configMismatchSubtitle =>
      'A configuração atual do sistema não corresponde a nenhum perfil deste aplicativo. Considere fazer backup da configuração atual e revisar as diferenças.';

  @override
  String get backupCurrentConfig => 'Fazer backup da configuração atual';

  @override
  String get viewDiff => 'Ver diferenças';

  @override
  String get noConfigsToCompare => 'Nenhum perfil para comparar';

  @override
  String get viewConfigDiffTitle => 'Ver diferenças de configuração';

  @override
  String get configMatches => 'Corresponde à configuração atual';

  @override
  String profileDiffTitle(Object name) {
    return 'Diferenças de configuração de $name';
  }

  @override
  String get configMatchesFull =>
      'Este perfil corresponde à configuração atual';

  @override
  String get noTargetConfig => '(sem configuração de destino)';

  @override
  String get diffItems => 'Diferenças:';

  @override
  String get currentConfigTab => 'Configuração atual';

  @override
  String get targetConfigTab => 'Configuração de destino';

  @override
  String get noCurrentGitConfig => '(sem configuração Git atual)';

  @override
  String get noProfiles => 'Sem perfis';

  @override
  String get clickToCreateProfile =>
      'Clique no botão no canto inferior direito para criar seu primeiro perfil';

  @override
  String platformLabel(Object host) {
    return 'Plataforma: $host';
  }

  @override
  String get sshEnabledStatus => 'SSH: habilitado';

  @override
  String get sshDisabledStatus => 'SSH: desabilitado';

  @override
  String get confirmDeleteTitle => 'Confirmar exclusão';

  @override
  String confirmDeleteContent(Object name) {
    return 'Tem certeza de que deseja excluir o perfil \"$name\"?';
  }

  @override
  String get delete => 'Excluir';

  @override
  String get deleteSuccess => 'Excluído com sucesso';

  @override
  String get deleteFailed => 'Falha ao excluir';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get generalSettings => 'Geral';

  @override
  String get minimizeToTray => 'Minimizar para a bandeja do sistema';

  @override
  String get minimizeToTraySubtitle =>
      'Ao fechar a janela, minimizar para a bandeja do sistema em vez de sair do aplicativo';

  @override
  String get backupSettings => 'Configurações de backup';

  @override
  String get enableAutoBackup => 'Habilitar backup automático';

  @override
  String get enableAutoBackupSubtitle =>
      'Fazer backup automaticamente da configuração atual ao alternar de perfil';

  @override
  String get maxBackupCount => 'Número máximo de backups';

  @override
  String get maxBackupCountHelper =>
      'Os backups mais antigos são excluídos automaticamente quando este número é excedido (1-50)';

  @override
  String get enterBackupCount => 'Digite um número de backups';

  @override
  String get backupCountRange => 'Digite um número entre 1 e 50';

  @override
  String get save => 'Salvar';

  @override
  String get enterMaxBackupCount => 'Digite o número máximo de backups';

  @override
  String get maxBackupCountRange =>
      'O número máximo de backups deve estar entre 1 e 50';

  @override
  String get settingsSaved => 'Configurações salvas';

  @override
  String get saveFailed => 'Falha ao salvar';

  @override
  String saveFailedWithError(Object error) {
    return 'Falha ao salvar: $error';
  }

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Seguir o sistema';

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
  String get newProfile => 'Novo perfil';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get configName => 'Nome do perfil';

  @override
  String get configNameHelper => 'ex.: Conta de trabalho, Conta pessoal';

  @override
  String get enterConfigName => 'Digite um nome de perfil';

  @override
  String get gitConfigContent => 'Conteúdo da configuração Git';

  @override
  String get importExistingConfig => 'Importar configuração existente';

  @override
  String get gitconfigHelper =>
      'Cole o conteúdo de .gitconfig ou um trecho de configuração';

  @override
  String get enterGitConfig => 'Digite o conteúdo da configuração Git';

  @override
  String get enableSsh => 'Habilitar SSH';

  @override
  String get enableSshSubtitle =>
      'Habilitar autenticação por chave SSH para este perfil';

  @override
  String get hostname => 'Nome do host';

  @override
  String get hostnameHelper => 'ex.: github.com, gitlab.com';

  @override
  String get hostnameRequired =>
      'Um nome de host é obrigatório quando o SSH está habilitado';

  @override
  String get sshPort => 'Porta SSH';

  @override
  String get sshPortHelper =>
      'Pré-preenchido com 443; deixe vazio para usar a porta padrão do SSH (22)';

  @override
  String get portRange => 'Digite uma porta entre 1 e 65535';

  @override
  String get sshPrivateKeyPath => 'Caminho da chave privada SSH';

  @override
  String get privateKeyHelper => 'ex.: ~/.ssh/id_rsa_work';

  @override
  String get privateKeyRequired =>
      'Um caminho de chave privada é obrigatório quando o SSH está habilitado';

  @override
  String get pickPrivateKeyTooltip => 'Escolher arquivo de chave privada';

  @override
  String get importGitConfigSuccess =>
      'Configuração .gitconfig atual importada com sucesso';

  @override
  String get importGitConfigFailed =>
      'Não foi possível encontrar .gitconfig ou falha na leitura';

  @override
  String pickFileFailed(Object error) {
    return 'Falha ao escolher o arquivo: $error';
  }

  @override
  String get saveSuccess => 'Salvo com sucesso';

  @override
  String get backupManagement => 'Gerenciamento de backups';

  @override
  String get restoreSelectedBackup => 'Restaurar backup selecionado';

  @override
  String get noBackups => 'Sem backups';

  @override
  String backupTime(Object date) {
    return 'Hora do backup: $date';
  }

  @override
  String fileCount(Object count) {
    return '$count arquivos';
  }

  @override
  String get gitConfigType => 'Configuração Git';

  @override
  String get sshConfigType => 'Configuração SSH';

  @override
  String backupPreviewTitle(Object type) {
    return 'Pré-visualização do backup $type';
  }

  @override
  String get noContent => 'Sem conteúdo';

  @override
  String get confirmRestore => 'Confirmar restauração';

  @override
  String confirmRestoreContent(Object type) {
    return 'Tem certeza de que deseja restaurar a configuração $type selecionada?\n\nIsso sobrescreverá a configuração atual.';
  }

  @override
  String get restore => 'Restaurar';

  @override
  String get restoreSuccess => 'Restauração bem-sucedida';

  @override
  String get restoreFailed => 'Falha ao restaurar';

  @override
  String restoreFailedWithError(Object error) {
    return 'Falha ao restaurar: $error';
  }

  @override
  String loadBackupsFailed(Object error) {
    return 'Falha ao carregar a lista de backups: $error';
  }

  @override
  String get gitBackupDone => 'Configuração Git atual com backup feito';

  @override
  String get sshBackupDone => 'Configuração SSH atual com backup feito';

  @override
  String get gitConfigUpdated => 'Configuração Git atualizada';

  @override
  String get gitConfigUpdateFailed => 'Falha ao atualizar a configuração Git';

  @override
  String get sshConfigUpdated => 'Configuração SSH atualizada';

  @override
  String get sshConfigUpdateFailed => 'Falha ao atualizar a configuração SSH';

  @override
  String get configRolledBack => 'Configuração revertida';

  @override
  String get gitConfigMatches => 'A configuração Git corresponde';

  @override
  String get gitConfigMismatch => 'A configuração Git não corresponde';

  @override
  String get sshConfigMatches => 'A configuração SSH corresponde';

  @override
  String get sshConfigMismatch => 'A configuração SSH não corresponde';

  @override
  String diffUserName(Object current, Object profile) {
    return 'Git user.name: atual \"$current\" ≠ perfil \"$profile\"';
  }

  @override
  String diffUserEmail(Object current, Object profile) {
    return 'Git user.email: atual \"$current\" ≠ perfil \"$profile\"';
  }

  @override
  String diffSshHostNotFound(Object host) {
    return 'SSH: nenhuma configuração encontrada para o host \"$host\"';
  }

  @override
  String diffSshIdentityFile(Object current, Object profile) {
    return 'SSH IdentityFile: atual \"$current\" ≠ perfil \"$profile\"';
  }

  @override
  String keyFileNotExist(Object path) {
    return 'O arquivo de chave privada não existe: $path';
  }

  @override
  String keyPermissionIncorrect(Object permissions) {
    return 'As permissões da chave privada estão incorretas, devem ser 600, atuais: $permissions';
  }

  @override
  String get keyPermissionCheckFailed =>
      'Não foi possível verificar as permissões da chave privada';

  @override
  String get backupNothing => 'Nada para fazer backup';
}
