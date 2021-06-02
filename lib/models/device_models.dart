import 'package:intl/intl.dart';

class ParamValue {
  ParamValue({required this.name, this.value = ''});

  final String name;
  final dynamic value;

  String get numValString => value is Map ? value['NumericValue'] ?? '?' : '?';

  String get valString => value is Map ? value['Value'] ?? '' : '';

  num? get numericValue => num.tryParse(RegExp(r'^\d+').firstMatch(numValString)?.group(0) ?? '');

  bool get comparable => numericValue != null;

  bool get isDate => date != null;

  DateTime? get date => DateTime.tryParse(value is Map ? value['Date'] ?? '' : '');

  @override
  String toString() {
    String res = '';
    if (value is String) {
      res = value;
    } else if (comparable) {
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
  DeviceModel(this.id, this.type, this.paramsValues);

  final String id;
  final String type;
  final Map<String, List<ParamValue>> paramsValues;

  ParamValue paramByName(String name, String section) {
    final sectionParams = paramsValues[section] ?? [];
    return sectionParams.firstWhere(
      (pv) => pv.name == name,
      orElse: () => ParamValue(name: name),
    );
  }

  String get name => paramByName('Name', 'meta').value ?? '';

  String get detailName => paramByName('DetailName', 'meta').value ?? '';
}
