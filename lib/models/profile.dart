import 'package:uuid/uuid.dart';

class Profile {
  final String id;
  final String name;
  final String gitconfig;
  final bool useSsh;
  final String host;
  final String identityFile;
  final int? sshPort;

  Profile({
    String? id,
    required this.name,
    required this.gitconfig,
    this.useSsh = false,
    this.host = '',
    this.identityFile = '',
    this.sshPort,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gitconfig': gitconfig,
      'use_ssh': useSsh,
      'host': host,
      'identity_file': identityFile,
      'ssh_port': sshPort,
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      gitconfig: json['gitconfig'],
      useSsh: json['use_ssh'] ?? false,
      host: json['host'] ?? '',
      identityFile: json['identity_file'] ?? '',
      // 兼容旧版本的 use_port_443 布尔字段
      sshPort: json['ssh_port'] ??
          (json['use_port_443'] == true ? 443 : null),
    );
  }

  Profile copyWith({
    String? name,
    String? gitconfig,
    bool? useSsh,
    String? host,
    String? identityFile,
    int? sshPort,
  }) {
    return Profile(
      id: id,
      name: name ?? this.name,
      gitconfig: gitconfig ?? this.gitconfig,
      useSsh: useSsh ?? this.useSsh,
      host: host ?? this.host,
      identityFile: identityFile ?? this.identityFile,
      sshPort: sshPort ?? this.sshPort,
    );
  }

  @override
  String toString() {
    return 'Profile(id: $id, name: $name, useSsh: $useSsh, host: $host)';
  }
}
