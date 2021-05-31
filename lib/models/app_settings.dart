// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/services/hive_storage.dart';
import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: HType.AppSettings)
class AppSettings extends HiveObject {
  @HiveField(0)
  String version = '';

  @HiveField(1)
  String selectedModelId = '';

  @HiveField(2)
  List<String> comparisonModelsIds = [];
}
