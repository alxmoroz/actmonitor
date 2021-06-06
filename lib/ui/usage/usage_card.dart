import 'package:amonitor/ui/usage/usage_chart_bar.dart';
import 'package:amonitor/ui/usage/usage_legend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/card.dart';
import '../components/text/text_widgets.dart';
import 'usage_element.dart';

class UsageCard extends StatelessWidget {
  const UsageCard({
    required this.title,
    required this.elements,
    required this.total,
    this.placeholder = '',
    this.legend,
  });

  @protected
  final String title;
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
      title: CardTitle(title),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (placeholder.isEmpty) ...[
            const SizedBox(height: 10),
            UsageChartBar(elements, total),
            legend ?? UsageLegend(elements),
          ],
          if (placeholder.isNotEmpty) NormalText(placeholder, padding: const EdgeInsets.all(10)),
        ],
      ),
    );
  }
}
