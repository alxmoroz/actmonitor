// Copyright (c) 2021. Alexandr Moroz

import 'package:amonitor/generated/l10n.dart';
import 'package:amonitor/models/app_settings.dart';
import 'package:amonitor/models/device_models.dart';
import 'package:amonitor/models/net_stat.dart';
import 'package:amonitor/services/hive_storage.dart';
import 'package:amonitor/services/specs_client.dart';
import 'package:amonitor/state/comparison_state.dart';
import 'package:amonitor/state/specs_state.dart';
import 'package:amonitor/state/usage_state.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info/package_info.dart';

late AppSettings settings;
late NetStat netStat;
late UsageState usageState;
late SpecsState specsState;
late ComparisonState comparisonState;
late IosDeviceInfo iosInfo;
DeviceModel? hostModel;

S get loc => S.current;

//TODO: UI-constants
bool get isTablet => iosInfo.model == 'iPad';

double get sidePadding => isTablet ? 20 : 10;

// TODO: перенести взаимодействие с БД в стейты

// TODO: все глабальные штуки перенести в стейт приложения

Future<void> initGlobals() async {
  await HiveStorage.init();

  if (HiveStorage.appSettingsBox.isEmpty) {
    await HiveStorage.appSettingsBox.add(AppSettings());
  }
  if (HiveStorage.netStatBox.isEmpty) {
    await HiveStorage.netStatBox.add(NetStat());
  }

  settings = HiveStorage.appSettingsBox.values.first;
  netStat = HiveStorage.netStatBox.values.first;

  // версия приложения
  final packageInfo = await PackageInfo.fromPlatform();
  // final savedVersion = settings.version;
  final currentVersion = packageInfo.version;
  settings.version = currentVersion;

  // инфа о текущем устройстве
  iosInfo = await DeviceInfoPlugin().iosInfo;

  // загрузка спецификаций
  specsState = SpecsState();
  await SpecsClient.load();
  // сопоставляем текущее устройство и модель из спецификаций
  hostModel = specsState.modelForId(iosInfo.isPhysicalDevice ? iosInfo.utsname.machine : iosInfo.model);
  if (specsState.isKnownModel(hostModel) && settings.selectedModelName.isEmpty) {
    settings.selectedModelName = hostModel!.name;
    await settings.save();
  }
  specsState.setSelectedModelByName(settings.selectedModelName);

  // загрузка списка сравниваемых устройств из бд в стейт
  comparisonState = ComparisonState();
  comparisonState.setComparisonModelsNames(settings.comparisonModelsNames);

  // получение информации о диске, памяти, батарее и трафике
  usageState = UsageState();
  await usageState.updateUsageInfo();
}
