import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/profile.dart';
import '../services/config_service.dart';
import '../services/file_service.dart';
import '../services/path_service.dart';

/// 首次启动引导页（规格 5.6）。
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _nameController = TextEditingController();
  bool _imported = false;
  bool _demoImported = false;
  String? _gitconfig;
  String? _sshconfig;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _importSystemConfig() async {
    final fileService = FileService.instance;
    final pathService = PathService.instance;
    final git = await fileService.readFile(pathService.gitConfigPath);
    final ssh = await fileService.readFile(pathService.sshConfigPath);

    setState(() {
      _imported = true;
      _gitconfig = git;
      _sshconfig = ssh;
      if (_nameController.text.isEmpty) {
        _nameController.text = _sshconfig != null ? '工作账号' : '个人账号';
      }
    });
  }

  /// 无账号体验：一键导入 2 个示例配置（规格 5.6，供商店认证测试使用）。
  Future<void> _importDemo() async {
    final configService = ConfigService.instance;
    final l10n = AppLocalizations.of(context);
    final demoProfiles = [
      Profile(
        name: l10n.demoProfileWorkName,
        gitconfig:
            '[user]\n\tname = Alex Johnson\n\temail = alex.johnson@company.example.com\n',
      ),
      Profile(
        name: l10n.demoProfilePersonalName,
        gitconfig:
            '[user]\n\tname = Alex\n\temail = alex.personal@gmail.com\n',
      ),
    ];
    for (final profile in demoProfiles) {
      await configService.addProfile(profile);
    }
    if (mounted) {
      setState(() => _demoImported = true);
    }
  }

  Future<void> _finish() async {
    final configService = ConfigService.instance;

    if (_imported && (_gitconfig?.isNotEmpty ?? false)) {
      await configService.addProfile(
        Profile(
          name: _nameController.text.trim().isEmpty
              ? '默认配置'
              : _nameController.text.trim(),
          gitconfig: _gitconfig!,
          useSsh: _sshconfig != null,
          sshconfig: _sshconfig ?? '',
        ),
      );
    }

    await configService.updateOnboarded(true);
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<void> _skip() async {
    await ConfigService.instance.updateOnboarded(true);
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.swap_horiz, size: 72),
            const SizedBox(height: 16),
            Text(
              l10n.onboardingWelcome,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.onboardingSubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 32),
            if (_imported) ...[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.onboardingNameHint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.onboardingImportDone,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.green),
              ),
            ] else
              ElevatedButton.icon(
                onPressed: _importSystemConfig,
                icon: const Icon(Icons.download),
                label: Text(l10n.onboardingImport),
              ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _demoImported ? null : _importDemo,
              icon: const Icon(Icons.science_outlined),
              label: Text(l10n.onboardingDemoButton),
            ),
            const SizedBox(height: 8),
            Text(
              _demoImported
                  ? l10n.onboardingDemoDone
                  : l10n.onboardingDemoHint,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: _demoImported ? Colors.green : Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _skip,
                    child: Text(l10n.onboardingSkip),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _finish,
                    child: Text(l10n.onboardingFinish),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}