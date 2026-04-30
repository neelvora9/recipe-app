import 'package:flutter/foundation.dart';

enum LogLevels {
  debug,
  info,
  warning,
  error,
}

Function(Object object, {String? name, LogLevels? level, StackTrace? stackTrace}) defaultPrinterForLogger =
    (Object object, {String? name, StackTrace? stackTrace, LogLevels? level}) {
  String _coloredString(String string) => switch (level) {
        LogLevels.debug => '\u001b[90m$string\u001b[0m',
        LogLevels.info => '\u001b[32m$string\u001b[0m',
        LogLevels.warning => '\u001B[34m$string\u001b[0m',
        LogLevels.error => '\u001b[31m$string\u001b[0m',
        _ => '\u001b[90m$string\u001b[0m',
      };

  String _prepareObject() => switch (level) {
        LogLevels.debug => _coloredString('[$name] [DEBUG] ${object.toString()}'),
        LogLevels.info => _coloredString('[$name] [INFO] ${object.toString()}'),
        LogLevels.warning => _coloredString('[$name] [WARNING] ${object.toString()}'),
        LogLevels.error => _coloredString('[$name] [ERROR] ${object.toString()}'),
        _ => _coloredString('[$name] ${object.toString()}'),
      };

  print(_prepareObject());

  if (stackTrace != null) {
    print(_coloredString('__________________________________'));
    print(_coloredString('${stackTrace.toString()}'));
  }
};

class AppLogger {
  String name;

  AppLogger({this.name = ''});

  void call(Object object, {StackTrace? stackTrace, LogLevels? level}) {
    level ??= LogLevels.info;
    if (kDebugMode) {
      defaultPrinterForLogger(object, stackTrace: stackTrace, level: level, name: name);
    }
  }

  void debug(Object object, {StackTrace? stackTrace}) => call(object, stackTrace: stackTrace, level: LogLevels.debug);

  void info(Object object, {StackTrace? stackTrace}) => call(object, stackTrace: stackTrace, level: LogLevels.info);

  void warning(Object object, {StackTrace? stackTrace}) => call(object, stackTrace: stackTrace, level: LogLevels.warning);

  void error(Object object, {StackTrace? stackTrace}) => call(object, stackTrace: stackTrace, level: LogLevels.error);
}
