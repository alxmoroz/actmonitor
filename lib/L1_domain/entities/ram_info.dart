import 'usage_info.dart';

class RamInfo extends UsageInfo {
  RamInfo({super.id = 'RamInfo'});

  int free = 0;
  int total = 0;
  int wired = 0;
  int active = 0;
  int inactive = 0;
  int compressed = 0;

  int get graphics => total - (freeTotal + wired + active + compressed);

  int get freeTotal => free + inactive;

  static Future<RamInfo> get() async {
    final r = RamInfo();
    await r.getValuesFrom('getRamUsage');
    return r;
  }

  @override
  void fillData() {
    if (values.length == 6) {
      wired = values[0];
      active = values[1];
      inactive = values[2];
      compressed = values[3];
      free = values[4];
      total = values[5];
    } else {
      throw Exception('Failed to get RAM info.');
    }
  }
}
