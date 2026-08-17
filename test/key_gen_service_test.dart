import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:git_switcher/services/key_gen_service.dart';
import 'package:git_switcher/services/path_service.dart';

import 'helpers.dart';

void main() {
  late Directory home;
  late PathService pathService;
  final keyGen = KeyGenService.instance;

  setUp(() async {
    home = await setUpIsolatedHome();
    pathService = PathService.instance;
  });

  tearDown(() async {
    await tearDownHome(home);
  });

  group('ssh-keygen 路径检测', () {
    test('validateSshKeygen 无效路径返回 false', () async {
      expect(
        await keyGen.validateSshKeygen('/nonexistent/ssh-keygen'),
        false,
      );
      expect(await keyGen.validateSshKeygen(''), false);
    });

    test('自定义路径可用时返回 custom=true 与对应路径', () async {
      final validPath = await _findRealKeygenPath();
      if (validPath == null) {
        markTestSkipped('系统无 ssh-keygen');
        return;
      }

      final info = await keyGen.detectSshKeygen(customPath: validPath);
      expect(info.available, true);
      expect(info.custom, true);
      expect(info.path, validPath);
    });

    test('自定义路径不可用时返回错误信息', () async {
      final info = await keyGen.detectSshKeygen(
        customPath: '/nonexistent/ssh-keygen',
      );
      expect(info.available, false);
      expect(info.custom, true);
      expect(info.error, isNotEmpty);
    });

    test('无自定义路径时走 PATH 自动检测', () async {
      final info = await keyGen.detectSshKeygen();
      final expected = await keyGen.isSshKeygenAvailable();
      expect(info.available, expected);
      if (info.available) {
        expect(info.path, isNotNull);
        expect(info.custom, false);
      }
    });
  });

  group('validateIdentifier - 标识校验', () {
    test('合法标识通过', () {
      expect(keyGen.validateIdentifier('github'), true);
      expect(keyGen.validateIdentifier('work_1'), true);
      expect(keyGen.validateIdentifier('a-b_c-2'), true);
    });

    test('非法标识拒绝', () {
      expect(keyGen.validateIdentifier(''), false);
      expect(keyGen.validateIdentifier('中文'), false);
      expect(keyGen.validateIdentifier('has space'), false);
      expect(keyGen.validateIdentifier('a.b'), false);
      expect(keyGen.validateIdentifier('a@b'), false);
      expect(keyGen.validateIdentifier('a/b'), false);
    });
  });

  group('identityFileLine - IdentityFile 行生成', () {
    test('ed25519 算法', () {
      expect(
        keyGen.identityFileLine(KeyAlgorithm.ed25519, 'github'),
        'IdentityFile ~/.ssh/id_ed25519_github',
      );
    });

    test('rsa 算法', () {
      expect(
        keyGen.identityFileLine(KeyAlgorithm.rsa, 'work'),
        'IdentityFile ~/.ssh/id_rsa_work',
      );
    });
  });

  group('generateKeyPair - 密钥生成', () {
    test('同名私钥存在时拒绝生成', () async {
      await writeHome(home, '.ssh/id_ed25519_github', 'existing');

      final result = await keyGen.generateKeyPair(
        algorithm: KeyAlgorithm.ed25519,
        identifier: 'github',
      );

      expect(result['success'], false);
      expect(result['message'], 'exists');
      expect(result['privateKey'], '${pathService.sshDir}/id_ed25519_github');
    });

    test('生成 ed25519 密钥对并设置 600 权限', () async {
      if (!await keyGen.isSshKeygenAvailable()) {
        markTestSkipped('ssh-keygen 不可用');
        return;
      }

      final result = await keyGen.generateKeyPair(
        algorithm: KeyAlgorithm.ed25519,
        identifier: 'github',
        email: 'dev@example.com',
        passphrase: '',
      );

      expect(result['success'], true);
      expect(result['message'], '');
      final privatePath = result['privateKey'] as String;
      final privateKey = File(privatePath);
      expect(privateKey.existsSync(), true);
      expect(
        privateKey.readAsStringSync(),
        contains('BEGIN OPENSSH PRIVATE KEY'),
      );
      expect(result['publicKey'], contains('ssh-ed25519'));
      if (!Platform.isWindows) {
        final stat = await Process.run('stat', ['-c', '%a', privatePath]);
        expect(stat.stdout.toString().trim(), '600');
      }
    });

    test('生成 rsa 密钥对', () async {
      if (!await keyGen.isSshKeygenAvailable()) {
        markTestSkipped('ssh-keygen 不可用');
        return;
      }

      final result = await keyGen.generateKeyPair(
        algorithm: KeyAlgorithm.rsa,
        identifier: 'work',
      );

      expect(result['success'], true);
      expect(File(result['privateKey'] as String).existsSync(), true);
      expect(result['publicKey'], contains('ssh-rsa'));
    });

    test('生成失败时返回错误信息', () async {
      if (Platform.isWindows) {
        markTestSkipped('Windows 无 chmod 权限语义');
        return;
      }
      // 构造只读的 .ssh 目录使写入失败（root 用户下该限制不生效，则跳过）。
      await Directory(pathService.sshDir).create(recursive: true);
      await Process.run('chmod', ['0555', pathService.sshDir]);

      final result = await keyGen.generateKeyPair(
        algorithm: KeyAlgorithm.ed25519,
        identifier: 'failtest',
      );

      if (result['success'] == true) {
        markTestSkipped('当前运行用户可绕过只读目录权限');
        return;
      }
      expect(result['success'], false);
      expect(result['message'], isNotEmpty);
    });
  });
}

/// 查找系统真实存在的 ssh-keygen 绝对路径（供自定义路径测试使用）。
Future<String?> _findRealKeygenPath() async {
  final which = await Process.run(
    Platform.isWindows ? 'where' : 'which',
    ['ssh-keygen'],
  );
  if (which.exitCode != 0) return null;
  final path = which.stdout.toString().trim().split('\n').first.trim();
  return path.isEmpty ? null : path;
}
