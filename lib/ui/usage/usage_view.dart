import 'package:amonitor/services/init.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../components/colors.dart';
import '../components/material_wrapper.dart';
import '../components/text/text_widgets.dart';
import 'usage_card.dart';

class UsageView extends StatelessWidget {
  Widget buildRamUsage(BuildContext ctx) {
    final ram = usageState.ram;
    return ram.error.isEmpty
        ? UsageCard(
            title: 'Memory',
            total: ram.total,
            elements: [
              UsageElement('Wired', ram.wired, warningColor),
              UsageElement('Active', ram.active, null),
              UsageElement('Compressed', ram.compressed, indigoColor),
              UsageElement('Graphics', ram.graphics, purpleColor),
              UsageElement('Free', ram.freeTotal, greyColor4),
            ],
          )
        : NormalText(ram.error);
  }

  Widget buildDiskUsage(BuildContext ctx) {
    final disk = usageState.disk;
    return disk.error.isEmpty
        ? UsageCard(
            title: 'Capacity',
            total: disk.total,
            elements: [
              UsageElement('Used', disk.total - disk.free, null),
              UsageElement('Free', disk.free, greyColor4),
            ],
            base: 1000,
          )
        : NormalText(disk.error);
  }

  Widget buildBatteryUsage(BuildContext ctx) {
    final battery = usageState.battery;
    return battery.error.isEmpty
        ? UsageCard(
            title: 'Battery',
            total: 100,
            elements: [
              UsageElement('Charged', battery.level, null),
              UsageElement('Discharged', battery.level - 100, greyColor4),
            ],
            base: 1,
          )
        : NormalText(battery.error);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: materialWrap(
          Observer(
            builder: (_) => Column(
              children: [
                buildRamUsage(context),
                buildDiskUsage(context),
                buildBatteryUsage(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
