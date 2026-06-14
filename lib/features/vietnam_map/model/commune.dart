class Commune {
  Commune({
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

  factory Commune.fromMap(Map<String, dynamic> e) {
    return Commune(
      dataId: _str(e['id']),
      ma: _str(e['ma']),
      ten: _str(e['ten']),
      type: e['type'] as String?,
      tenShort: e['ten_short'] as String?,
      areaKm2: _double(e['area_km2']),
      population: _int(e['population']),
      density: _double(e['density']),
      capital: e['capital'] as String?,
      address: e['address'] as String?,
      phone: e['phone'] as String?,
      decree: e['decree'] as String?,
      decreeUrl: e['decree_url'] as String?,
      predecessors: e['predecessors'] as String?,
      nPredecessors: _int(e['n_predecessors']),
      parentMa: e['parent_ma'] as String?,
      parentTen: e['parent_ten'] as String?,
      centroidLon: _double(e['centroid_lon']),
      centroidLat: _double(e['centroid_lat']),
      geomType: e['geom_type'] as String?,
      nVertices: _int(e['n_vertices']),
      macroRegion: e['macro_region'] as String?,
      predecessorsList: _strList(e['predecessors_list']),
      bbox: _doubleList(e['bbox']),
      keywords: _strList(e['keywords']),
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

String _str(dynamic v) => v?.toString() ?? '';
double? _double(dynamic v) => v is num ? v.toDouble() : null;
int? _int(dynamic v) => v is num ? v.toInt() : null;
List<String>? _strList(dynamic v) =>
    v is List ? [for (final e in v) e.toString()] : null;
List<double>? _doubleList(dynamic v) =>
    v is List ? [for (final e in v) if (e is num) e.toDouble()] : null;
