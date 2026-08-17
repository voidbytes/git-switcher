import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:git_switcher/services/log_service.dart';

void main() {
  late Directory logDir;

  setUp(() async {
    logDir = await Directory.systemTemp.createTemp('git_switcher_log_test_');
    // 每次初始化日志服务，隔离单例状态。
    LogService.instance.initialize(
      logDir: logDir.path,
      level: LogLevel.info,
    );
  });

  tearDown(() async {
    if (logDir.existsSync()) {
      await logDir.delete(recursive: true);
    }
  });

  group('LogLevel.fromString - 级别解析', () {
    test('合法级别解析正确（不区分大小写）', () {
      expect(LogLevel.fromString('trace'), LogLevel.trace);
      expect(LogLevel.fromString('DEBUG'), LogLevel.debug);
      expect(LogLevel.fromString('info'), LogLevel.info);
      expect(LogLevel.fromString('warn'), LogLevel.warn);
      expect(LogLevel.fromString('warning'), LogLevel.warn);
      expect(LogLevel.fromString('Error'), LogLevel.error);
    });

    test('非法级别回退到默认 info', () {
      expect(LogLevel.fromString(''), LogLevel.info);
      expect(LogLevel.fromString('verbose'), LogLevel.info);
      expect(LogLevel.fromString('all'), LogLevel.info);
    });
  });

  group('日志级别过滤', () {
    test('默认 info 级别下 debug 不写文件、info 写入', () {
      LogService.instance.debug('debug消息', tag: 'T');
      LogService.instance.info('info消息', tag: 'T');

      final content = _todayLogContent(logDir);
      expect(content, isNot(contains('debug消息')));
      expect(content, contains('info消息'));
    });

    test('error 级别只写 error，info/warn 被过滤', () {
      LogService.instance.setLevel(LogLevel.error);
      LogService.instance.info('info消息');
      LogService.instance.warn('warn消息');
      LogService.instance.error('error消息');

      final content = _todayLogContent(logDir);
      expect(content, contains('error消息'));
      expect(content, isNot(contains('info消息')));
      expect(content, isNot(contains('warn消息')));
    });

    test('trace 级别下所有级别均写入', () {
      LogService.instance.setLevel(LogLevel.trace);
      LogService.instance.trace('trace消息');
      LogService.instance.debug('debug消息');

      final content = _todayLogContent(logDir);
      expect(content, contains('trace消息'));
      expect(content, contains('debug消息'));
    });
  });

  group('日志文件输出', () {
    test('日志写入按天命名的文件', () {
      LogService.instance.info('写入成功');

      final dir = Directory(logDir.path);
      expect(dir.existsSync(), true);
      final files = dir.listSync().whereType<File>().toList();
      expect(files, isNotEmpty);
      expect(
        files.single.path,
        endsWith('git-switcher-${_today()}.log'),
      );
    });

    test('日志行包含时间戳与级别标记', () {
      LogService.instance.warn('带级别消息', tag: 'TAG');

      final content = _todayLogContent(logDir);
      expect(content, matches(RegExp(r'\[\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}')));
      // 级别标记统一右对齐补齐到 5 字符（如 [WARN ]），见 _padLevel。
      expect(content, contains('[WARN ]'));
      expect(content, contains('[TAG]'));
      expect(content, contains('带级别消息'));
    });
  });

  group('日志目录初始化', () {
    test('initialize 自动创建目录', () async {
      final nested = Directory('${logDir.path}/a/b');
      LogService.instance.initialize(logDir: nested.path, level: LogLevel.info);
      LogService.instance.info('x');
      expect(nested.existsSync(), true);
    });
  });
}

String _today() {
  final now = DateTime.now();
  String pad(int n) => n.toString().padLeft(2, '0');
  return '${now.year}-${pad(now.month)}-${pad(now.day)}';
}

String _todayLogContent(Directory logDir) {
  final f = File('${logDir.path}/git-switcher-${_today()}.log');
  if (!f.existsSync()) return '';
  return f.readAsStringSync();
}
