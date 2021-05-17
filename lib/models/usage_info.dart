import 'package:flutter/services.dart';

abstract class UsageInfo {
  List? values;

  Exception? exception = Exception('no data');

  String get error => exception != null ? exception.toString() : '';

  Future<void> getValuesFrom(String methodName) async {
    const _channel = MethodChannel('amonitor.w-cafe.ru/usage');
    try {
      values = await _channel.invokeMethod(methodName);
      fillData();
    } on Exception catch (e) {
      exception = e;
    }
  }

  void fillData() {
    throw Exception('fillData Not implemented!');
  }

  static Future<UsageInfo> get() {
    throw Exception('get Not implemented!');
  }
}
