// Copyright (c) 2021. Alexandr Moroz

import 'package:hive/hive.dart';

import '../services/hive_storage.dart';
import 'net_info.dart';

part 'app_settings.g.dart';

@HiveType(typeId: HType.AppSettings)
class AppSettings extends HiveObject {
  @HiveField(0, defaultValue: '')
  String version = '';

  @HiveField(1, defaultValue: '')
  String selectedModelName = '';

  @HiveField(2, defaultValue: <String>[])
  List<String> comparisonModelsNames = [];

  @HiveField(3)
  NetInfo? netInfo;

  @HiveField(4, defaultValue: <NetInfo>[])
  List<NetInfo> netInfoChunks = [];
}
