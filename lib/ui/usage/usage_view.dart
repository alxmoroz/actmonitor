import 'package:amonitor/services/globals.dart';
import 'package:amonitor/ui/components/text/text_widgets.dart';
import 'package:amonitor/ui/usage/usage_element.dart';
import 'package:amonitor/ui/usage/usage_legend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

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
        title: '${loc.memory} ${UsageElement.memory(ram.total)}',
        total: ram.total,
        elements: [
          UsageElement.memory(ram.wired, label: loc.wired, color: CupertinoColors.activeOrange),
          UsageElement.memory(ram.active, label: loc.active),
          UsageElement.memory(ram.compressed, label: loc.compressed, color: CupertinoColors.systemIndigo),
          UsageElement.memory(ram.graphics, label: loc.graphics, color: CupertinoColors.systemPurple),
          UsageElement.memory(ram.freeTotal, label: loc.free, color: freeColor),
        ],
        placeholder: ram.placeholder,
      );
    }

    Widget buildDiskUsage() {
      final disk = usageState.disk;
      return UsageCard(
        title: '${loc.capacity} ${UsageElement.disk(disk.total)}',
        total: disk.total,
        elements: [
          UsageElement.disk(disk.total - disk.free, label: loc.used),
          UsageElement.disk(disk.free, label: loc.free, color: freeColor),
        ],
        placeholder: disk.placeholder,
      );
    }

    Widget buildBatteryUsage() {
      final battery = usageState.battery;
      final batteryLifeElements = <UsageElement>[];
      const batterySection = 'battery_life';
      specsState.paramsBySection(batterySection).forEach((dynamic p) {
        if (hostModel != null) {
          final pv = hostModel?.paramByName(p, batterySection);

          if (pv != null && pv.isNum) {
            final hours = pv.numValue!.toInt();
            batteryLifeElements.add(UsageElement.duration(
              hours * battery.level / 100,
              label: Intl.message(p, name: p),
            ));
          }
        }
      });

      return UsageCard(
        title: '${loc.battery} ${UsageElement.battery(battery.level)} ${Intl.message(battery.state, name: battery.state)}',
        total: 100,
        elements: [
          UsageElement.battery(battery.level, color: CupertinoColors.systemGreen),
          UsageElement.battery(100 - battery.level, color: freeColor),
        ],
        legend: Column(children: [
          SizedBox(height: cardPadding),
          SmallText(loc.battery_legend_title),
          UsageLegend(batteryLifeElements),
        ]),
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
                SizedBox(height: cardPadding),
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
