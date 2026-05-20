import 'package:latlong2/latlong.dart';

class LowerLevelPlace {
  const LowerLevelPlace({
    required this.id,
    required this.code,
    required this.name,
    required this.level,
    required this.parentCode,
    required this.parentName,
    required this.coordinate,
  });

  final String id;
  final String code;
  final String name;
  final String level;
  final String parentCode;
  final String parentName;
  final LatLng coordinate;
}
