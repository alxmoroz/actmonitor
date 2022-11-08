// Copyright (c) 2021. Alexandr Moroz

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../L1_domain/entities/device_models.dart';
import '../../components/buttons.dart';
import '../../components/colors.dart';
import '../../components/icons.dart';
import '../../components/material_wrapper.dart';
import '../../components/models_list.dart';
import '../../components/navbar.dart';
import '../../components/separator.dart';
import '../../components/text_widgets.dart';
import '../../extra/services.dart';
import 'comparison_controller.dart';

class ComparisonListView extends StatelessWidget {
  static String get routeName => 'ComparisonListView';

  ComparisonController get _controller => comparisonController;

  List<DeviceModel> get models => specsController.modelsForNames(_controller.comparisonModelsNames);

  @override
  Widget build(BuildContext context) {
    Future<void> _addModel() async {
      final model = await selectModel(context, _controller.selectedModel, comparisonMode: true);
      if (model != null) {
        _controller.addComparisonModelName(model.name);
        _controller.setSelectedModel(model);
      }
    }

    Future<void> _removeModel(DeviceModel model) async {
      _controller.removeComparisonModelName(model.name);
    }

    return CupertinoPageScaffold(
      navigationBar: navBar(
        context,
        backTitle: 'OK',
        title: loc.comparison_models_title,
        trailing: Button.icon(plusIcon, _addModel, padding: const EdgeInsets.only(left: 20, right: 12, bottom: 8)),
      ),
      backgroundColor: cardBackgroundColor,
      child: materialWrap(
        Observer(
          builder: (_) => Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (_, index) {
                        final model = models[index];
                        return ListTile(
                          title: Row(
                            children: [
                              MediumText(model.name),
                              SmallText(model.detailName, padding: const EdgeInsets.only(left: 4)),
                            ],
                          ),
                          trailing: Button.icon(removeIcon, () => _removeModel(model)),
                          dense: true,
                        );
                      },
                      itemCount: models.length,
                      separatorBuilder: (_, __) => const Separator(),
                    ),
                  ),
                ],
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRect(
                    child: Container(
                      color: CupertinoDynamicColor.resolve(navbarBgColor, context),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Button(loc.add_model, _addModel),
                              dense: true,
                              visualDensity: VisualDensity.compact,
                            ),
                            if (_controller.comparisonModelsNames.length > 1)
                              ListTile(
                                title: Button.primary(loc.compare, () => Navigator.of(context).pop()),
                                dense: true,
                                visualDensity: VisualDensity.compact,
                              ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
