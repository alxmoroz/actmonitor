import 'package:amonitor/models/device_models.dart';
import 'package:amonitor/services/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../components/buttons.dart';
import '../components/colors.dart';
import '../components/icons.dart';
import '../components/material_wrapper.dart';
import '../components/models_list.dart';
import '../components/navbar.dart';
import '../components/separator.dart';
import '../components/text/text_widgets.dart';

class ComparisonListView extends StatelessWidget {
  static String get routeName => 'ComparisonListView';

  List<DeviceModel> get models => specsState.modelsForIds(comparisonState.comparisonModelsIds);

  @override
  Widget build(BuildContext context) {
    Future<void> _addModel() async {
      final model = await selectModel(context, comparisonState.selectedModel, true);
      if (model != null) {
        comparisonState.addComparisonModelId(model.id);
        comparisonState.setSelectedModel(model);
        settings.comparisonModelsIds.add(model.id);
        await settings.save();
      }
    }

    Future<void> _removeModel(DeviceModel model) async {
      comparisonState.removeComparisonModelId(model.id);
      settings.comparisonModelsIds.remove(model.id);
      await settings.save();
    }

    return CupertinoPageScaffold(
      navigationBar: navBar(
        context,
        backTitle: 'OK',
        title: 'Comparison models',
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Button('+ Model', _addModel),
                        dense: true,
                        visualDensity: VisualDensity.compact,
                      ),
                      if (comparisonState.comparisonModelsIds.length > 1)
                        ListTile(
                          title: Button.primary('Compare', () => Navigator.of(context).pop()),
                          dense: true,
                          visualDensity: VisualDensity.compact,
                        ),
                      const SizedBox(height: 12),
                    ],
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
