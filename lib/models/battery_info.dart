import 'package:amonitor/models/usage_info.dart';

class BatteryInfo extends UsageInfo {
  double rawLevel = 0;
  int rawState = 0;

  int get level => (rawLevel * 100).round();

  String get state => ['unknown', 'unplugged', 'charging', 'full'][rawState];

  static Future<BatteryInfo> get() async {
    final r = BatteryInfo();
    await r.getValuesFrom('getBatteryUsage');
    return r;
  }

  @override
  void fillData() {
    if (values != null && values!.length == 2 && values![0] > -1) {
      rawLevel = values![0];
      rawState = values![1];
      exception = null;
    } else {
      exception = Exception('Failed to get Battery info.');
    }
  }
}
