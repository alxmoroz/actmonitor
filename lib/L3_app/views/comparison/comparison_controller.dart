// Copyright (c) 2021. Alexandr Moroz

import 'package:mobx/mobx.dart';

import '../../../L1_domain/entities/device_models.dart';
import '../../extra/services.dart';

part 'comparison_controller.g.dart';

class ComparisonController extends _ComparisonControllerBase with _$ComparisonController {
  Future<ComparisonController> init() async {
    comparisonModelsNames = ObservableList.of(settingsController.settings?.comparisonModelsNames ?? []);
    return this;
  }
}

abstract class _ComparisonControllerBase with Store {
  @observable
  ObservableList<String> comparisonModelsNames = ObservableList();

  @observable
  DeviceModel? selectedModel;

  @action
  Future addComparisonModelName(String name) async {
    comparisonModelsNames.add(name);
    await settingsController.updateModelNames(comparisonModelsNames);
  }

  @action
  Future removeComparisonModelName(String name) async {
    comparisonModelsNames.remove(name);
    await settingsController.updateModelNames(comparisonModelsNames);
  }

  @action
  Future setComparisonModelsNames(Iterable<String> names) async {
    comparisonModelsNames = ObservableList.of(names);
    await settingsController.updateModelNames(comparisonModelsNames);
  }

  @action
  Future setSelectedModel(DeviceModel model) async {
    selectedModel = model;
    await settingsController.updateSelectedModel(model.name);
  }
}
