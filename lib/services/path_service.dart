import 'dart:io';

class PathService {
  static PathService? _instance;
  static PathService get instance => _instance ??= PathService._();
  PathService._();

  late String _homeDir;
  late String _gitSwitcherDir;

  Future<void> initialize() async {
    if (Platform.isWindows) {
      _homeDir = Platform.environment['USERPROFILE'] ?? '';
    } else {
      _homeDir = Platform.environment['HOME'] ?? '';
    }

    _gitSwitcherDir = '$_homeDir/.git_switcher';

    await Directory(_gitSwitcherDir).create(recursive: true);
    await Directory('$_gitSwitcherDir/backup').create(recursive: true);
    await Directory('$_gitSwitcherDir/backup/git').create(recursive: true);
    await Directory('$_gitSwitcherDir/backup/ssh').create(recursive: true);
  }

  String get homeDir => _homeDir;
  String get gitSwitcherDir => _gitSwitcherDir;
  String get configFilePath => '$_gitSwitcherDir/config.json';
  String get gitConfigPath => '$_homeDir/.gitconfig';
  String get sshConfigPath => '$_homeDir/.ssh/config';
  String get sshDir => '$_homeDir/.ssh';
  String get gitBackupDir => '$_gitSwitcherDir/backup/git';
  String get sshBackupDir => '$_gitSwitcherDir/backup/ssh';

  Future<void> ensureSshDirExists() async {
    await Directory(sshDir).create(recursive: true);
  }

  String resolvePath(String path) {
    if (path.startsWith('~/')) {
      return path.replaceFirst('~/', '$_homeDir/');
    }
    return path;
  }
}
