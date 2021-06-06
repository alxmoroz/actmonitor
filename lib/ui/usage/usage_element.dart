import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class UsageElement {
  const UsageElement.duration(this.value, {this.label, this.color})
      : base = 1,
        type = 'duration';

  const UsageElement.memory(this.value, {this.label, this.color})
      : base = 1024,
        type = 'memory';

  const UsageElement.disk(this.value, {this.label, this.color})
      : base = 1000,
        type = 'disk';

  const UsageElement.battery(this.value, {this.label, this.color})
      : base = 1,
        type = 'battery';

  final num value;
  final String? label;
  final Color? color;
  final double base;
  final String type;

  String _bytesString() {
    String unit = 'KB';
    double divider = base;
    if (value > divider * base) {
      divider *= base;
      unit = 'MB';
    }
    if (value > divider * base) {
      divider *= base;
      unit = 'GB';
    }
    if (value > divider * base) {
      divider *= base;
      unit = 'TB';
    }
    return '${NumberFormat("#").format(value / divider)} $unit';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  String toString() {
    switch (type) {
      case 'duration':
        {
          final d = Duration(seconds: (value.toDouble() * 3600).toInt());
          return '${_twoDigits(d.inHours)}:${_twoDigits(d.inMinutes.remainder(60))}';
        }
      case 'battery':
        return '$value%';
      default:
        return _bytesString();
    }
  }
}
