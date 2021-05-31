import 'package:amonitor/models/device_models.dart';
import 'package:amonitor/services/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/colors.dart';
import '../components/text/text_widgets.dart';

class ComparisonParameterCard extends StatelessWidget {
  const ComparisonParameterCard(this.paramName);

  @protected
  final String paramName;

  List<DeviceModel> get models => specsState.modelsForIds(comparisonState.comparisonModelsIds);

  @override
  Widget build(BuildContext context) {
    const String section = 'parameters';

    double maxScale = -1.0;
    models.forEach((model) {
      final pv = model.paramByName(paramName, section);
      final numValue = pv.comparable ? pv.numericValue!.toDouble() : 0.0;
      if (maxScale <= numValue) {
        maxScale = numValue;
      }
    });

    final items = models.map((model) {
      final pv = model.paramByName(paramName, section);
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(right: 6, top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      NormalText(model.name, align: TextAlign.right),
                      if (model.detailName.isNotEmpty) SmallText(model.detailName, padding: const EdgeInsets.only(top: 2), align: TextAlign.right),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    if (pv.comparable)
                      LinearProgressIndicator(
                        value: pv.numericValue!.toDouble() / maxScale,
                        minHeight: 24,
                        backgroundColor: Colors.transparent,
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4, top: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MediumText(pv.numValString),
                          SmallText(pv.valString, padding: const EdgeInsets.only(top: 2)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      );
    }).toList(growable: false);

    return Card(
      color: CupertinoDynamicColor.resolve(cardBackgroundColor, context),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            H3(paramName, color: CupertinoColors.systemGrey),
            const SizedBox(height: 8),
            ...items,
          ],
        ),
      ),
    );
  }
}
