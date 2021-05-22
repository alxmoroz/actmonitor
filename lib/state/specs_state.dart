// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/models/devices.dart';
import 'package:mobx/mobx.dart';

part 'specs_state.g.dart';

class SpecsState = _SpecsStateBase with _$SpecsState;

abstract class _SpecsStateBase with Store {
  @observable
  Map<String, dynamic> parameters = <String, List<String>>{};

  @observable
  List<Device> devices = [];

  // выбранное устройство
  @observable
  Device? device;

  @action
  void setParameters(Map<String, dynamic> params) {
    parameters = params;
  }

  @action
  void setDevices(List<Device> devs) {
    devices = devs;
  }

  @action
  void setDevice(Device dev) {
    device = dev;
  }

  List<Device> get knownDevices => devices.where((d) => d.isKnown).toList(growable: false);

  List<String> get devicesIds => knownDevices.map((e) => e.id).toList(growable: false);
  List<dynamic> paramsBySection(String section) => parameters[section] ?? <dynamic>[];
}
