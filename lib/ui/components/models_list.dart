// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/models/device_models.dart';
import 'package:amonitor/services/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bottom_sheet.dart';
import 'selection/single_variant_selection.dart';
import 'text/text_widgets.dart';

Future<DeviceModel?> selectModel(BuildContext context, String id) async {
  DeviceModel? model;
  if (specsState.models.isNotEmpty) {
    model = await showModalBottomSheet<DeviceModel>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: false,
      useRootNavigator: true,
      builder: (context) => AMBottomSheet(ModelsList(id)),
    );
  }
  return model;
}

class ModelsList extends StatelessWidget {
  const ModelsList(this.selectedId);

  @protected
  final String selectedId;

  int _selectionIndex() => specsState.knownModelsIds.indexOf(selectedId);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const MediumText('Select model', align: TextAlign.center),
        const SizedBox(height: 8),
        Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 190),
          child: SingleChildScrollView(
            child: SingleVariantSelection(
              specsState.knownModels
                  .map((model) => SelectionItem(
                      view: Row(
                        children: [
                          MediumText(model.name),
                          SmallText(model.detailName, padding: const EdgeInsets.only(left: 6)),
                        ],
                      ),
                      onSelect: () => Navigator.of(context).pop(model)))
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
