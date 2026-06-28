import 'package:flutter/foundation.dart';
import '../../../features/vietnam_map/data/firestore_repository.dart';
import '../../../features/vietnam_map/model/province.dart';

class RegionStat {
  const RegionStat({required this.name, required this.count});
  final String name;
  final int count;
}

class TypeStat {
  const TypeStat({required this.name, required this.count});
  final String name;
  final int count;
}

/// ViewModel cho màn hình Thống Kê tỉnh thành.
/// Tương tự @Service trong Spring Boot — UI chỉ đọc state, không tự tính toán.
class ProvinceStatsViewModel extends ChangeNotifier {
  ProvinceStatsViewModel() {
    _load();
  }

  bool isLoading = true;
  String? error;

  List<Province> _all = [];

  // Top 10 dân số cao nhất
  List<Province> top10Population = [];

  // Top 10 diện tích lớn nhất
  List<Province> top10Area = [];

  // Top 10 mật độ dân số cao nhất
  List<Province> top10Density = [];

  // Phân bố theo vùng miền (Bắc / Trung / Nam)
  List<RegionStat> regionStats = [];

  // Phân loại đơn vị hành chính (Tỉnh / Thành phố)
  List<TypeStat> typeStats = [];

  // Tổng quan
  int get totalProvinces => _all.length;
  int get totalPopulation =>
      _all.fold(0, (sum, p) => sum + (p.population ?? 0));
  double get totalAreaKm2 =>
      _all.fold(0.0, (sum, p) => sum + (p.areaKm2 ?? 0));
  double get avgDensity {
    final valid = _all.where((p) => p.density != null).toList();
    if (valid.isEmpty) return 0;
    return valid.fold(0.0, (sum, p) => sum + p.density!) / valid.length;
  }

  Future<void> _load() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      _all = await FirestoreRepository.instance.getAllProvinces();
      _compute();
    } catch (e) {
      error = e.toString();
      debugPrint('[ProvinceStatsViewModel] load error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _compute() {
    final withPop = _all.where((p) => p.population != null).toList()
      ..sort((a, b) => b.population!.compareTo(a.population!));
    top10Population = withPop.take(10).toList();

    final withArea = _all.where((p) => p.areaKm2 != null).toList()
      ..sort((a, b) => b.areaKm2!.compareTo(a.areaKm2!));
    top10Area = withArea.take(10).toList();

    final withDensity = _all.where((p) => p.density != null).toList()
      ..sort((a, b) => b.density!.compareTo(a.density!));
    top10Density = withDensity.take(10).toList();

    // Đếm theo macroRegion
    final regionMap = <String, int>{};
    for (final p in _all) {
      final r = p.macroRegion ?? 'Khác';
      regionMap[r] = (regionMap[r] ?? 0) + 1;
    }
    regionStats = regionMap.entries
        .map((e) => RegionStat(name: e.key, count: e.value))
        .toList()
      ..sort((a, b) => b.count.compareTo(a.count));

    // Đếm theo type (Tỉnh / Thành phố trực thuộc TW)
    final typeMap = <String, int>{};
    for (final p in _all) {
      final t = p.type ?? 'Khác';
      typeMap[t] = (typeMap[t] ?? 0) + 1;
    }
    typeStats = typeMap.entries
        .map((e) => TypeStat(name: e.key, count: e.value))
        .toList()
      ..sort((a, b) => b.count.compareTo(a.count));
  }

  /// Gọi lại khi muốn refresh data
  Future<void> reload() => _load();
}
