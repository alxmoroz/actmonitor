import 'package:amonitor/services/hive_storage.dart';
import 'package:hive/hive.dart';

import 'usage_info.dart';

part 'net_stat.g.dart';

@HiveType(typeId: HType.NetStat)
class NetStat extends HiveObject {
  @HiveField(0, defaultValue: <NetInfo>[])
  List<NetInfo> records = [];
  @HiveField(1)
  NetInfo? _kernelData;

  NetInfo get kernelData => _kernelData ?? NetInfo();

  void setKernelData(NetInfo data) => _kernelData = data;
}

//TODO: общение с iOS вынести в сервисы

@HiveType(typeId: HType.NetInfo)
class NetInfo extends UsageInfo {
  @HiveField(0, defaultValue: 0)
  int wifiReceived = 0;
  @HiveField(1, defaultValue: 0)
  int wifiSent = 0;
  @HiveField(2, defaultValue: 0)
  int cellularReceived = 0;
  @HiveField(3, defaultValue: 0)
  int cellularSent = 0;
  @HiveField(4)
  DateTime? _dateTime;

  DateTime get dateTime => _dateTime ?? DateTime.now();

  void setDateTime(DateTime dt) => _dateTime = dt;

  int get total => wifiReceived + wifiSent + cellularReceived + cellularSent;

  static Future<NetInfo> get() async {
    final r = NetInfo();
    await r.getValuesFrom('getNetUsage');
    return r;
  }

  @override
  void fillData() {
    if (values.length == 4) {
      wifiReceived = values[0];
      wifiSent = values[1];
      cellularReceived = values[2];
      cellularSent = values[3];
    } else {
      throw Exception('Failed to get NET info.');
    }
  }

  Future<void> saveToUserDefaults() async {
    try {
      await channel.invokeMethod<void>('saveNetUsage', {
        'wifiReceived': wifiReceived,
        'wifiSent': wifiSent,
        'cellularReceived': cellularReceived,
        'cellularSent': cellularSent,
      });
    } on Exception catch (e) {
      status = 'error';
      exception = e;
    }
  }

  bool sameDay(NetInfo other) => dateTime.year == other.dateTime.year && dateTime.month == other.dateTime.month && dateTime.day == other.dateTime.day;

  NetInfo operator +(NetInfo other) {
    final res = NetInfo();
    res.wifiReceived = wifiReceived + other.wifiReceived;
    res.wifiSent = wifiSent + other.wifiSent;
    res.cellularReceived = cellularReceived + other.cellularReceived;
    res.cellularSent = cellularSent + other.cellularSent;
    return res;
  }

  NetInfo operator -(NetInfo other) {
    final res = NetInfo();
    res.wifiReceived = wifiReceived - other.wifiReceived;
    res.wifiSent = wifiSent - other.wifiSent;
    res.cellularReceived = cellularReceived - other.cellularReceived;
    res.cellularSent = cellularSent - other.cellularSent;
    return res;
  }

  bool operator <(NetInfo? other) {
    return other != null &&
        (wifiReceived < other.wifiReceived ||
            wifiSent < other.wifiSent ||
            cellularReceived < other.cellularReceived ||
            cellularSent < other.cellularSent);
  }
}
