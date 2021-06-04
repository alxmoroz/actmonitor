// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/models/device_models.dart';
import 'package:amonitor/services/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import '../components/icons.dart';
import '../components/images.dart';
import '../components/material_wrapper.dart';
import '../components/models_list.dart';
import '../components/navbar.dart';
import '../components/text/text_widgets.dart';

class SpecsView extends StatelessWidget {
  static String get routeName => 'SpecsView';

  @override
  Widget build(BuildContext context) {
    Future<void> _selectDevice() async {
      final model = await selectModel(context, specsState.selectedModel);
      if (model != null) {
        specsState.setSelectedModel(model);
        settings.selectedModelId = model.id;
        await settings.save();
      }
    }

    Widget _buildSpecs() {
      final model = specsState.selectedModel;
      final params = model != null ? model.paramsValues['parameters'] ?? [] : <ParamValue>[];
      Widget _buildItem(int index) {
        final pv = params[index];
        final valueStr = pv.toString();
        return ListTile(
          title: SmallText(Intl.message(pv.name, name: pv.name)),
          subtitle: NormalText(Intl.message(valueStr, name: valueStr)),
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
            H3(specsState.selectedModel?.name ?? 'Select model'),
            H3(specsState.selectedModel?.detailName ?? '', padding: const EdgeInsets.only(left: 4), weight: FontWeight.w300),
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
        navigationBar: navBar(context, middle: materialWrap(_buildDeviceSelectBtn())),
        child: Container(
          decoration: bgDecoration,
          child: materialWrap(_buildSpecs()),
        ),
      ),
    );
  }
}
