// Copyright (c) 2024. Alexandr Moroz

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
  Map<String, dynamic> parameters = <String, dynamic>{};

  @observable
  List<DeviceModel> models = [];

  @observable
  DeviceModel? selectedModel;

  @computed
  List<DeviceModel> get knownModels => models.where((m) => isKnownModel(m)).toList(growable: false);

  @action
  void setParameters(Map<String, dynamic> params) => parameters = params;

  @action
  void setModels(List<DeviceModel> ms) => models = ms.reversed.toList();

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

  List<String> paramsBySection(String section) {
    final value = parameters[section];
    if (value is List<String>) {
      return value;
    } else if (value is List) {
      // Safely convert to List<String>, filtering out non-string values
      return value.whereType<String>().toList();
    }
    return <String>[];
  }

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
    final Map<String, dynamic> typedParams = {};

    paramsJson.forEach((key, value) {
      if (value is List) {
        // Safely convert list elements to strings, filtering out non-string values
        final List<String> stringList = [];
        for (final item in value) {
          if (item is String) {
            stringList.add(item);
          } else {
            // Log warning for non-string values but continue processing
            print('Warning: Non-string value "$item" found in parameter "$key", skipping');
          }
        }
        typedParams[key] = stringList;
      } else {
        // Log warning for non-list values but continue processing
        print('Warning: Non-list value found for parameter "$key", expected List<String>');
      }
    });

    setParameters(typedParams);
  }

  Future<List<DeviceModel>> _getSpecsForType(String type) async {
    final String deviceJsonString = await rootBundle.loadString('assets/data/$type.json');
    final Map<String, dynamic> deviceJson = await json.decode(deviceJsonString);

    final List<DeviceModel> devices = [];
    deviceJson.forEach((name, paramsValues) {
      final Map<String, List<ParamValue>> deviceParamsValues = {};
      parameters.forEach((section, params) {
        final List<ParamValue> pValues = [];
        if (params is List<String>) {
          params.forEach((param) {
            final valueJson = paramsValues[param];
            if (valueJson != null) {
              pValues.add(ParamValue(name: param, value: valueJson));
            }
          });
        }
        deviceParamsValues.putIfAbsent(section, () => pValues);
      });
      devices.add(DeviceModel(name, type, deviceParamsValues));
    });
    return devices;
  }
}
