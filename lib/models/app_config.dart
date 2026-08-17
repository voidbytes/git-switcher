import 'last_switch_snapshot.dart';

/// 应用设置（AppConfig）。
class AppConfig {
  final bool enableBackup;
  final int maxBackupCount;
  final String? activeProfileId;

  /// 最近一次切换的快照；一键撤销的数据源（单层撤销）。
  final LastSwitchSnapshot? lastSwitchSnapshot;

  final bool minimizeToTray;
  final String? languageCode;

  /// 用户指定的 ssh-keygen 路径（空 = 自动检测 / PATH 默认）。
  final String? sshKeygenPath;

  /// 日志级别（'trace'|'debug'|'info'|'warn'|'error'，空 = 默认 info）。
  final String? logLevel;

  /// 首次启动引导是否完成。
  final bool onboarded;

  const AppConfig({
    this.enableBackup = true,
    this.maxBackupCount = 5,
    this.activeProfileId,
    this.lastSwitchSnapshot,
    this.minimizeToTray = false,
    this.languageCode,
    this.sshKeygenPath,
    this.logLevel,
    this.onboarded = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'enable_backup': enableBackup,
      'max_backup_count': maxBackupCount,
      'active_profile_id': activeProfileId,
      'last_switch_snapshot': lastSwitchSnapshot?.toJson(),
      'minimize_to_tray': minimizeToTray,
      'language_code': languageCode,
      'ssh_keygen_path': sshKeygenPath,
      'log_level': logLevel,
      'onboarded': onboarded,
    };
  }

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    final snapshotJson = json['last_switch_snapshot'];
    return AppConfig(
      enableBackup: json['enable_backup'] ?? true,
      maxBackupCount: json['max_backup_count'] ?? 5,
      activeProfileId: json['active_profile_id'],
      lastSwitchSnapshot: snapshotJson is Map<String, dynamic>
          ? LastSwitchSnapshot.fromJson(snapshotJson)
          : null,
      minimizeToTray: json['minimize_to_tray'] ?? false,
      languageCode: json['language_code'],
      sshKeygenPath: json['ssh_keygen_path'],
      logLevel: json['log_level'],
      onboarded: json['onboarded'] ?? false,
    );
  }

  static const Object _unset = Object();

  AppConfig copyWith({
    bool? enableBackup,
    int? maxBackupCount,
    Object? activeProfileId = _unset,
    Object? lastSwitchSnapshot = _unset,
    bool? minimizeToTray,
    String? languageCode,
    Object? sshKeygenPath = _unset,
    String? logLevel,
    bool? onboarded,
    bool clearSnapshot = false,
  }) {
    return AppConfig(
      enableBackup: enableBackup ?? this.enableBackup,
      maxBackupCount: maxBackupCount ?? this.maxBackupCount,
      activeProfileId: activeProfileId == _unset
          ? this.activeProfileId
          : activeProfileId as String?,
      lastSwitchSnapshot: clearSnapshot
          ? null
          : lastSwitchSnapshot == _unset
              ? this.lastSwitchSnapshot
              : lastSwitchSnapshot as LastSwitchSnapshot?,
      minimizeToTray: minimizeToTray ?? this.minimizeToTray,
      languageCode: languageCode ?? this.languageCode,
      sshKeygenPath: sshKeygenPath == _unset
          ? this.sshKeygenPath
          : sshKeygenPath as String?,
      logLevel: logLevel ?? this.logLevel,
      onboarded: onboarded ?? this.onboarded,
    );
  }
}
