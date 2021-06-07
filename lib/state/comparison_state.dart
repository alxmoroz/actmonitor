// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/models/device_models.dart';
import 'package:mobx/mobx.dart';

part 'comparison_state.g.dart';

class ComparisonState = _ComparisonStateBase with _$ComparisonState;

abstract class _ComparisonStateBase with Store {
  @observable
  ObservableList<String> comparisonModelsNames = ObservableList();

  @observable
  DeviceModel? selectedModel;

  @action
  void addComparisonModelName(String name) {
    comparisonModelsNames.add(name);
  }

  @action
  void removeComparisonModelName(String name) {
    comparisonModelsNames.remove(name);
  }

  @action
  void setComparisonModelsNames(Iterable<String> names) {
    comparisonModelsNames
      ..clear()
      ..addAll(names);
  }

  @action
  void setSelectedModel(DeviceModel model) {
    selectedModel = model;
  }
}
