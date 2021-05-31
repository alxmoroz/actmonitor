import 'package:amonitor/services/globals.dart';

class ComparisonClient {
  static void load() {
    comparisonState.setComparisonDevices(
      specsState.devices.where(
        (d) => settings.comparisonDevicesIds.contains(d.id),
      ),
    );
  }
}
