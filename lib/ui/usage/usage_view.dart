import 'package:amonitor/services/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../components/images.dart';
import 'usage_card.dart';

class UsageView extends StatelessWidget {
  static String get routeName => 'UsageView';

  @override
  Widget build(BuildContext context) {
    final freeColor = CupertinoColors.systemGrey3;

    Widget buildRamUsage() {
      final ram = usageState.ram;
      return UsageCard(
        title: loc.memory,
        total: ram.total,
        elements: [
          UsageElement(loc.wired, ram.wired, CupertinoColors.activeOrange),
          UsageElement(loc.active, ram.active),
          UsageElement(loc.compressed, ram.compressed, CupertinoColors.systemIndigo),
          UsageElement(loc.graphics, ram.graphics, CupertinoColors.systemPurple),
          UsageElement(loc.free, ram.freeTotal, freeColor),
        ],
        placeholder: ram.placeholder,
      );
    }

    Widget buildDiskUsage() {
      final disk = usageState.disk;
      return UsageCard(
        title: loc.capacity,
        total: disk.total,
        elements: [
          UsageElement(loc.used, disk.total - disk.free),
          UsageElement(loc.free, disk.free, freeColor),
        ],
        base: 1000,
        placeholder: disk.placeholder,
      );
    }

    Widget buildBatteryUsage() {
      final battery = usageState.battery;
      return UsageCard(
        title: loc.battery,
        total: 100,
        elements: [
          UsageElement('Charged', battery.level),
          UsageElement('Discharged', battery.level - 100, freeColor),
        ],
        base: 1,
        placeholder: battery.placeholder,
      );
    }

    return CupertinoPageScaffold(
      child: Container(
        decoration: bgDecoration(context),
        child: SafeArea(
          child: Observer(
            builder: (_) => Column(
              children: [
                buildRamUsage(),
                buildDiskUsage(),
                buildBatteryUsage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
