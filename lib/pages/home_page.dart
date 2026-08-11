import 'package:flutter/material.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('切换失败: $e'), backgroundColor: Colors.red),
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
              title: const Text('SSH 配置冲突'),
              content: Text(
                '检测到当前系统中针对主机 "${profile.host}" 的 SSH 私钥路径为:\n\n$conflictPath\n\n您希望将其更改为:\n\n${profile.identityFile}\n\n是否继续？',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    '继续切换',
                    style: TextStyle(color: Colors.orange),
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
            content: Text(success ? '切换成功' : '切换失败\n${messages.join('\n')}'),
            backgroundColor: success ? Colors.green : Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('切换失败: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      _checkActiveProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Git账号切换器'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _checkActiveProfile,
            tooltip: '刷新当前配置状态',
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
    final Color cardColor;
    final IconData icon;
    final String title;
    final String subtitle;
    final bool configMatched;

    if (_activeProfile != null) {
      cardColor = Colors.green.shade100;
      icon = Icons.check_circle;
      title = '当前激活: ${_activeProfile!.name}';
      subtitle = '系统配置与所选配置一致';
      configMatched = true;
    } else {
      cardColor = Colors.orange.shade100;
      icon = Icons.warning;
      title = '配置不一致提醒';
      subtitle = '当前系统配置与本软件中的配置不匹配，建议先备份当前配置并查看差异。';
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
                    label: const Text('备份当前配置'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: _showConfigDiff,
                    icon: const Icon(Icons.difference, size: 18),
                    label: const Text('查看差异'),
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
    final profiles = _configService.profiles;
    if (profiles.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('暂无配置可对比'),
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
        title: const Text('查看配置差异'),
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
                      ? '与当前配置一致'
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
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  Future<void> _showProfileDiffDetail(Profile profile) async {
    final result = await _gitService.getConfigDiff(profile);
    final differences = (result['differences'] as List).cast<String>();
    final currentGitConfig = result['currentGitConfig'] as String?;
    final profileGitConfig = result['profileGitConfig'] as String?;

    if (!mounted) return;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${profile.name} 配置差异'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: DefaultTabController(
            length: 2,
            child: differences.isEmpty
                ? Column(
                    children: [
                      const Text(
                        '该配置与当前配置一致',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: _buildConfigContentView(
                          profileGitConfig ?? '（无目标配置）',
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
                              const Text(
                                '差异项:',
                                style: TextStyle(
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
                      const TabBar(
                        tabs: [Tab(text: '当前配置'), Tab(text: '目标配置')],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildConfigContentView(
                              currentGitConfig ?? '（无当前Git配置）',
                            ),
                            _buildConfigContentView(
                              profileGitConfig ?? '（无目标配置）',
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
            child: const Text('关闭'),
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
    final profiles = _configService.profiles;

    if (profiles.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('暂无配置', style: TextStyle(fontSize: 18, color: Colors.grey)),
            Text('点击右下角按钮创建第一个配置'),
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
                if (profile.host.isNotEmpty) Text('平台: ${profile.host}'),
                Text('SSH: ${profile.useSsh ? '启用' : '禁用'}'),
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除配置 "${profile.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _configService.deleteProfile(profile.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? '删除成功' : '删除失败'),
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
