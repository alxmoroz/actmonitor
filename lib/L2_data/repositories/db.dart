// Copyright (c) 2022. Alexandr Moroz

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../models/app_settings.dart';
import '../models/net_stat.dart';

class HType {
  static const AppSettings = 0;
  static const NetInfo = 1;
  static const NetStat = 2;
}

class HiveStorage {
  Future<HiveStorage> init() async {
    if (!kIsWeb) {
      final _dir = await getApplicationDocumentsDirectory();
      final _dirPath = _dir.path;
      Hive.init(_dirPath);
    } else {
      // TODO: убрать после фикса Hive 2.2
      Hive.init('');
    }

    Hive.registerAdapter(AppSettingsHOAdapter());
    Hive.registerAdapter(NetInfoHOAdapter());
    Hive.registerAdapter(NetStatHOAdapter());

    return this;
  }
}
