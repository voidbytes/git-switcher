/// 最近一次切换的快照（撤销数据源）。
///
/// 只保留最近一次（单层撤销）：保存切换前 `~/.gitconfig` 与 `~/.ssh/config`
/// 的全文，供「一键撤销」整文件写回。
class LastSwitchSnapshot {
  /// 切换前的活跃 Profile id；可能为 null（此前无匹配配置）。
  final String? profileId;

  /// 切换前 `~/.gitconfig` 全文。
  final String? gitconfig;

  /// 切换前 `~/.ssh/config` 全文或 null。
  final String? sshconfig;

  /// 本次切换是否托管了 `~/.ssh/config`（即目标 profile 使用 SSH）。
  /// 用于撤销时区分「未托管（不动 ssh）」与「托管但切换前无文件（删除）」。
  final bool? sshManaged;

  /// 切换时间（ISO-8601）。
  final String switchedAt;

  const LastSwitchSnapshot({
    this.profileId,
    this.gitconfig,
    this.sshconfig,
    this.sshManaged,
    required this.switchedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'profile_id': profileId,
      'gitconfig': gitconfig,
      'sshconfig': sshconfig,
      'ssh_managed': sshManaged,
      'switched_at': switchedAt,
    };
  }

  factory LastSwitchSnapshot.fromJson(Map<String, dynamic> json) {
    return LastSwitchSnapshot(
      profileId: json['profile_id'],
      gitconfig: json['gitconfig'],
      sshconfig: json['sshconfig'],
      sshManaged: json['ssh_managed'],
      switchedAt: json['switched_at'] ?? '',
    );
  }
}
