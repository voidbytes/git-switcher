import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../l10n/localization_service.dart';
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
  String _languageCode = 'system';

  @override
  void initState() {
    super.initState();
    final config = _configService.appConfig;
    _enableBackup = config.enableBackup;
    _maxBackupController.text = config.maxBackupCount.toString();
    _minimizeToTray = config.minimizeToTray;
    _languageCode = config.languageCode ?? 'system';
  }

  @override
  void dispose() {
    _maxBackupController.dispose();
    super.dispose();
  }

  String _langLabel(AppLocalizations l10n, String code) {
    switch (code) {
      case 'system':
        return l10n.languageSystem;
      case 'zh':
        return l10n.langZhSimplified;
      case 'zh_Hant':
        return l10n.langZhTraditional;
      case 'en':
        return l10n.langEnglish;
      case 'fr':
        return l10n.langFrench;
      case 'de':
        return l10n.langGerman;
      case 'es':
        return l10n.langSpanish;
      case 'ja':
        return l10n.langJapanese;
      case 'ko':
        return l10n.langKorean;
      case 'ru':
        return l10n.langRussian;
      case 'pt':
        return l10n.langPortuguese;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildSettings(l10n),
    );
  }

  Widget _buildSettings(AppLocalizations l10n) {
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
                  Text(
                    l10n.generalSettings,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text(l10n.minimizeToTray),
                    subtitle: Text(l10n.minimizeToTraySubtitle),
                    value: _minimizeToTray,
                    onChanged: (value) {
                      setState(() => _minimizeToTray = value);
                    },
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _languageCode,
                    decoration: InputDecoration(
                      labelText: l10n.language,
                      border: const OutlineInputBorder(),
                    ),
                    items: kSupportedLanguageCodes
                        .map(
                          (code) => DropdownMenuItem(
                            value: code,
                            child: Text(_langLabel(l10n, code)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _languageCode = value);
                      }
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
                  Text(
                    l10n.backupSettings,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  SwitchListTile(
                    title: Text(l10n.enableAutoBackup),
                    subtitle: Text(l10n.enableAutoBackupSubtitle),
                    value: _enableBackup,
                    onChanged: (value) {
                      setState(() => _enableBackup = value);
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _maxBackupController,
                    decoration: InputDecoration(
                      labelText: l10n.maxBackupCount,
                      border: const OutlineInputBorder(),
                      helperText: l10n.maxBackupCountHelper,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.enterBackupCount;
                      }
                      final num = int.tryParse(value);
                      if (num == null || num < 1 || num > 50) {
                        return l10n.backupCountRange;
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
                  child: Text(l10n.cancel),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  child: Text(l10n.save),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveSettings() async {
    final l10n = AppLocalizations.of(context);
    final maxBackupText = _maxBackupController.text.trim();
    if (maxBackupText.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.enterMaxBackupCount)));
      return;
    }

    final maxBackup = int.tryParse(maxBackupText);
    if (maxBackup == null || maxBackup < 1 || maxBackup > 50) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.maxBackupCountRange)));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final newConfig = _configService.appConfig.copyWith(
        enableBackup: _enableBackup,
        maxBackupCount: maxBackup,
        minimizeToTray: _minimizeToTray,
        languageCode: _languageCode == 'system' ? null : _languageCode,
      );

      final success = await _configService.updateAppConfig(newConfig);
      applyLocale(newConfig.languageCode);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? l10n.settingsSaved : l10n.saveFailed),
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
        ).showSnackBar(SnackBar(content: Text(l10n.saveFailedWithError(e.toString()))));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}