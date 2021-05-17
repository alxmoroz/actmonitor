import 'package:amonitor/models/usage_info.dart';

class DiskInfo extends UsageInfo {
  int free = 0;
  int total = 0;

  static Future<DiskInfo> get() async {
    final d = DiskInfo();
    await d.getValuesFrom('getDiskUsage');
    return d;
  }

  @override
  void fillData() {
    if (values != null && values!.length == 2) {
      free = values![0];
      total = values![1];
      exception = null;
    } else {
      exception = Exception('Failed to get disk info.');
    }
  }
}
