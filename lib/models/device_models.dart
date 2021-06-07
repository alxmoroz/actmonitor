import 'package:intl/intl.dart';

class ParamValue {
  ParamValue({required this.name, this.value = ''});

  final String name;
  final dynamic value;

  String get numValString => value is Map ? value['NumericValue'] ?? '?' : '?';

  String get valString => value is Map ? value['Value'] ?? '' : '';

  num? get numValue => num.tryParse(RegExp(r'^\d+').firstMatch(numValString)?.group(0) ?? '');

  bool get isNum => numValue != null;

  bool get isDate => date != null;

  DateTime? get date => DateTime.tryParse(value is Map ? value['Date'] ?? '' : '');

  @override
  String toString() {
    String res = value.toString();
    if (value is String) {
      res = value;
    } else if (isNum) {
      res = '$numValString${valString.isNotEmpty ? '\n' + valString : ''}';
    } else if (isDate) {
      res = DateFormat.yMMMMd().format(date!);
    } else if (value is Map) {
      res = (value as Map).values.join('\n');
    }
    return res;
  }
}

class DeviceModel {
  DeviceModel(this.name, this.type, this.paramsValues);

  final String name;
  final String type;
  final Map<String, List<ParamValue>> paramsValues;

  ParamValue paramByName(String name, String section) {
    final sectionParams = paramsValues[section] ?? [];
    return sectionParams.firstWhere(
      (pv) => pv.name == name,
      orElse: () => ParamValue(name: name),
    );
  }

  List<dynamic> get ids => paramByName('ids', 'meta').value ?? <dynamic>[];

  String get detailName => paramByName('DetailName', 'meta').value ?? '';

  @override
  String toString() {
    return '$name $detailName';
  }
}
