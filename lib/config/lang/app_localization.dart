

import 'dart:async';

// import 'package:easy_localization/src/easy_localization_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:myapp/config/lang/languages.dart';
import 'package:myapp/config/lang/src/language_model.dart';
import 'package:myapp/config/lang/src/translations.dart';

import 'src/localization_controller.dart';
import 'src/localization.dart';
import '../../core/helper/logger.dart';
export 'package:myapp/config/lang/app_localization.dart';
export 'package:myapp/config/lang/src/extensions.dart';

class AppLocalization extends StatefulWidget {
  final Widget child;

  final Locale? startLocale;
  final bool useFallbackTranslations;

  final bool saveLocale;

  final path = 'lib/config/lang/jsons';
  final Locale? fallbackLocale = languages.firstOrNull?.locale;

  AppLocalization({
    Key? key,
    required this.child,
    this.startLocale,
    this.useFallbackTranslations = false,
    this.saveLocale = true,
  }) : super(key: key) {
    AppLocalization.logger.debug('Start');
  }

  @override
  _AppLocalizationState createState() => _AppLocalizationState();

  static _AppLocalizationProvider? of(BuildContext context) => _AppLocalizationProvider.of(context);

  static Future<void> init() async => await LocalizationController.init();

  static AppLogger logger = AppLogger(name: '🌐 App Localization');
}

class _AppLocalizationState extends State<AppLocalization> {
  _AppLocalizationDelegate? delegate;
  LocalizationController? localizationController;
  FlutterError? translationsLoadError;

  @override
  void initState() {
    AppLocalization.logger.debug('Init state');
    localizationController = LocalizationController(
      saveLocale: widget.saveLocale,
      fallbackLocale: widget.fallbackLocale,
      supportedLocales: languages.localeList,
      startLocale: widget.startLocale,
      useFallbackTranslations: widget.useFallbackTranslations,
      path: widget.path,

    );
    // causes localization to rebuild with new language
    localizationController!.addListener(() {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    localizationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalization.logger.debug('Build');

    return _AppLocalizationProvider(
      widget,
      localizationController!,
      delegate: _AppLocalizationDelegate(
        localizationController: localizationController,
        supportedLocales: localizationController?.supportedLocales,
      ),
    );
  }
}

class _AppLocalizationProvider extends InheritedWidget {
  final AppLocalization parent;
  final LocalizationController _localeState;
  final Locale? currentLocale;
  final _AppLocalizationDelegate delegate;
  final bool _translationsLoaded;

  List<LocalizationsDelegate> get delegates => [
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ];

  List<Locale> get supportedLocales => _localeState.supportedLocales;

  Locale get locale => _localeState.locale;

  Locale? get fallbackLocale => parent.fallbackLocale;

  Locale get deviceLocale => _localeState.deviceLocale;

  Locale? get savedLocale => _localeState.savedLocale;

  _AppLocalizationProvider(this.parent, this._localeState, {Key? key, required this.delegate})
      : currentLocale = _localeState.locale,
        _translationsLoaded = _localeState.translations != null,
        super(key: key, child: parent.child) {
    AppLocalization.logger.debug('Init provider');
  }

  void setTranslations(Translations? t) {
    _localeState.setTranslations(t);
  }

  void setSupportedLocales(List<Locale> t) {
    _localeState.setSupportedLocales(t);
  }

  Future<void> setLocale(Locale locale) async {
    if (locale != _localeState.locale) {
      assert(_localeState.supportedLocales.contains(locale));
      await _localeState.setLocale(locale);
    }
  }

  Future<void> deleteSavedLocale() async {
    await _localeState.deleteSavedLocale();
  }

  Future<void> resetLocale() => _localeState.resetLocale();

  @override
  bool updateShouldNotify(_AppLocalizationProvider oldWidget) {
    return oldWidget.currentLocale != locale || oldWidget._translationsLoaded != _translationsLoaded || oldWidget.supportedLocales != supportedLocales;
  }

  static _AppLocalizationProvider? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<_AppLocalizationProvider>();
}

class _AppLocalizationDelegate extends LocalizationsDelegate<Localization> {
  final List<Locale>? supportedLocales;
  final LocalizationController? localizationController;

  _AppLocalizationDelegate({
    this.localizationController,
    this.supportedLocales,
  }) {
    AppLocalization.logger.debug('Init Localization Delegate');
  }

  @override
  bool isSupported(Locale locale) => supportedLocales!.contains(locale);

  @override
  Future<Localization> load(Locale value) async {
    AppLocalization.logger.debug('Load Localization Delegate');
    if (localizationController!.translations == null) {
      await localizationController!.loadTranslations();
    }

    Localization.load(
      value,
      translations: localizationController!.translations,
      fallbackTranslations: localizationController!.fallbackTranslations,
    );
    return Future.value(Localization.instance);
  }

  @override
  bool shouldReload(LocalizationsDelegate<Localization> old) => false;
}
