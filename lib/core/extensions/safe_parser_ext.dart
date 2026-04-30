extension SafeParser on Object? {
  // ─────────────────────────────
  // BOOL
  // ─────────────────────────────
  bool toBool() {
    if (this is bool) return this as bool;
    if (this is String) {
      return toString().toLowerCase() == 'true' || this == '1';
    }
    if (this is int) return this == 1;
    return false;
  }

  bool? toBoolOrNull() {
    if (this == null) return null;
    if (this is bool) return this as bool;
    if (this is String) {
      final val = toString().toLowerCase();
      if (val == 'true' || val == '1') return true;
      if (val == 'false' || val == '0') return false;
    }
    if (this is int) return this == 1;
    return null;
  }

  // ─────────────────────────────
  // STRING
  // ─────────────────────────────
  String toStr({String defaultValue = ""}) {
    if (this == null) return defaultValue;
    return toString();
  }

  String? toStrOrNull() {
    if (this == null) return null;
    return toString();
  }

  // ─────────────────────────────
  // INT
  // ─────────────────────────────
  int toInt({int defaultValue = 0}) {
    if (this is int) return this as int;
    if (this is double) return (this as double).toInt();
    if (this is String) return int.tryParse(this as String) ?? defaultValue;
    return defaultValue;
  }

  int? toIntOrNull() {
    if (this == null) return null;
    if (this is int) return this as int;
    if (this is double) return (this as double).toInt();
    if (this is String) return int.tryParse(this as String);
    return null;
  }

  // ─────────────────────────────
  // DOUBLE
  // ─────────────────────────────
  double toDouble({double defaultValue = 0.0}) {
    if (this is double) return this as double;
    if (this is int) return (this as int).toDouble();
    if (this is String) return double.tryParse(this as String) ?? defaultValue;
    return defaultValue;
  }

  double? toDoubleOrNull() {
    if (this == null) return null;
    if (this is double) return this as double;
    if (this is int) return (this as int).toDouble();
    if (this is String) return double.tryParse(this as String);
    return null;
  }

  // ─────────────────────────────
  // LIST
  // ─────────────────────────────
  List<T> toList<T>() {
    if (this is List) {
      return (this as List).map((e) => e as T).toList();
    }
    return [];
  }

  List<T>? toListOrNull<T>() {
    if (this == null) return null;
    if (this is List) {
      return (this as List).where((e) => e is T).cast<T>().toList();
    }
    return null;
  }

  // ─────────────────────────────
  // MAP
  // ─────────────────────────────
  Map<String, dynamic> toMap() {
    if (this is Map<String, dynamic>) {
      return this as Map<String, dynamic>;
    }
    return {};
  }

  Map<String, dynamic>? toMapOrNull() {
    if (this == null) return null;
    if (this is Map<String, dynamic>) {
      return this as Map<String, dynamic>;
    }
    return null;
  }

  // ─────────────────────────────
  // NULL CAST
  // ─────────────────────────────
  T? toNullable<T>() {
    if (this == null) return null;
    return this as T;
  }

  // ─────────────────────────────
  // DATE TIME
  // ─────────────────────────────
  DateTime? toDateTime() {
    if (this is DateTime) return this as DateTime;
    if (this is String) return DateTime.tryParse(this as String);
    return null;
  }

  DateTime? toDateTimeOrNull() {
    return toDateTime(); // same behavior
  }

  // ─────────────────────────────
  // MAP LIST
  // ─────────────────────────────
  List<Map<String, dynamic>> toMapList() {
    if (this is List) {
      return (this as List).whereType<Map<String, dynamic>>().toList();
    }
    return [];
  }

  List<Map<String, dynamic>>? toMapListOrNull() {
    if (this == null) return null;
    if (this is List) {
      return (this as List).whereType<Map<String, dynamic>>().toList();
    }
    return null;
  }
}
