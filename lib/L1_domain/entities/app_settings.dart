// Copyright (c) 2022. Alexandr Moroz

import '../entities/base_entity.dart';

class AppSettings extends LocalPersistable {
  AppSettings({
    required this.firstLaunch,
    this.version = '',
    this.selectedModelName = '',
    required this.comparisonModelsNames,
  });

  final bool firstLaunch;

  String version;
  String selectedModelName = '';
  List<String> comparisonModelsNames = [];
}
