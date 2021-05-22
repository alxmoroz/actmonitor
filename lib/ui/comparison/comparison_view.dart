import 'package:amonitor/services/globals.dart';
import 'package:amonitor/ui/components/colors.dart';
import 'package:amonitor/ui/components/material_wrapper.dart';
import 'package:amonitor/ui/components/selection/separator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/text/text_widgets.dart';

class ComparisonView extends StatelessWidget {
  Widget buildBlocks() {
    //TODO: редактор выбранных устройств
    comparisonState.setComparisonDevices(specsState.knownDevices.getRange(5, 8).toList());

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
    }).toList();

    Widget buildHeader(int index) {
      return MediumText(comparableParams[index]);
    }

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
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SubtitleText('${d.name} ${d.detailName}'),
                ),
                Expanded(
                  flex: 2,
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      LinearProgressIndicator(
                        value: pv.numericValue!.toDouble() / maxScale,
                        minHeight: 21,
                        // color: tealColor,
                        backgroundColor: Colors.transparent,
                      ),
                      // SubtitleText(pv.toString(), color: darkColor, padding: const EdgeInsets.symmetric(horizontal: 4)),
                      NormalText(pv.toString(), padding: const EdgeInsets.symmetric(horizontal: 4)),
                    ],
                  ),
                ),
              ],
            ),
            const Separator(height: 8),
          ],
        );
      }).toList(growable: false);

      return Card(
        color: greyColor6,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildHeader(index),
              const SizedBox(height: 8),
              ...items,
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemBuilder: (_, index) => buildBlock(index),
      itemCount: comparableParams.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: SafeArea(
        child: materialWrap(
          buildBlocks(),
        ),
      ),
    );
  }
}
