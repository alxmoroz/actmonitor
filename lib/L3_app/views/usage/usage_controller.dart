// Copyright (c) 2022. Alexandr Moroz

import 'package:mobx/mobx.dart';

import '../../../L1_domain/entities/battery_info.dart';
import '../../../L1_domain/entities/disk_info.dart';
import '../../../L1_domain/entities/net_stat.dart';
import '../../../L1_domain/entities/ram_info.dart';
import '../../extra/services.dart';

part 'usage_controller.g.dart';

class UsageController extends _UsageControllerBase with _$UsageController {
  Future<UsageController> init() async {
    await netStatsUC.cleanData();
    await updateUsageInfo();
    return this;
  }
}

abstract class _UsageControllerBase with Store {
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

  @observable
  DateTime selectedMonth = DateTime.now();

  @action
  Future<void> _updateRamUsage() async => ram = await RamInfo.get();

  @action
  Future<void> _updateDiskUsage() async => disk = await DiskInfo.get();

  @action
  Future<void> _updateBatteryUsage() async => battery = await BatteryInfo.get();

  @action
  Future _updateNetUsage() async {
    NetStat? netStat = await netStatsUC.getOne();
    netStat ??= NetStat(records: [], kernelData: NetInfo(dateTime: DateTime.now()));
    final savedKernelData = netStat.kernelData;
    netStatRecords = netStat.records;

    // накапливаем инфу по дням. При смене даты добавляем новую запись
    // все дельты складываем в крайний элемент (с сегодняшней датой)
    // если данных нет, складываем текущее значение kernelNetStat в элемент с текущей датой dailyStats
    final todayRecord = NetInfo(dateTime: DateTime.now());
    if (netStatRecords.isEmpty || !netStatRecords.last.sameDay(todayRecord)) {
      netStatRecords.add(todayRecord);
    }

    // Считаем разницу между текущим и предыдущим значением kernelData
    // Если разница положительная, то добавляем её в текущий элемент
    // Если разница отрицательная (перезагрузка или переполнение), то добавляем значение из ядра
    final kernelData = await NetInfo.get();
    final increment = kernelData < savedKernelData ? kernelData : kernelData - savedKernelData;
    netStatRecords.last += increment;
    await netStatsUC.update(NetStat(records: netStatRecords, kernelData: kernelData));

    netStatRecords = netStatRecords;

    downloadSpeed = ((increment.wifiReceived + increment.cellularReceived) / updateTimerInterval).ceil();
    uploadSpeed = ((increment.wifiSent + increment.cellularSent) / updateTimerInterval).ceil();

    await netStatSumForCurrentMonth.saveToUserDefaults();
  }

  @action
  void setNextMonth() => selectedMonth = DateTime(selectedMonth.year, selectedMonth.month + 1);

  @action
  void setPrevMonth() => selectedMonth = DateTime(selectedMonth.year, selectedMonth.month - 1);

  @action
  void setCurrentMonth() => selectedMonth = DateTime.now();

  @computed
  DateTime get firstDate => netStatRecords.isNotEmpty ? netStatRecords.first.dateTime : DateTime.now();

  @computed
  bool get canNextMonth {
    final now = DateTime.now();
    return !(selectedMonth.year == now.year && selectedMonth.month == now.month);
  }

  @computed
  bool get canPrevMonth {
    return !(selectedMonth.year == firstDate.year && selectedMonth.month == firstDate.month);
  }

  @computed
  NetInfo get netStatSumForCurrentMonth => netStatSumForMonth(DateTime.now());

  NetInfo _sumRecords(Iterable<NetInfo> records) {
    final NetInfo sumInfo = records.fold(NetInfo(dateTime: DateTime.now()), (prev, entry) => prev + entry);
    sumInfo.done();
    return sumInfo;
  }

  NetInfo netStatSumForMonth(DateTime month) => _sumRecords(recordsForMonth(month));

  Iterable<NetInfo> recordsForMonth(DateTime month) => netStatRecords.where((r) => r.dateTime.year == month.year && r.dateTime.month == month.month);

  Future updateUsageInfo() async {
    await _updateRamUsage();
    await _updateDiskUsage();
    await _updateBatteryUsage();
    await _updateNetUsage();
  }
}
