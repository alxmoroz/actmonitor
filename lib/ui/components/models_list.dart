// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/models/device_models.dart';
import 'package:amonitor/services/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'notch.dart';
import 'selection/single_variant_selection.dart';
import 'text/text_widgets.dart';

Future<DeviceModel?> selectModel(BuildContext context, DeviceModel? selectedModel, [bool exclude = false]) async {
  DeviceModel? model;
  if (specsState.models.isNotEmpty) {
    model = await showModalBottomSheet<DeviceModel>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) => ModelsList(selectedModel, exclude),
    );
  }
  return model;
}

class ModelsList extends StatefulWidget {
  const ModelsList(this.selectedModel, this.exclude);

  @protected
  final DeviceModel? selectedModel;
  @protected
  final bool exclude;

  @override
  _ModelsListState createState() => _ModelsListState();
}

class _ModelsListState extends State<ModelsList> with TickerProviderStateMixin {
  late String selectedType;

  Iterable<DeviceModel> get pageModels => specsState.knownModels.where((m) => m.type == selectedType);

  int selectedIndex() => widget.selectedModel != null && !widget.exclude ? pageModels.toList(growable: false).indexOf(widget.selectedModel!) : -1;

  @override
  void initState() {
    selectedType = widget.selectedModel != null ? widget.selectedModel!.type : 'iphone';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.85,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) => Container(
        decoration: BoxDecoration(
          color: CupertinoDynamicColor.resolve(CupertinoColors.tertiarySystemBackground, context),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Notch(),
            const MediumText('Select model', align: TextAlign.center),
            const SizedBox(height: 8),
            CupertinoSlidingSegmentedControl(
              children: const {
                'iphone': MediumText('iPhone'),
                'ipad': MediumText('iPad'),
                'ipod': MediumText('iPod touch'),
              },
              groupValue: selectedType,
              onValueChanged: (type) {
                setState(() {
                  selectedType = type.toString();
                });
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: SingleVariantSelection(
                  pageModels
                      .map((model) => SelectionItem(
                          view: Row(
                            children: [
                              MediumText(model.name),
                              SmallText(model.detailName, padding: const EdgeInsets.only(left: 6)),
                            ],
                          ),
                          onSelect: () => Navigator.of(context).pop(model)))
                      .toList(growable: false),
                  selectedIndex: selectedIndex(),
                  hasDivider: true,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
