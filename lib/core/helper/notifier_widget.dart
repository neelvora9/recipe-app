import 'package:flutter/material.dart';

class NotifierWidget<T> extends StatefulWidget {
  final T initialValue;
  final Widget Function(BuildContext context, ValueNotifier<T> state) builder;
  final Widget? child;
  final void Function(ValueNotifier<T> notifier)? onInit;
  final void Function(ValueNotifier<T> notifier)? onDispose;

  const NotifierWidget({
    super.key,
    required this.initialValue,
    required this.builder,
    this.child,
    this.onInit,
    this.onDispose,
  });

  @override
  State<NotifierWidget<T>> createState() => _NotifierWidgetState<T>();
}

class _NotifierWidgetState<T> extends State<NotifierWidget<T>> with AutomaticKeepAliveClientMixin{
  late final ValueNotifier<T> notifier;

  @override
  void initState() {
    super.initState();
    notifier = ValueNotifier(widget.initialValue);
    widget.onInit?.call(notifier);
  }

  @override
  void dispose() {
    widget.onDispose?.call(notifier);
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder<T>(
      valueListenable: notifier,
      builder: (context, value, child) => widget.builder(context, notifier),
      child: widget.child,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
