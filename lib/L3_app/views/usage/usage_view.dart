// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import '../../components/buttons.dart';
import '../../components/card.dart';
import '../../components/colors.dart';
import '../../components/constants.dart';
import '../../components/icons.dart';
import '../../components/images.dart';
import '../../extra/services.dart';
import '../../text_widgets.dart';
import 'net_usage_details.dart';
import 'usage_card.dart';
import 'usage_controller.dart';
import 'usage_element.dart';
import 'usage_legend.dart';

class UsageView extends StatelessWidget {
  static String get routeName => 'UsageView';

  UsageController get _controller => usageController;

  @override
  Widget build(BuildContext context) {
    const freeColor = CupertinoColors.systemGrey3;

    Widget buildRamUsage() {
      final ram = _controller.ram;
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
      final disk = _controller.disk;
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
      final battery = _controller.battery;
      final batteryLifeElements = <UsageElement>[];
      const batterySection = 'battery_life';
      specsController.paramsBySection(batterySection).forEach((dynamic p) {
        if (specsController.hostModel != null) {
          final pv = specsController.hostModel!.paramByName(p, batterySection);

          if (pv.isNum) {
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
          SizedBox(height: onePadding / 2),
          SmallText(loc.battery_legend_title),
          UsageLegend(batteryLifeElements),
        ]),
        placeholder: battery.placeholder,
      );
    }

    Widget buildNetUsage() {
      final stat = usageController.netStatSumForCurrentMonth;
      final netUsageElements = [
        UsageElement.disk(stat.wifiReceived, label: loc.net_wifi_received, color: CupertinoColors.activeOrange),
        UsageElement.disk(stat.wifiSent, label: loc.net_wifi_sent),
        UsageElement.disk(stat.cellularReceived, label: loc.net_cellular_received, color: CupertinoColors.systemIndigo),
        UsageElement.disk(stat.cellularSent, label: loc.net_cellular_sent, color: CupertinoColors.systemPurple),
      ];

      return UsageCard(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: onePadding),
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
                      padding: EdgeInsets.symmetric(horizontal: onePadding / 2),
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
          SizedBox(height: onePadding / 2),
          SmallText(
            '↓${UsageElement.disk(_controller.downloadSpeed)} / s  ↑${UsageElement.disk(_controller.uploadSpeed)} / s',
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
              SizedBox(height: onePadding),
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
              SizedBox(height: onePadding * 3)
            ],
          ),
        ),
      ),
    );
  }
}
