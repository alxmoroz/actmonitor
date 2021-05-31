import 'package:amonitor/services/globals.dart';

class ComparisonClient {
  static void load() {
    comparisonState.setComparisonModelsIds(settings.comparisonModelsIds);
  }
}
