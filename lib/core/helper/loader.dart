 

import 'package:layer_kit/layer_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/config/theme/theme.dart';
import 'package:myapp/config/theme/configs/theme_config.dart';

import '../utils/devlog.dart';

BuildContext? c;

showLoader(context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      c = AppRouter.context;
      return const LoaderPage();
    },
  );
}

hideLoader() {
  try {
    Navigator.pop(c ?? AppRouter.context);
  } catch (e) {
    devlogError("error in hide loader : $e");
  }
}

class LoaderPage extends StatelessWidget {
  const LoaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, r) {
        return;
      },
      child: Material(
        color: Colors.grey.shade800.withOpacity(0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4.w)),
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.background,
                  boxShadow: [
                    BoxShadow(color: context.colors.foreground.withValues(alpha: 0.1), blurRadius: 5),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    CupertinoActivityIndicator(color: context.colors.primary, radius: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
