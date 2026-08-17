import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../services/config_service.dart';
import '../services/key_gen_service.dart';
import '../services/path_service.dart';

/// 密钥生成页（规格 5.3）。
class KeyGenPage extends StatefulWidget {
  /// 生成成功后回填 IdentityFile 行的回调（由父页面传入）。
  final void Function(String? identityFileLine)? onIdentityFileFilled;

  const KeyGenPage({super.key, this.onIdentityFileFilled});

  @override
  State<KeyGenPage> createState() => _KeyGenPageState();
}

class _KeyGenPageState extends State<KeyGenPage> {
  final _keyGenService = KeyGenService.instance;
  final _pathService = PathService.instance;
  final _configService = ConfigService.instance;
  final _identifierController = TextEditingController();
  final _emailController = TextEditingController();
  final _passphraseController = TextEditingController();
  final _keygenPathController = TextEditingController();

  KeyAlgorithm _algorithm = KeyAlgorithm.ed25519;
  bool _isGenerating = false;
  String? _privateKeyPath;
  String? _publicKey;

  /// ssh-keygen 检测结果（null = 尚未检测）。
  SshKeygenInfo? _keygenInfo;

  @override
  void initState() {
    super.initState();
    _detectKeygen();
  }

  /// 页面加载时自动检测 ssh-keygen 可用性，并回填已保存的自定义路径。
  Future<void> _detectKeygen() async {
    final savedPath = _configService.appConfig.sshKeygenPath;
    if (savedPath != null && savedPath.trim().isNotEmpty) {
      _keygenPathController.text = savedPath.trim();
    }
    final info = await _keyGenService.detectSshKeygen(customPath: savedPath);
    if (!mounted) return;
    setState(() => _keygenInfo = info);
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _emailController.dispose();
    _passphraseController.dispose();
    _keygenPathController.dispose();
    super.dispose();
  }

  /// 校验用户输入的路径并保存为自定义路径。
  Future<void> _verifyKeygenPath() async {
    final l10n = AppLocalizations.of(context);
    final path = _keygenPathController.text.trim();
    if (path.isEmpty) {
      // 空路径 = 使用自动检测 / PATH 默认。
      final info = await _keyGenService.detectSshKeygen();
      if (!mounted) return;
      setState(() => _keygenInfo = info);
      await _saveKeygenPath(null);
      _showMessage(
        info.available ? l10n.keygenDetectedAt(info.path!) : l10n.keygenNotFound,
        info.available ? Colors.green : Colors.red,
      );
      return;
    }

    final available = await _keyGenService.validateSshKeygen(path);
    if (!mounted) return;
    setState(() {
      _keygenInfo = SshKeygenInfo(
        available: available,
        path: path,
        custom: true,
        error: available ? null : l10n.keygenPathInvalid(path),
      );
    });
    await _saveKeygenPath(available ? path : null);
    _showMessage(
      available ? l10n.keygenPathValid(path) : l10n.keygenPathInvalid(path),
      available ? Colors.green : Colors.red,
    );
  }

  /// 保存（或清除）自定义 ssh-keygen 路径。
  Future<void> _saveKeygenPath(String? path) async {
    await _configService.updateAppConfig(
      _configService.appConfig.copyWith(sshKeygenPath: path),
    );
  }

  /// 恢复自动检测（清除自定义路径）。
  Future<void> _resetKeygenPath() async {
    await _saveKeygenPath(null);
    final info = await _keyGenService.detectSshKeygen();
    if (!mounted) return;
    setState(() {
      _keygenPathController.text = info.path ?? '';
      _keygenInfo = info;
    });
  }

