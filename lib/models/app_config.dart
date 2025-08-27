class AppConfig {
  final bool enableBackup;
  final int maxBackupCount;
  final String? activeProfileId;
  final bool minimizeToTray;

  const AppConfig({
    this.enableBackup = true,
    this.maxBackupCount = 5,
    this.activeProfileId,
    this.minimizeToTray = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'enable_backup': enableBackup,
      'max_backup_count': maxBackupCount,
      'active_profile_id': activeProfileId,
      'minimize_to_tray': minimizeToTray,
    };
  }

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      enableBackup: json['enable_backup'] ?? true,
      maxBackupCount: json['max_backup_count'] ?? 5,
      activeProfileId: json['active_profile_id'],
      minimizeToTray: json['minimize_to_tray'] ?? false,
    );
  }

  AppConfig copyWith({
    bool? enableBackup,
    int? maxBackupCount,
    String? activeProfileId,
    bool? minimizeToTray,
  }) {
    return AppConfig(
      enableBackup: enableBackup ?? this.enableBackup,
      maxBackupCount: maxBackupCount ?? this.maxBackupCount,
      activeProfileId: activeProfileId,
      minimizeToTray: minimizeToTray ?? this.minimizeToTray,
    );
  }
}
