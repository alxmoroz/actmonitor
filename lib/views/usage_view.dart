import 'package:amonitor/components/material_wrapper.dart';
import 'package:amonitor/components/text/text_widgets.dart';
import 'package:amonitor/services/init.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

class UsageView extends StatelessWidget {
  String bytesToString(int bytes, [double base = 1024]) {
    String unit = 'KB';
    double divider = base;
    if (bytes > divider * base) {
      divider *= base;
      unit = 'MB';
    }
    if (bytes > divider * base) {
      divider *= base;
      unit = 'GB';
    }
    if (bytes > divider * base) {
      divider *= base;
      unit = 'TB';
    }
    return '${NumberFormat("0.#").format(bytes / divider)} $unit';
  }

  Widget buildRamUsageInfo() {
    return usageState.ram.error.isEmpty
        ? Column(
            children: [
              const H3('Ram Usage\n'),
              NormalText('Wired: ${bytesToString(usageState.ram.wired)}'),
              NormalText('Active: ${bytesToString(usageState.ram.active)}'),
              NormalText('Compressed: ${bytesToString(usageState.ram.compressed)}'),
              NormalText('Graphics: ${bytesToString(usageState.ram.graphics)}'),
              NormalText('Free: ${bytesToString(usageState.ram.freeTotal)}'),
              NormalText('Total: ${bytesToString(usageState.ram.total)}'),
            ],
          )
        : NormalText(usageState.ram.error);
  }

  Widget buildDiskUsageInfo() {
    return usageState.disk.error.isEmpty
        ? Column(
            children: [
              const H3('\nCapacity\n'),
              NormalText('Free: ${bytesToString(usageState.disk.free, 1000)}'),
              NormalText('Total: ${bytesToString(usageState.disk.total, 1000)}'),
            ],
          )
        : NormalText(usageState.disk.error);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: materialWrap(
          Observer(
            builder: (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildRamUsageInfo(),
                buildDiskUsageInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
