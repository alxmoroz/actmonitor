// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/models/battery_info.dart';
import 'package:amonitor/models/disk_info.dart';
import 'package:amonitor/models/ram_info.dart';
import 'package:mobx/mobx.dart';

part 'usage_state.g.dart';

class UsageState = _UsageStateBase with _$UsageState;

abstract class _UsageStateBase with Store {
  @observable
  RamInfo ram = RamInfo();

  @observable
  DiskInfo disk = DiskInfo();

  @observable
  BatteryInfo battery = BatteryInfo();

  @action
  Future<void> updateRamUsage() async {
    ram = await RamInfo.get();
  }

  @action
  Future<void> updateDiskUsage() async {
    disk = await DiskInfo.get();
  }

  @action
  Future<void> updateBatteryUsage() async {
    battery = await BatteryInfo.get();
  }
}
