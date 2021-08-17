// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/models/device_models.dart';
import 'package:amonitor/services/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/card.dart';
import '../components/text/text_widgets.dart';

class ComparisonParameterCard extends StatelessWidget {
  const ComparisonParameterCard(this.paramName);

  @protected
  final String paramName;

  List<DeviceModel> get models => specsState.modelsForNames(comparisonState.comparisonModelsNames);

  @override
  Widget build(BuildContext context) {
    const String section = 'parameters';

    double maxScale = -1.0;
    models.forEach((model) {
      final pv = model.paramByName(paramName, section);
      final numValue = pv.isNum ? pv.numValue!.toDouble() : 0.0;
      if (maxScale <= numValue) {
        maxScale = numValue;
      }
    });

    final items = models.map((model) {
      final pv = model.paramByName(paramName, section);
      return Column(
        children: [
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(right: 6, top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      NormalText(model.name, align: TextAlign.right),
                      if (model.detailName.isNotEmpty) SmallText(model.detailName, padding: const EdgeInsets.only(top: 2), align: TextAlign.right),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    if (pv.isNum)
                      LinearProgressIndicator(
                        value: pv.numValue!.toDouble() / maxScale,
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
        ],
      );
    }).toList(growable: false);

    return AMCard(
      title: CardTitle(Intl.message(paramName, name: paramName)),
      body: Padding(padding: EdgeInsets.fromLTRB(sidePadding, 0, sidePadding, sidePadding), child: Column(children: [...items])),
    );
  }
}
