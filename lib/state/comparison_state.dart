// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/models/devices.dart';
import 'package:mobx/mobx.dart';

part 'comparison_state.g.dart';

class ComparisonState = _ComparisonStateBase with _$ComparisonState;

abstract class _ComparisonStateBase with Store {
  // выбранные устройства
  @observable
  List<Device> comparisonDevices = [];

  @action
  void setComparisonDevices(List<Device> devices) {
    comparisonDevices = devices;
  }
}
