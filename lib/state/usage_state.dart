// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';

part 'usage_state.g.dart';

abstract class UsageInfo {
  List? values;

  int free = 0;
  int total = 0;

  Exception? exception = Exception('no data');

  String get error => exception != null ? exception.toString() : '';

  Future<void> _getValuesFrom(String methodName) async {
    const _channel = MethodChannel('amonitor.w-cafe.ru/usage');
    try {
      values = await _channel.invokeMethod(methodName);
      _fillData();
    } on Exception catch (e) {
      exception = e;
    }
  }

  void _fillData() {
    throw Exception('fillData Not implemented!');
  }
}

class RamInfo extends UsageInfo {
  int wired = 0;
  int active = 0;
  int inactive = 0;
  int compressed = 0;

  int get graphics => total - (free + inactive + wired + active + compressed);

  int get freeTotal => free + inactive;

  static Future<RamInfo> update() async {
    final r = RamInfo();
    await r._getValuesFrom('getRamUsage');
    return r;
  }

  @override
  void _fillData() {
    if (values != null && values!.length == 6) {
      wired = values![0];
      active = values![1];
      inactive = values![2];
      compressed = values![3];
      free = values![4];
      total = values![5];
      exception = null;
    } else {
      exception = Exception('Failed to get RAM info.');
    }
  }
}

class DiskInfo extends UsageInfo {
  static Future<DiskInfo> update() async {
    final d = DiskInfo();
    await d._getValuesFrom('getDiskUsage');
    return d;
  }

  @override
  void _fillData() {
    if (values != null && values!.length == 2) {
      free = values![0];
      total = values![1];
      exception = null;
    } else {
      exception = Exception('Failed to get disk info.');
    }
  }
}

class UsageState = _UsageStateBase with _$UsageState;

abstract class _UsageStateBase with Store {
  @observable
  RamInfo ram = RamInfo();

  @observable
  DiskInfo disk = DiskInfo();

  @action
  Future<void> updateRamUsage() async {
    ram = await RamInfo.update();
  }

  @action
  Future<void> updateDiskUsage() async {
    disk = await DiskInfo.update();
  }
}
