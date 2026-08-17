import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:git_switcher/l10n/app_localizations_en.dart';
import 'package:git_switcher/l10n/core_messages.dart';
import 'package:git_switcher/l10n/localization_service.dart';
import 'package:git_switcher/services/config_service.dart';
import 'package:git_switcher/services/path_service.dart';

/// 为测试创建隔离的主目录环境：
/// 1. 复用各单例服务（不重置），把路径服务的 HOME 指向临时目录；
/// 2. 清空配置服务的内存状态并重新加载；
/// 3. 初始化全局本地化实例（供服务生成用户可见消息）。
Future<Directory> setUpIsolatedHome() async {
  final temp = await Directory.systemTemp.createTemp('git_switcher_test_');
  await PathService.instance.initialize(homeDir: temp.path);
  ConfigService.instance.debugClear();
  await ConfigService.instance.initialize();
  L.debugSetLocalization(AppLocalizationsEn());
  // 核心服务消息源：测试使用英文，与服务消息断言一致。
  Msg.use(const DefaultCoreMessages());
  return temp;
}

/// 清理临时主目录；恢复只读目录权限，避免删除失败。
Future<void> tearDownHome(Directory temp) async {
  final sshDir = Directory('${temp.path}/.ssh');
  if (sshDir.existsSync()) {
    await Process.run('chmod', ['0755', sshDir.path]).then((_) {});
  }
  if (temp.existsSync()) {
    await temp.delete(recursive: true);
  }
}

/// 便捷：写入主目录下的相对路径文件。
Future<File> writeHome(Directory home, String relativePath, String content) async {
  final file = File('${home.path}/$relativePath');
  await file.parent.create(recursive: true);
  await file.writeAsString(content);
  return file;
}
