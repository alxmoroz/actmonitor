import 'dart:convert';

import 'package:amonitor/models/devices.dart';
import 'package:amonitor/services/init.dart';
import 'package:flutter/services.dart';

class SpecsClient {
  static Future<void> load() async {
    await _loadParams();

    final List<Device> devices = [];
    ['ipad', 'iphone', 'ipod'].forEach((type) async {
      devices.addAll(await _loadSpecsForDevice(type));
    });
    specsState.setDevices(devices);
  }

  static Future<void> _loadParams() async {
    final paramsJsonString = await rootBundle.loadString('assets/data/params.json');
    final Map<String, dynamic> paramsJson = await json.decode(paramsJsonString);
    specsState.setParameters(paramsJson);
  }

  static Future<List<Device>> _loadSpecsForDevice(String type) async {
    final String deviceJsonString = await rootBundle.loadString('assets/data/$type.json');
    final Map<String, dynamic> deviceJson = await json.decode(deviceJsonString);

    final List<Device> devices = [];
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
      devices.add(Device(id, type, deviceParamsValues));
    });
    return devices;
  }
}
