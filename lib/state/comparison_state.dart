// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/models/device_models.dart';
import 'package:mobx/mobx.dart';

part 'comparison_state.g.dart';

class ComparisonState = _ComparisonStateBase with _$ComparisonState;

abstract class _ComparisonStateBase with Store {
  @observable
  ObservableList<String> comparisonModelsIds = ObservableList();

  @observable
  DeviceModel? selectedModel;

  @action
  void addComparisonModelId(String id) {
    comparisonModelsIds.add(id);
  }

  @action
  void removeComparisonModelId(String id) {
    comparisonModelsIds.remove(id);
  }

  @action
  void setComparisonModelsIds(Iterable<String> ids) {
    comparisonModelsIds
      ..clear()
      ..addAll(ids);
  }

  @action
  void setSelectedModel(DeviceModel model) {
    selectedModel = model;
  }
}
