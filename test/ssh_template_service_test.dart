import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:git_switcher/services/ssh_template_service.dart';

void main() {
  final template = SshTemplateService.instance;

  group('build - GitHub', () {
    test('直连模式不含 ProxyCommand', () {
      final content = template.build(
        provider: SshProvider.github,
        mode: ProxyMode.direct,
        identityFile: '~/.ssh/id_ed25519_github',
      );
      expect(content, contains('Host github.com'));
      expect(content, contains('HostName ssh.github.com'));
      expect(content, contains('User git'));
      expect(content, contains('Port 443'));
      expect(content, contains('IdentityFile ~/.ssh/id_ed25519_github'));
      expect(content, contains('ServerAliveInterval 60'));
      expect(content, isNot(contains('ProxyCommand')));
    });

    test('代理模式插入平台对应 ProxyCommand', () {
      final content = template.build(
        provider: SshProvider.github,
        mode: ProxyMode.proxy,
        identityFile: '~/.ssh/id_ed25519_github',
        proxyAddress: '127.0.0.1:7890',
      );
      expect(content, contains('ProxyCommand'));
      if (Platform.isWindows) {
        expect(content, contains('connect -S 127.0.0.1:7890 %h %p'));
      } else if (Platform.isMacOS) {
        expect(content, contains('/usr/bin/nc -X 5 -x 127.0.0.1:7890 %h %p'));
      } else {
        expect(content, contains('nc -X 5 -x 127.0.0.1:7890 %h %p'));
      }
    });

    test('直连模式即使指定代理地址也不生成 ProxyCommand', () {
      final content = template.build(
        provider: SshProvider.github,
        mode: ProxyMode.direct,
        identityFile: '~/.ssh/id_ed25519_github',
        proxyAddress: '192.168.1.1:8080',
      );
      expect(content, isNot(contains('ProxyCommand')));
    });
  });

  group('build - 其他平台', () {
    test('GitLab 仅直连（忽略代理模式）', () {
      final content = template.build(
        provider: SshProvider.gitlab,
        mode: ProxyMode.proxy,
        identityFile: '~/.ssh/id_ed25519_gitlab',
      );
      expect(content, contains('Host gitlab.com'));
      expect(content, contains('HostName gitlab.com'));
      expect(content, contains('User git'));
      expect(content, isNot(contains('ProxyCommand')));
    });

    test('Gitee 直连', () {
      final content = template.build(
        provider: SshProvider.gitee,
        mode: ProxyMode.direct,
        identityFile: '~/.ssh/id_ed25519_gitee',
      );
      expect(content, contains('Host gitee.com'));
      expect(content, contains('HostName gitee.com'));
      expect(content, isNot(contains('ProxyCommand')));
    });

    test('blank 返回空字符串', () {
      expect(
        template.build(
          provider: SshProvider.blank,
          mode: ProxyMode.direct,
          identityFile: 'x',
        ),
        '',
      );
    });
  });
}
