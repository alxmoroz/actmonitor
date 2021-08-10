import 'package:amonitor/ui/usage/usage_element.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UsageChartBar extends StatelessWidget {
  const UsageChartBar(this.elements, this.total);

  final List<UsageElement> elements;
  final int total;

  @override
  Widget build(BuildContext context) {
    double lastValue = 0;
    return elements.isNotEmpty
        ? Stack(
            children: elements
                .map((el) {
                  lastValue += el.value.toDouble();
                  final color = el.color;
                  return LinearProgressIndicator(
                    value: lastValue / (total > 0 ? total : 1),
                    minHeight: 24,
                    valueColor: color != null ? AlwaysStoppedAnimation<Color>(CupertinoDynamicColor.resolve(color, context)) : null,
                    backgroundColor: Colors.transparent,
                  );
                })
                .toList(growable: false)
                .reversed
                .toList(growable: false),
          )
        : Container();
  }
}
