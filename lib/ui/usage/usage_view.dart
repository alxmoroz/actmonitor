import 'package:amonitor/services/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'usage_card.dart';

class UsageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final freeColor = CupertinoColors.systemGrey3;

    Widget buildRamUsage() {
      final ram = usageState.ram;
      return UsageCard(
        title: 'Memory',
        total: ram.total,
        elements: [
          UsageElement('Wired', ram.wired, CupertinoColors.activeOrange),
          UsageElement('Active', ram.active),
          UsageElement('Compressed', ram.compressed, CupertinoColors.systemIndigo),
          UsageElement('Graphics', ram.graphics, CupertinoColors.systemPurple),
          UsageElement('Free', ram.freeTotal, freeColor),
        ],
        placeholder: ram.placeholder,
      );
    }

    Widget buildDiskUsage() {
      final disk = usageState.disk;
      return UsageCard(
        title: 'Capacity',
        total: disk.total,
        elements: [
          UsageElement('Used', disk.total - disk.free),
          UsageElement('Free', disk.free, freeColor),
        ],
        base: 1000,
        placeholder: disk.placeholder,
      );
    }

    Widget buildBatteryUsage() {
      final battery = usageState.battery;
      return UsageCard(
        title: 'Battery',
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
      backgroundColor: Colors.transparent,
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
    );
  }
}
