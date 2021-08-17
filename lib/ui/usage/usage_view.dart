// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import '../../services/globals.dart';
import '../components/buttons.dart';
import '../components/card.dart';
import '../components/colors.dart';
import '../components/icons.dart';
import '../components/images.dart';
import '../components/text/text_widgets.dart';
import '../usage/net_usage_details.dart';
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
          SizedBox(height: sidePadding / 2),
          SmallText(loc.battery_legend_title),
          UsageLegend(batteryLifeElements),
        ]),
        placeholder: battery.placeholder,
      );
    }

    Widget buildNetUsage() {
      final stat = usageState.netStatSumForCurrentMonth;
      final netUsageElements = [
        UsageElement.disk(stat.wifiReceived, label: loc.net_wifi_received, color: CupertinoColors.activeOrange),
        UsageElement.disk(stat.wifiSent, label: loc.net_wifi_sent),
        UsageElement.disk(stat.cellularReceived, label: loc.net_cellular_received, color: CupertinoColors.systemIndigo),
        UsageElement.disk(stat.cellularSent, label: loc.net_cellular_sent, color: CupertinoColors.systemPurple),
      ];

      return UsageCard(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: sidePadding),
          child: Row(
            children: [
              CardTitle('${loc.network}', padding: EdgeInsets.zero),
              const Spacer(),
              Button(
                '',
                () => showNetDetails(context),
                child: Row(
                  children: [
                    SmallText(
                      '${DateFormat.yMMMM().format(DateTime.now())}',
                      color: CupertinoColors.activeBlue,
                      padding: EdgeInsets.symmetric(horizontal: sidePadding / 2),
                    ),
                    netDetailsIcon,
                  ],
                ),
              ),
            ],
          ),
        ),
        total: stat.total,
        elements: netUsageElements,
        legend: Column(children: [
          SizedBox(height: sidePadding / 2),
          SmallText(
            '↓${UsageElement.disk(usageState.downloadSpeed)} / s  ↑${UsageElement.disk(usageState.uploadSpeed)} / s',
            weight: FontWeight.w300,
            color: darkColor,
          ),
          UsageLegend(netUsageElements),
        ]),
        placeholder: stat.placeholder,
      );
    }

    return CupertinoPageScaffold(
      child: Container(
        decoration: bgDecoration(context),
        child: Observer(
          builder: (_) => Column(
            children: [
              SizedBox(height: sidePadding),
              Expanded(
                child: ListView(
                  children: [
                    buildRamUsage(),
                    buildDiskUsage(),
                    buildBatteryUsage(),
                    buildNetUsage(),
                  ],
                ),
              ),
              SizedBox(height: sidePadding * 3)
            ],
          ),
        ),
      ),
    );
  }
}
