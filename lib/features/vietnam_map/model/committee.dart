import 'administrative_unit.dart';

class Committee extends AdministrativeUnit {
  Committee({required super.dataId, required super.ma, required super.ten, super.type, super.tenShort, super.areaKm2, super.population, super.density, super.capital, super.address, super.phone, super.decree, super.decreeUrl, super.predecessors, super.nPredecessors, super.parentMa, super.parentTen, super.centroidLon, super.centroidLat, super.geomType, super.nVertices, super.macroRegion, super.predecessorsList, super.bbox, super.keywords, super.embedText, super.parentTenXa});
  factory Committee.fromMap(Map<String, dynamic> e) {
    final u = AdministrativeUnit.fromMap(e);
    return Committee(dataId: u.dataId, ma: u.ma, ten: u.ten, type: u.type, tenShort: u.tenShort, areaKm2: u.areaKm2, population: u.population, density: u.density, capital: u.capital, address: u.address, phone: u.phone, decree: u.decree, decreeUrl: u.decreeUrl, predecessors: u.predecessors, nPredecessors: u.nPredecessors, parentMa: u.parentMa, parentTen: u.parentTen, centroidLon: u.centroidLon, centroidLat: u.centroidLat, geomType: u.geomType, nVertices: u.nVertices, macroRegion: u.macroRegion, predecessorsList: u.predecessorsList, bbox: u.bbox, keywords: u.keywords, embedText: u.embedText, parentTenXa: u.parentTenXa);
  }
}
