import 'package:amonitor/components/material_wrapper.dart';
import 'package:amonitor/components/text/text_widgets.dart';
import 'package:amonitor/services/init.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class BatteryView extends StatelessWidget {
  Widget buildBatteryInfo() {
    return usageState.battery.error.isEmpty
        ? Column(
            children: [
              const H3('\nBattery\n\n'),
              NormalText('Level: ${usageState.battery.level}'),
              NormalText('State: ${usageState.battery.state}'),
            ],
          )
        : NormalText(usageState.battery.error);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: materialWrap(
          Observer(
            builder: (_) => Center(
              child: buildBatteryInfo(),
            ),
          ),
        ),
      ),
    );
  }
}
