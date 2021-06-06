import 'package:amonitor/models/usage_info.dart';
import 'package:amonitor/services/globals.dart';

class BatteryInfo extends UsageInfo {
  double _rawLevel = 0;
  int _rawState = 0;

  int get level => (_rawLevel * 100).round();

  String get state => ['unknown', 'unplugged', 'charging', 'full'][_rawState];

  static Future<BatteryInfo> get() async {
    final r = BatteryInfo();
    await r.getValuesFrom('getBatteryUsage');
    return r;
  }

  @override
  void fillData() {
    if (values.length == 2 && values[0] > -1) {
      _rawLevel = values[0];
      _rawState = values[1];
    } else if (!iosInfo.isPhysicalDevice) {
      // debug simulator
      _rawLevel = 0.66;
      _rawState = 3;
    } else {
      throw Exception('Failed to get Battery info');
    }
  }
}
