// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/services/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/card.dart';
import '../components/text/text_widgets.dart';
import '../usage/usage_chart_bar.dart';
import '../usage/usage_legend.dart';
import 'usage_element.dart';

class UsageCard extends StatelessWidget {
  const UsageCard({
    this.title,
    this.titleText,
    required this.elements,
    required this.total,
    this.placeholder = '',
    this.legend,
    this.chartOverlay,
  });

  @protected
  final Widget? title;
  @protected
  final String? titleText;
  @protected
  final Widget? legend;
  @protected
  final Widget? chartOverlay;
  @protected
  final List<UsageElement> elements;
  @protected
  final int total;
  @protected
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return AMCard(
      title: title ?? CardTitle(titleText ?? '', padding: EdgeInsets.all(cardPadding)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (placeholder.isEmpty) ...[
            Stack(
              children: [
                UsageChartBar(elements, total),
                chartOverlay ?? Container(),
              ],
            ),
            legend ?? UsageLegend(elements),
          ],
          if (placeholder.isNotEmpty) NormalText(placeholder, padding: EdgeInsets.all(cardPadding)),
        ],
      ),
    );
  }
}
