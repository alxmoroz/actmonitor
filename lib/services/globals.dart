// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/generated/l10n.dart';
import 'package:amonitor/models/app_settings.dart';
import 'package:amonitor/services/hive_storage.dart';
import 'package:amonitor/services/specs_client.dart';
import 'package:amonitor/state/app_state.dart';
import 'package:amonitor/state/comparison_state.dart';
import 'package:amonitor/state/specs_state.dart';
import 'package:amonitor/state/usage_state.dart';
import 'package:package_info/package_info.dart';

const bool kIsWeb = identical(0, 0.0);

late AppSettings settings;
late AppState appState;
late UsageState usageState;
late SpecsState specsState;
late ComparisonState comparisonState;

S get loc => S.current;

class Globals {
  static Future<void> initialize() async {
    await HiveStorage.init();

    appState = AppState();
    usageState = UsageState();
    specsState = SpecsState();
    comparisonState = ComparisonState();

    // первый запуск приложения
    final firstLaunch = HiveStorage.appSettingsBox.values.isEmpty;
    if (firstLaunch) {
      await HiveStorage.appSettingsBox.add(AppSettings());
    }

    settings = HiveStorage.appSettingsBox.values.first;

    final packageInfo = await PackageInfo.fromPlatform();
    // final savedVersion = settings.version;
    final currentVersion = packageInfo.version;
    settings.version = currentVersion;
    await settings.save();

    // загрузка предустановленных данных
    await SpecsClient.load();
  }
}
