import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:git_switcher/services/ssh_config_service.dart';

import 'helpers.dart';

void main() {
  late Directory home;
  final sshService = SshConfigService.instance;

  setUp(() async {
    home = await setUpIsolatedHome();
  });

  tearDown(() async {
    await tearDownHome(home);
  });

  group('extractIdentityFiles - 提取 IdentityFile 行', () {
    test('提取单个 IdentityFile 并展开 ~', () {
      final result = sshService.extractIdentityFiles('''
Host github.com
  IdentityFile ~/.ssh/id_work
''');
      expect(result, ['${home.path}/.ssh/id_work']);
    });

    test('提取多个 IdentityFile', () {
      final result = sshService.extractIdentityFiles('''
Host github.com
  IdentityFile ~/.ssh/id_work
Host gitlab.com
  IdentityFile ~/.ssh/id_gitlab
''');
      expect(result.length, 2);
    });

    test('大小写不敏感', () {
      final result = sshService.extractIdentityFiles(
        '  identityfile ~/.ssh/a\n  IDENTITYFILE ~/.ssh/b\n',
      );
      expect(result.length, 2);
    });

    test('多余空格与 Tab 缩进', () {
      final result = sshService.extractIdentityFiles(
        '\tIdentityFile   ~/.ssh/id_work\n',
      );
      expect(result, ['${home.path}/.ssh/id_work']);
    });

    test('无 IdentityFile 时返回空', () {
      final result = sshService.extractIdentityFiles(
        'Host github.com\n  User git\n',
      );
      expect(result, isEmpty);
    });

    test('双引号包裹的路径去除引号', () {
      final result = sshService.extractIdentityFiles(
        'Host gh\n  IdentityFile "${home.path}/keys/id_a"\n',
      );
      expect(result, ['${home.path}/keys/id_a']);
    });

    test('双引号包裹的 ~ 路径去除引号并展开', () {
      final result = sshService.extractIdentityFiles(
        'Host gh\n  IdentityFile "~/.ssh/id_a"\n',
      );
      expect(result, ['${home.path}/.ssh/id_a']);
    });

    test('相对路径基于 ~/.ssh 解析', () {
      final result = sshService.extractIdentityFiles(
        'Host gh\n  IdentityFile id_a\n',
      );
      expect(result, ['${home.path}/.ssh/id_a']);
    });

    test('绝对路径保持不变', () {
      final result = sshService.extractIdentityFiles(
        'Host gh\n  IdentityFile /etc/keys/id_a\n',
      );
      expect(result, ['/etc/keys/id_a']);
    });

    test('IdentityFile 无值时不误吞下一行', () {
      final result = sshService.extractIdentityFiles('''
Host gh
  IdentityFile
  User git
  Port 22
''');
      expect(result, isEmpty);
    });

    test('无值时不影响其他 IdentityFile 提取', () {
      final result = sshService.extractIdentityFiles('''
Host gh
  IdentityFile
  IdentityFile ~/.ssh/id_a
''');
      expect(result, ['${home.path}/.ssh/id_a']);
    });
  });

  group('extractHosts - 提取 Host 行', () {
    test('提取首个 token 并保留通配符', () {
      final result = sshService.extractHosts('''
Host *
Host github.com gitlab.com
  User git
''');
      expect(result, ['*', 'github.com']);
    });

    test('大小写不敏感', () {
      final result = sshService.extractHosts('  host github.com\n');
      expect(result, ['github.com']);
    });

    test('无 Host 时返回空', () {
      expect(sshService.extractHosts('User git\n  IdentityFile ~/.ssh/a'), isEmpty);
    });
  });

  group('firstConcreteHost - 取第一个非通配符 Host', () {
    test('跳过通配符取具体 Host', () {
      final result = sshService.firstConcreteHost('''
Host *
  User git
Host github.com
  User git
''');
      expect(result, 'github.com');
    });

    test('仅通配符时返回 null', () {
      expect(sshService.firstConcreteHost('Host *\n  User git'), isNull);
    });

    test('空内容返回 null', () {
      expect(sshService.firstConcreteHost(''), isNull);
    });
  });
}
