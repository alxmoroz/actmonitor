import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/colors.dart';
import '../components/text/text_widgets.dart';
import 'usage_element.dart';

class UsageLegend extends StatelessWidget {
  const UsageLegend(this.elements);

  final List<UsageElement> elements;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: elements
              .map((el) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SmallText(el.label ?? '', color: darkColor),
                      const SizedBox(height: 2),
                      MediumText(el.toString()),
                    ],
                  ))
              .toList(growable: false),
        ));
  }
}
