import 'model_helpers.dart';

/// Cấu trúc dữ liệu chung cho đơn vị hành chính (Tỉnh/Huyện/Xã/Phường...)
/// Committee và Commune đều có cùng schema này → kế thừa để tránh lặp code
class AdministrativeUnit {
  AdministrativeUnit({
    required this.dataId,
    required this.ma,
    required this.ten,
    this.type,
    this.tenShort,
    this.areaKm2,
    this.population,
    this.density,
    this.capital,
    this.address,
    this.phone,
    this.decree,
    this.decreeUrl,
    this.predecessors,
    this.nPredecessors,
    this.parentMa,
    this.parentTen,
    this.centroidLon,
    this.centroidLat,
    this.geomType,
    this.nVertices,
    this.macroRegion,
    this.predecessorsList,
    this.bbox,
    this.keywords,
    this.embedText,
    this.parentTenXa,
  });

  factory AdministrativeUnit.fromMap(Map<String, dynamic> e) {
    return AdministrativeUnit(
      dataId: mapStr(e['id']),
      ma: mapStr(e['ma']),
      ten: mapStr(e['ten']),
      type: e['type'] as String?,
      tenShort: e['ten_short'] as String?,
      areaKm2: mapDouble(e['area_km2']),
      population: mapInt(e['population']),
      density: mapDouble(e['density']),
      capital: e['capital'] as String?,
      address: e['address'] as String?,
      phone: e['phone'] as String?,
      decree: e['decree'] as String?,
      decreeUrl: e['decree_url'] as String?,
      predecessors: e['predecessors'] as String?,
      nPredecessors: mapInt(e['n_predecessors']),
      parentMa: e['parent_ma'] as String?,
      parentTen: e['parent_ten'] as String?,
      centroidLon: mapDouble(e['centroid_lon']),
      centroidLat: mapDouble(e['centroid_lat']),
      geomType: e['geom_type'] as String?,
      nVertices: mapInt(e['n_vertices']),
      macroRegion: e['macro_region'] as String?,
      predecessorsList: mapStrList(e['predecessors_list']),
      bbox: mapDoubleList(e['bbox']),
      keywords: mapStrList(e['keywords']),
      embedText: e['embed_text'] as String?,
      parentTenXa: e['parent_ten_xa'] as String?,
    );
  }

  final String dataId;
  final String ma;
  final String ten;
  final String? type;
  final String? tenShort;
  final double? areaKm2;
  final int? population;
  final double? density;
  final String? capital;
  final String? address;
  final String? phone;
  final String? decree;
  final String? decreeUrl;
  final String? predecessors;
  final int? nPredecessors;
  final String? parentMa;
  final String? parentTen;
  final double? centroidLon;
  final double? centroidLat;
  final String? geomType;
  final int? nVertices;
  final String? macroRegion;
  final List<String>? predecessorsList;
  final List<double>? bbox;
  final List<String>? keywords;
  final String? embedText;
  final String? parentTenXa;
}
