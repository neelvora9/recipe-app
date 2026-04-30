 

import 'package:flutter/widgets.dart';

import '../app_localization.dart';
import 'translations.dart';

class Localization {
  Translations? _translations, _fallbackTranslations;

  final RegExp _replaceArgRegex = RegExp('{}');
  final RegExp _linkKeyMatcher = RegExp(r'(?:@(?:\.[a-z]+)?:(?:[\w\-_|.]+|\([\w\-_|.]+\)))');
  final RegExp _linkKeyPrefixMatcher = RegExp(r'^@(?:\.([a-z]+))?:');
  final RegExp _bracketsMatcher = RegExp('[()]');
  final _modifiers = <String, String Function(String?)>{
    'upper': (String? val) => val!.toUpperCase(),
    'lower': (String? val) => val!.toLowerCase(),
    'capitalize': (String? val) => '${val![0].toUpperCase()}${val.substring(1)}'
  };

  bool _useFallbackTranslationsForEmptyResources = false;

  Localization();

  static Localization? _instance;

  static Localization get instance => _instance ?? (_instance = Localization());

  static Localization? of(BuildContext context) => Localizations.of<Localization>(context, Localization);

  static bool load(
      Locale locale, {
        Translations? translations,
        Translations? fallbackTranslations,
        bool useFallbackTranslationsForEmptyResources = false,
      }) {
    instance._translations = translations;
    instance._fallbackTranslations = fallbackTranslations;
    instance._useFallbackTranslationsForEmptyResources = useFallbackTranslationsForEmptyResources;
    return translations == null ? false : true;
  }

  String tr(String key, {List<String>? args, Map<String, String>? namedArgs, String? gender}) {
    late String res;
    if (gender != null) {
      res = _gender(key, gender: gender);
    } else {
      res = _resolve(key);
    }
    res = _replaceLinks(res);
    res = _replaceNamedArgs(res, namedArgs);
    return _replaceArgs(res, args);
  }

  String _replaceLinks(String res, {bool logging = true}) {
    final matches = _linkKeyMatcher.allMatches(res);
    var result = res;

    for (final match in matches) {
      final link = match[0]!;
      final linkPrefixMatches = _linkKeyPrefixMatcher.allMatches(link);
      final linkPrefix = linkPrefixMatches.first[0]!;
      final formatterName = linkPrefixMatches.first[1];

      final linkPlaceholder = link.replaceAll(linkPrefix, '').replaceAll(_bracketsMatcher, '');

      var translated = _resolve(linkPlaceholder);

      if (formatterName != null) {
        if (_modifiers.containsKey(formatterName)) {
          translated = _modifiers[formatterName]!(translated);
        } else {
          if (logging) {
            AppLocalization.logger.warning('Undefined modifier $formatterName, available modifiers: ${_modifiers.keys.toString()}');
          }
        }
      }

      result = translated.isEmpty ? result : result.replaceAll(link, translated);
    }

    return result;
  }

  String _replaceArgs(String res, List<String>? args) {
    if (args == null || args.isEmpty) return res;
    for (var str in args) {
      res = res.replaceFirst(_replaceArgRegex, str);
    }
    return res;
  }

  String _replaceNamedArgs(String res, Map<String, String>? args) {
    if (args == null || args.isEmpty) return res;
    args.forEach((String key, String value) => res = res.replaceAll(RegExp('{$key}'), value));
    return res;
  }

  String _gender(String key, {required String gender}) {
    return _resolve('$key.$gender');
  }

  String _resolve(String key, {bool logging = true, bool fallback = true}) {
    var resource = _translations?.get(key);
    if (resource == null || (_useFallbackTranslationsForEmptyResources && resource.isEmpty)) {
      if (logging) {
        // AppLocalization.logger.warning('Localization key [$key] not found');
      }
      if (_fallbackTranslations == null || !fallback) {
        return key;
      } else {
        resource = _fallbackTranslations?.get(key);
        if (resource == null || (_useFallbackTranslationsForEmptyResources && resource.isEmpty)) {
          if (logging) {
            AppLocalization.logger.warning('Fallback localization key [$key] not found');
          }
          return key;
        }
      }
    }
    return resource;
  }

  bool exists(String key) {
    return _translations?.get(key) != null;
  }
}
