// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';

import '../../components/colors.dart';
import '../../text_widgets.dart';
import 'usage_element.dart';

class UsageLegend extends StatelessWidget {
  const UsageLegend(this.elements, {this.noLabel = false});

  @protected
  final List<UsageElement> elements;
  @protected
  final bool noLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: elements
              .map(
                (el) => Row(
                  crossAxisAlignment: noLabel ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 2, right: noLabel ? 4 : 2, top: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: CupertinoDynamicColor.resolve(el.color, context),
                        ),
                        width: 7,
                        height: 7,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!noLabel) SmallText(el.label ?? '', color: darkColor, weight: FontWeight.w300),
                        const SizedBox(height: 2),
                        MediumText(el.toString()),
                      ],
                    ),
                  ],
                ),
              )
              .toList(growable: false),
        ));
  }
}
