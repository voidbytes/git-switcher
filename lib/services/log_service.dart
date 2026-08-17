import 'dart:io';

/// 日志级别，按严重程度升序排列。
/// 级别过滤规则：只输出级别 >= 当前设置级别的日志。
enum LogLevel {
  /// 跟踪：最细粒度的调试信息，仅开发调试时使用。
  trace(0),

  /// 调试：调试信息，开发阶段启用以了解执行流程。
  debug(1),

  /// 信息：正常运行的关键里程碑信息（默认级别）。
  info(2),

  /// 警告：潜在问题，不影响当前操作但值得关注。
  warn(3),

  /// 错误：已发生的错误，操作可能失败。
  error(4);

  const LogLevel(this.value);
  final int value;

  /// 从字符串解析日志级别，不区分大小写。
  /// 无法解析时返回 [LogLevel.info]。
  static LogLevel fromString(String s) {
    switch (s.toLowerCase()) {
      case 'trace':
        return LogLevel.trace;
      case 'debug':
        return LogLevel.debug;
      case 'info':
        return LogLevel.info;
      case 'warn':
      case 'warning':
        return LogLevel.warn;
      case 'error':
        return LogLevel.error;
      default:
        return LogLevel.info;
    }
  }
}

/// 日志服务（纯 Dart，无 Flutter 依赖）。
///
/// 功能：
/// - 五级日志：TRACE / DEBUG / INFO / WARN / ERROR，默认 INFO
/// - 按天滚动输出到 `~/.git_switcher/logs/git-switcher-YYYY-MM-DD.log`
/// - 同时输出到 stderr（GUI 与 CLI 通用）
/// - 线程安全（同步写入，适合桌面应用）
///
/// 业界惯例位置：
///   Linux/macOS/Windows 统一使用 `~/.git_switcher/logs/`，
///   与应用本身的数据目录保持一致，避免因平台差异导致排查困难。
///
/// 向后兼容别名（`Log.instance`），供服务层引用。
typedef Log = LogService;

class LogService {
  static LogService? _instance;
  static LogService get instance => _instance ??= LogService._();
  LogService._();

  LogLevel _level = LogLevel.info;
  String? _logDir;
  String? _currentLogFile;
  String? _today;
  String? _lastLogDir;

  /// 当前日志级别。
  LogLevel get level => _level;

  /// 日志目录路径（初始化后方可读取）。
  String? get logDir => _logDir;

  /// 初始化日志服务。
  ///
  /// [logDir] 日志目录，缺省时不写文件（仅 stderr）。
  /// [level] 日志级别，缺省 INFO。
  void initialize({String? logDir, LogLevel level = LogLevel.info}) {
    _level = level;
    if (logDir != null) {
      _logDir = logDir;
      _ensureLogDir();
      _rotateIfNeeded();
    }
  }

  void _ensureLogDir() {
    if (_logDir != null) {
      Directory(_logDir!).createSync(recursive: true);
    }
  }

  void _rotateIfNeeded() {
    final t = _todayDate();
    // 除按天滚动外，还需感知 logDir 变化：
    // 同一天内以新目录重新 initialize 时，必须切换到新目录下的日志文件，
    // 否则仍写旧路径（旧目录被删除后写入会持续失败）。
    if (_logDir != null &&
        (t != _today || _currentLogFile == null || _logDir != _lastLogDir)) {
      _today = t;
      _lastLogDir = _logDir;
      _currentLogFile = '$_logDir/git-switcher-$t.log';
    }
  }

  static String _todayDate() {
    final now = DateTime.now();
    return '${now.year}-${_pad(now.month)}-${_pad(now.day)}';
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');

  /// 设置日志级别。
  void setLevel(LogLevel level) {
    _level = level;
    info('日志级别已切换为 ${level.name.toUpperCase()}');
  }

  // ---------------------------------------------------------------------------
  // 便捷方法
  // ---------------------------------------------------------------------------

  void trace(String message, {String? tag}) => _log(LogLevel.trace, message, tag: tag);
  void debug(String message, {String? tag}) => _log(LogLevel.debug, message, tag: tag);
  void info(String message, {String? tag}) => _log(LogLevel.info, message, tag: tag);
  void warn(String message, {String? tag}) => _log(LogLevel.warn, message, tag: tag);
  void error(String message, {String? tag}) => _log(LogLevel.error, message, tag: tag);

  // ---------------------------------------------------------------------------
  // 核心日志方法
  // ---------------------------------------------------------------------------

  void _log(LogLevel level, String message, {String? tag}) {
    if (level.value < _level.value) return;

    final now = DateTime.now();
    final timestamp =
        '${now.year}-${_pad(now.month)}-${_pad(now.day)} '
        '${_pad(now.hour)}:${_pad(now.minute)}:${_pad(now.second)}.'
        '${now.millisecond.toString().padLeft(3, '0')}';
    final levelStr = _padLevel(level);
    final tagStr = tag != null ? ' [$tag]' : '';
    final line = '[$timestamp] [$levelStr]$tagStr $message';

    // 同步写入 stderr（GUI 与 CLI 通用）。
    stderr.writeln(line);

    // 写入文件（按天滚动）。
    if (_logDir != null) {
      _writeToFile(line);
    }
  }

  static String _padLevel(LogLevel level) {
    // 统一右对齐到 5 字符，保证日志对齐美观。
    return level.name.toUpperCase().padRight(5);
  }

  void _writeToFile(String line) {
    try {
      _rotateIfNeeded();
      if (_currentLogFile != null) {
        File(_currentLogFile!).writeAsStringSync(
          '$line\n',
          mode: FileMode.append,
        );
      }
    } catch (_) {
      // 写入文件失败时静默忽略，避免日志系统自身造成级联故障。
    }
  }
}