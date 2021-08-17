import 'package:flutter/services.dart';

abstract class UsageInfo {
  List? _values;
  Exception? exception;
  String status = 'loading';

  final channel = const MethodChannel('amonitor.w-cafe.ru/usage');

  String get _error => exception != null ? exception.toString() : 'unknown error';

  List get values => _values ?? <dynamic>[];

  String get placeholder => {'done': '', 'loading': 'loading', 'error': _error}[status] ?? '';

  void done() => status = 'done';

  Future<void> getValuesFrom(String methodName) async {
    try {
      status = 'loading';
      _values = await channel.invokeMethod(methodName);
      fillData();
      done();
    } on Exception catch (e) {
      status = 'error';
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
