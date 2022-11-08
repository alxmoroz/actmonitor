// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/card.dart';
import '../../components/constants.dart';
import '../../text_widgets.dart';
import 'usage_chart_bar.dart';
import 'usage_element.dart';
import 'usage_legend.dart';

class UsageCard extends StatelessWidget {
  const UsageCard({
    this.title,
    this.titleText,
    required this.elements,
    required this.total,
    this.placeholder = '',
    this.legend,
    this.chartOverlay,
    this.margin,
    this.chartHeight,
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
  @protected
  final EdgeInsets? margin;
  @protected
  final double? chartHeight;

  @override
  Widget build(BuildContext context) {
    return AMCard(
      title: title ?? (titleText != null ? CardTitle(titleText!, padding: EdgeInsets.all(onePadding)) : SizedBox(height: onePadding * 2)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (placeholder.isEmpty) ...[
            Stack(
              children: [
                UsageChartBar(elements, total, height: chartHeight),
                chartOverlay ?? Container(),
              ],
            ),
            legend ?? UsageLegend(elements),
          ],
          if (placeholder.isNotEmpty) NormalText(placeholder, padding: EdgeInsets.all(onePadding)),
        ],
      ),
      margin: margin,
    );
  }
}
