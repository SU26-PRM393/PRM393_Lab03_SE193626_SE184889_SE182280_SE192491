String mapStr(dynamic v) => v?.toString() ?? '';
double? mapDouble(dynamic v) => v is num ? v.toDouble() : null;
int? mapInt(dynamic v) => v is num ? v.toInt() : null;
List<String>? mapStrList(dynamic v) =>
    v is List ? [for (final e in v) e.toString()] : null;
List<double>? mapDoubleList(dynamic v) =>
    v is List ? [for (final e in v) if (e is num) e.toDouble()] : null;
