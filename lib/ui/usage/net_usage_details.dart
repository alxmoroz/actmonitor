// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import '../../models/net_stat.dart';
import '../../services/globals.dart';
import '../components/notch.dart';
import '../usage/month_selector.dart';
import '../usage/usage_card.dart';
import '../usage/usage_element.dart';

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
  Iterable<NetInfo> get records => usageState.recordsForMonth(usageState.selectedMonth).toList(growable: false).reversed;

  Widget itemBuilder(BuildContext context, int index) {
    final NetInfo record = records.elementAt(index);
    return UsageCard(
      titleText: DateFormat.yMMMMd().format(record.dateTime),
      elements: [
        UsageElement.disk(record.wifiReceived, label: loc.net_wifi_received, color: CupertinoColors.activeOrange),
        UsageElement.disk(record.wifiSent, label: loc.net_wifi_sent),
        UsageElement.disk(record.cellularReceived, label: loc.net_cellular_received, color: CupertinoColors.systemIndigo),
        UsageElement.disk(record.cellularSent, label: loc.net_cellular_sent, color: CupertinoColors.systemPurple),
      ],
      total: record.total,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Notch(),
            MonthSelector(),
            SizedBox(height: sidePadding / 2),
            Expanded(
              child: Observer(
                builder: (_) => ListView.builder(
                  itemBuilder: itemBuilder,
                  itemCount: records.length,
                ),
              ),
            ),
            SizedBox(height: sidePadding),
          ],
        ),
      ),
    );
  }
}
