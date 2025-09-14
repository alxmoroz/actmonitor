// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../L1_domain/entities/device_models.dart';
import '../../components/buttons.dart';
import '../../components/constants.dart';
import '../../components/images.dart';
import '../../components/navbar.dart';
import '../../extra/services.dart';
import 'comparison_controller.dart';
import 'comparison_list_view.dart';
import 'comparison_parameter_card.dart';

class ComparisonView extends StatelessWidget {
  static String get routeName => 'ComparisonView';

  ComparisonController get _controller => comparisonController;

  List<DeviceModel> get models => specsController.modelsForNames(_controller.comparisonModelsNames);

  Future _gotoComparisonList(BuildContext context) async => await Navigator.of(context).pushNamed(ComparisonListView.routeName);

  List<String> get comparableParams {
    const section = 'parameters';
    return specsController.paramsBySection(section).where((p) {
      int comparableValuesCount = 0;
      models.forEach((m) {
        final pv = m.paramByName(p, section);
        if (pv.isNum) {
          comparableValuesCount++;
        }
      });
      return comparableValuesCount > 1 || (models.length == 1 && comparableValuesCount > 0);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // группируем по параметрам, которые можно сравнивать для выбранных устройств

    return CupertinoPageScaffold(
      navigationBar: navBar(
        context,
        title: loc.comparison,
        trailing: Button(loc.comparison_models_list_edit, () => _gotoComparisonList(context), padding: EdgeInsets.only(right: onePadding)),
      ),
      child: Observer(
        builder: (_) => Container(
          decoration: bgDecoration(context),
          child: Column(
            children: [
              SizedBox(height: onePadding),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (_, index) => ComparisonParameterCard(comparableParams[index]),
                  itemCount: comparableParams.length,
                ),
              ),
              SizedBox(height: onePadding * 3),
            ],
          ),
        ),
      ),
    );
  }
}
