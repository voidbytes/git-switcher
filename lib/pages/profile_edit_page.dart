import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../l10n/app_localizations.dart';
import '../models/profile.dart';
import '../services/config_service.dart';
import '../services/file_service.dart';
import '../services/path_service.dart';

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
  final _hostController = TextEditingController();
  final _identityFileController = TextEditingController();
  final _sshPortController = TextEditingController();

  bool _useSsh = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.profile != null) {
      _nameController.text = widget.profile!.name;
      _gitconfigController.text = widget.profile!.gitconfig;
      _useSsh = widget.profile!.useSsh;
      _hostController.text = widget.profile!.host;
      _identityFileController.text = widget.profile!.identityFile;
      _sshPortController.text = widget.profile!.sshPort?.toString() ?? '';
    } else {
      _hostController.text = 'github.com';
      _sshPortController.text = '443';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _gitconfigController.dispose();
    _hostController.dispose();
    _identityFileController.dispose();
    _sshPortController.dispose();
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
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                TextButton.icon(
                  icon: const Icon(Icons.download),
                  label: Text(l10n.importExistingConfig),
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
              TextFormField(
                controller: _hostController,
                decoration: InputDecoration(
                  labelText: l10n.hostname,
                  border: const OutlineInputBorder(),
                  helperText: l10n.hostnameHelper,
                ),
                validator: _useSsh
                    ? (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.hostnameRequired;
                        }
                        return null;
                      }
                    : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _sshPortController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.sshPort,
                  border: const OutlineInputBorder(),
                  helperText: l10n.sshPortHelper,
                ),
                validator: _useSsh
                    ? (value) {
                        if (value == null || value.trim().isEmpty) {
                          return null;
                        }
                        final port = int.tryParse(value.trim());
                        if (port == null || port < 1 || port > 65535) {
                          return l10n.portRange;
                        }
                        return null;
                      }
                    : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _identityFileController,
                      decoration: InputDecoration(
                        labelText: l10n.sshPrivateKeyPath,
                        border: const OutlineInputBorder(),
                        helperText: l10n.privateKeyHelper,
                      ),
                      validator: _useSsh
                          ? (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.privateKeyRequired;
                              }
                              return null;
                            }
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.folder_open),
                    onPressed: _pickPrivateKeyFile,
                    tooltip: l10n.pickPrivateKeyTooltip,
                  ),
                ],
              ),
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

  void _importGitConfig() async {
    final l10n = AppLocalizations.of(context);
    final gitConfigPath = PathService.instance.gitConfigPath;
    final content = await FileService.instance.readFile(gitConfigPath);
    if (content != null) {
      _gitconfigController.text = content;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.importGitConfigSuccess),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.importGitConfigFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _pickPrivateKeyFile() async {
    final l10n = AppLocalizations.of(context);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        _identityFileController.text = result.files.first.path ?? '';
        if (Platform.isWindows) {
          _identityFileController.text = _identityFileController.text
              .replaceAll(r'\', r'\\');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.pickFileFailed(e.toString()))));
      }
    }
  }

  void _saveProfile() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final portText = _sshPortController.text.trim();
      final sshPort = _useSsh && portText.isNotEmpty
          ? int.tryParse(portText)
          : null;

      final profile = Profile(
        id: widget.profile?.id,
        name: _nameController.text.trim(),
        gitconfig: _gitconfigController.text,
        useSsh: _useSsh,
        host: _useSsh ? _hostController.text.trim() : '',
        identityFile: _useSsh ? _identityFileController.text.trim() : '',
        sshPort: sshPort,
      );

      final success = widget.profile == null
          ? await ConfigService.instance.addProfile(profile)
          : await ConfigService.instance.updateProfile(profile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? l10n.saveSuccess : l10n.saveFailed),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );

        if (success) {
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      _showErrorSnackBar(l10n.saveFailedWithError(e.toString()));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }
}