class BackupItem {
  final String timestamp;
  final String type;
  final String filename;
  final String? content;

  BackupItem({
    required this.timestamp,
    required this.type,
    required this.filename,
    this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'type': type,
      'filename': filename,
      'content': content,
    };
  }

  factory BackupItem.fromJson(Map<String, dynamic> json) {
    return BackupItem(
      timestamp: json['timestamp'],
      type: json['type'],
      filename: json['filename'],
      content: json['content'],
    );
  }
}
