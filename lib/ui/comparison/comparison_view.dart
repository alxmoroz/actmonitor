// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/models/device_models.dart';
import 'package:amonitor/services/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../comparison/comparison_list_view.dart';
import '../comparison/comparison_parameter_card.dart';
import '../components/buttons.dart';
import '../components/images.dart';
import '../components/navbar.dart';

class ComparisonView extends StatefulWidget {
  static String get routeName => 'ComparisonView';

  @override
  _ComparisonViewState createState() => _ComparisonViewState();
}

class _ComparisonViewState extends State<ComparisonView> {
  List<DeviceModel> get models => specsState.modelsForNames(comparisonState.comparisonModelsNames);

  Future<void> _gotoComparisonList() async {
    await Navigator.of(context).pushNamed(ComparisonListView.routeName);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // группируем по параметрам, которые можно сравнивать для выбранных устройств
    const section = 'parameters';
    final comparableParams = specsState.paramsBySection(section).where((dynamic p) {
      int comparableValuesCount = 0;
      models.forEach((m) {
        final pv = m.paramByName(p, section);
        if (pv.isNum) {
          comparableValuesCount++;
        }
      });
      return comparableValuesCount > 1 || (models.length == 1 && comparableValuesCount > 0);
    }).toList(growable: false);

    return CupertinoPageScaffold(
      navigationBar: navBar(
        context,
        title: loc.comparison,
        trailing: Button(loc.comparison_models_list_edit, _gotoComparisonList, padding: const EdgeInsets.only(right: 12)),
      ),
      child: Container(
        decoration: bgDecoration(context),
        child: Column(
          children: [
            SizedBox(height: sidePadding),
            Expanded(
              child: ListView.builder(
                itemBuilder: (_, index) => ComparisonParameterCard(comparableParams[index]),
                itemCount: comparableParams.length,
              ),
            ),
            SizedBox(height: sidePadding * 3),
          ],
        ),
      ),
    );
  }
}
