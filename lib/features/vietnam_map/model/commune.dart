import 'package:isar/isar.dart';

part 'commune.g.dart';

@collection
class Commune {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String dataId;

  @Index()
  late String ma;

  @Index(caseSensitive: false)
  late String ten;

  String? type;
  String? tenShort;

  double? areaKm2;
  int? population;
  double? density;

  String? capital;

  String? decree;
  String? decreeUrl;

  String? predecessors;

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
