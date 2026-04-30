 

import 'package:myapp/config/lang/src/translations.dart';

class TranslationApiModel {
  final String code;
  final String language;
  final int? version;
  final Translations translations;

  TranslationApiModel({required this.code, required this.language, required this.version, required this.translations});

  factory TranslationApiModel.fromJson(Map<String, dynamic> json) =>
      TranslationApiModel(code: json['code'], language: json['language'], version: json['version'], translations: Translations(json['translations']));

  Map<String, dynamic> toJson() => {
        "code": code,
        "language": language,
        "version": version,
        "translations": translations.translations,
      };
}
