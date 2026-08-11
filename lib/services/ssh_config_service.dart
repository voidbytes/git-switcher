import 'package:path/path.dart' as p;
import '../services/file_service.dart';
import '../services/path_service.dart';

class SshConfigService {
  static SshConfigService? _instance;

  static SshConfigService get instance => _instance ??= SshConfigService._();

  SshConfigService._();

  final _fileService = FileService.instance;
  final _pathService = PathService.instance;

  Future<Map<String, dynamic>> parseConfig(String host) async {
    final content = await _fileService.readFile(_pathService.sshConfigPath);
    if (content == null) {
      return {'exists': false, 'hasWildcard': false, 'identityFile': null};
    }

    final lines = content.split('\n');
    String? currentHost;
    String? identityFile;
    bool foundHost = false;
    bool hasWildcard = false;

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('Host ')) {
        if (foundHost) break;

        currentHost = trimmed.substring(5).trim();

        if (currentHost == host) {
          foundHost = true;
        } else if (currentHost == '*') {
          hasWildcard = true;
        }
      } else if (foundHost && trimmed.startsWith('IdentityFile ')) {
        identityFile = _pathService.resolvePath(trimmed.substring(13).trim());
        break;
      }
    }

    if (identityFile == null && hasWildcard) {
      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.startsWith('Host *')) {
          currentHost = '*';
        } else if (currentHost == '*' && trimmed.startsWith('IdentityFile ')) {
          identityFile = _pathService.resolvePath(trimmed.substring(13).trim());
          break;
        }
      }
    }

    return {
      'exists': foundHost,
      'hasWildcard': hasWildcard,
      'identityFile': identityFile,
    };
  }

  Future<String?> getSshConfigConflict(
    String host,
    String newIdentityFile,
  ) async {
    final parsedConfig = await parseConfig(host);
    final currentIdentityFile = parsedConfig['identityFile'] as String?;

    if (currentIdentityFile == null) {
      return null;
    }

    final normalizedCurrent = p.normalize(
      _pathService.resolvePath(currentIdentityFile),
    );
    final normalizedNew = p.normalize(
      _pathService.resolvePath(newIdentityFile),
    );

    if (normalizedCurrent != normalizedNew) {
      return currentIdentityFile;
    }

    return null;
  }

  Future<bool> updateSshConfig(
    String host,
    String identityFile, {
    bool usePort443 = false,
  }) async {
    await _pathService.ensureSshDirExists();

    final content =
        await _fileService.readFile(_pathService.sshConfigPath) ?? '';
    final lines = content.split('\n');

    // 使用 443 端口时，HostName 指向 GitHub 的 ssh.github.com，Host 仍保留为别名
    final hostName = usePort443 ? 'ssh.github.com' : host;

    int hostBlockStartIndex = -1;
    int hostBlockEndIndex = lines.length;

    for (int i = 0; i < lines.length; i++) {
      final trimmed = lines[i].trim();
      if (trimmed.startsWith('Host ')) {
        if (hostBlockStartIndex != -1) {
          hostBlockEndIndex = i;
          break;
        }
        if (trimmed.substring(5).trim() == host) {
          hostBlockStartIndex = i;
        }
      }
    }

    if (hostBlockStartIndex == -1) {
      // 新建 host 块
      if (lines.isNotEmpty && lines.last.trim().isNotEmpty) {
        lines.add('');
      }
      lines.addAll([
        'Host $host',
        '  HostName $hostName',
        '  User git',
        if (usePort443) '  Port 443',
        '  IdentityFile $identityFile',
      ]);
      return await _fileService.writeFile(
        _pathService.sshConfigPath,
        lines.join('\n'),
      );
    }

    // 更新已有 host 块：同步 HostName / Port / IdentityFile
    String indentation = '';
    final directives = <String, int>{};
    for (int i = hostBlockStartIndex + 1; i < hostBlockEndIndex; i++) {
      final line = lines[i];
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

      if (indentation.isEmpty) {
        final match = RegExp(r'^(\s+)').firstMatch(line);
        if (match != null) indentation = match.group(1)!;
      }

      final key = trimmed.split(RegExp(r'\s+')).first;
      if (key == 'IdentityFile' || key == 'HostName' || key == 'Port') {
        directives[key] = i;
      }
    }
    if (indentation.isEmpty) {
      indentation = '  ';
    }

    final desired = <String, String>{
      'IdentityFile': identityFile,
      'HostName': hostName,
      if (usePort443) 'Port': '443',
    };

    // 1) 就地更新已存在的指令
    for (final entry in desired.entries) {
      final idx = directives[entry.key];
      if (idx != null) {
        lines[idx] = '$indentation${entry.key} ${entry.value}';
      }
    }

    // 2) 未启用 443 时移除可能残留的 Port 行
    if (!usePort443 && directives.containsKey('Port')) {
      lines.removeAt(directives['Port']!);
    }

    // 3) 插入缺失的指令（紧随 Host 行之后）
    final missing = desired.keys.where((k) => !directives.containsKey(k)).toList();
    if (missing.isNotEmpty) {
      lines.insertAll(
        hostBlockStartIndex + 1,
        missing.map((k) => '$indentation$k ${desired[k]}'),
      );
    }

    return await _fileService.writeFile(
      _pathService.sshConfigPath,
      lines.join('\n'),
    );
  }

  Future<bool> validateSshConfig(
    String host,
    String expectedIdentityFile,
  ) async {
    final config = await parseConfig(host);
    final currentIdentityFile = config['identityFile'] as String?;
    if (currentIdentityFile == null) return false;

    return p.normalize(_pathService.resolvePath(currentIdentityFile)) ==
        p.normalize(_pathService.resolvePath(expectedIdentityFile));
  }
}
