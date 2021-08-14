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

double get cardPadding => isTablet ? 20 : 10;

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
      await HiveStorage.netStatBox.add(NetStat());
    }

    settings = HiveStorage.appSettingsBox.values.first;
    netStat = HiveStorage.netStatBox.values.first;

    final packageInfo = await PackageInfo.fromPlatform();
    // final savedVersion = settings.version;
    final currentVersion = packageInfo.version;
    settings.version = currentVersion;

    // инфа о текущем устройстве
    iosInfo = await DeviceInfoPlugin().iosInfo;

    // загрузка спецификаций
    await SpecsClient.load();
    // сопоставляем текущее устройство и модель из спецификаций
    hostModel = specsState.modelForId(iosInfo.isPhysicalDevice ? iosInfo.utsname.machine : iosInfo.model);
    if (specsState.isKnownModel(hostModel) && settings.selectedModelName.isEmpty) {
      settings.selectedModelName = hostModel!.name;
    }
    specsState.setSelectedModelByName(settings.selectedModelName);

    // настройки
    await settings.save();

    // загрузка списка сравниваемых устройств из бд в стейт
    comparisonState.setComparisonModelsNames(settings.comparisonModelsNames);

    // время загрузки
    await usageState.updateBootInfo();
    // получение информации о диске, памяти, батарее и трафике
    await usageState.updateUsageInfo();
  }
}
