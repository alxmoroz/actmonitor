import 'package:amonitor/ui/components/colors.dart';
import 'package:amonitor/ui/components/text/text_widgets.dart';
import 'package:amonitor/ui/usage/usage_element.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                      NormalText(el.toString()),
                    ],
                  ))
              .toList(growable: false),
        ));
  }
}
