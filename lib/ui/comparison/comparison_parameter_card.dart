import 'package:amonitor/models/devices.dart';
import 'package:amonitor/services/globals.dart';
import 'package:amonitor/ui/components/colors.dart';
import 'package:amonitor/ui/components/text/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ComparisonParameterCard extends StatelessWidget {
  const ComparisonParameterCard(this.paramName);

  @protected
  final String paramName;

  List<Device> get _devices => comparisonState.comparisonDevices;

  static const String section = 'parameters';

  @override
  Widget build(BuildContext context) {
    double maxScale = -1.0;
    _devices.forEach((d) {
      final pv = d.paramByName(paramName, section);
      final numValue = pv.numericValue!.toDouble();
      if (maxScale <= numValue) {
        maxScale = numValue;
      }
    });

    final items = _devices.map((d) {
      final pv = d.paramByName(paramName, section);
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4, top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      NormalText(d.name),
                      SubtitleText(d.detailName, padding: const EdgeInsets.only(top: 2)),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    LinearProgressIndicator(value: pv.numericValue!.toDouble() / maxScale, minHeight: 24, backgroundColor: Colors.transparent),
                    Padding(
                      padding: const EdgeInsets.only(left: 4, top: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MediumText(pv.numValString),
                          SubtitleText(pv.valString, padding: const EdgeInsets.only(top: 2)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      );
    }).toList(growable: false);

    return Card(
      color: CupertinoDynamicColor.resolve(cardBackgroundColor, context),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MediumText(paramName),
            const SizedBox(height: 8),
            ...items,
          ],
        ),
      ),
    );
  }
}
