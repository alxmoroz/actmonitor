// Copyright (c) 2021. Alexandr Moroz

import 'package:hive/hive.dart';

import '../../L1_domain/entities/app_settings.dart';
import '../repositories/db.dart';
import 'base.dart';

part 'app_settings.g.dart';

@HiveType(typeId: HType.AppSettings)
class AppSettingsHO extends BaseModel<AppSettings> {
  @HiveField(0, defaultValue: '')
  String version = '';

  @HiveField(1, defaultValue: '')
  String selectedModelName = '';

  @HiveField(2, defaultValue: <String>[])
  List<String> comparisonModelsNames = [];

  @override
  AppSettings toEntity() => AppSettings(
        version: version,
        firstLaunch: false,
        selectedModelName: selectedModelName,
        comparisonModelsNames: comparisonModelsNames,
      );

  @override
  Future update(AppSettings entity) async {
    id = entity.id;
    version = entity.version;
    selectedModelName = entity.selectedModelName;
    comparisonModelsNames = entity.comparisonModelsNames;
    await save();
  }
}
