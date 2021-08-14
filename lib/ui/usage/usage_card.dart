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
  });

  @protected
  final Widget? title;
  @protected
  final String? titleText;
  @protected
  final Widget? legend;
  @protected
  final List<UsageElement> elements;
  @protected
  final int total;
  @protected
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return AMCard(
      title: title ?? CardTitle(titleText ?? '', padding: EdgeInsets.fromLTRB(cardPadding, cardPadding, cardPadding, 0)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (placeholder.isEmpty) ...[
            SizedBox(height: cardPadding),
            UsageChartBar(elements, total),
            legend ?? UsageLegend(elements),
          ],
          if (placeholder.isNotEmpty) NormalText(placeholder, padding: EdgeInsets.all(cardPadding)),
        ],
      ),
    );
  }
}
