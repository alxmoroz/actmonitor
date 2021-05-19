import 'package:amonitor/services/init.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'components/material_wrapper.dart';
import 'components/text/text_widgets.dart';

class SpecsView extends StatelessWidget {
  Widget buildItem(BuildContext _, int index) {
    final device = specsState.devices[index];
    final specs = device.paramsValues.map((pv) => '${pv.parameter.name}: $pv').join('\n');

    return ListTile(
      title: NormalText(device.paramByName('Name').value.toString()),
      subtitle: SubtitleText(specs),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: NormalText('Specs')),
      child: SafeArea(
        child: materialWrap(
          Observer(
            builder: (_) => ListView.builder(
              itemBuilder: buildItem,
              itemCount: specsState.devices.length,
            ),
          ),
        ),
      ),
    );
  }
}
