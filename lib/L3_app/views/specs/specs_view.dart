// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import '../../../L1_domain/entities/device_models.dart';
import '../../components/card.dart';
import '../../components/constants.dart';
import '../../components/icons.dart';
import '../../components/images.dart';
import '../../components/material_wrapper.dart';
import '../../components/models_list.dart';
import '../../components/navbar.dart';
import '../../extra/services.dart';
import '../../text_widgets.dart';
import 'specs_controller.dart';

class SpecsView extends StatelessWidget {
  static String get routeName => 'SpecsView';

  SpecsController get _controller => specsController;

  @override
  Widget build(BuildContext context) {
    Future<void> _selectDevice() async {
      final model = await selectModel(context, specsController.selectedModel);
      if (model != null) {
        _controller.setSelectedModel(model);
        await settingsController.updateSelectedModel(model.name);
      }
    }

    Widget _buildSpecs() {
      final model = _controller.selectedModel;
      final params = model != null ? model.paramsValues['parameters'] ?? [] : <ParamValue>[];
      Widget _buildItem(int index) {
        final pv = params[index];
        final valueStr = pv.toString();
        return AMCard(
          title: CardTitle(Intl.message(pv.name, name: pv.name)),
          body: NormalText(Intl.message(valueStr, name: valueStr), padding: EdgeInsets.all(onePadding)),
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
            H3(_controller.selectedModel?.name ?? 'Select model'),
            H3(_controller.selectedModel?.detailName ?? '', padding: const EdgeInsets.only(left: 4), weight: FontWeight.w300),
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
          decoration: bgDecoration(context),
          child: Column(
            children: [
              SizedBox(height: onePadding),
              Expanded(
                child: materialWrap(_buildSpecs()),
              ),
              SizedBox(height: onePadding * 3),
            ],
          ),
        ),
      ),
    );
  }
}
