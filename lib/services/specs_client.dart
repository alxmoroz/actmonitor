import 'dart:convert';

import 'package:amonitor/models/device_models.dart';
import 'package:amonitor/services/globals.dart';
import 'package:flutter/services.dart';

class SpecsClient {
  static Future<void> load() async {
    await _loadParams();

    final List<DeviceModel> models = [];
    for (String type in ['iphone', 'ipad', 'ipod']) {
      models.addAll(await _getSpecsForType(type));
    }
    specsState.setModels(models);
  }

  static Future<void> _loadParams() async {
    final paramsJsonString = await rootBundle.loadString('assets/data/params.json');
    final Map<String, dynamic> paramsJson = await json.decode(paramsJsonString);
    specsState.setParameters(paramsJson);
  }

  static Future<List<DeviceModel>> _getSpecsForType(String type) async {
    final String deviceJsonString = await rootBundle.loadString('assets/data/$type.json');
    final Map<String, dynamic> deviceJson = await json.decode(deviceJsonString);

    final List<DeviceModel> devices = [];
    deviceJson.forEach((id, dynamic paramsValues) {
      final Map<String, List<ParamValue>> deviceParamsValues = {};
      specsState.parameters.forEach((section, dynamic params) {
        final List<ParamValue> pValues = [];
        (params as List<dynamic>).forEach((dynamic param) {
          final dynamic valueJson = paramsValues[param];
          if (valueJson != null) {
            pValues.add(ParamValue(name: param, value: valueJson));
          }
        });
        deviceParamsValues.putIfAbsent(section, () => pValues);
      });
      devices.add(DeviceModel(id, type, deviceParamsValues));
    });
    return devices;
  }
}
