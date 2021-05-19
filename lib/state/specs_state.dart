// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/models/devices.dart';
import 'package:mobx/mobx.dart';

part 'specs_state.g.dart';

class SpecsState = _SpecsStateBase with _$SpecsState;

abstract class _SpecsStateBase with Store {
  @observable
  List<Parameter> parameters = [];

  @observable
  List<Device> devices = [];

  @action
  void setParameters(List<Parameter> params) {
    parameters = params;
  }

  @action
  void setDevices(List<Device> devs) {
    devices = devs;
  }
}
