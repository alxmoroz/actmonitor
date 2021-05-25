// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/models/devices.dart';
import 'package:amonitor/services/globals.dart';
import 'package:amonitor/ui/specs/devices_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../components/bottom_sheet.dart';
import '../components/icons.dart';
import '../components/material_wrapper.dart';
import '../components/text/text_widgets.dart';

class SpecsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> _selectDevice() async {
      if (specsState.devices.isNotEmpty) {
        final device = await showModalBottomSheet<Device>(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          enableDrag: false,
          useRootNavigator: true,
          builder: (context) => AMBottomSheet(DevicesList()),
        );
        if (device != null) {
          specsState.setDevice(device);
        }
      }
    }

    Widget _buildSpecs() {
      final device = specsState.device;
      final params = device != null ? device.paramsValues['parameters'] ?? [] : <ParamValue>[];
      Widget _buildItem(int index) {
        final pv = params[index];
        return ListTile(
          title: SubtitleText(pv.name),
          subtitle: NormalText(pv.toString()),
          visualDensity: VisualDensity.compact,
          dense: true,
        );
      }

      return ListView.builder(
        itemBuilder: (_, index) => _buildItem(index),
        itemCount: params.length,
      );
    }

    Widget _buildDeviceSelectBtn() {
      return ListTile(
        title: Row(
          children: [
            TitleText(specsState.device?.name ?? 'Select device', color: CupertinoColors.systemGrey6),
            TitleText(
              specsState.device?.detailName ?? '',
              color: CupertinoColors.systemGrey5,
              padding: const EdgeInsets.only(left: 4),
              weight: FontWeight.w300,
            ),
          ],
        ),
        trailing: dropdownIcon,
        onTap: _selectDevice,
        dense: true,
        visualDensity: VisualDensity.compact,
      );
    }

    return Observer(
      builder: (_) => CupertinoPageScaffold(
        backgroundColor: Colors.transparent,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.systemFill,
          middle: materialWrap(_buildDeviceSelectBtn()),
        ),

        /// тень
        // Container(
        //   height: 12,
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //       begin: Alignment.topCenter,
        //       end: Alignment.bottomCenter,
        //       colors: [Color(0x33000000), Color(0x00000000)],
        //     ),
        //   ),
        // ),
        child: materialWrap(
          _buildSpecs(),
        ),
      ),
    );
  }
}
