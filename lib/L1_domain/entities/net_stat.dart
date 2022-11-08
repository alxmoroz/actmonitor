import '../../L1_domain/entities/usage_info.dart';
import 'base_entity.dart';

class NetStat extends LocalPersistable {
  NetStat({
    super.id = 'NetStat',
    required this.records,
    required this.kernelData,
  });

  List<NetInfo> records = [];
  NetInfo kernelData;
}

class NetInfo extends UsageInfo {
  NetInfo({
    super.id = 'NetInfo',
    this.wifiReceived = 0,
    this.cellularReceived = 0,
    this.cellularSent = 0,
    this.wifiSent = 0,
    required this.dateTime,
  });

  int wifiReceived;
  int wifiSent;
  int cellularReceived = 0;
  int cellularSent = 0;
  DateTime dateTime;

  int get total => wifiReceived + wifiSent + cellularReceived + cellularSent;

  static Future<NetInfo> get() async {
    final r = NetInfo(dateTime: DateTime.now());
    await r.getValuesFrom('getNetUsage');
    return r;
  }

  Future saveToUserDefaults() async {
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

  bool sameDay(NetInfo other) => dateTime.year == other.dateTime.year && dateTime.month == other.dateTime.month && dateTime.day == other.dateTime.day;

  NetInfo operator +(NetInfo other) {
    final res = NetInfo(dateTime: DateTime.now());
    res.wifiReceived = wifiReceived + other.wifiReceived;
    res.wifiSent = wifiSent + other.wifiSent;
    res.cellularReceived = cellularReceived + other.cellularReceived;
    res.cellularSent = cellularSent + other.cellularSent;
    return res;
  }

  NetInfo operator -(NetInfo other) {
    final res = NetInfo(dateTime: DateTime.now());
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
