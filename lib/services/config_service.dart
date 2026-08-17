import 'dart:convert';
import 'dart:io';

import '../models/profile.dart';
import '../models/app_config.dart';
import '../models/last_switch_snapshot.dart';
import '../services/file_service.dart';
import '../services/path_service.dart';
import 'log_service.dart';

/// 应用配置服务：读写 `~/.git_switcher/config.json`。
///
/// 配置文件结构（见规格 4.3）：
/// ```json
/// { "version": 1, "settings": { ... }, "profiles": [ ... ] }
/// ```
/// - 顶层 `version` 必填；缺失按 1 兜底（加载后保存时补写）。
/// - `version < 当前版本` → 按迁移链逐级升级并写回当前版本。
/// - `version > 当前版本` → 只读展示、禁止写入（避免降级损坏数据）。
class ConfigService {
  static ConfigService? _instance;
  static ConfigService get instance => _instance ??= ConfigService._();
  ConfigService._();

  /// 当前配置文件版本。
  static const int configVersion = 1;

  final _fileService = FileService.instance;
  final _pathService = PathService.instance;

  List<Profile> _profiles = [];
  AppConfig _appConfig = const AppConfig();

  /// 版本过新时为 true，禁止写入（只读）。
  bool _readOnly = false;

  List<Profile> get profiles => List.unmodifiable(_profiles);
  AppConfig get appConfig => _appConfig;
  bool get isReadOnly => _readOnly;

  Future<void> initialize() async {
    await _pathService.initialize();
    await _loadConfig();
  }

  Future<void> _loadConfig() async {
    try {
      final content = await _fileService.readFile(_pathService.configFilePath);
      if (content != null) {
        final decoded = jsonDecode(content);
        if (decoded is! Map<String, dynamic>) {
          Log.instance.warn('配置格式无效，已忽略');
          return;
        }

        final rawVersion = decoded['version'];
        int version = 1;
        if (rawVersion is int) {
          version = rawVersion;
        } else if (rawVersion is num) {
          version = rawVersion.toInt();
        } else if (rawVersion is String) {
          // 手工编辑/外部工具可能把 version 写成字符串；同样参与只读判断，
          // 避免 "version": "2" 被当成 1 而降级覆写新格式配置。
          version = int.tryParse(rawVersion) ?? 1;
        }

        if (version > configVersion) {
          // 由更高版本应用创建：只读展示，禁止写入。
          _readOnly = true;
          Log.instance.warn('配置版本过新（$version > $configVersion），进入只读模式');
        } else {
          _readOnly = false;
          version = _migrate(decoded, version);
        }

        final settings = decoded['settings'];
        if (settings is Map<String, dynamic>) {
          try {
            _appConfig = AppConfig.fromJson(settings);
          } catch (e) {
            // settings 单个字段类型损坏仅回退默认设置，
            // 不让整个配置（含 profiles）被外层 catch 清空。
            Log.instance.warn('settings 解析失败，使用默认设置: $e');
            _appConfig = const AppConfig();
          }
        }

        final profiles = decoded['profiles'];
        if (profiles is List) {
          _profiles = [];
          for (final raw in profiles.whereType<Map<String, dynamic>>()) {
            try {
              _profiles.add(Profile.fromJson(raw));
            } catch (e) {
              // 单条损坏数据仅跳过该条，避免整个配置列表被清空。
              Log.instance.warn('跳过损坏的 Profile 条目: $e');
            }
          }
        }
      }
    } catch (e) {
      Log.instance.error('加载配置失败: $e');

      _profiles = [];
      _appConfig = const AppConfig();
      _readOnly = false;
    }
  }

  /// 版本迁移链：从 [fromVersion] 逐级升级到 [ConfigService.configVersion]。
  /// 迁移完成后由 [ConfigService._saveConfig] 统一写回当前版本。
  ///
  /// 当前版本为 1，旧文件（无 version）即视为 1，暂无需迁移；
  /// 后续新增版本时在此补充对应的迁移函数，禁止原地改结构不升版本。
  int _migrate(Map<String, dynamic> decoded, int fromVersion) {
    var version = fromVersion;
    while (version < configVersion) {
      switch (version) {
        // case 1: decoded = _migrateV1ToV2(decoded); break;
        default:
          break;
      }
      version++;
    }
    return version;
  }

  Future<bool> _saveConfig() async {
    if (_readOnly) {
      Log.instance.warn('配置版本过新，拒绝写入');
      return false;
    }
    try {
      final config = {
        'version': configVersion,
        'settings': _appConfig.toJson(),
        'profiles': _profiles.map((p) => p.toJson()).toList(),
      };

      var encoder = JsonEncoder.withIndent('  ');
      final content = encoder.convert(config);
      // 先写临时文件再原子重命名，避免并发读者读到半截 JSON。
      final path = _pathService.configFilePath;
      final tmpPath = '$path.tmp';
      if (await _fileService.writeFile(tmpPath, content)) {
        try {
          await File(tmpPath).rename(path);
          return true;
        } catch (_) {
          try {
            await File(tmpPath).delete();
          } catch (_) {}
          return await _fileService.writeFile(path, content);
        }
      }
      return false;
    } catch (e) {
      Log.instance.error('保存配置失败: $e');
      return false;
    }
  }

