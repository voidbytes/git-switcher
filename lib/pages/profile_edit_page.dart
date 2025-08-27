import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
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
    } else {
      _hostController.text = 'github.com';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _gitconfigController.dispose();
    _hostController.dispose();
    _identityFileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profile == null ? '新建配置' : '修改配置'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildForm(),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '配置名称',
                border: OutlineInputBorder(),
                helperText: '例如：工作账号、个人账号',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入配置名称';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Text('Git 配置内容', style: TextStyle(fontSize: 16)),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text('导入现有配置'),
                  onPressed: _importGitConfig,
                ),
              ],
            ),
            TextFormField(
              controller: _gitconfigController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                helperText: '粘贴 .gitconfig 内容或配置片段',
              ),
              maxLines: 8,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入Git配置内容';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('启用 SSH'),
              subtitle: const Text('为此配置启用SSH密钥认证'),
              value: _useSsh,
              onChanged: (value) {
                setState(() => _useSsh = value);
              },
            ),
            if (_useSsh) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _hostController,
                decoration: const InputDecoration(
                  labelText: '主机名',
                  border: OutlineInputBorder(),
                  helperText: '例如：github.com, gitlab.com',
                ),
                validator: _useSsh
                    ? (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '启用SSH时必须指定主机名';
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
                      decoration: const InputDecoration(
                        labelText: 'SSH 私钥路径',
                        border: OutlineInputBorder(),
                        helperText: '例如：~/.ssh/id_rsa_work',
                      ),
                      validator: _useSsh
                          ? (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '启用SSH时必须指定私钥路径';
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
                    tooltip: '选择私钥文件',
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
                    child: const Text('取消'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text('保存'),
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
    final gitConfigPath = PathService.instance.gitConfigPath;
    final content = await FileService.instance.readFile(gitConfigPath);
    if (content != null) {
      _gitconfigController.text = content;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('成功导入当前 .gitconfig 配置'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('未找到 .gitconfig 文件或读取失败'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _pickPrivateKeyFile() async {
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
        ).showSnackBar(SnackBar(content: Text('选择文件失败: $e')));
      }
    }
  }

  void _saveProfile() async {
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
        host: _useSsh ? _hostController.text.trim() : '',
        identityFile: _useSsh ? _identityFileController.text.trim() : '',
      );

      final success = widget.profile == null
          ? await ConfigService.instance.addProfile(profile)
          : await ConfigService.instance.updateProfile(profile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? '保存成功' : '保存失败'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );

        if (success) {
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      _showErrorSnackBar('保存失败: $e');
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
