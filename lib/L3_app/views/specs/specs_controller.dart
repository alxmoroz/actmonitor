// Copyright (c) 2022. Alexandr Moroz

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';

import '../../../L1_domain/entities/device_models.dart';
import '../../../L2_data/repositories/platform.dart';
import '../../extra/services.dart';

part 'specs_controller.g.dart';

class SpecsController extends _SpecsControllerBase with _$SpecsController {
  Future<SpecsController> init() async {
    // загрузка спецификаций
    await load();

    // сопоставляем текущее устройство и модель из спецификаций
    hostModel = modelForId(isPhysicalDevice ? deviceModelID : deviceModelName);

    String? selectedModelName = settingsController.settings?.selectedModelName;

    if (hostModel != null && isKnownModel(hostModel) && (selectedModelName == null || selectedModelName.isEmpty)) {
      selectedModelName = hostModel!.name;
      await settingsController.updateSelectedModel(selectedModelName);
    }
    if (selectedModelName != null) {
      setSelectedModelByName(selectedModelName);
    }
    return this;
  }
}

abstract class _SpecsControllerBase with Store {
  @observable
  DeviceModel? hostModel;

  @observable
  Map<String, dynamic> parameters = <String, List<String>>{};

  @observable
  List<DeviceModel> models = [];

  @observable
  DeviceModel? selectedModel;

  @computed
  List<DeviceModel> get knownModels => models.where((m) => isKnownModel(m)).toList(growable: false);

  @action
  void setParameters(Map<String, dynamic> params) => parameters = params;

  @action
  void setModels(List<DeviceModel> ms) => models = ms;

  @action
  void setSelectedModel(DeviceModel? model) => selectedModel = model;

  @action
  void setSelectedModelByName(String name) => selectedModel = modelForName(name);

  DeviceModel? modelForId(String? id) {
    try {
      return models.firstWhere((m) => m.ids.contains(id));
    } catch (_) {
      return null;
    }
  }

  DeviceModel? modelForName(String name) {
    try {
      return knownModels.firstWhere((m) => m.name == name);
    } catch (_) {
      return null;
    }
  }

  List<DeviceModel> modelsForNames(Iterable<String> names) => models.where((m) => names.contains(m.name)).toList(growable: false);

  List<dynamic> paramsBySection(String section) => parameters[section] ?? <dynamic>[];

  bool isKnownModel(DeviceModel? dm) => dm?.detailName != 'Unknown model';

  Future load() async {
    await _loadParams();

    final List<DeviceModel> models = [];
    for (String type in ['iphone', 'ipad', 'ipod']) {
      models.addAll(await _getSpecsForType(type));
    }
    setModels(models);
  }

  Future _loadParams() async {
    final paramsJsonString = await rootBundle.loadString('assets/data/params.json');
    final Map<String, dynamic> paramsJson = await json.decode(paramsJsonString);
    setParameters(paramsJson);
  }

  Future<List<DeviceModel>> _getSpecsForType(String type) async {
    final String deviceJsonString = await rootBundle.loadString('assets/data/$type.json');
    final Map<String, dynamic> deviceJson = await json.decode(deviceJsonString);

    final List<DeviceModel> devices = [];
    deviceJson.forEach((name, dynamic paramsValues) {
      final Map<String, List<ParamValue>> deviceParamsValues = {};
      parameters.forEach((section, dynamic params) {
        final List<ParamValue> pValues = [];
        (params as List<dynamic>).forEach((dynamic param) {
          final dynamic valueJson = paramsValues[param];
          if (valueJson != null) {
            pValues.add(ParamValue(name: param, value: valueJson));
          }
        });
        deviceParamsValues.putIfAbsent(section, () => pValues);
      });
      devices.add(DeviceModel(name, type, deviceParamsValues));
    });
    return devices;
  }
}