  // -------------------------------------------------------------------------
  // 跨进程互斥：所有配置变更都在锁内「重读磁盘 → 应用变更 → 写回」，
  // 避免并发 CLI/GUI 进程相互覆盖（last-write-wins 丢更新）。
  // -------------------------------------------------------------------------

  /// 获取锁的重试总时长；超时后降级为无锁写入（保持可用性优先）。
  static const _lockRetryTimeout = Duration(seconds: 5);

  /// 锁文件残留判定时长：超过该时间的锁视为持有进程已崩溃，可强抢。
  static const _lockStaleTimeout = Duration(seconds: 10);

  File get _lockFile =>
      File('${_pathService.gitSwitcherDir}/config.lock');

  /// 在配置锁保护下执行 [action]。
  ///
  /// - 以 `File.create(exclusive)` 原子抢占锁文件；
  /// - 锁被占用时自旋重试；残留超时的锁自动清除；
  /// - 重试超时后降级为无锁执行（记录警告），不让 CLI 卡死。
  Future<void> _withLock(Future<void> Function() action) async {
    final deadline = DateTime.now().add(_lockRetryTimeout);
    var acquired = false;
    while (!acquired) {
      try {
        await _lockFile.create(exclusive: true);
        acquired = true;
      } catch (_) {
        try {
          final stat = await _lockFile.stat();
          if (DateTime.now().difference(stat.modified) > _lockStaleTimeout) {
            try {
              await _lockFile.delete();
            } catch (_) {}
            continue;
          }
        } catch (_) {}
        if (DateTime.now().isAfter(deadline)) {
          Log.instance.warn('获取配置锁超时，降级为无锁写入（可能丢失并发更新）');
          break;
        }
        await Future<void>.delayed(const Duration(milliseconds: 25));
      }
    }
    try {
      await action();
    } finally {
      if (acquired) {
        try {
          await _lockFile.delete();
        } catch (_) {}
      }
    }
  }

  /// 锁内重读磁盘配置（丢弃内存态），是 RMW 的「读」步骤。
  /// [mutate] 返回是否发生了变更：无变更/被拒绝时跳过写回并返回 false。
  Future<bool> _lockedReadModifyWrite(
    Future<bool> Function() mutate,
  ) async {
    var ok = false;
    await _withLock(() async {
      await _loadConfig();
      final changed = await mutate();
      if (!changed) return;
      ok = await _saveConfig();
    });
    return ok;
  }

  Future<bool> addProfile(Profile profile) async {
    final name = profile.name.trim();
    if (name.isEmpty) {
      Log.instance.warn('添加 Profile 失败: 名称不能为空');
      return false;
    }
    return _lockedReadModifyWrite(() async {
      for (final p in _profiles) {
        if (p.name == name) {
          Log.instance.warn('添加 Profile 失败: 名称已存在: $name');
          return false;
        }
      }
      _profiles.add(profile);
      return true;
    });
  }

  Future<bool> updateProfile(Profile profile) async {
    return _lockedReadModifyWrite(() async {
      final index = _profiles.indexWhere((p) => p.id == profile.id);
      if (index == -1) return false;
      _profiles[index] = profile;
      return true;
    });
  }

  Future<bool> deleteProfile(String id) async {
    return _lockedReadModifyWrite(() async {
      _profiles.removeWhere((p) => p.id == id);
      if (_appConfig.activeProfileId == id) {
        // 删除当前活跃配置：同时清空活跃标记与撤销快照。
        _appConfig = _appConfig.copyWith(
          activeProfileId: null,
          clearSnapshot: true,
        );
      } else if (_appConfig.lastSwitchSnapshot?.profileId == id) {
        _appConfig = _appConfig.copyWith(clearSnapshot: true);
      }
      return true;
    });
  }

  Future<bool> updateAppConfig(AppConfig config) async {
    return _lockedReadModifyWrite(() async {
      _appConfig = config;
      return true;
    });
  }

  Future<bool> updateActiveProfileId(String? profileId) async {
    return _lockedReadModifyWrite(() async {
      _appConfig = _appConfig.copyWith(activeProfileId: profileId);
      return true;
    });
  }

  /// 写入最近一次切换的快照（每次成功切换后覆盖）。
  Future<bool> updateLastSwitchSnapshot(LastSwitchSnapshot? snapshot) async {
    return _lockedReadModifyWrite(() async {
      _appConfig = _appConfig.copyWith(lastSwitchSnapshot: snapshot);
      return true;
    });
  }

  Future<bool> clearLastSwitchSnapshot() async {
    return _lockedReadModifyWrite(() async {
      _appConfig = _appConfig.copyWith(clearSnapshot: true);
      return true;
    });
  }

  Future<bool> updateOnboarded(bool onboarded) async {
    return _lockedReadModifyWrite(() async {
      _appConfig = _appConfig.copyWith(onboarded: onboarded);
      return true;
    });
  }

  Profile? getProfileById(String id) {
    try {
      return _profiles.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 测试辅助：清空内存状态并重置只读标记。
  void debugClear() {
    _profiles = [];
    _appConfig = const AppConfig();
    _readOnly = false;
  }
}
