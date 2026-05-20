import 'package:isar/isar.dart';

part 'committee.g.dart';

@collection
class Committee {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String dataId;

  @Index()
  String? ma;

  @Index(caseSensitive: false)
  late String ten;

  String? type;
  String? tenShort;

  double? areaKm2;
  int? population;
  double? density;

  String? capital;
  String? address;
  String? phone;

  String? decree;
  String? decreeUrl;

  String? predecessors;
  int? nPredecessors;

  @Index()
  String? parentMa;

  String? parentTen;

  double? centroidLon;
  double? centroidLat;

  String? geomType;

  int? nVertices;

  @Index()
  String? macroRegion;

  List<String>? predecessorsList;

  List<double>? bbox;

  List<String>? keywords;

  String? embedText;

  String? parentTenXa;
}
