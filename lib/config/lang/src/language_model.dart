 

import 'dart:ui';

import 'package:myapp/config/lang/app_localization.dart';

class LanguageModel {
  final String code;
  final String language;
  final String displayName;
  final String image;

  Locale get locale => this.code.toLocale();

  LanguageModel({required this.code, required this.language, required this.displayName, required this.image});

  factory LanguageModel.fromJson(Map<String, dynamic> json) =>
      LanguageModel(code: json['code'], language: json['language'], displayName: json['display_name'], image: json['image']);

  Map<String, dynamic> toJson() => {
        'code': code,
        'language': language,
        'display_name': displayName,
        'image': image,
      };
}

extension LocaleListExt on List<LanguageModel> {
  List<Locale> get localeList => this.map((e) => e.code.toLocale()).toList();
  LanguageModel? find(String key) => this.where((element) => element.code == key).firstOrNull;
}
