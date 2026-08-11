import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/profile.dart';
import '../services/config_service.dart';
import '../services/git_service.dart';
import '../services/ssh_config_service.dart';
import 'profile_edit_page.dart';
import 'backup_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _configService = ConfigService.instance;
  final _gitService = GitService.instance;
  final _sshConfigService = SshConfigService.instance;
  bool _isLoading = false;
  Profile? _activeProfile;

  @override
  void initState() {
    super.initState();
    _checkActiveProfile();
  }

  Future<void> _checkActiveProfile() async {
    setState(() {
      _isLoading = true;
      _activeProfile = null;
    });
    try {
      final activeProfile = await _gitService.findActiveProfile();
      if (mounted) {
        setState(() {
          _activeProfile = activeProfile;
        });
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.switchFailedWithError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
      debugPrintStack();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _switchProfile(Profile profile) async {
    setState(() => _isLoading = true);
    final l10n = AppLocalizations.of(context);

    try {
      if (profile.useSsh) {
        final conflictPath = await _sshConfigService.getSshConfigConflict(
          profile.host,
          profile.identityFile,
        );

        if (conflictPath != null && mounted) {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(l10n.sshConfigConflictTitle),
              content: Text(
                l10n.sshConfigConflictContent(
                  profile.host,
                  conflictPath,
                  profile.identityFile,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    l10n.continueSwitch,
                    style: const TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
          );

          if (confirmed != true) {
            setState(() => _isLoading = false);
            return;
          }
        }
      }

      final result = await _gitService.switchProfile(
        profile,
        _configService.appConfig.enableBackup,
        _configService.appConfig.maxBackupCount,
      );

      if (mounted) {
        final success = result['git'] == true && result['ssh'] == true;
        final messages = result['messages'] as List<String>;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? l10n.switchSuccess
                  : l10n.switchFailedWithMessages(messages.join('\n')),
            ),
            backgroundColor: success ? Colors.green : Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.switchFailedWithError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      _checkActiveProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _checkActiveProfile,
            tooltip: l10n.refreshTooltip,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _openSettings(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildActiveProfileCard(),
                Expanded(child: _buildProfileList()),
              ],
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _openBackupPage(),
            heroTag: "backup",
            child: const Icon(Icons.backup),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () => _createProfile(),
            heroTag: "create",
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveProfileCard() {
    final l10n = AppLocalizations.of(context);
    final Color cardColor;
    final IconData icon;
    final String title;
    final String subtitle;
    final bool configMatched;

    if (_activeProfile != null) {
      cardColor = Colors.green.shade100;
      icon = Icons.check_circle;
      title = l10n.activeProfileTitle(_activeProfile!.name);
      subtitle = l10n.activeProfileSubtitle;
      configMatched = true;
    } else {
      cardColor = Colors.orange.shade100;
      icon = Icons.warning;
      title = l10n.configMismatchTitle;
      subtitle = l10n.configMismatchSubtitle;
      configMatched = false;
    }

    return Card(
      margin: const EdgeInsets.all(16),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(subtitle, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            if (!configMatched) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _backupCurrentConfig,
                    icon: const Icon(Icons.backup, size: 18),
                    label: Text(l10n.backupCurrentConfig),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: _showConfigDiff,
                    icon: const Icon(Icons.difference, size: 18),
                    label: Text(l10n.viewDiff),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _backupCurrentConfig() async {
    final messages = await _gitService.backupCurrentConfig();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(messages.join('\n')),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _showConfigDiff() async {
    final l10n = AppLocalizations.of(context);
    final profiles = _configService.profiles;
    if (profiles.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.noConfigsToCompare),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    // 收集每个配置的差异摘要
    final diffs = <Profile, List<String>>{};
    for (final profile in profiles) {
      final result = await _gitService.getConfigDiff(profile);
      final differences = (result['differences'] as List).cast<String>();
      diffs[profile] = differences;
    }

    if (!mounted) return;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.viewConfigDiffTitle),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: diffs.entries.map((entry) {
              final profile = entry.key;
              final differences = entry.value;
              return ListTile(
                dense: true,
                leading: Icon(
                  differences.isEmpty
                      ? Icons.check_circle
                      : Icons.error_outline,
                  color: differences.isEmpty ? Colors.green : Colors.orange,
                ),
                title: Text(
                  profile.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  differences.isEmpty
                      ? l10n.configMatches
                      : differences.join('\n'),
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () => _showProfileDiffDetail(profile),
              );
            }).toList(),
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

  Future<void> _showProfileDiffDetail(Profile profile) async {
    final l10n = AppLocalizations.of(context);
    final result = await _gitService.getConfigDiff(profile);
    final differences = (result['differences'] as List).cast<String>();
    final currentGitConfig = result['currentGitConfig'] as String?;
    final profileGitConfig = result['profileGitConfig'] as String?;

    if (!mounted) return;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.profileDiffTitle(profile.name)),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: DefaultTabController(
            length: 2,
            child: differences.isEmpty
                ? Column(
                    children: [
                      Text(
                        l10n.configMatchesFull,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: _buildConfigContentView(
                          profileGitConfig ?? l10n.noTargetConfig,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.diffItems,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...differences.map(
                                (d) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    '• $d',
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TabBar(
                        tabs: [
                          Tab(text: l10n.currentConfigTab),
                          Tab(text: l10n.targetConfigTab),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildConfigContentView(
                              currentGitConfig ?? l10n.noCurrentGitConfig,
                            ),
                            _buildConfigContentView(
                              profileGitConfig ?? l10n.noTargetConfig,
                            ),
                          ],
                        ),
                      ),
                    ],
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

  Widget _buildConfigContentView(String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        child: Text(
          content,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildProfileList() {
    final l10n = AppLocalizations.of(context);
    final profiles = _configService.profiles;

    if (profiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              l10n.noProfiles,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(l10n.clickToCreateProfile),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        final profile = profiles[index];
        final bool isActive = _activeProfile?.id == profile.id;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: isActive
                ? Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.person, color: Colors.grey),
            title: Text(
              profile.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (profile.host.isNotEmpty)
                  Text(l10n.platformLabel(profile.host)),
                Text(
                  profile.useSsh
                      ? l10n.sshEnabledStatus
                      : l10n.sshDisabledStatus,
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.swap_horiz, color: Colors.green),
                  onPressed: () => _switchProfile(profile),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editProfile(profile),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteProfile(profile),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _createProfile() async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ProfileEditPage()));

    if (result == true) {
      setState(() {});
      _checkActiveProfile();
    }
  }

  void _editProfile(Profile profile) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfileEditPage(profile: profile),
      ),
    );

    if (result == true) {
      setState(() {});
      _checkActiveProfile();
    }
  }

  void _deleteProfile(Profile profile) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeleteTitle),
        content: Text(l10n.confirmDeleteContent(profile.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _configService.deleteProfile(profile.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? l10n.deleteSuccess : l10n.deleteFailed),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
        if (success) {
          setState(() {});
          _checkActiveProfile();
        }
      }
    }
  }

  void _openBackupPage() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const BackupPage()));
    _checkActiveProfile();
  }

  void _openSettings() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SettingsPage()));
  }
}