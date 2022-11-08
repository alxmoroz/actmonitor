// Copyright (c) 2022. Alexandr Moroz

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../L1_domain/usecases/net_stats_uc.dart';
import '../../L1_domain/usecases/settings_uc.dart';
import '../../L2_data/repositories/db.dart';
import '../../L2_data/repositories/db_repo.dart';
import '../l10n/generated/l10n.dart';
import '../views/comparison/comparison_controller.dart';
import '../views/specs/specs_controller.dart';
import '../views/usage/usage_controller.dart';
import 'settings_controller.dart';

S get loc => S.current;

GetIt getIt = GetIt.instance;

SettingsController get settingsController => GetIt.I<SettingsController>();
SpecsController get specsController => GetIt.I<SpecsController>();
UsageController get usageController => GetIt.I<UsageController>();
ComparisonController get comparisonController => GetIt.I<ComparisonController>();

SettingsUC get settingsUC => GetIt.I<SettingsUC>();
NetStatsUC get netStatsUC => GetIt.I<NetStatsUC>();

void setup() {
  // device
  getIt.registerSingletonAsync<BaseDeviceInfo>(() async => await DeviceInfoPlugin().deviceInfo);
  getIt.registerSingletonAsync<PackageInfo>(() async => await PackageInfo.fromPlatform());

  // repo / adapters
  getIt.registerSingletonAsync<HiveStorage>(() async => await HiveStorage().init());

  // use cases
  getIt.registerSingleton<SettingsUC>(SettingsUC(repo: SettingsRepo()));
  getIt.registerSingleton<NetStatsUC>(NetStatsUC(repo: NetStatsRepo()));

  // global state controllers
  getIt.registerSingletonAsync<SettingsController>(() async => SettingsController().init(), dependsOn: [HiveStorage]);
  getIt.registerSingletonAsync<SpecsController>(() async => SpecsController().init(), dependsOn: [SettingsController]);
  getIt.registerSingletonAsync<ComparisonController>(() async => ComparisonController().init(), dependsOn: [SettingsController]);
  getIt.registerSingletonAsync<UsageController>(() async => UsageController().init(), dependsOn: [SettingsController]);
}
