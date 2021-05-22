class ParamValue {
  ParamValue({required this.name, this.value = ''});

  final String name;
  final dynamic value;

  num? get numericValue => num.tryParse(RegExp(r'^\d+').firstMatch(value is Map ? (value['NumericValue'] ?? '') : toString())?.group(0) ?? '');

  bool get comparable => numericValue != null;

  @override
  String toString() {
    String res = '';
    if (value is String) {
      res = value;
    } else if (value is Map) {
      res = (value as Map).values.toList().join('\n');
    }
    return res;
  }
}

class Device {
  Device(this.id, this.type, this.paramsValues);

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

  bool get isKnown => detailName != 'Unknown model';
}
