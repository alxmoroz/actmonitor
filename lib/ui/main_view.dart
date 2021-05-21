import 'dart:async';

import 'package:amonitor/services/globals.dart';
import 'package:amonitor/ui/components/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'compare/compare_view.dart';
import 'components/icons.dart';
import 'specs/specs_view.dart';
import 'usage/usage_view.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final Timer usageTimer;

  void updateState() {
    usageState.updateRamUsage();
    usageState.updateDiskUsage();
    usageState.updateBatteryUsage();
  }

  @override
  void initState() {
    updateState();
    usageTimer = Timer.periodic(const Duration(seconds: 3), (_) => updateState());
    super.initState();
  }

  @override
  void dispose() {
    usageTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appState.setContext(context);

    final tabViews = [
      UsageView(),
      SpecsView(),
      CompareView(),
    ];

    return Container(
      decoration: bgDecoration,
      child: CupertinoTabScaffold(
        backgroundColor: Colors.transparent,
        tabBar: CupertinoTabBar(
          backgroundColor: Colors.transparent,
          items: [
            BottomNavigationBarItem(icon: usageTabbarIcon),
            BottomNavigationBarItem(icon: specsTabbarIcon),
            BottomNavigationBarItem(icon: compareTabbarIcon),
          ],
        ),
        tabBuilder: (_, index) => CupertinoTabView(
          builder: (_) => tabViews[index],
        ),
      ),
    );
  }
}
