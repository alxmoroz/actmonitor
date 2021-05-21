// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/models/devices.dart';
import 'package:amonitor/services/globals.dart';
import 'package:amonitor/ui/components/selection/separator.dart';
import 'package:amonitor/ui/specs/devices_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../components/bottom_safe_padding.dart';
import '../components/bottom_sheet.dart';
import '../components/icons.dart';
import '../components/material_wrapper.dart';
import '../components/text/text_widgets.dart';

class SpecsView extends StatelessWidget {
  Future<void> _selectDevice() async {
    if (specsState.devices.isNotEmpty) {
      final device = await showModalBottomSheet<Device>(
        context: appState.context!,
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

    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemBuilder: (_, index) => _buildItem(index),
        itemCount: params.length,
        separatorBuilder: (_, int index) => const Separator(height: 4),
      ),
    );
  }

  Widget _buildDeviceSelectBtn() {
    final detName = specsState.device?.detailName ?? '';
    return ListTile(
      title: TitleText(specsState.device?.name ?? 'Select device'),
      subtitle: detName.isNotEmpty ? SubtitleText(detName) : null,
      trailing: dropdownIcon,
      onTap: _selectDevice,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // backgroundColor: greyColor3,
      backgroundColor: Colors.transparent,
      child: SafeArea(
        child: materialWrap(
          Observer(
            builder: (_) => Column(
              children: [
                const SizedBox(height: 8),
                _buildDeviceSelectBtn(),
                _buildSpecs(),
                BottomSafePadding(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
