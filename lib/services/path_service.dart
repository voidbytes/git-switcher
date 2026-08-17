import 'dart:io';

class PathService {
  static PathService? _instance;
  static PathService get instance => _instance ??= PathService._();
  PathService._();

  late String _homeDir;
  late String _gitSwitcherDir;
  bool _initialized = false;

  /// [homeDir] 可选，供测试注入隔离的主目录；缺省时取系统用户主目录。
  /// 已初始化（如测试已注入主目录）后再次调用且未传 [homeDir] 时，保留原值。
  ///
  /// 空白 [homeDir]（如空字符串）按未提供处理，避免把数据写到文件系统根目录。
  Future<void> initialize({String? homeDir}) async {
    if (homeDir != null && homeDir.trim().isNotEmpty) {
      _homeDir = homeDir;
    } else if (!_initialized) {
      if (Platform.isWindows) {
        _homeDir = Platform.environment['USERPROFILE'] ?? '';
      } else {
        _homeDir = Platform.environment['HOME'] ?? '';
      }
    }
    _initialized = true;

    // home 为空（HOME/USERPROFILE 未设置或为空白）时禁止继续，
    // 避免路径拼接退化为 /.git_switcher 写入文件系统根目录。
    if (_homeDir.trim().isEmpty) {
      throw FileSystemException(
        'Home directory is empty (pass --home or set HOME/USERPROFILE)',
        _homeDir,
      );
    }

    // 校验 home 目录可用性：已存在但非目录时抛出清晰错误（由调用方友好处理）。
    final type = FileSystemEntity.typeSync(_homeDir);
    if (type != FileSystemEntityType.notFound &&
        type != FileSystemEntityType.directory) {
      throw FileSystemException(
        'Home path is not a directory: $_homeDir',
        _homeDir,
      );
    }

    _gitSwitcherDir = '$_homeDir/.git_switcher';

    await Directory(_gitSwitcherDir).create(recursive: true);
    await Directory('$_gitSwitcherDir/backup').create(recursive: true);
    await Directory('$_gitSwitcherDir/backup/git').create(recursive: true);
    await Directory('$_gitSwitcherDir/backup/ssh').create(recursive: true);
    await Directory('$_gitSwitcherDir/logs').create(recursive: true);
  }

  String get homeDir => _homeDir;
  String get gitSwitcherDir => _gitSwitcherDir;
  String get configFilePath => '$_gitSwitcherDir/config.json';
  String get gitConfigPath => '$_homeDir/.gitconfig';
  String get sshConfigPath => '$_homeDir/.ssh/config';
  String get sshDir => '$_homeDir/.ssh';
  String get gitBackupDir => '$_gitSwitcherDir/backup/git';
  String get sshBackupDir => '$_gitSwitcherDir/backup/ssh';

  /// 日志目录。业界常用位置：
  /// - Linux/macOS: `~/.git_switcher/logs`
  /// - Windows: `%USERPROFILE%\.git_switcher\logs`
  String get logsDir => '$_gitSwitcherDir/logs';

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
