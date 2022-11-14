// Copyright (c) 2022. Alexandr Moroz

import 'package:mobx/mobx.dart';

import '../../../L1_domain/entities/app_settings.dart';
import '../../../L2_data/repositories/platform.dart';
import 'services.dart';

part 'settings_controller.g.dart';

class SettingsController extends _SettingsControllerBase with _$SettingsController {
  Future<SettingsController> init() async {
    await settingsUC.cleanData();
    await fetchData();
    return this;
  }
}

abstract class _SettingsControllerBase with Store {
  @observable
  AppSettings? settings;

  @computed
  bool get isFirstLaunch => settings?.firstLaunch ?? true;

  @computed
  String get appVersion => settings?.version ?? '';

  @action
  Future fetchData() async {
    await settingsUC.updateVersion(packageInfo.version);
    settings = await settingsUC.getSettings();
  }

  @action
  Future updateSelectedModel(String selectedModelName) async {
    await settingsUC.updateSelectedModel(selectedModelName);
    settings = await settingsUC.getSettings();
  }

  @action
  Future updateModelNames(List<String> modelNames) async {
    settings = await settingsUC.updateModelNames(modelNames);
    settings = await settingsUC.getSettings();
  }

  @action
  void clearData() => settings = null;
}
