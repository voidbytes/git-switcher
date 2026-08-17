import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/profile.dart';
import '../services/config_service.dart';
import '../services/file_service.dart';
import '../services/path_service.dart';
import '../services/ssh_template_service.dart';
import 'key_gen_page.dart';

/// 新建/编辑配置页（规格 5.2）。
class ProfileEditPage extends StatefulWidget {
  final Profile? profile;

  const ProfileEditPage({super.key, this.profile});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _gitconfigController = TextEditingController();
  final _sshconfigController = TextEditingController();

  bool _useSsh = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.profile != null) {
      _nameController.text = widget.profile!.name;
      _gitconfigController.text = widget.profile!.gitconfig;
      _useSsh = widget.profile!.useSsh;
      _sshconfigController.text = widget.profile!.sshconfig;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _gitconfigController.dispose();
    _sshconfigController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profile == null ? l10n.newProfile : l10n.editProfile),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildForm(l10n),
    );
  }

  Widget _buildForm(AppLocalizations l10n) {
    final isNew = widget.profile == null;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isNew) ...[
              _buildQuickCreateSection(l10n),
              const Divider(),
            ],
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.configName,
                border: const OutlineInputBorder(),
                helperText: l10n.configNameHelper,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.enterConfigName;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.gitConfigContent,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                if (isNew)
                  TextButton.icon(
                    icon: const Icon(Icons.download),
                    label: Text(l10n.importSystemGit),
                    onPressed: _importGitConfig,
                  ),
              ],
            ),
            TextFormField(
              controller: _gitconfigController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                helperText: l10n.gitconfigHelper,
              ),
              maxLines: 8,
              style: const TextStyle(fontFamily: 'monospace'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.enterGitConfig;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(l10n.enableSsh),
              subtitle: Text(l10n.enableSshSubtitle),
              value: _useSsh,
              onChanged: (value) {
                setState(() => _useSsh = value);
              },
            ),
            if (_useSsh) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.sshConfigContent,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  if (isNew)
                    TextButton.icon(
                      icon: const Icon(Icons.download),
                      label: Text(l10n.importSystemSsh),
                      onPressed: _importSshConfig,
                    ),
                ],
              ),
              TextFormField(
                controller: _sshconfigController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  helperText: l10n.sshConfigHelper,
                ),
                maxLines: 10,
                style: const TextStyle(fontFamily: 'monospace'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.enterSshConfig;
                  }
                  return null;
                },
              ),
              if (_sshconfigController.text.trim().isNotEmpty)
                _buildSshPreview(l10n),
            ],
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.cancel),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    child: Text(l10n.save),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 快捷创建区（仅新建时显示，规格 5.2）。
  Widget _buildQuickCreateSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quickCreateTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.auto_awesome),
              label: Text(l10n.fromTemplate),
              onPressed: _openTemplateSelector,
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.copy_all),
              label: Text(l10n.fromExistingProfile),
              onPressed: _copyExistingProfile,
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.vpn_key),
              label: Text(l10n.generateKeyPair),
              onPressed: _openKeyGen,
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSshPreview(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.sshPreviewTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SelectableText(
            _sshconfigController.text,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// 模板选择器（规格 5.2.1）。
  Future<void> _openTemplateSelector() async {
    final l10n = AppLocalizations.of(context);
    SshProvider? provider;
    ProxyMode mode = ProxyMode.direct;
    final proxyController = TextEditingController(text: '127.0.0.1:7890');

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(l10n.templateProviderTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(l10n.providerGithub),
                      selected: provider == SshProvider.github,
                      onSelected: (_) =>
                          setDialogState(() => provider = SshProvider.github),
                    ),
                    ChoiceChip(
                      label: Text(l10n.providerGitlab),
                      selected: provider == SshProvider.gitlab,
                      onSelected: (_) =>
                          setDialogState(() => provider = SshProvider.gitlab),
                    ),
                    ChoiceChip(
                      label: Text(l10n.providerGitee),
                      selected: provider == SshProvider.gitee,
                      onSelected: (_) =>
                          setDialogState(() => provider = SshProvider.gitee),
                    ),
                    ChoiceChip(
                      label: Text(l10n.providerBlank),
                      selected: provider == SshProvider.blank,
                      onSelected: (_) =>
                          setDialogState(() => provider = SshProvider.blank),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(l10n.templateModeTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SegmentedButton<ProxyMode>(
                  segments: [
                    ButtonSegment(
                      value: ProxyMode.direct,
                      label: Text(l10n.modeDirect),
                    ),
                    ButtonSegment(
                      value: ProxyMode.proxy,
                      label: Text(l10n.modeProxy),
                    ),
                  ],
                  selected: {mode},
                  onSelectionChanged: (s) =>
                      setDialogState(() => mode = s.first),
                ),
                if (mode == ProxyMode.proxy) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: proxyController,
                    decoration: InputDecoration(
                      labelText: l10n.proxyAddress,
                      border: const OutlineInputBorder(),
                      helperText: l10n.proxyAddressHint,
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                if (provider == null) return;
                final identityFile =
                    provider == SshProvider.github
                        ? '~/.ssh/id_ed25519_github'
                        : provider == SshProvider.gitlab
                        ? '~/.ssh/id_ed25519_gitlab'
                        : provider == SshProvider.gitee
                        ? '~/.ssh/id_ed25519_gitee'
                        : '';
                final ssh = SshTemplateService.instance.build(
                  provider: provider!,
                  mode: mode,
                  identityFile: identityFile,
                  proxyAddress: proxyController.text.trim(),
                );
                setState(() {
                  _useSsh = true;
                  _sshconfigController.text = ssh;
                });
                Navigator.of(dialogContext).pop();
                _showMessage(l10n.templateGenerated, Colors.green);
              },
              child: Text(l10n.confirm),
            ),
          ],
        ),
      ),
    );
  }

  /// 从本软件已有 Profile 深拷贝（规格 5.2）。
  Future<void> _copyExistingProfile() async {
    final l10n = AppLocalizations.of(context);
    final profiles = ConfigService.instance.profiles;
    if (profiles.isEmpty) {
      _showMessage(l10n.noProfiles, Colors.orange);
      return;
    }

    Profile? selected = profiles.first;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectProfileToCopy),
        content: DropdownButton<Profile>(
          value: selected,
          isExpanded: true,
          items: profiles
              .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
              .toList(),
          onChanged: (v) => selected = v,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              if (selected != null) {
                setState(() {
                  _nameController.text = '${selected!.name}${l10n.copyProfileSuffix}';
                  _gitconfigController.text = selected!.gitconfig;
                  _useSsh = selected!.useSsh;
                  _sshconfigController.text = selected!.sshconfig;
                });
              }
              Navigator.of(context).pop();
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  void _importGitConfig() async {
    final l10n = AppLocalizations.of(context);
    final content = await FileService.instance.readFile(
      PathService.instance.gitConfigPath,
    );
    if (content != null) {
      setState(() => _gitconfigController.text = content);
      _showMessage(l10n.importGitConfigSuccess, Colors.green);
    } else {
      _showMessage(l10n.importGitConfigFailed, Colors.red);
    }
  }

  void _importSshConfig() async {
    final l10n = AppLocalizations.of(context);
    final content = await FileService.instance.readFile(
      PathService.instance.sshConfigPath,
    );
    if (content != null) {
      setState(() {
        _useSsh = true;
        _sshconfigController.text = content;
      });
      _showMessage(l10n.importSshConfigSuccess, Colors.green);
    } else {
      _showMessage(l10n.importSshConfigFailed, Colors.red);
    }
  }

  Future<void> _openKeyGen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => KeyGenPage(
          onIdentityFileFilled: (line) {
            if (line != null) {
              setState(() {
                _useSsh = true;
                if (_sshconfigController.text.trim().isEmpty) {
                  _sshconfigController.text = 'Host github.com\n';
                }
                _sshconfigController.text =
                    '${_sshconfigController.text}\n  $line';
              });
            }
          },
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final profile = Profile(
        id: widget.profile?.id,
        name: _nameController.text.trim(),
        gitconfig: _gitconfigController.text,
        useSsh: _useSsh,
        sshconfig: _useSsh ? _sshconfigController.text : '',
      );

      final success = widget.profile == null
          ? await ConfigService.instance.addProfile(profile)
          : await ConfigService.instance.updateProfile(profile);

      if (mounted) {
        _showMessage(success ? l10n.saveSuccess : l10n.saveFailed,
            success ? Colors.green : Colors.red);
        if (success) {
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      _showMessage(l10n.saveFailedWithError(e.toString()), Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
}