import 'package:path/path.dart' as p;

import '../services/path_service.dart';

/// SSH 配置轻量提取服务。
///
/// 遵循产品技术规格 v1.0：**禁止**实现 SSH config 解析器（Host 块定位 /
/// 指令就地更新 / 通配符语义 / 冲突检测）。本服务仅保留规格允许的「轻量提取」：
/// 用正则从 sshconfig 文本中提取 `IdentityFile` 行与 `Host` 行，仅用于
/// 私钥存在性校验与 `ssh -T` 验证，属于纯文本行匹配，不做语义解析。
class SshConfigService {
  static SshConfigService? _instance;
  static SshConfigService get instance => _instance ??= SshConfigService._();
  SshConfigService._();

  final _pathService = PathService.instance;

  static final _identityFileRe = RegExp(
    r'^[ \t]*IdentityFile[ \t]+(.+?)[ \t]*$',
    multiLine: true,
    caseSensitive: false,
  );

  static final _hostRe = RegExp(
    r'^\s*Host\s+(.+?)\s*$',
    multiLine: true,
    caseSensitive: false,
  );

  /// 提取 sshconfig 中所有 `IdentityFile` 行，返回解析后的路径。
  ///
  /// 解析规则与 ssh 语义一致：
  /// - 去除包裹路径的双引号（`IdentityFile "~/.ssh/id_a"`）；
  /// - `~/` 展开为主目录；
  /// - 相对路径（不以 `/` 开头）按 ssh 规则基于 `~/.ssh` 解析。
  List<String> extractIdentityFiles(String content) {
    final paths = <String>[];
    for (final match in _identityFileRe.allMatches(content)) {
      var raw = match.group(1)!.trim();
      // 去除成对的双引号。
      if (raw.length >= 2 &&
          raw.startsWith('"') &&
          raw.endsWith('"')) {
        raw = raw.substring(1, raw.length - 1).trim();
      }
      if (raw.isEmpty) continue;
      paths.add(_resolveIdentityPath(raw));
    }
    return paths;
  }

  String _resolveIdentityPath(String raw) {
    if (p.isAbsolute(raw)) return raw;
    if (raw.startsWith('~/')) {
      return _pathService.resolvePath(raw);
    }
    // 相对路径基于 ~/.ssh。
    return '${_pathService.homeDir}/.ssh/$raw';
  }

  /// 提取所有 `Host` 行的首个 token（含 `*` 通配符）。
  List<String> extractHosts(String content) {
    final hosts = <String>[];
    for (final match in _hostRe.allMatches(content)) {
      final first = match.group(1)!.trim().split(RegExp(r'\s+')).first;
      if (first.isNotEmpty) {
        hosts.add(first);
      }
    }
    return hosts;
  }

  /// 取第一个非通配符 Host（用于 `ssh -T` 验证）。
  String? firstConcreteHost(String content) {
    for (final host in extractHosts(content)) {
      if (host != '*') return host;
    }
    return null;
  }
}
