import 'package:flutter/services.dart';

abstract class UsageInfo {
  List? _values;
  Exception? _exception;
  String _status = 'loading';

  String get _error => _exception != null ? _exception.toString() : 'unknown error';

  List get values => _values ?? <dynamic>[];

  String get placeholder => {'done': '', 'loading': 'loading', 'error': _error}[_status] ?? '';

  void done() => _status = 'done';

  Future<void> getValuesFrom(String methodName) async {
    const _channel = MethodChannel('amonitor.w-cafe.ru/usage');
    try {
      _status = 'loading';
      _values = await _channel.invokeMethod(methodName);
      fillData();
      done();
    } on Exception catch (e) {
      _status = 'error';
      _exception = e;
    }
  }

  void fillData() {
    throw Exception('fillData Not implemented!');
  }

  static Future<UsageInfo> get() {
    throw Exception('get Not implemented!');
  }
}