  /// 通过文件选择器选择 ssh-keygen 可执行文件。
  Future<void> _browseKeygenPath() async {
    final l10n = AppLocalizations.of(context);
    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: l10n.keygenBrowseBtn,
        type: FileType.custom,
        allowedExtensions: Platform.isWindows ? ['exe'] : null,
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;
        if (file.path != null) {
          _keygenPathController.text = file.path!;
          await _verifyKeygenPath();
        }
      }
    } catch (e) {
      _showMessage(l10n.pickFileFailed(e.toString()), Colors.red);
    }
  }

  Future<void> _generate() async {
    final l10n = AppLocalizations.of(context);
    final identifier = _identifierController.text.trim();

    if (!_keyGenService.validateIdentifier(identifier)) {
      _showMessage(l10n.keyIdentifierInvalid, Colors.red);
      return;
    }

    final email = _emailController.text.trim();
    if (email.isNotEmpty && !email.contains('@')) {
      _showMessage(l10n.keyEmailInvalid, Colors.red);
      return;
    }

    // 生成前再次确认 ssh-keygen 可用（使用已保存路径或自动检测）。
    final keygenPath = _configService.appConfig.sshKeygenPath;
    final keygenAvailable = keygenPath != null && keygenPath.isNotEmpty
        ? await _keyGenService.validateSshKeygen(keygenPath)
        : await _keyGenService.isSshKeygenAvailable();
    if (!keygenAvailable) {
      _showMessage(l10n.keygenUnavailable, Colors.red);
      return;
    }

    setState(() => _isGenerating = true);
    try {
      final result = await _keyGenService.generateKeyPair(
        algorithm: _algorithm,
        identifier: identifier,
        email: email,
        passphrase: _passphraseController.text,
        sshKeygenPath: keygenPath,
      );

      if (result['message'] == 'exists') {
        if (!mounted) return;
        final overwrite = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.keyExistsTitle),
            content: Text(l10n.keyExistsContent(result['privateKey'])),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.continueSwitch),
              ),
            ],
          ),
        );
        if (overwrite == true) {
          await _forceGenerate(identifier, email);
        }
      } else if (result['success'] == true) {
        setState(() {
          _privateKeyPath = result['privateKey'] as String?;
          _publicKey = result['publicKey'] as String?;
        });
        _showMessage(l10n.keygenSuccess, Colors.green);
        if (_passphraseController.text.isNotEmpty) {
          _showMessage(l10n.passphraseReminder, Colors.orange);
        }
      } else {
        _showMessage(l10n.keygenFailed(result['message']), Colors.red);
      }
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _forceGenerate(String identifier, String email) async {
    final l10n = AppLocalizations.of(context);
    // 用户确认覆盖：先删除同名私钥/公钥文件，再重新生成。
    final keyName = _algorithm == KeyAlgorithm.ed25519
        ? 'id_ed25519_$identifier'
        : 'id_rsa_$identifier';
    for (final suffix in ['', '.pub']) {
      final f = File('${_pathService.sshDir}/$keyName$suffix');
      if (f.existsSync()) {
        await f.delete();
      }
    }
    final result = await _keyGenService.generateKeyPair(
      algorithm: _algorithm,
      identifier: identifier,
      email: email,
      passphrase: _passphraseController.text,
      sshKeygenPath: _configService.appConfig.sshKeygenPath,
    );
    if (result['success'] == true) {
      setState(() {
        _privateKeyPath = result['privateKey'] as String?;
        _publicKey = result['publicKey'] as String?;
      });
      _showMessage(l10n.keygenSuccess, Colors.green);
    } else {
      _showMessage(l10n.keygenFailed(result['message']), Colors.red);
    }
  }

  void _copyPublicKey() {
    final l10n = AppLocalizations.of(context);
    if (_publicKey == null) return;
    Clipboard.setData(ClipboardData(text: _publicKey!));
    _showMessage(l10n.publicKeyCopied, Colors.green);
  }

  void _fillCurrentConfig() {
    final l10n = AppLocalizations.of(context);
    final identifier = _identifierController.text.trim();
    final line = _keyGenService.identityFileLine(_algorithm, identifier);
    widget.onIdentityFileFilled?.call(line);
    _showMessage(l10n.fillIdentityFileDone, Colors.green);
    Navigator.of(context).pop();
  }

  void _showMessage(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.keyManagementTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isGenerating
          ? const Center(child: CircularProgressIndicator())
          : _buildForm(l10n),
    );
  }

  Widget _buildKeygenSection(AppLocalizations l10n) {
    final info = _keygenInfo;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  info == null
                      ? Icons.sync
                      : info.available
                          ? Icons.check_circle
                          : Icons.error_outline,
                  color: info == null
                      ? Colors.grey
                      : info.available
                          ? Colors.green
                          : Colors.red,
                ),
                const SizedBox(width: 8),
                Expanded(child: _buildKeygenStatusText(l10n, info)),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _keygenPathController,
              decoration: InputDecoration(
                labelText: l10n.keygenPathLabel,
                hintText: l10n.keygenPathHint,
                border: const OutlineInputBorder(),
                isDense: true,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.folder_open),
                  tooltip: l10n.keygenBrowseBtn,
                  onPressed: _browseKeygenPath,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _verifyKeygenPath,
                    icon: const Icon(Icons.verified),
                    label: Text(l10n.keygenVerifyBtn),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _resetKeygenPath,
                    icon: const Icon(Icons.restart_alt),
                    label: Text(l10n.keygenResetBtn),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeygenStatusText(AppLocalizations l10n, SshKeygenInfo? info) {
    if (info == null) {
      return Text(l10n.keygenDetecting, style: const TextStyle(fontSize: 14));
    }
    if (info.available && info.path != null) {
      return Text(
        l10n.keygenDetectedAt(info.path!),
        style: const TextStyle(fontSize: 14),
      );
    }
    return Text(
      info.error ?? l10n.keygenNotFound,
      style: const TextStyle(fontSize: 14, color: Colors.red),
    );
  }

  Widget _buildForm(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildKeygenSection(l10n),
          const SizedBox(height: 16),
          TextFormField(
            controller: _identifierController,
            decoration: InputDecoration(
              labelText: l10n.keyIdentifier,
              border: const OutlineInputBorder(),
              helperText: l10n.keyIdentifierHelper,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: l10n.keyEmail,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passphraseController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: l10n.keyPassphrase,
              border: const OutlineInputBorder(),
              helperText: l10n.keyPassphraseHelper,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<KeyAlgorithm>(
            initialValue: _algorithm,
            decoration: InputDecoration(
              labelText: l10n.keyAlgorithmLabel,
              border: const OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: KeyAlgorithm.ed25519,
                child: Text('ed25519'),
              ),
              DropdownMenuItem(value: KeyAlgorithm.rsa, child: Text('rsa (4096)')),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _algorithm = value);
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _generate,
            icon: const Icon(Icons.vpn_key),
            label: Text(l10n.generateKey),
          ),
          if (_privateKeyPath != null && _publicKey != null) ...[
            const SizedBox(height: 24),
            Text(l10n.privateKeyPath),
            const SizedBox(height: 4),
            SelectableText(
              _privateKeyPath!,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
            const SizedBox(height: 16),
            Text(l10n.publicKey),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxHeight: 160),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  _publicKey!,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _copyPublicKey,
                    icon: const Icon(Icons.copy),
                    label: Text(l10n.copyPublicKey),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _fillCurrentConfig,
                    icon: const Icon(Icons.input),
                    label: Text(l10n.fillIdentityFile),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}