// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/models/boot_info.dart';
import 'package:mobx/mobx.dart';

import '../models/battery_info.dart';
import '../models/disk_info.dart';
import '../models/net_stat.dart';
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
    netInfo = await NetInfo.get();

    //TODO: накапливать инфу по дням. При смене даты
    // все дельты складываем в элемент с текущей датой
    // как посчитать дельту:
    // - если данных нет, складываем текущее значение kernelNetStat в элемент с текущей датой dailyStats
    // - считаем разницу между текущим и предыдущим значением kernelNetStat
    // - если разница положительная, то добавляем её в текущий элемент. Если разница отрицательная (перезагрузка или переполнение)
    // , то добавляем значение из ядра

    if (netInfo < netStat.kernelData) {
      netStat.entries.add(netInfo);
    }

    netStat.kernelData = netInfo;
    await netStat.save();
  }

  @computed
  NetInfo get netInfoAll {
    final NetInfo chunkSum = netStat.entries.fold(netInfo, (previousValue, element) => previousValue + element);
    return chunkSum;
  }

  Future<void> updateBootInfo() async {
    final bootInfo = await BootInfo.get();
    settings.bootDate = bootInfo.bootDate;
    await settings.save();
  }

  Future<void> updateUsageInfo() async {
    await updateRamUsage();
    await updateDiskUsage();
    await updateBatteryUsage();
    await updateNetUsage();
  }
}
