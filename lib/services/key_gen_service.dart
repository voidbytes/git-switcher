import 'dart:io';
import 'log_service.dart';
import 'path_service.dart';

/// 密钥生成算法。
enum KeyAlgorithm { ed25519, rsa }

/// ssh-keygen 检测结果。
class SshKeygenInfo {
  /// 是否可用。
  final bool available;

  /// 实际路径（可用时），或 null。
  final String? path;

  /// 是否为用户自定义路径。
  final bool custom;

  /// 错误信息（不可用时）。
  final String? error;

  const SshKeygenInfo({
    required this.available,
    this.path,
    this.custom = false,
    this.error,
  });
}

/// 密钥生成服务（规格 5.3 / 8）。
///
/// 支持自动检测 ssh-keygen 位置、验证自定义路径、生成 ed25519 / rsa 密钥对。
class KeyGenService {
  static KeyGenService? _instance;
  static KeyGenService get instance => _instance ??= KeyGenService._();
  KeyGenService._();

  final _pathService = PathService.instance;

  static final RegExp identifierRe = RegExp(r'^[A-Za-z0-9_-]+$');

  bool validateIdentifier(String identifier) => identifierRe.hasMatch(identifier);

  // ---------------------------------------------------------------------------
  // ssh-keygen 路径检测与校验
  // ---------------------------------------------------------------------------

  /// 自动检测 ssh-keygen 位置。
  ///
  /// 依次尝试：
  /// 1. [customPath]（非空时）—— 用户自定义路径
  /// 2. `which ssh-keygen`（Unix）或 `where ssh-keygen`（Windows）
  /// 3. 直接运行 `ssh-keygen -?` 验证
  Future<SshKeygenInfo> detectSshKeygen({String? customPath}) async {
    // 1. 用户自定义路径
    if (customPath != null && customPath.trim().isNotEmpty) {
      final path = customPath.trim();
      final valid = await _validateSshKeygenAt(path);
      if (valid) {
        Log.instance.info('使用自定义 ssh-keygen 路径: $path', tag: 'KeyGen');
        return SshKeygenInfo(available: true, path: path, custom: true);
      }
      return SshKeygenInfo(
        available: false,
        path: path,
        custom: true,
        error: '自定义路径不可用: $path',
      );
    }

    // 2. 通过 PATH 搜索
    try {
      final whichCmd = Platform.isWindows ? 'where' : 'which';
      final result = await Process.run(whichCmd, ['ssh-keygen']);
      if (result.exitCode == 0) {
        final path = result.stdout.toString().trim().split('\n').first.trim();
        if (path.isNotEmpty) {
          Log.instance.info('自动检测到 ssh-keygen: $path', tag: 'KeyGen');
          return SshKeygenInfo(available: true, path: path);
        }
      }
    } catch (e) {
      Log.instance.debug('which/where 查找失败: $e', tag: 'KeyGen');
    }

    // 3. 直接运行 ssh-keygen -? 验证
    final available = await _validateSshKeygenAt('ssh-keygen');
    Log.instance.info(
      available ? 'ssh-keygen 可用（PATH 默认）' : 'ssh-keygen 不可用',
      tag: 'KeyGen',
    );
    return SshKeygenInfo(
      available: available,
      path: available ? 'ssh-keygen' : null,
      error: available ? null : '未找到 ssh-keygen，请安装 OpenSSH 客户端',
    );
  }

  /// 校验指定路径的 ssh-keygen 是否可用。
  /// 使用文件存在性 + 可执行性校验（ssh-keygen 无合法无操作参数）。
  Future<bool> _validateSshKeygenAt(String path) async {
    try {
      final stat = FileStat.statSync(path);
      if (stat.type == FileSystemEntityType.notFound) return false;
      // Windows 下仅检查存在性；Unix 下还需具备可执行位。
      if (Platform.isWindows) return true;
      return stat.mode & 0x111 != 0;
    } catch (_) {
      return false;
    }
  }

  /// 校验指定路径的 ssh-keygen 是否可用（公开方法，供 UI 调用）。
  Future<bool> validateSshKeygen(String path) async {
    if (path.trim().isEmpty) return false;
    return _validateSshKeygenAt(path.trim());
  }

  /// 向后兼容：仅检查 ssh-keygen 是否可用（PATH 默认）。
  Future<bool> isSshKeygenAvailable() async {
    final info = await detectSshKeygen();
    return info.available;
  }

  // ---------------------------------------------------------------------------
  // 密钥生成
  // ---------------------------------------------------------------------------

  /// 生成密钥对。
  ///
  /// [sshKeygenPath] 可选，指定 ssh-keygen 的路径。
  /// [identifier] 用于文件名（如 `github`、`work`）。
  /// [email] 可选，非空时写入 `-C` 注释。
  /// [passphrase] 可选，留空 = 无口令。
  ///
  /// 返回 `{ success, privateKey, publicKey, message }`。
  Future<Map<String, dynamic>> generateKeyPair({
    required KeyAlgorithm algorithm,
    required String identifier,
    String email = '',
    String passphrase = '',
    String? sshKeygenPath,
  }) async {
    final keyName = _keyFileName(algorithm, identifier);
    final privatePath = '${_pathService.sshDir}/$keyName';
    final publicPath = '$privatePath.pub';

    // 同名文件已存在 → 拒绝（由 UI 确认覆盖后重试）。
    if (File(privatePath).existsSync()) {
      return {
        'success': false,
        'message': 'exists',
        'privateKey': privatePath,
        'publicKey': publicPath,
      };
    }

    try {
      await Directory(_pathService.sshDir).create(recursive: true);

      final keygen = sshKeygenPath ?? 'ssh-keygen';
      final args = <String>[
        '-t',
        algorithm == KeyAlgorithm.ed25519 ? 'ed25519' : 'rsa',
        if (algorithm == KeyAlgorithm.rsa) '-b',
        if (algorithm == KeyAlgorithm.rsa) '4096',
        if (email.isNotEmpty) '-C',
        if (email.isNotEmpty) email,
        '-f',
        privatePath,
        '-N',
        passphrase,
      ];

      final result = await Process.run(keygen, args);
      if (result.exitCode != 0) {
        return {
          'success': false,
          'message': result.stderr.toString().trim(),
          'privateKey': privatePath,
          'publicKey': publicPath,
        };
      }

      // 非 Windows 自动 chmod 600 私钥。
      if (!Platform.isWindows) {
        await Process.run('chmod', ['600', privatePath]);
      }

      final publicContent = await File(publicPath).readAsString();
      return {
        'success': true,
        'message': '',
        'privateKey': privatePath,
        'publicKey': publicContent,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
        'privateKey': privatePath,
        'publicKey': publicPath,
      };
    }
  }

  String _keyFileName(KeyAlgorithm algorithm, String identifier) {
    final algo = algorithm == KeyAlgorithm.ed25519 ? 'ed25519' : 'rsa';
    return 'id_${algo}_$identifier';
  }

  /// 生成用于填入 sshconfig 的 `IdentityFile` 行。
  String identityFileLine(KeyAlgorithm algorithm, String identifier) {
    return 'IdentityFile ~/.ssh/${_keyFileName(algorithm, identifier)}';
  }
}