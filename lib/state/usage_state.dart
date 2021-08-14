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
  final int updateTimerInterval = 3;

  @observable
  RamInfo ram = RamInfo();

  @observable
  DiskInfo disk = DiskInfo();

  @observable
  BatteryInfo battery = BatteryInfo();

  @observable
  List<NetInfo> netStatRecords = [];

  @observable
  int downloadSpeed = 0;

  @observable
  int uploadSpeed = 0;

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
    final kernelData = await NetInfo.get();

    // накапливаем инфу по дням. При смене даты добавляем новую запись
    // все дельты складываем в крайний элемент (с сегодняшней датой)
    // если данных нет, складываем текущее значение kernelNetStat в элемент с текущей датой dailyStats
    final todayRecord = NetInfo();
    if (netStat.records.isEmpty || !netStat.records.last.sameDay(todayRecord)) {
      netStat.records.add(todayRecord);
    }

    // Считаем разницу между текущим и предыдущим значением kernelData
    // Если разница положительная, то добавляем её в текущий элемент
    // Если разница отрицательная (перезагрузка или переполнение), то добавляем значение из ядра
    final increment = kernelData < netStat.kernelData ? kernelData : kernelData - netStat.kernelData;
    netStat.records.last += increment;
    netStat.kernelData = kernelData;
    await netStat.save();

    netStatRecords = netStat.records;
    downloadSpeed = ((increment.wifiReceived + increment.cellularReceived) / updateTimerInterval).ceil();
    uploadSpeed = ((increment.wifiSent + increment.cellularSent) / updateTimerInterval).ceil();
    // print('netStat.records.last ${UsageElement.memory(netStat.records.last.wifiReceived)}');
    // print('KD ${UsageElement.memory(netStat.kernelData.wifiReceived)}');
    // print('increment ${UsageElement.memory(increment.wifiReceived)}');
  }

  @computed
  NetInfo get netStatSum {
    final NetInfo sumInfo = netStatRecords.fold(NetInfo(), (prev, entry) => prev + entry);
    sumInfo.done();
    return sumInfo;
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
