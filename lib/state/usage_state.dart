// Copyright (c) 2021. Alexandr Moroz

import 'package:mobx/mobx.dart';

import '../models/battery_info.dart';
import '../models/disk_info.dart';
import '../models/net_info.dart';
import '../models/ram_info.dart';
import '../services/globals.dart';

part 'usage_state.g.dart';

class UsageState = _UsageStateBase with _$UsageState;

abstract class _UsageStateBase with Store {
  @observable
  RamInfo ram = RamInfo();

  @observable
  DiskInfo disk = DiskInfo();

  @observable
  BatteryInfo battery = BatteryInfo();

  @observable
  NetInfo netInfo = NetInfo();

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

  @action
  Future<void> updateNetUsage() async {
    final savedInfo = settings.netInfo ?? NetInfo();
    final currentInfo = await NetInfo.get();
    //TODO: нужно проверять на факт перезагрузки (время перезагрузки позже, чем время сохранения)
    if (currentInfo.wifiReceived < savedInfo.wifiReceived ||
        currentInfo.wifiSent < savedInfo.wifiSent ||
        currentInfo.cellularReceived < savedInfo.cellularReceived ||
        currentInfo.cellularSent < savedInfo.cellularSent) {
      settings.netInfoChunks.add(savedInfo);
    }
    settings.netInfo = currentInfo;
    await settings.save();

    netInfo = settings.netInfoChunks.fold(savedInfo, (previousValue, element) => previousValue + element);
  }
}
