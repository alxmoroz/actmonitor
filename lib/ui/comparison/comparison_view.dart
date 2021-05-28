import 'package:amonitor/services/globals.dart';
import 'package:amonitor/ui/comparison/comparison_list_view.dart';
import 'package:amonitor/ui/comparison/comparison_parameter_card.dart';
import 'package:amonitor/ui/components/images.dart';
import 'package:amonitor/ui/components/navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ComparisonView extends StatefulWidget {
  static String get routeName => 'ComparisonView';

  @override
  _ComparisonViewState createState() => _ComparisonViewState();
}

class _ComparisonViewState extends State<ComparisonView> {
  Future<void> _gotoComparisonList() async {
    await Navigator.of(context).pushNamed(ComparisonListView.routeName);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //TODO: редактор выбранных устройств
    comparisonState.setComparisonDevices(specsState.knownDevices.getRange(8, 12).toList(growable: false));

    final devices = comparisonState.comparisonDevices;

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
        trailing: CupertinoButton(onPressed: _gotoComparisonList, padding: const EdgeInsets.only(right: 12), child: const Text('Edit')),
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
