// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';

part 'usage_state.g.dart';

class RamInfo {
  RamInfo([List? ramValues]) {
    if (ramValues != null && ramValues.length == 6) {
      wired = ramValues[0];
      active = ramValues[1];
      inactive = ramValues[2];
      compressed = ramValues[3];
      free = ramValues[4];
      total = ramValues[5];
      error = '';
    } else {
      error = 'Failed to get RAM info.';
    }
  }

  int wired = 0;
  int active = 0;
  int inactive = 0;
  int compressed = 0;
  int free = 0;
  int total = 0;
  String error = 'no data';

  int get graphics => total - (free + inactive + wired + active + compressed);

  int get freeTotal => free + inactive;
}

class UsageState = _UsageStateBase with _$UsageState;

abstract class _UsageStateBase with Store {
  final _platform = const MethodChannel('amonitor.w-cafe.ru/usage');

  @observable
  RamInfo ram = RamInfo();

  @observable
  int freeDisk = 0;
  @observable
  int totalDisk = -1;
  @observable
  String diskError = '';

  @action
  Future<void> updateRamUsage() async {
    try {
      final ramValues = await _platform.invokeMethod<List>('getRamUsage');
      ram = RamInfo(ramValues);
    } on PlatformException catch (e) {
      ram.error = 'Failed to get RAM info: ${e.message}.';
    }
  }

  @action
  Future<void> updateDiskUsage() async {}
}
