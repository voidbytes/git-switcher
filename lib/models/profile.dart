import 'package:uuid/uuid.dart';

/// 配置（Profile）。
///
/// 遵循产品技术规格 v1.0：SSH 采用「整文件切换」策略，每个 Profile 保存
/// 完整的 `~/.ssh/config` 文本（[sshconfig]），切换时整文件覆盖写。
class Profile {
  final String id;
  final String name;

  /// 完整 `~/.gitconfig` 内容。
  final String gitconfig;

  /// 是否启用 SSH 切换。
  final bool useSsh;

  /// 完整 `~/.ssh/config` 内容；`useSsh == true` 时必填非空。
  final String sshconfig;

  Profile({
    String? id,
    required this.name,
    required this.gitconfig,
    this.useSsh = false,
    this.sshconfig = '',
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gitconfig': gitconfig,
      'use_ssh': useSsh,
      'sshconfig': sshconfig,
    };
  }

  /// 从 JSON 解析。兼容旧格式（host / identity_file / ssh_port /
  /// use_port_443），自动拼装 sshconfig 并迁移到新格式。
  factory Profile.fromJson(Map<String, dynamic> json) {
    final hasNewSsh = json['sshconfig'] is String;
    final useSsh = json['use_ssh'] ?? false;

    // 规格 4.1：仅当存在 SSH 相关旧字段时才拼装 sshconfig；
    // 无 SSH 相关旧字段 → sshconfig=""、use_ssh=false。
    final hasLegacySsh = json.containsKey('host') ||
        json.containsKey('identity_file') ||
        json.containsKey('ssh_port') ||
        json.containsKey('use_port_443');

    String sshconfig;
    if (hasNewSsh) {
      sshconfig = json['sshconfig'] as String;
    } else if (hasLegacySsh) {
      sshconfig = buildSshConfigFromLegacy(
        host: json['host'] as String? ?? '',
        identityFile: json['identity_file'] as String? ?? '',
        sshPort: _legacySshPort(json),
      );
    } else {
      sshconfig = '';
    }

    // 迁移后 use_ssh=true 但 sshconfig 为空 → 按 use_ssh=false 兜底。
    final effectiveUseSsh = useSsh && sshconfig.trim().isNotEmpty;

    return Profile(
      id: json['id'],
      name: json['name'],
      gitconfig: json['gitconfig'],
      useSsh: effectiveUseSsh,
      sshconfig: sshconfig,
    );
  }

  static int? _legacySshPort(Map<String, dynamic> json) {
    final port = json['ssh_port'];
    if (port is int) return port;
    if (json['use_port_443'] == true) return 443;
    return null;
  }

  /// 按规格 4.1 的旧格式迁移规则拼装 sshconfig。
  static String buildSshConfigFromLegacy({
    required String host,
    required String identityFile,
    int? sshPort,
  }) {
    final hostName = (sshPort != null && host == 'github.com')
        ? 'ssh.github.com'
        : host;
    final lines = <String>[
      'Host $host',
      '  HostName $hostName',
      '  User git',
      if (sshPort != null) '  Port $sshPort',
      '  IdentityFile $identityFile',
    ];
    return lines.join('\n');
  }

  Profile copyWith({
    String? name,
    String? gitconfig,
    bool? useSsh,
    String? sshconfig,
  }) {
    return Profile(
      id: id,
      name: name ?? this.name,
      gitconfig: gitconfig ?? this.gitconfig,
      useSsh: useSsh ?? this.useSsh,
      sshconfig: sshconfig ?? this.sshconfig,
    );
  }

  @override
  String toString() {
    return 'Profile(id: $id, name: $name, useSsh: $useSsh)';
  }
}
