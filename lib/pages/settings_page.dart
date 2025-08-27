import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/app_config.dart';
import '../services/config_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _configService = ConfigService.instance;
  final _maxBackupController = TextEditingController();

  bool _enableBackup = true;
  bool _isLoading = false;
  bool _minimizeToTray = false;

  @override
  void initState() {
    super.initState();
    final config = _configService.appConfig;
    _enableBackup = config.enableBackup;
    _maxBackupController.text = config.maxBackupCount.toString();
    _minimizeToTray = config.minimizeToTray;
  }

  @override
  void dispose() {
    _maxBackupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildSettings(),
    );
  }

  Widget _buildSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '通用设置',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('最小化到托盘'),
                    subtitle: const Text('关闭窗口时，最小化到系统托盘而非退出应用'),
                    value: _minimizeToTray,
                    onChanged: (value) {
                      setState(() => _minimizeToTray = value);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '备份设置',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  SwitchListTile(
                    title: const Text('启用自动备份'),
                    subtitle: const Text('切换配置时自动备份当前配置'),
                    value: _enableBackup,
                    onChanged: (value) {
                      setState(() => _enableBackup = value);
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _maxBackupController,
                    decoration: const InputDecoration(
                      labelText: '最大备份数量',
                      border: OutlineInputBorder(),
                      helperText: '超出此数量将自动删除最旧的备份 (1-50)',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入备份数量';
                      }
                      final num = int.tryParse(value);
                      if (num == null || num < 1 || num > 50) {
                        return '请输入1-50之间的数字';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),

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
                  onPressed: _saveSettings,
                  child: const Text('保存'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveSettings() async {
    final maxBackupText = _maxBackupController.text.trim();
    if (maxBackupText.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入最大备份数量')));
      return;
    }

    final maxBackup = int.tryParse(maxBackupText);
    if (maxBackup == null || maxBackup < 1 || maxBackup > 50) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('最大备份数量必须在1-50之间')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final newConfig = AppConfig(
        enableBackup: _enableBackup,
        maxBackupCount: maxBackup,
        minimizeToTray: _minimizeToTray,
      );

      final success = await _configService.updateAppConfig(newConfig);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? '设置已保存' : '保存失败'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );

        if (success) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存失败: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
