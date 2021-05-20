import 'package:amonitor/services/init.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../components/colors.dart';
import 'usage_card.dart';

class UsageView extends StatelessWidget {
  Widget buildRamUsage(BuildContext ctx) {
    final ram = usageState.ram;
    return UsageCard(
      title: 'Memory',
      total: ram.total,
      elements: [
        UsageElement('Wired', ram.wired, warningColor),
        UsageElement('Active', ram.active, null),
        UsageElement('Compressed', ram.compressed, indigoColor),
        UsageElement('Graphics', ram.graphics, purpleColor),
        UsageElement('Free', ram.freeTotal, greyColor4),
      ],
      placeholder: ram.placeholder,
    );
  }

  Widget buildDiskUsage(BuildContext ctx) {
    final disk = usageState.disk;
    return UsageCard(
      title: 'Capacity',
      total: disk.total,
      elements: [
        UsageElement('Used', disk.total - disk.free, null),
        UsageElement('Free', disk.free, greyColor4),
      ],
      base: 1000,
      placeholder: disk.placeholder,
    );
  }

  Widget buildBatteryUsage(BuildContext ctx) {
    final battery = usageState.battery;
    return UsageCard(
      title: 'Battery',
      total: 100,
      elements: [
        UsageElement('Charged', battery.level, null),
        UsageElement('Discharged', battery.level - 100, greyColor4),
      ],
      base: 1,
      placeholder: battery.placeholder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: SafeArea(
        child: Observer(
          builder: (_) => Column(
            children: [
              buildRamUsage(context),
              buildDiskUsage(context),
              buildBatteryUsage(context),
            ],
          ),
        ),
      ),
    );
  }
}
