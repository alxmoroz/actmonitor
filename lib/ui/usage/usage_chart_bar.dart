// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'usage_element.dart';

class UsageChartBar extends StatelessWidget {
  const UsageChartBar(this.elements, this.total, {this.height});

  @protected
  final List<UsageElement> elements;
  @protected
  final int total;
  @protected
  final double? height;

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
                    minHeight: height ?? 24,
                    valueColor: AlwaysStoppedAnimation<Color>(CupertinoDynamicColor.resolve(color, context)),
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
