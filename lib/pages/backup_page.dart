import 'package:flutter/material.dart';
import '../models/backup_item.dart';
import '../services/file_service.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  List<BackupItem> _backupItems = [];
  bool _isLoading = false;
  BackupItem? _selectedBackup;

  @override
  void initState() {
    super.initState();
    _loadBackups();
  }

  Future<void> _loadBackups() async {
    setState(() => _isLoading = true);
    try {
      final items = await FileService.instance.getBackupList();
      setState(() {
        _backupItems = items;
        _selectedBackup = null;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('加载备份列表失败: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('备份管理'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadBackups),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBackupList(),
      bottomNavigationBar: _selectedBackup != null
          ? Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _restoreBackup,
                child: const Text('恢复选中的备份'),
              ),
            )
          : null,
    );
  }

  Widget _buildBackupList() {
    if (_backupItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.backup_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('暂无备份', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }

    final groupedBackups = <String, List<BackupItem>>{};
    for (final backup in _backupItems) {
      final date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(backup.timestamp),
      );
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
          '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

      if (!groupedBackups.containsKey(dateStr)) {
        groupedBackups[dateStr] = [];
      }
      groupedBackups[dateStr]!.add(backup);
    }

    final sortedDates = groupedBackups.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final backups = groupedBackups[date]!;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            title: Text('备份时间: $date'),
            subtitle: Text('${backups.length} 个文件'),
            children: [
              RadioGroup<BackupItem>(
                groupValue: _selectedBackup,
                onChanged: (value) {
                  setState(() => _selectedBackup = value);
                },
                child: Column(
                  children: backups
                      .map(
                        (backup) => RadioListTile<BackupItem>(
                          value: backup,

                          title: Text(
                            backup.type == 'git' ? 'Git 配置' : 'SSH 配置',
                          ),
                          subtitle: Text(backup.filename),
                          secondary: IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () => _previewBackup(backup),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _previewBackup(BackupItem backup) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${backup.type.toUpperCase()} 备份预览'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: Text(
              backup.content ?? '无内容',
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _restoreBackup() async {
    if (_selectedBackup == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认恢复'),
        content: Text(
          '确定要恢复选中的${_selectedBackup!.type == 'git' ? 'Git' : 'SSH'}配置吗？\n\n'
          '这将覆盖当前配置。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('恢复', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );

    if (confirmed == true && _selectedBackup != null) {
      setState(() => _isLoading = true);
      try {
        final success = await FileService.instance.restoreBackup(
          _selectedBackup!,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(success ? '恢复成功' : '恢复失败'),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('恢复失败: $e')));
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
