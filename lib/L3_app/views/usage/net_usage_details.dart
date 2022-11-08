// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import '../../../L1_domain/entities/net_stat.dart';
import '../../components/constants.dart';
import '../../components/notch.dart';
import '../../extra/services.dart';
import '../../text_widgets.dart';
import '../usage/usage_card.dart';
import 'month_selector.dart';
import 'usage_controller.dart';
import 'usage_element.dart';
import 'usage_legend.dart';

Future<void> showNetDetails(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (context) => NetDetailsView(),
  );
}

class NetDetailsView extends StatelessWidget {
  UsageController get _controller => usageController;

  Iterable<NetInfo> get records => _controller.recordsForMonth(_controller.selectedMonth).toList(growable: false).reversed;

  Widget monthSummary() {
    final NetInfo record = _controller.netStatSumForMonth(_controller.selectedMonth);
    final elements = [
      UsageElement.disk(record.wifiReceived, label: loc.net_wifi_received, color: CupertinoColors.activeOrange),
      UsageElement.disk(record.wifiSent, label: loc.net_wifi_sent),
      UsageElement.disk(record.cellularReceived, label: loc.net_cellular_received, color: CupertinoColors.systemIndigo),
      UsageElement.disk(record.cellularSent, label: loc.net_cellular_sent, color: CupertinoColors.systemPurple),
    ];
    return UsageCard(
      title: Column(children: [
        Notch(),
        MonthSelector(),
      ]),
      elements: elements,
      total: record.total,
      margin: EdgeInsets.zero,
      chartHeight: 32,
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    final NetInfo record = records.elementAt(index);
    final elements = [
      UsageElement.disk(record.wifiReceived, label: loc.net_wifi_received, color: CupertinoColors.activeOrange),
      UsageElement.disk(record.wifiSent, label: loc.net_wifi_sent),
      UsageElement.disk(record.cellularReceived, label: loc.net_cellular_received, color: CupertinoColors.systemIndigo),
      UsageElement.disk(record.cellularSent, label: loc.net_cellular_sent, color: CupertinoColors.systemPurple),
    ];
    return UsageCard(
      title: MediumText(DateFormat.MMMMd().format(record.dateTime), color: CupertinoColors.systemGrey, padding: EdgeInsets.all(onePadding)),
      elements: elements,
      legend: UsageLegend(elements, noLabel: true),
      total: record.total,
      chartHeight: 18,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) => Container(
        decoration: BoxDecoration(
          color: CupertinoDynamicColor.resolve(CupertinoColors.secondarySystemBackground, context),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Observer(
          builder: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              monthSummary(),
              SizedBox(height: onePadding),
              Expanded(
                child: ListView.builder(
                  itemBuilder: itemBuilder,
                  itemCount: records.length,
                ),
              ),
              SizedBox(height: onePadding),
            ],
          ),
        ),
      ),
    );
  }
}
