import 'package:amonitor/services/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import '../components/buttons.dart';
import '../components/card.dart';
import '../components/images.dart';
import '../components/text/text_widgets.dart';
import '../usage/usage_element.dart';
import '../usage/usage_legend.dart';
import 'usage_card.dart';

class UsageView extends StatelessWidget {
  static String get routeName => 'UsageView';

  @override
  Widget build(BuildContext context) {
    final freeColor = CupertinoColors.systemGrey3;

    Widget buildRamUsage() {
      final ram = usageState.ram;
      return UsageCard(
        titleText: '${loc.memory} ${UsageElement.memory(ram.total)}',
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
        titleText: '${loc.capacity} ${UsageElement.disk(disk.total)}',
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
        titleText: '${loc.battery} ${UsageElement.battery(battery.level)} ${Intl.message(battery.state, name: battery.state)}',
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

    Widget buildNetUsage() {
      final netInfo = usageState.netInfoAll;
      return UsageCard(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: cardPadding),
          child: Row(
            children: [
              CardTitle('${loc.network}', padding: EdgeInsets.zero),
              const Spacer(),
              SmallText('${DateFormat.yMMMMd().add_Hm().format(usageState.netInfoStartDate)}'),
              const Spacer(),
              Button.icon(const Icon(CupertinoIcons.restart, color: Colors.red), usageState.resetNetUsage),
            ],
          ),
        ),
        total: netInfo.total,
        elements: [
          UsageElement.memory(netInfo.wifiReceived, label: loc.net_wifi_received, color: CupertinoColors.activeOrange),
          UsageElement.memory(netInfo.wifiSent, label: loc.net_wifi_sent),
          UsageElement.memory(netInfo.cellularReceived, label: loc.net_cellular_received, color: CupertinoColors.systemIndigo),
          UsageElement.memory(netInfo.cellularSent, label: loc.net_cellular_sent, color: CupertinoColors.systemPurple),
        ],
        placeholder: netInfo.placeholder,
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
                buildNetUsage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
