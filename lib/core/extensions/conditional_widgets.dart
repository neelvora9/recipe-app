import 'package:flutter/material.dart';

extension ConditionalWidget on Widget {
  Widget showIf(bool condition) => condition ? this : const SizedBox.shrink();

  Widget wrapIf(bool condition, Widget Function(Widget) wrapper) {
    return condition ? wrapper(this) : this;
  }
}