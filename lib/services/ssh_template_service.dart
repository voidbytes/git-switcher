import 'dart:io';

/// SSH 服务商模板。
enum SshProvider { github, gitlab, gitee, blank }

/// 连接方式。
enum ProxyMode { direct, proxy }

/// 内部模板生成服务（规格 7）。
///
/// 模板**仅生成 sshconfig**（SSH Host 块），与 gitconfig 无关。
/// **默认直连（不含 ProxyCommand）**；仅当显式选择代理时才按平台插入
/// ProxyCommand 行。
class SshTemplateService {
  static SshTemplateService? _instance;
  static SshTemplateService get instance => _instance ??= SshTemplateService._();
  SshTemplateService._();

  /// 生成 sshconfig 文本。
  ///
  /// [identityFile] 为 `IdentityFile` 路径占位（如 `~/.ssh/id_ed25519_github`）。
  /// [proxyAddress] 形如 `127.0.0.1:7890`；直连时忽略。
  String build({
    required SshProvider provider,
    required ProxyMode mode,
    required String identityFile,
    String proxyAddress = '127.0.0.1:7890',
  }) {
    switch (provider) {
      case SshProvider.github:
        return _github(mode, identityFile, proxyAddress);
      case SshProvider.gitlab:
        return _generic('gitlab.com', identityFile, directOnly: true);
      case SshProvider.gitee:
        return _generic('gitee.com', identityFile, directOnly: true);
      case SshProvider.blank:
        return '';
    }
  }

  String _github(ProxyMode mode, String identityFile, String proxyAddress) {
    final lines = <String>[
      'Host github.com',
      '  HostName ssh.github.com',
      '  User git',
      '  Port 443',
      if (mode == ProxyMode.proxy) _proxyCommand('ssh.github.com', proxyAddress),
      '  IdentityFile $identityFile',
      '  ServerAliveInterval 60',
    ];
    return lines.join('\n');
  }

  String _generic(String host, String identityFile, {required bool directOnly}) {
    return [
      'Host $host',
      '  HostName $host',
      '  User git',
      '  IdentityFile $identityFile',
      '  ServerAliveInterval 60',
    ].join('\n');
  }

  /// 按平台生成 ProxyCommand 行（规格 7.1 / 12）。
  String _proxyCommand(String host, String proxyAddress) {
    if (Platform.isWindows) {
      return '  ProxyCommand connect -S $proxyAddress %h %p';
    }
    if (Platform.isMacOS) {
      return '  ProxyCommand /usr/bin/nc -X 5 -x $proxyAddress %h %p';
    }
    return '  ProxyCommand nc -X 5 -x $proxyAddress %h %p';
  }
}