import 'package:amonitor/services/globals.dart';
import 'package:amonitor/ui/components/colors.dart';
import 'package:amonitor/ui/components/material_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/text/text_widgets.dart';

class ComparisonView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //TODO: редактор выбранных устройств
    comparisonState.setComparisonDevices(specsState.knownDevices.getRange(8, 12).toList(growable: false));

    final devices = comparisonState.comparisonDevices;

    // TODO: подумать при возможности над упрощением подготовки презентера этого
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

    Widget buildBlock(int index) {
      final dynamic p = comparableParams[index];
      double maxScale = -1.0;
      devices.forEach((d) {
        final pv = d.paramByName(p, section);
        final numValue = pv.numericValue!.toDouble();
        if (maxScale <= numValue) {
          maxScale = numValue;
        }
      });

      final items = devices.map((d) {
        final pv = d.paramByName(p, section);
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
              MediumText(comparableParams[index]),
              const SizedBox(height: 8),
              ...items,
            ],
          ),
        ),
      );
    }

    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: SafeArea(
        child: materialWrap(
          ListView.builder(
            itemBuilder: (_, index) => buildBlock(index),
            itemCount: comparableParams.length,
          ),
        ),
      ),
    );
  }
}
