// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/models/device_models.dart';
import 'package:amonitor/services/globals.dart';
import 'package:mobx/mobx.dart';

part 'specs_state.g.dart';

class SpecsState = _SpecsStateBase with _$SpecsState;

abstract class _SpecsStateBase with Store {
  @observable
  Map<String, dynamic> parameters = <String, List<String>>{};

  @observable
  List<DeviceModel> models = [];

  @observable
  DeviceModel? selectedModel;

  @computed
  List<DeviceModel> get knownModels => models.where((m) => m.isKnown).toList(growable: false);

  @computed
  List<String> get knownModelsIds => knownModels.map((m) => m.id).toList(growable: false);

  @computed
  DeviceModel? get hostModel {
    // симулятор, неизвестное устройство
    final id = iosInfo.isPhysicalDevice ? iosInfo.utsname.machine : iosInfo.model;
    return modelForId(id);
  }

  @action
  void setParameters(Map<String, dynamic> params) {
    parameters = params;
  }

  @action
  void setModels(List<DeviceModel> ms) {
    models = ms;
  }

  @action
  void setSelectedModel(DeviceModel? model) {
    selectedModel = model;
  }

  @action
  void setSelectedModelById(String? id) {
    setSelectedModel(modelForId(id));
  }

  DeviceModel? modelForId(String? id) {
    try {
      return models.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  List<DeviceModel> modelsForIds(Iterable<String> ids) => models.where((m) => ids.contains(m.id)).toList(growable: false);

  List<dynamic> paramsBySection(String section) => parameters[section] ?? <dynamic>[];
}
