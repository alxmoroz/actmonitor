// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/services/init.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/selection/single_variant_selection.dart';
import '../components/text/text_widgets.dart';

class DevicesList extends StatelessWidget {
  int _selectionIndex() => specsState.devicesIds.indexOf(specsState.device?.id ?? '');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const MediumText('loc.selectDevice', align: TextAlign.center),
        const SizedBox(height: 8),
        Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 190),
          child: SingleChildScrollView(
            child: SingleVariantSelection(
              specsState.knownDevices
                  .map((device) => SelectionItem(
                      view: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          NormalText(device.name),
                          if (device.detailName.isNotEmpty) SubtitleText(device.detailName),
                        ],
                      ),
                      onSelect: () => Navigator.of(context).pop(device)))
                  .toList(growable: false),
              selectedIndex: _selectionIndex(),
              hasDivider: true,
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
