import 'package:flutter/material.dart';
import 'package:layer_kit/layer_kit.dart';
import 'package:myapp/config/lang/app_localization.dart';
import 'package:myapp/config/theme/configs/theme_config.dart';
import 'package:myapp/config/theme/configs/theme_extensions.dart';
import 'package:myapp/config/theme/theme.dart';
import 'package:myapp/core/constants/app_strings.dart';
import 'package:myapp/src/home/screens/home_screen.dart';
import 'package:myapp/src/settings/screens/settings_screen.dart';

import '../config/routes/routes.dart';
import '../config/theme/atoms/text.dart';

class MainScreen extends StatefulWidget with BaseRoute {
  final int? initialIndex;

  const MainScreen({super.key, this.initialIndex});

  @override
  State<MainScreen> createState() => _MainScreenState();

  @override
  Widget get screen => this;

  @override
  Routes get routeName => Routes.mainscreen;
}

enum BottomNavItem {
  home(Icons.home),
  activity(Icons.message),
  profile(Icons.settings);

  final IconData icon;

  const BottomNavItem(this.icon);

  BaseRoute get route => switch (this) {
        BottomNavItem.home => HomeScreen() as BaseRoute,
        BottomNavItem.activity => HomeScreen() as BaseRoute,
        BottomNavItem.profile => SettingScreen() as BaseRoute,
      };

  String get title => switch (this) {
        BottomNavItem.home => "home".tr(),
        BottomNavItem.activity => "demo".tr(),
        BottomNavItem.profile => "settings".tr(),
      };
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  late final PageController pctr;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex ?? 0;
    pctr = PageController(initialPage: currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppString.custom("${BottomNavItem.values[currentIndex].title} ${"".tr()}").appbar.build(color: context.colors.primary),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  currentIndex = 2;
                  pctr.jumpToPage(2);
                });
              },
              color: context.colors.primary,
              icon: Icon(Icons.settings))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: BottomNavItem.values
            .map((e) => BottomNavigationBarItem(
                  icon: Icon(
                    e.icon,
                    color: currentIndex == e.index ? context.colors.primary : context.colors.foreground,
                  ),
                  label: e.title,
                ))
            .toList(),
        unselectedItemColor: context.colors.foreground.withOpacity(0.5),
        selectedItemColor: context.colors.primary,
        currentIndex: currentIndex,
        selectedFontSize: 1.8.h,
        onTap: (index) => setState(() {
          currentIndex = index;
          pctr.jumpToPage(index);
        }),
      ),
      body: Center(
        child: PageView(
          controller: pctr,

          ///UNCOMMENT THIS LINE TO DISABLE HORIZONTAL SCROLL
          // physics: NeverScrollableScrollPhysics(),
          onPageChanged: (index) => setState(() => currentIndex = index),
          children: BottomNavItem.values.map((e) => e.route.screen).toList(),
        ),
      ),
    );
  }
}

//  IndexedStack(
//     index: currentIndex,
//     children: BottomNavItem.values.map((e) => e.route.screen).toList(),
//   )
