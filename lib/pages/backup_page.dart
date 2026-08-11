import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
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
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.loadBackupsFailed(e.toString()))));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.backupManagement),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadBackups),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBackupList(l10n),
      bottomNavigationBar: _selectedBackup != null
          ? Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _restoreBackup,
                child: Text(l10n.restoreSelectedBackup),
              ),
            )
          : null,
    );
  }

  Widget _buildBackupList(AppLocalizations l10n) {
    if (_backupItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.backup_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              l10n.noBackups,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
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
            title: Text(l10n.backupTime(date)),
            subtitle: Text(l10n.fileCount(backups.length)),
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
                            backup.type == 'git'
                                ? l10n.gitConfigType
                                : l10n.sshConfigType,
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
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.backupPreviewTitle(
            backup.type == 'git' ? 'Git' : 'SSH',
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: Text(
              backup.content ?? l10n.noContent,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _restoreBackup() async {
    final l10n = AppLocalizations.of(context);
    if (_selectedBackup == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmRestore),
        content: Text(
          l10n.confirmRestoreContent(
            _selectedBackup!.type == 'git' ? 'Git' : 'SSH',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.restore, style: const TextStyle(color: Colors.orange)),
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
              content: Text(success ? l10n.restoreSuccess : l10n.restoreFailed),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.restoreFailedWithError(e.toString()))));
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}