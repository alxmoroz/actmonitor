// Copyright (c) 2021. Alexandr Moroz

import 'package:mobx/mobx.dart';

part 'comparison_state.g.dart';

class ComparisonState = _ComparisonStateBase with _$ComparisonState;

abstract class _ComparisonStateBase with Store {
  @observable
  ObservableList<String> comparisonModelsIds = ObservableList();

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
}
