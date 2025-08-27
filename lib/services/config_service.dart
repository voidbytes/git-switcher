import 'dart:convert';
import 'package:flutter/cupertino.dart';

import '../models/profile.dart';
import '../models/app_config.dart';
import '../services/file_service.dart';
import '../services/path_service.dart';

class ConfigService {
  static ConfigService? _instance;
  static ConfigService get instance => _instance ??= ConfigService._();
  ConfigService._();

  final _fileService = FileService.instance;
  final _pathService = PathService.instance;

  List<Profile> _profiles = [];
  AppConfig _appConfig = const AppConfig();

  List<Profile> get profiles => List.unmodifiable(_profiles);
  AppConfig get appConfig => _appConfig;

  Future<void> initialize() async {
    await _pathService.initialize();
    await _loadConfig();
  }

  Future<void> _loadConfig() async {
    try {
      final content = await _fileService.readFile(_pathService.configFilePath);
      if (content != null) {
        final json = jsonDecode(content);

        if (json['settings'] != null) {
          _appConfig = AppConfig.fromJson(json['settings']);
        }

        if (json['profiles'] != null) {
          _profiles = (json['profiles'] as List)
              .map((p) => Profile.fromJson(p))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('加载配置失败: $e');

      _profiles = [];
      _appConfig = const AppConfig();
    }
  }

  Future<bool> _saveConfig() async {
    try {
      final config = {
        'settings': _appConfig.toJson(),
        'profiles': _profiles.map((p) => p.toJson()).toList(),
      };

      var encoder = JsonEncoder.withIndent('  ');
      final content = encoder.convert(config);
      return await _fileService.writeFile(_pathService.configFilePath, content);
    } catch (e) {
      debugPrint('保存配置失败: $e');
      return false;
    }
  }

  Future<bool> addProfile(Profile profile) async {
    _profiles.add(profile);
    return await _saveConfig();
  }

  Future<bool> updateProfile(Profile profile) async {
    final index = _profiles.indexWhere((p) => p.id == profile.id);
    if (index != -1) {
      _profiles[index] = profile;
      return await _saveConfig();
    }
    return false;
  }

  Future<bool> deleteProfile(String id) async {
    _profiles.removeWhere((p) => p.id == id);
    if (_appConfig.activeProfileId == id) {
      await updateActiveProfileId(null);
    }
    return await _saveConfig();
  }

  Future<bool> updateAppConfig(AppConfig config) async {
    _appConfig = config;
    return await _saveConfig();
  }

  Future<bool> updateActiveProfileId(String? profileId) async {
    _appConfig = _appConfig.copyWith(activeProfileId: profileId);
    return await _saveConfig();
  }

  Profile? getProfileById(String id) {
    try {
      return _profiles.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
