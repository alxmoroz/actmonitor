import 'dart:async';

import 'package:amonitor/services/init.dart';
import 'package:flutter/cupertino.dart';

import 'compare_view.dart';
import 'components/icons.dart';
import 'specs_view.dart';
import 'usage/battery_view.dart';
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
    globalState.setContext(context);

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
