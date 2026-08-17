// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Git 계정 전환기';

  @override
  String get trayShowWindow => '기본 창 표시';

  @override
  String get trayAbout => '정보';

  @override
  String get trayExit => '종료';

  @override
  String get aboutTitle => 'Git Switcher 정보';

  @override
  String get aboutAuthor => '저자: voidbytes';

  @override
  String get aboutAuthorHomepage => '작성자 홈페이지:';

  @override
  String get aboutProjectUrl => '프로젝트 URL:';

  @override
  String get close => '닫기';

  @override
  String switchFailedWithError(Object error) {
    return '전환 실패: $error';
  }

  @override
  String get sshConfigConflictTitle => 'SSH 설정 충돌';

  @override
  String sshConfigConflictContent(
    Object conflictPath,
    Object host,
    Object identityFile,
  ) {
    return '호스트 \"$host\"에 대해 현재 시스템에 설정된 SSH 개인 키 경로는:\n\n$conflictPath\n\n다음으로 변경하려고 합니다:\n\n$identityFile\n\n계속하시겠습니까?';
  }

  @override
  String get cancel => '취소';

  @override
  String get continueSwitch => '전환 계속';

  @override
  String get switchSuccess => '전환 성공';

  @override
  String switchFailedWithMessages(Object messages) {
    return '전환 실패\n$messages';
  }

  @override
  String get refreshTooltip => '현재 설정 상태 새로 고침';

  @override
  String activeProfileTitle(Object name) {
    return '현재 활성: $name';
  }

  @override
  String get activeProfileSubtitle => '시스템 구성이 선택한 프로필과 일치합니다';

  @override
  String get configMismatchTitle => '구성 불일치 알림';

  @override
  String get configMismatchSubtitle =>
      '현재 시스템 구성이 이 앱의 어떤 프로필과도 일치하지 않습니다. 현재 구성을 백업하고 차이점을 확인하는 것이 좋습니다.';

  @override
  String get backupCurrentConfig => '현재 구성 백업';

  @override
  String get viewDiff => '차이점 보기';

  @override
  String get noConfigsToCompare => '비교할 프로필이 없습니다';

  @override
  String get viewConfigDiffTitle => '구성 차이점 보기';

  @override
  String get configMatches => '현재 구성과 일치';

  @override
  String profileDiffTitle(Object name) {
    return '$name 구성 차이점';
  }

  @override
  String get configMatchesFull => '이 프로필은 현재 구성과 일치합니다';

  @override
  String get noTargetConfig => '(대상 구성 없음)';

  @override
  String get diffItems => '차이 항목:';

  @override
  String get currentConfigTab => '현재 구성';

  @override
  String get targetConfigTab => '대상 구성';

  @override
  String get noCurrentGitConfig => '(현재 Git 구성 없음)';

  @override
  String get noProfiles => '프로필이 없습니다';

  @override
  String get clickToCreateProfile => '오른쪽 아래 버튼을 클릭하여 첫 번째 프로필을 만드세요';

  @override
  String platformLabel(Object host) {
    return '플랫폼: $host';
  }

  @override
  String get sshEnabledStatus => 'SSH: 사용';

  @override
  String get sshDisabledStatus => 'SSH: 사용 안 함';

  @override
  String get confirmDeleteTitle => '삭제 확인';

  @override
  String confirmDeleteContent(Object name) {
    return '프로필 \"$name\"을(를) 삭제하시겠습니까?';
  }

  @override
  String get delete => '삭제';

  @override
  String get deleteSuccess => '삭제 성공';

  @override
  String get deleteFailed => '삭제 실패';

  @override
  String get settingsTitle => '설정';

  @override
  String get generalSettings => '일반';

  @override
  String get minimizeToTray => '시스템 트레이로 최소화';

  @override
  String get minimizeToTraySubtitle => '창을 닫을 때 앱을 종료하지 않고 시스템 트레이로 최소화합니다';

  @override
  String get backupSettings => '백업 설정';

  @override
  String get enableAutoBackup => '자동 백업 사용';

  @override
  String get enableAutoBackupSubtitle => '프로필을 전환할 때 현재 구성을 자동으로 백업합니다';

  @override
  String get maxBackupCount => '최대 백업 수';

  @override
  String get maxBackupCountHelper => '이 수를 초과하면 가장 오래된 백업이 자동으로 삭제됩니다 (1-50)';

  @override
  String get enterBackupCount => '백업 수를 입력하세요';

  @override
  String get backupCountRange => '1과 50 사이의 숫자를 입력하세요';

  @override
  String get save => '저장';

  @override
  String get enterMaxBackupCount => '최대 백업 수를 입력하세요';

  @override
  String get maxBackupCountRange => '최대 백업 수는 1과 50 사이여야 합니다';

  @override
  String get settingsSaved => '설정이 저장되었습니다';

  @override
  String get saveFailed => '저장 실패';

  @override
  String saveFailedWithError(Object error) {
    return '저장 실패: $error';
  }

  @override
  String get language => '언어';

  @override
  String get languageSystem => '시스템 따르기';

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
  String get newProfile => '새 프로필';

  @override
  String get editProfile => '프로필 편집';

  @override
  String get configName => '프로필 이름';

  @override
  String get configNameHelper => '예: 업무 계정, 개인 계정';

  @override
  String get enterConfigName => '프로필 이름을 입력하세요';

  @override
  String get gitConfigContent => 'Git 구성 내용';

  @override
  String get importExistingConfig => '기존 구성 가져오기';

  @override
  String get gitconfigHelper => '.gitconfig 내용 또는 구성 조각을 붙여넣으세요';

  @override
  String get enterGitConfig => 'Git 구성 내용을 입력하세요';

  @override
  String get enableSsh => 'SSH 사용';

  @override
  String get enableSshSubtitle => '이 프로필에 SSH 키 인증을 사용합니다';

  @override
  String get hostname => '호스트 이름';

  @override
  String get hostnameHelper => '예: github.com, gitlab.com';

  @override
  String get hostnameRequired => 'SSH를 사용하면 호스트 이름이 필요합니다';

  @override
  String get sshPort => 'SSH 포트';

  @override
  String get sshPortHelper => '443으로 미리 채워집니다. 비워 두면 SSH 기본 포트 22를 사용합니다';

  @override
  String get portRange => '1과 65535 사이의 포트 번호를 입력하세요';

  @override
  String get sshPrivateKeyPath => 'SSH 개인 키 경로';

  @override
  String get privateKeyHelper => '예: ~/.ssh/id_rsa_work';

  @override
  String get privateKeyRequired => 'SSH를 사용하면 개인 키 경로가 필요합니다';

  @override
  String get pickPrivateKeyTooltip => '개인 키 파일 선택';

  @override
  String get importGitConfigSuccess => '현재 .gitconfig를 가져왔습니다';

  @override
  String get importGitConfigFailed => '.gitconfig를 찾을 수 없거나 읽기에 실패했습니다';

  @override
  String pickFileFailed(Object error) {
    return '파일 선택 실패: $error';
  }

  @override
  String get saveSuccess => '저장 성공';

  @override
  String get backupManagement => '백업 관리';

  @override
  String get restoreSelectedBackup => '선택한 백업 복원';

  @override
  String get noBackups => '백업이 없습니다';

  @override
  String backupTime(Object date) {
    return '백업 시간: $date';
  }

  @override
  String fileCount(Object count) {
    return '$count개 파일';
  }

  @override
  String get gitConfigType => 'Git 구성';

  @override
  String get sshConfigType => 'SSH 구성';

  @override
  String backupPreviewTitle(Object type) {
    return '$type 백업 미리보기';
  }

  @override
  String get noContent => '내용 없음';

  @override
  String get confirmRestore => '복원 확인';

  @override
  String confirmRestoreContent(Object type) {
    return '선택한 $type 구성을 복원하시겠습니까?\n\n현재 구성을 덮어씁니다.';
  }

  @override
  String get restore => '복원';

  @override
  String get restoreSuccess => '복원 성공';

  @override
  String get restoreFailed => '복원 실패';

  @override
  String restoreFailedWithError(Object error) {
    return '복원 실패: $error';
  }

  @override
  String loadBackupsFailed(Object error) {
    return '백업 목록을 불러오지 못했습니다: $error';
  }

  @override
  String get gitBackupDone => '현재 Git 구성을 백업했습니다';

  @override
  String get sshBackupDone => '현재 SSH 구성을 백업했습니다';

  @override
  String get gitConfigUpdated => 'Git 구성을 업데이트했습니다';

  @override
  String get gitConfigUpdateFailed => 'Git 구성 업데이트 실패';

  @override
  String get sshConfigUpdated => 'SSH 구성을 업데이트했습니다';

  @override
  String get sshConfigUpdateFailed => 'SSH 구성 업데이트 실패';

  @override
  String get configRolledBack => '구성을 롤백했습니다';

  @override
  String get gitConfigMatches => 'Git 구성이 일치합니다';

  @override
  String get gitConfigMismatch => 'Git 구성이 일치하지 않습니다';

  @override
  String get sshConfigMatches => 'SSH 구성이 일치합니다';

  @override
  String get sshConfigMismatch => 'SSH 구성이 일치하지 않습니다';

  @override
  String diffUserName(Object current, Object profile) {
    return 'Git user.name: 현재 \"$current\" ≠ 프로필 \"$profile\"';
  }

  @override
  String diffUserEmail(Object current, Object profile) {
    return 'Git user.email: 현재 \"$current\" ≠ 프로필 \"$profile\"';
  }

  @override
  String diffSshHostNotFound(Object host) {
    return 'SSH: 호스트 \"$host\"에 대한 구성이 없습니다';
  }

  @override
  String diffSshIdentityFile(Object current, Object profile) {
    return 'SSH IdentityFile: 현재 \"$current\" ≠ 프로필 \"$profile\"';
  }

  @override
  String keyFileNotExist(Object path) {
    return '개인 키 파일이 없습니다: $path';
  }

  @override
  String keyPermissionIncorrect(Object permissions) {
    return '개인 키 권한이 올바르지 않습니다. 600이어야 하며 현재는 $permissions입니다';
  }

  @override
  String get keyPermissionCheckFailed => '개인 키 권한을 확인할 수 없습니다';

  @override
  String get backupNothing => '백업할 구성이 없습니다';

  @override
  String get sshNoIdentityFile => 'SSH 구성에서 IdentityFile 행을 찾을 수 없습니다';

  @override
  String get verifyGitMismatch =>
      'Git 신원 확인 실패: user.name 또는 user.email이 대상 구성과 일치하지 않습니다';

  @override
  String verifySshFailed(Object host) {
    return 'SSH 확인 실패: $host';
  }

  @override
  String get undoFailed => '실행 취소 실패';

  @override
  String get importSystemGit => '시스템 .gitconfig 가져오기';

  @override
  String get importSystemSsh => '시스템 .ssh/config 가져오기';

  @override
  String get sshConfigContent => 'SSH 구성 내용';

  @override
  String get sshConfigHelper => '.ssh/config 내용을 붙여넣기 (전체 파일 전환)';

  @override
  String get enterSshConfig => 'SSH를 사용하는 경우 구성 내용이 필요합니다';

  @override
  String get quickCreateTitle => '빠른 생성';

  @override
  String get fromTemplate => '템플릿에서';

  @override
  String get fromExistingProfile => '기존 프로필 복사';

  @override
  String get generateKeyPair => '키 쌍 생성';

  @override
  String get sshPreviewTitle => '~/.ssh/config에 쓸 내용';

  @override
  String get templateProviderTitle => '공급자 선택';

  @override
  String get providerGithub => 'GitHub';

  @override
  String get providerGitlab => 'GitLab';

  @override
  String get providerGitee => 'Gitee';

  @override
  String get providerBlank => '비어 있음';

  @override
  String get templateModeTitle => '연결 모드';

  @override
  String get modeDirect => '직접';

  @override
  String get modeProxy => '프록시';

  @override
  String get proxyAddress => '프록시 주소';

  @override
  String get proxyAddressHint => '비워 두면 기본 127.0.0.1:7890 사용';

  @override
  String get templateGenerated => 'SSH 구성 템플릿 생성됨';

  @override
  String get selectProfileToCopy => '복사할 프로필 선택';

  @override
  String get copyProfileSuffix => ' (복사)';

  @override
  String get confirm => '확인';

  @override
  String get importSshConfigSuccess => '현재 .ssh/config 구성 가져오기 성공';

  @override
  String get importSshConfigFailed => '.ssh/config 파일을 찾을 수 없거나 읽을 수 없습니다';

  @override
  String get onboardingWelcome => 'Git Switcher에 오신 것을 환영합니다';

  @override
  String get onboardingSubtitle => '여러 Git / SSH 신원을 한 번의 클릭으로 관리하고 전환';

  @override
  String get onboardingNameHint => '이 프로필의 이름 지정 (예: 회사 계정)';

  @override
  String get onboardingImportDone => '현재 시스템 구성을 가져왔습니다. 저장 전에 수정할 수 있습니다';

  @override
  String get onboardingImport => '현재 시스템 구성 가져오기';

  @override
  String get onboardingSkip => '건너뛰기';

  @override
  String get onboardingFinish => '완료';

  @override
  String get overwriteSshTitle => 'SSH 구성 덮어쓰기 확인';

  @override
  String get overwriteSshContent =>
      '이 도구로 관리되지 않는 SSH 구성을 덮어쓰려고 합니다. 계속하시겠습니까?';

  @override
  String get switchVerified => '전환 성공, 신원 확인됨';

  @override
  String get switchWrittenNotVerified => '구성이 기록되었지만 확인에 실패했습니다';

  @override
  String get undoSuccess => '이전 구성으로 되돌렸습니다';

  @override
  String get undoNothing => '실행 취소할 항목이 없습니다';

  @override
  String get undoLastSwitch => '마지막 전환 실행 취소';

  @override
  String get keyManagementTitle => '키 관리';

  @override
  String get keyIdentifier => '식별자 (영문)';

  @override
  String get keyIdentifierHelper => '영문자, 숫자, - 및 _만 허용되며 파일 이름에 사용됩니다';

  @override
  String get keyIdentifierInvalid => '식별자는 영문자, 숫자, - 및 _만 허용합니다';

  @override
  String get keyEmail => '이메일 (선택)';

  @override
  String get keyEmailInvalid => '이메일 형식이 올바르지 않습니다. @를 포함해야 합니다';

  @override
  String get keyPassphrase => '암호 문구 (선택)';

  @override
  String get keyPassphraseHelper => '비워 두면 암호 없음; 설정하면 매번 사용 시 필요합니다';

  @override
  String get keyAlgorithmLabel => '알고리즘';

  @override
  String get generateKey => '키 쌍 생성';

  @override
  String get privateKeyPath => '개인 키 경로';

  @override
  String get publicKey => '공개 키';

  @override
  String get copyPublicKey => '공개 키 복사';

  @override
  String get fillIdentityFile => '현재 구성에 채우기';

  @override
  String get keygenSuccess => '키 쌍 생성 성공';

  @override
  String keygenFailed(Object message) {
    return '키 생성 실패: $message';
  }

  @override
  String get keygenUnavailable => 'ssh-keygen을 찾을 수 없습니다. OpenSSH 클라이언트를 설치하세요';

  @override
  String get keyExistsTitle => '키가 이미 존재합니다';

  @override
  String keyExistsContent(Object path) {
    return '키가 이미 존재합니다: $path\n덮어쓸까요?';
  }

  @override
  String get passphraseReminder => '암호 문구가 설정되었습니다. 매번 사용 시 필요합니다';

  @override
  String get fillIdentityFileDone => 'IdentityFile 행이 채워졌습니다';

  @override
  String get publicKeyCopied => '공개 키가 클립보드에 복사되었습니다';

  @override
  String get keygenDetecting => 'ssh-keygen 사용 가능 여부 확인 중…';

  @override
  String keygenDetectedAt(Object path) {
    return 'ssh-keygen 발견됨: $path';
  }

  @override
  String get keygenNotFound =>
      'ssh-keygen을 찾을 수 없습니다. OpenSSH 클라이언트를 설치하거나 경로를 지정하세요';

  @override
  String get keygenPathLabel => '사용자 지정 ssh-keygen 경로';

  @override
  String get keygenPathHint => '비워두면 자동 감지 (PATH / 일반적인 설치 위치)';

  @override
  String get keygenVerifyBtn => '확인';

  @override
  String get keygenResetBtn => '자동 감지로 초기화';

  @override
  String get keygenBrowseBtn => '찾아보기';

  @override
  String keygenPathValid(Object path) {
    return '유효한 ssh-keygen 경로: $path';
  }

  @override
  String keygenPathInvalid(Object path) {
    return '잘못된 ssh-keygen 경로: $path';
  }

  @override
  String get logSettings => '로그 설정';

  @override
  String get logSettingsSubtitle => '로그 수준 및 저장 위치';

  @override
  String get logLevel => '로그 수준';

  @override
  String get logLevelTrace => 'TRACE (가장 상세)';

  @override
  String get logLevelDebug => 'DEBUG (디버그)';

  @override
  String get logLevelInfo => 'INFO (기본값)';

  @override
  String get logLevelWarn => 'WARN (경고)';

  @override
  String get logLevelError => 'ERROR (오류만)';

  @override
  String get logFileLocation => '로그 디렉터리';

  @override
  String get onboardingDemoButton => '예시 프로필 사용해 보기';

  @override
  String get onboardingDemoHint =>
      '계정이 필요 없습니다 — 예시 프로필 2개를 가져와 회원가입 없이 모든 기능을 체험해 보세요';

  @override
  String get onboardingDemoDone => '예시 프로필이 가져와졌습니다 — 완료를 클릭해 시작하세요';

  @override
  String get demoProfileWorkName => '예시-업무 계정';

  @override
  String get demoProfilePersonalName => '예시-개인 계정';
}
