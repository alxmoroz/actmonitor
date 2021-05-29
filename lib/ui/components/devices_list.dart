// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/models/devices.dart';
import 'package:amonitor/services/globals.dart';
import 'package:amonitor/ui/components/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'selection/single_variant_selection.dart';
import 'text/text_widgets.dart';

Future<Device?> selectDevice(BuildContext context) async {
  Device? device;
  if (specsState.devices.isNotEmpty) {
    device = await showModalBottomSheet<Device>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: false,
      useRootNavigator: true,
      builder: (context) => AMBottomSheet(DevicesList()),
    );
  }
  return device;
}

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
                      view: Row(
                        children: [
                          MediumText(device.name),
                          SmallText(device.detailName, padding: const EdgeInsets.only(left: 6)),
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
