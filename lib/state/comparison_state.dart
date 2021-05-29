// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/models/devices.dart';
import 'package:mobx/mobx.dart';

part 'comparison_state.g.dart';

class ComparisonState = _ComparisonStateBase with _$ComparisonState;

abstract class _ComparisonStateBase with Store {
  // выбранные устройства
  @observable
  ObservableSet<Device> comparisonDevicesSet = ObservableSet();

  @computed
  List<Device> get comparisonDevices {
    return comparisonDevicesSet.toList(growable: false);
  }

  @action
  void addComparisonDevice(Device device) {
    comparisonDevicesSet.add(device);
  }

  @action
  void removeComparisonDevice(Device device) {
    comparisonDevicesSet.remove(device);
  }

  @action
  void setComparisonDevices(Iterable<Device> devices) {
    comparisonDevicesSet
      ..clear()
      ..addAll(devices);
  }
}
