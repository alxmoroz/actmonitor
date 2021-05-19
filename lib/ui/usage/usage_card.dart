import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/colors.dart';
import '../components/text/text_widgets.dart';

class UsageElement {
  const UsageElement(this.label, this.value, this.color);

  @protected
  final String label;
  @protected
  final int value;
  @protected
  final Color? color;
}

class UsageCard extends StatelessWidget {
  const UsageCard({
    required this.title,
    required this.elements,
    required this.total,
    this.base = 1024,
  });

  @protected
  final String title;
  @protected
  final List<UsageElement> elements;
  @protected
  final int total;
  @protected
  final double base;

  String bytesToString(int bytes) {
    String unit = 'KB';
    double divider = base;
    if (bytes > divider * base) {
      divider *= base;
      unit = 'MB';
    }
    if (bytes > divider * base) {
      divider *= base;
      unit = 'GB';
    }
    if (bytes > divider * base) {
      divider *= base;
      unit = 'TB';
    }
    return '${NumberFormat("0.#").format(bytes / divider)} $unit';
  }

  Widget buildUsageChart() {
    int lastValue = 0;

    return elements.isNotEmpty
        ? Stack(
            children: elements
                .map((el) {
                  lastValue += el.value;
                  final color = el.color;
                  return LinearProgressIndicator(
                    value: lastValue / total,
                    minHeight: 24,
                    valueColor: color != null ? AlwaysStoppedAnimation<Color>(color) : null,
                    backgroundColor: Colors.transparent,
                  );
                })
                .toList(growable: false)
                .reversed
                .toList(growable: false),
          )
        : Container();
  }

  Widget usageLabel(
    String title,
    int value,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NormalText(title),
          NormalText('${bytesToString(value)}'),
        ],
      );

  Widget buildLegend() => Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: elements.map((el) => usageLabel(el.label, el.value)).toList(growable: false),
      ));

  @override
  Widget build(BuildContext context) {
    return Card(
      color: greyColor6,
      margin: const EdgeInsets.all(12),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TitleText('$title ${bytesToString(total)}', padding: const EdgeInsets.all(12), align: TextAlign.left),
          buildUsageChart(),
          buildLegend(),
        ],
      ),
    );
  }
}
