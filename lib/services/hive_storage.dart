// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/models/app_settings.dart';
import 'package:amonitor/models/net_stat.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

const bool _kIsWeb = identical(0, 0.0);

class HType {
  static const AppSettings = 0;
  static const NetInfo = 1;
  static const NetStat = 2;
}

class HiveStorage {
  HiveStorage();

  static late Box<AppSettings> appSettingsBox;
  static late Box<NetStat> netStatBox;

  static Future<void> init() async {
    if (!_kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
    }
    Hive.registerAdapter(NetInfoAdapter());
    Hive.registerAdapter(NetStatAdapter());
    Hive.registerAdapter(AppSettingsAdapter());

    appSettingsBox = await Hive.openBox<AppSettings>('AppSettings');
    netStatBox = await Hive.openBox<NetStat>('NetStat');
  }
}
