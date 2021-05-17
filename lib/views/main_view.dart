import 'dart:async';

import 'package:amonitor/components/icons.dart';
import 'package:amonitor/services/init.dart';
import 'package:amonitor/views/battery_view.dart';
import 'package:amonitor/views/compare_view.dart';
import 'package:amonitor/views/specs_view.dart';
import 'package:amonitor/views/usage_view.dart';
import 'package:flutter/cupertino.dart';

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
      BatteryView(),
      SpecsView(),
      CompareView(),
    ];

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(icon: usageTabbarIcon()),
          BottomNavigationBarItem(icon: batteryTabbarIcon()),
          BottomNavigationBarItem(icon: specsTabbarIcon()),
          BottomNavigationBarItem(icon: compareTabbarIcon()),
        ],
      ),
      tabBuilder: (BuildContext context, int index) => CupertinoTabView(builder: (BuildContext context) => tabViews[index]),
    );
  }
}
