import 'package:isar/isar.dart';

part 'committee.g.dart';

@collection
class Committee {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String dataId;

  @Index(caseSensitive: false)
  late String ten;

  String? type;
  String? tenShort;

  @Index()
  String? parentMa;

  String? parentTen;

  double? centroidLon;
  double? centroidLat;

  String? geomType;

  @Index()
  String? macroRegion;

  List<String>? keywords;

  String? embedText;
}
