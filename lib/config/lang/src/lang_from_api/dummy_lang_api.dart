
import 'package:myapp/config/lang/src/lang_from_api/translation_api_model.dart';

import '../language_model.dart';

///
/// ALL THIS CODE ARE HUMAN CODED, YOU CAN CHANGE THIS AS PER YOUR NEED
///

class DummyLangApi {
  const DummyLangApi._();

  static bool fetchLanguagesFromApi = false;

  /// Simulated API call to fetch the list of supported languages.
  static Future<List<LanguageModel>> fetchLanguages() async {
    if (!fetchLanguagesFromApi) return List.empty();
    await Future.delayed(const Duration(milliseconds: 300)); // simulate latency
    return [
      LanguageModel(code: "en", language: "English", displayName: "English", image: "🇬🇧"),
      LanguageModel(code: "hi", language: "Hindi", displayName: "हिन्दी", image: "🇮🇳"),
      LanguageModel(code: "gu", language: "Gujarati", displayName: "ગુજરાતી", image: "🇮🇳"),
      LanguageModel(code: "de", language: "German", displayName: "Deutsch", image: "🇩🇪"),
      LanguageModel(code: "fr", language: "French", displayName: "French", image: "🇩🇪"),
    ];
  }

  /// Simulated API call to fetch translations based on [code].
  static Future<TranslationApiModel?> fetchTranslations(String code) async {
    if (!fetchLanguagesFromApi) return null;
    await Future.delayed(const Duration(milliseconds: 300)); // simulate latency

    final translationsData = {
      "en": {
        "code": "en",
        "language": "English",
        "display_name": "English",
        "version": 1,
        "translations": {
          "home": "Home",
          "demo": "Demo",
          "profile": "Profile",
          "screen": "Screen",
          "loginScreen": "Login Screen",
          "homeScreen {}": "Home Screen {}",
          "demoScreen {}": "Demo Screen {}",
          "nextScreen": "Next Screen",
          "demo2": "Demo 2",
          "profileScreen": "Profile Screen {}",
          "loginWithoutEmailPassword": "Login Without Email & Password",
          "settings": "Settings",
          "Settings": "Settings",
          "Change Theme": "Change Theme",
          "Dark Theme": "Dark Theme",
          "Change Language": "Change Language"
        },
      },
      "hi": {
        "code": "hi",
        "language": "Hindi",
        "display_name": "हिन्दी",
        "version": 1,
        "translations": {
          "home": "होम",
          "demo": "डेमो",
          "profile": "प्रोफ़ाइल",
          "screen": "स्क्रीन",
          "loginScreen": "लॉगिन स्क्रीन",
          "homeScreen {}": "होम स्क्रीन {}",
          "demoScreen {}": "डेमो स्क्रीन {}",
          "nextScreen": "अगली स्क्रीन",
          "demo2": "डेमो 2",
          "profileScreen": "प्रोफ़ाइल स्क्रीन {}",
          "loginWithoutEmailPassword": "बिना ईमेल और पासवर्ड के लॉगिन करें",
          "settings": "सेटिंग्स",
          "Settings": "सेटिंग्स",
          "Change Theme": "थीम बदलें",
          "Dark Theme": "डार्क थीम",
          "Change Language": "भाषा बदलें"
        },
      },
      "gu": {
        "code": "gu",
        "language": "Gujarati",
        "display_name": "ગુજરાતી",
        "version": 1,
        "translations": {
          "home": "હોમ",
          "demo": "ડેમો",
          "profile": "પ્રોફાઇલ",
          "screen": "સ્ક્રીન",
          "loginScreen": "લૉગિન સ્ક્રીન",
          "homeScreen {}": "હોમ સ્ક્રીન {}",
          "demoScreen {}": "ડેમો સ્ક્રીન {}",
          "nextScreen": "આગલી સ્ક્રીન",
          "demo2": "ડેમો 2",
          "profileScreen": "પ્રોફાઇલ સ્ક્રીન {}",
          "loginWithoutEmailPassword": "ઈમેલ અને પાસવર્ડ વગર લૉગિન કરો",
          "settings": "સેટિંગ્સ",
          "Settings": "સેટિંગ્સ",
          "Change Theme": "થીમ બદલો",
          "Dark Theme": "ડાર્ક થીમ",
          "Change Language": "ભાષા બદલો"
        },
      },
    };

    final jsonData = translationsData[code];
    if (jsonData == null) return null;
    return TranslationApiModel.fromJson(jsonData);
  }
}
