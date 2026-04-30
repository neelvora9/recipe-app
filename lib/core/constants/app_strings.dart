class AppString {
  final bool isCustom;
  final String value;

  final List<String>? args;
  final Map<String, String>? namedArgs;

  const AppString._(
    this.value, {
    this.isCustom = false,
    this.args,
    this.namedArgs,
  });

  static const appName = AppString._('Flutter Clean Architecture');
  static const appVersion = AppString._('1.0.0');
  static const reset = AppString._('Reset');
  static const notifier_widget_example_with_counter = AppString._('Notifier Widget Example with Counter');
  static const choose_your_style_language = AppString._('Choose Your Style & Language');
  static const dark_theme = AppString._('Dark Theme');
  static const change_theme = AppString._('Change Theme');
  static const change_language = AppString._('Change Language');
  static const Continue = AppString._('Continue');
  static const loginScreen = AppString._('loginScreen');
  static const loginWithoutEmailPassword = AppString._('loginWithoutEmailPassword');
  static const demoScreen = AppString._('demoScreen');
  static const Process = AppString._('Process');
  static const nextScreen = AppString._('nextScreen');
  static const screen = AppString._('screen');

  static AppString demoScreen_XX(List<String> args) => AppString._('demoScreen {}', args: args);
  static AppString homeScreen_XX(List<String> args) => AppString._('homeScreen {}', args: args);

  factory AppString.custom(String value) {
    return AppString._(value, isCustom: true);
  }
}
