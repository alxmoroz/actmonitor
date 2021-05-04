import 'package:amonitor/components/material_wrapper.dart';
import 'package:amonitor/components/text/text_widgets.dart';
import 'package:flutter/cupertino.dart';

class BatteryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: materialWrap(
          const Center(
            child: H3('Battery'),
          ),
        ),
      ),
    );
  }
}
