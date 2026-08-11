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
}
