import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:git_switcher/l10n/localization_service.dart';

void main() {
  group('resolveLocale', () {
    test('显式语言代码', () {
      expect(resolveLocale('zh', null), const Locale('zh'));
      expect(resolveLocale('zh_Hant', null), const Locale('zh', 'Hant'));
      expect(resolveLocale('en', null), const Locale('en'));
      expect(resolveLocale('fr', null), const Locale('fr'));
      expect(resolveLocale('de', null), const Locale('de'));
      expect(resolveLocale('es', null), const Locale('es'));
      expect(resolveLocale('ja', null), const Locale('ja'));
      expect(resolveLocale('ko', null), const Locale('ko'));
      expect(resolveLocale('ru', null), const Locale('ru'));
      expect(resolveLocale('pt', null), const Locale('pt'));
    });

    test('null 跟随系统', () {
      expect(resolveLocale(null, const Locale('en')), const Locale('en'));
      expect(resolveLocale(null, const Locale('it')), const Locale('zh'));
      expect(resolveLocale(null, null), const Locale('zh'));
    });

    test('system 跟随系统', () {
      expect(resolveLocale('system', const Locale('fr')), const Locale('fr'));
      expect(resolveLocale('system', null), const Locale('zh'));
    });
  });

  group('localizedLocale', () {
    test('繁体区域使用繁体中文', () {
      expect(localizedLocale(const Locale('zh', 'TW')), const Locale('zh', 'Hant'));
      expect(localizedLocale(const Locale('zh', 'HK')), const Locale('zh', 'Hant'));
      expect(localizedLocale(const Locale('zh', 'MO')), const Locale('zh', 'Hant'));
    });

    test('简体中文区域使用简体', () {
      expect(localizedLocale(const Locale('zh', 'CN')), const Locale('zh'));
      expect(localizedLocale(const Locale('zh')), const Locale('zh'));
    });

    test('受支持语言直接映射', () {
      expect(localizedLocale(const Locale('en', 'US')), const Locale('en'));
      expect(localizedLocale(const Locale('ja', 'JP')), const Locale('ja'));
      expect(localizedLocale(const Locale('pt', 'BR')), const Locale('pt'));
    });

    test('不支持的方言回退到中文', () {
      expect(localizedLocale(const Locale('it')), const Locale('zh'));
      expect(localizedLocale(const Locale('ar')), const Locale('zh'));
      expect(localizedLocale(null), const Locale('zh'));
    });
  });

  test('kSupportedLanguageCodes 覆盖全部支持语言', () {
    expect(
      kSupportedLanguageCodes,
      containsAll([
        'system',
        'zh',
        'zh_Hant',
        'en',
        'fr',
        'de',
        'es',
        'ja',
        'ko',
        'ru',
        'pt',
      ]),
    );
  });
}
