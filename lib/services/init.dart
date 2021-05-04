// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/generated/l10n.dart';
import 'package:amonitor/models/app_settings.dart';
import 'package:amonitor/services/hive_storage.dart';
import 'package:amonitor/state/global_state.dart';
import 'package:package_info_plus/package_info_plus.dart';

const bool kIsWeb = identical(0, 0.0);

//TODO: не очень четко видно отличие от GlobalState по функциональности

late AppSettings settings;
late GlobalState globalState;

S get loc => S.current;

class Init {
  Init();

  static Future<void> initialize() async {
    await HiveStorage.init();

    // первый запуск приложения
    final firstLaunch = HiveStorage.appSettingsBox.values.isEmpty;
    if (firstLaunch) {
      await HiveStorage.appSettingsBox.add(AppSettings());
      // загрузка предустановленных данных
    }

    settings = HiveStorage.appSettingsBox.values.first;

    final packageInfo = await PackageInfo.fromPlatform();
    // final savedVersion = settings.version;
    final currentVersion = packageInfo.version;
    settings.version = currentVersion;
    await settings.save();

    globalState = GlobalState();
  }
}
