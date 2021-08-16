// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/net_stat.dart';
import '../../services/globals.dart';
import '../components/notch.dart';
import '../components/text/text_widgets.dart';
import '../usage/usage_card.dart';
import '../usage/usage_element.dart';

Future<void> showNetDetails(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (context) => const NetDetailsView(),
  );
}

class NetDetailsView extends StatefulWidget {
  const NetDetailsView();

  @override
  _NetDetailsViewState createState() => _NetDetailsViewState();
}

class _NetDetailsViewState extends State<NetDetailsView> {
  Iterable<NetInfo> records = [];
  DateTime month = DateTime.now();

  @override
  void initState() {
    records = usageState.recordsForMonth(month).toList(growable: false).reversed;
    super.initState();
  }

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
            H3(DateFormat.yMMMM().format(month)),
            SizedBox(height: cardPadding / 2),
            Expanded(
              child: ListView.builder(
                itemBuilder: itemBuilder,
                itemCount: records.length,
              ),
            ),
            SizedBox(height: cardPadding),
          ],
        ),
      ),
    );
  }
}
