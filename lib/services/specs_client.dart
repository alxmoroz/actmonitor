import 'dart:convert';

import 'package:amonitor/models/devices.dart';
import 'package:amonitor/services/init.dart';
import 'package:flutter/services.dart';

class SpecsClient {
  static Future<void> load() async {
    await _loadParams();
    final List<Device> devices = [];
    List<Device> specs = await _loadSpecsForDevice('ipad');
    devices.addAll(specs);
    specs = await _loadSpecsForDevice('iphone');
    devices.addAll(specs);
    devices.addAll(await _loadSpecsForDevice('ipod'));
    specsState.setDevices(devices);
  }

  static Future<void> _loadParams() async {
    final List<Parameter> params = [];
    final paramsJsonString = await rootBundle.loadString('assets/data/params.json');
    final Map<String, dynamic> paramsJson = await json.decode(paramsJsonString);

    (paramsJson['parameters'] ?? <dynamic>[]).forEach((dynamic param) {
      params.add(Parameter(param));
    });
    specsState.setParameters(params);
  }

  static Future<List<Device>> _loadSpecsForDevice(String type) async {
    final String deviceJsonString = await rootBundle.loadString('assets/data/$type.json');
    final Map<String, dynamic> deviceJson = await json.decode(deviceJsonString);

    final List<Device> devices = [];

    deviceJson.forEach((id, dynamic deviceParams) {
      final List<ParamValue> pValues = [];
      specsState.parameters.forEach((param) {
        final dynamic valueJson = deviceParams[param.name];
        if (valueJson != null) {
          pValues.add(ParamValue(parameter: param, value: valueJson));
        }
      });
      devices.add(Device(id, type, pValues));
    });

    return devices;
  }
}
