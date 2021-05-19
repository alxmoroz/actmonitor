class Parameter {
  Parameter(this.name);

  final String name;
}

class ParamValue {
  ParamValue({required this.parameter, this.value = ''});

  final Parameter parameter;
  final dynamic value;

  bool get comparable => value is Map && value['numericValue'] != null && value['numericValue'].isNotEmpty;

  @override
  String toString() {
    String res = '';
    if (value is String) {
      res = value;
    } else if (value is Map) {
      res = (value as Map).values.toList().join(', ');
    }
    return res;
  }
}

class Device {
  Device(this.id, this.type, this.paramsValues);

  final String id;
  final String type;
  final List<ParamValue> paramsValues;

  ParamValue paramByName(String name) => paramsValues.firstWhere(
        (pv) => pv.parameter.name == name,
        orElse: () => ParamValue(parameter: Parameter(name)),
      );
}
