import 'package:uuid/uuid.dart';

class Profile {
  final String id;
  final String name;
  final String gitconfig;
  final bool useSsh;
  final String host;
  final String identityFile;
  final bool usePort443;

  Profile({
    String? id,
    required this.name,
    required this.gitconfig,
    this.useSsh = false,
    this.host = '',
    this.identityFile = '',
    this.usePort443 = false,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gitconfig': gitconfig,
      'use_ssh': useSsh,
      'host': host,
      'identity_file': identityFile,
      'use_port_443': usePort443,
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
      usePort443: json['use_port_443'] ?? false,
    );
  }

  Profile copyWith({
    String? name,
    String? gitconfig,
    bool? useSsh,
    String? host,
    String? identityFile,
    bool? usePort443,
  }) {
    return Profile(
      id: id,
      name: name ?? this.name,
      gitconfig: gitconfig ?? this.gitconfig,
      useSsh: useSsh ?? this.useSsh,
      host: host ?? this.host,
      identityFile: identityFile ?? this.identityFile,
      usePort443: usePort443 ?? this.usePort443,
    );
  }

  @override
  String toString() {
    return 'Profile(id: $id, name: $name, useSsh: $useSsh, host: $host)';
  }
}
