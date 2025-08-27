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

  Future<bool> updateSshConfig(String host, String identityFile) async {
    await _pathService.ensureSshDirExists();

    final content =
        await _fileService.readFile(_pathService.sshConfigPath) ?? '';
    final lines = content.split('\n');

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

    if (hostBlockStartIndex != -1) {
      int identityFileIndex = -1;
      String indentation = '  ';

      for (int i = hostBlockStartIndex + 1; i < hostBlockEndIndex; i++) {
        final line = lines[i];
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

        final match = RegExp(r'^(\s+)').firstMatch(line);
        if (match != null) {
          indentation = match.group(1)!;
        }

        if (trimmed.startsWith('IdentityFile ')) {
          identityFileIndex = i;
        }

        if (indentation != '  ') break;
      }

      final newIdentityLine =
          '$indentation'
          'IdentityFile $identityFile';

      if (identityFileIndex != -1) {
        lines[identityFileIndex] = newIdentityLine;
      } else {
        lines.insert(hostBlockStartIndex + 1, newIdentityLine);
      }

      return await _fileService.writeFile(
        _pathService.sshConfigPath,
        lines.join('\n'),
      );
    } else {
      if (lines.isNotEmpty && lines.last.trim().isNotEmpty) {
        lines.add('');
      }
      lines.addAll([
        'Host $host',
        '  HostName $host',
        '  User git',
        '  IdentityFile $identityFile',
      ]);
      return await _fileService.writeFile(
        _pathService.sshConfigPath,
        lines.join('\n'),
      );
    }
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
