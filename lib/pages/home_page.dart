import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/profile.dart';
import '../services/config_service.dart';
import '../services/git_service.dart';
import 'key_gen_page.dart';
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
        setState(() => _activeProfile = activeProfile);
      }
    } catch (e) {
      debugPrint('识别活跃配置失败: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _switchProfile(Profile profile) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isLoading = true);

    try {
      // 覆盖确认：仅 use_ssh 且当前 ~/.ssh/config 非本工具管理时。
      if (profile.useSsh && await _gitService.isUnmanagedSshConfig()) {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.overwriteSshTitle),
            content: Text(l10n.overwriteSshContent),
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

      final result = await _gitService.switchProfile(
        profile,
        _configService.appConfig.enableBackup,
        _configService.appConfig.maxBackupCount,
      );

      if (!mounted) return;

      if (result.success) {
        // 成功 → 自动验证。
        final verify = await _gitService.verifyAfterSwitch(profile);
        final verified = verify['verified'] == true;
        _showMessage(
          verified ? l10n.switchVerified : l10n.switchWrittenNotVerified,
          verified ? Colors.green : Colors.orange,
        );
      } else {
        _showMessage(
          l10n.switchFailedWithMessages(result.messages.join('\n')),
          Colors.red,
        );
      }
    } catch (e) {
      if (mounted) {
        _showMessage(l10n.switchFailedWithError(e.toString()), Colors.red);
      }
    } finally {
      _checkActiveProfile();
    }
  }

  Future<void> _undoLastSwitch() async {
    final l10n = AppLocalizations.of(context);
    final (done, error) = await _gitService.undoLastSwitch();
    if (mounted) {
      if (done) {
        _showMessage(l10n.undoSuccess, Colors.green);
      } else if (error != null) {
        _showMessage(error, Colors.red);
      } else {
        _showMessage(l10n.undoNothing, Colors.orange);
      }
    }
    _checkActiveProfile();
  }

  void _showMessage(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
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
            onPressed: () => _openKeyGen(),
            heroTag: "keygen",
            tooltip: l10n.keyManagementTitle,
            child: const Icon(Icons.vpn_key),
          ),
          const SizedBox(height: 16),
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

    final hasSnapshot = _configService.appConfig.lastSwitchSnapshot != null;

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
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: hasSnapshot ? _undoLastSwitch : null,
                  icon: const Icon(Icons.undo, size: 18),
                  label: Text(l10n.undoLastSwitch),
                ),
                if (!configMatched) ...[
                  const SizedBox(width: 8),
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _backupCurrentConfig() async {
    final messages = await _gitService.backupCurrentConfig();
    if (mounted) {
      _showMessage(messages.join('\n'), Colors.green);
    }
  }

  Future<void> _showConfigDiff() async {
    final l10n = AppLocalizations.of(context);
    final profiles = _configService.profiles;
    if (profiles.isEmpty) {
      _showMessage(l10n.noConfigsToCompare, Colors.orange);
      return;
    }
    if (!mounted) return;

    Profile? selected = _activeProfile ?? profiles.first;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.viewConfigDiffTitle),
        content: SizedBox(
          width: double.maxFinite,
          child: DropdownButton<Profile>(
            value: selected,
            isExpanded: true,
            items: profiles
                .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                .toList(),
            onChanged: (v) => selected = v,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (selected != null) _showProfileDiffDetail(selected!);
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  Future<void> _showProfileDiffDetail(Profile profile) async {
    final l10n = AppLocalizations.of(context);
    final result = await _gitService.getConfigDiff(profile);
    final gitDiff = (result['gitDiff'] as List).cast<ConfigDiffEntry>();
    final sshDiff = (result['sshDiff'] as List).cast<ConfigDiffEntry>();
    final currentGit = result['currentGitConfig'] as String?;
    final profileGit = result['profileGitConfig'] as String?;
    final currentSsh = result['currentSshConfig'] as String?;
    final profileSsh = result['profileSshConfig'] as String?;

    if (!mounted) return;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.profileDiffTitle(profile.name)),
        content: SizedBox(
          width: double.maxFinite,
          height: 480,
          child: DefaultTabController(
            length: profile.useSsh ? 2 : 1,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(text: l10n.gitConfigType),
                    if (profile.useSsh) Tab(text: l10n.sshConfigType),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildDiffContent(l10n, gitDiff, currentGit, profileGit),
                      if (profile.useSsh)
                        _buildDiffContent(l10n, sshDiff, currentSsh, profileSsh),
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

  Widget _buildDiffContent(
    AppLocalizations l10n,
    List<ConfigDiffEntry> diff,
    String? current,
    String? target,
  ) {
    return Column(
      children: [
        if (diff.isEmpty)
          Expanded(
            child: Center(
              child: Text(
                l10n.configMatchesFull,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
        else
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: diff.map((d) {
                final Color color;
                final String text;
                if (d.oldContent.isEmpty) {
                  color = Colors.green;
                  text = '+ ${d.newContent}';
                } else if (d.newContent.isEmpty) {
                  color = Colors.red;
                  text = '- ${d.oldContent}';
                } else {
                  color = Colors.orange;
                  text = '~ ${d.oldContent}  →  ${d.newContent}';
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    '$text  (L${d.lineNumber})',
                    style: TextStyle(color: color, fontSize: 12),
                  ),
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildConfigView(l10n.currentConfigTab, current ?? ''),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildConfigView(l10n.targetConfigTab, target ?? ''),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConfigView(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          height: 120,
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: SingleChildScrollView(
            child: Text(
              content,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
            ),
          ),
        ),
      ],
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
                Text(_gitSummary(profile.gitconfig)),
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

  String _gitSummary(String gitconfig) {
    final name = RegExp(
      r'^\s*name\s*=\s*(.+)$',
      multiLine: true,
    ).firstMatch(gitconfig)?.group(1)?.trim();
    final email = RegExp(
      r'^\s*email\s*=\s*(.+)$',
      multiLine: true,
    ).firstMatch(gitconfig)?.group(1)?.trim();
    return '${name ?? '(无 name)'} <${email ?? ''}>';
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
        _showMessage(
          success ? l10n.deleteSuccess : l10n.deleteFailed,
          success ? Colors.green : Colors.red,
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

  void _openKeyGen() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const KeyGenPage()));
  }

  void _openSettings() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SettingsPage()));
  }
}