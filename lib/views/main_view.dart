import 'package:amonitor/components/icons.dart';
import 'package:amonitor/views/battery_view.dart';
import 'package:amonitor/views/compare_view.dart';
import 'package:amonitor/views/specs_view.dart';
import 'package:amonitor/views/usage_view.dart';
import 'package:flutter/cupertino.dart';

class MainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tabViews = [
      UsageView(),
      BatteryView(),
      SpecsView(),
      CompareView(),
    ];

    // TODO: implement build
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
