// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/models/boot_info.dart';
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
    netInfo = settings.netInfo = await NetInfo.get();
    await settings.save();
  }

  @computed
  NetInfo get netInfoAll {
    final NetInfo chunkSum = settings.netInfoChunks.fold(netInfo, (previousValue, element) => previousValue + element);
    return chunkSum - settings.netInfoResetAdjustment;
  }

  @action
  Future<void> resetNetUsage() async {
    settings.netInfoResetDate = DateTime.now();
    settings.netInfoResetAdjustment = settings.netInfo = await NetInfo.get();
    settings.netInfoChunks.clear();
    await settings.save();
  }

  DateTime get netInfoStartDate {
    return settings.netInfoResetDate != null && settings.bootDate.difference(settings.netInfoResetDate!).isNegative
        ? settings.netInfoResetDate!
        : settings.bootDate;
  }

  Future<void> updateBootInfo() async {
    final bootInfo = await BootInfo.get();
    // после перезагрузки нужно добавить инфу в чанки
    // текущая дата загрузки новее чем дата в настройках -> была перезагрузка
    //TODO: проверить
    if (settings.bootDate.difference(bootInfo.bootDate).isNegative) {
      settings.netInfoChunks.add(netInfo);
      settings.bootDate = bootInfo.bootDate;
      await settings.save();
    }
  }

  Future<void> updateUsageInfo() async {
    await updateRamUsage();
    await updateDiskUsage();
    await updateBatteryUsage();
    await updateNetUsage();
  }
}
