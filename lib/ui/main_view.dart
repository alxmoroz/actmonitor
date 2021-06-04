import 'dart:async';

import 'package:amonitor/services/globals.dart';
import 'package:amonitor/ui/comparison/comparison_list_view.dart';
import 'package:amonitor/ui/comparison/comparison_view.dart';
import 'package:amonitor/ui/components/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    final tabViews = [
      UsageView(),
      SpecsView(),
      ComparisonView(),
    ];

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: navbarBgColor,
        items: [
          BottomNavigationBarItem(icon: usageTabbarIcon, label: loc.usage),
          BottomNavigationBarItem(icon: specsTabbarIcon, label: loc.specs),
          BottomNavigationBarItem(icon: compareTabbarIcon, label: loc.comparison),
        ],
      ),
      tabBuilder: (_, index) => CupertinoTabView(
        builder: (_) => tabViews[index],
        routes: {
          ComparisonListView.routeName: (_) => ComparisonListView(),
        },
      ),
    );
  }
}
