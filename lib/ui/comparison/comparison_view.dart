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
  List<DeviceModel> get devices => specsState.modelsForIds(comparisonState.comparisonModelsIds);

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
      devices.forEach((d) {
        final pv = d.paramByName(p, section);
        if (pv.comparable) {
          comparableValuesCount++;
        }
      });
      return comparableValuesCount > 0;
    }).toList(growable: false);

    return CupertinoPageScaffold(
      navigationBar: navBar(
        context,
        title: 'Comparison',
        trailing: Button('Edit', _gotoComparisonList, padding: const EdgeInsets.only(right: 12)),
      ),
      child: Container(
        decoration: bgDecoration,
        child: Column(
          children: [
            const SizedBox(height: 6),
            Expanded(
              child: ListView.builder(
                itemBuilder: (_, index) => ComparisonParameterCard(comparableParams[index]),
                itemCount: comparableParams.length,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
