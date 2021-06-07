// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/generated/l10n.dart';
import 'package:amonitor/models/app_settings.dart';
import 'package:amonitor/models/device_models.dart';
import 'package:amonitor/services/hive_storage.dart';
import 'package:amonitor/services/specs_client.dart';
import 'package:amonitor/state/comparison_state.dart';
import 'package:amonitor/state/specs_state.dart';
import 'package:amonitor/state/usage_state.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info/package_info.dart';

late AppSettings settings;
late UsageState usageState;
late SpecsState specsState;
late ComparisonState comparisonState;
late IosDeviceInfo iosInfo;
DeviceModel? hostModel;

S get loc => S.current;

class Globals {
  static Future<void> initialize() async {
    await HiveStorage.init();

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

    // загрузка спецификаций
    await SpecsClient.load();

    // инфа о текущем устройстве
    iosInfo = await DeviceInfoPlugin().iosInfo;
    hostModel = specsState.modelForId(iosInfo.isPhysicalDevice ? iosInfo.utsname.machine : iosInfo.model);
    if (specsState.isKnownModel(hostModel) && settings.selectedModelName.isEmpty) {
      settings.selectedModelName = hostModel!.name;
    }
    specsState.setSelectedModelById(settings.selectedModelName);

    // настройки
    await settings.save();

    // загрузка списка сравниваемых устройств из бд в стейт
    comparisonState.setComparisonModelsNames(settings.comparisonModelsNames);
  }
}
