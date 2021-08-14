import 'package:amonitor/services/hive_storage.dart';
import 'package:hive/hive.dart';

import 'usage_info.dart';

part 'net_stat.g.dart';

@HiveType(typeId: HType.NetStat)
class NetStat extends HiveObject {
  @HiveField(0, defaultValue: <NetInfo>[])
  List<NetInfo> entries = [];
  @HiveField(1)
  NetInfo? kernelData;
}

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

  NetInfo operator +(NetInfo? other) {
    if (other != null) {
      wifiReceived += other.wifiReceived;
      wifiSent += other.wifiSent;
      cellularReceived += other.cellularReceived;
      cellularSent += other.cellularSent;
    }
    return this;
  }

  NetInfo operator -(NetInfo? other) {
    if (other != null) {
      wifiReceived -= other.wifiReceived;
      wifiSent -= other.wifiSent;
      cellularReceived -= other.cellularReceived;
      cellularSent -= other.cellularSent;
    }
    return this;
  }

  bool operator <(NetInfo? other) {
    return other != null &&
        (wifiReceived < other.wifiReceived ||
            wifiSent < other.wifiSent ||
            cellularReceived < other.cellularReceived ||
            cellularSent < other.cellularSent);
  }
}
