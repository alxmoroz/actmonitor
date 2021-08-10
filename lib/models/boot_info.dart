import 'usage_info.dart';

class BootInfo extends UsageInfo {
  int bootTimeSeconds = 0;

  DateTime get bootDate => DateTime.fromMillisecondsSinceEpoch(bootTimeSeconds * 1000);

  static Future<BootInfo> get() async {
    final r = BootInfo();
    await r.getValuesFrom('getBootTime');
    return r;
  }

  @override
  void fillData() {
    if (values.length == 1) {
      bootTimeSeconds = values[0];
    } else {
      throw Exception('Failed to get BootTime info.');
    }
  }
}
