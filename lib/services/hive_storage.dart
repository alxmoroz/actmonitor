// Copyright (c) 2021. Alexandr Moroz

import 'package:choice/models/app_settings.dart';
import 'package:choice/services/init.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HType {
  static const AppSettings = 0;
}

class HiveStorage {
  HiveStorage();

  static late Box<AppSettings> appSettingsBox;

  static Future<void> init() async {
    if (!kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
    }
    Hive.registerAdapter(AppSettingsAdapter());

    appSettingsBox = await Hive.openBox<AppSettings>('AppSettings');
  }
}
