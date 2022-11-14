// Copyright (c) 2022. Alexandr Moroz

import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../components/colors.dart';
import '../../components/icons.dart';
import '../../extra/services.dart';
import '../comparison/comparison_list_view.dart';
import '../comparison/comparison_view.dart';
import '../specs/specs_view.dart';
import '../usage/usage_view.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final Timer usageTimer;

  @override
  void initState() {
    usageTimer = Timer.periodic(Duration(seconds: usageController.updateTimerInterval), (_) async => await usageController.updateUsageInfo());
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
        inactiveColor: inactiveColor,
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
