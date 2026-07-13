import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:vietnam_map_flutter/models/commune.dart';
import 'package:vietnam_map_flutter/models/province.dart';

/// Nguồn dữ liệu duy nhất cho provinces và communes từ Firestore.
/// Tương tự @Repository trong Spring Boot — controller không gọi Firestore trực tiếp.
///
/// In-memory cache: sau lần đọc đầu tiên, data nằm trong RAM
/// nên các lần gọi tiếp theo trả về ngay lập tức (0 network).
/// Firestore offline persistence cũng cache ở tầng SDK nên khi
/// mở app lần 2 không cần mạng.
class FirestoreRepository {
  FirestoreRepository._();
  
  static final instance = FirestoreRepository._();

  List<Province>? _provincesCache;
  List<Commune>? _communesCache;

  /// Lấy tất cả tỉnh/thành (34 documents) từ local assets
  Future<List<Province>> getAllProvinces() async {
    if (_provincesCache != null) {
      debugPrint('[LocalAsset] provinces → RAM cache (0 reads)');
      return _provincesCache!;
    }

    try {
      debugPrint('[LocalAsset] provinces → Tải từ local asset provinces.json (0 reads)');
      final raw = await rootBundle.loadString('assets/data/provinces.json');
      final decoded = jsonDecode(raw) as List<dynamic>;
      _provincesCache = decoded
          .map((item) => Province.fromMap(item as Map<String, dynamic>))
          .toList();
      return _provincesCache!;
    } catch (e) {
      debugPrint('[LocalAsset] Lỗi đọc file local provinces.json: $e');
      return [];
    }
  }

  /// Lấy tất cả xã/phường (3,321 documents) từ local assets
  Future<List<Commune>> getAllCommunes() async {
    if (_communesCache != null) {
      debugPrint('[LocalAsset] communes → RAM cache (0 reads)');
      return _communesCache!;
    }

    try {
      debugPrint('[LocalAsset] communes → Tải từ local asset communes.json (0 reads)');
      final raw = await rootBundle.loadString('assets/data/communes.json');
      final decoded = jsonDecode(raw) as List<dynamic>;
      _communesCache = decoded
          .map((item) => Commune.fromMap(item as Map<String, dynamic>))
          .toList();
      return _communesCache!;
    } catch (e) {
      debugPrint('[LocalAsset] Lỗi đọc file local communes.json: $e');
      return [];
    }
  }

  /// Lấy chi tiết 1 tỉnh theo mã — dùng in-memory cache
  Future<Province?> getProvinceByMa(String ma) async {
    final list = await getAllProvinces();
    try {
      return list.firstWhere((p) => p.ma == ma);
    } catch (_) {
      return null;
    }
  }

  /// Lấy chi tiết 1 xã/phường theo mã — dùng in-memory cache
  Future<Commune?> getCommuneByMa(String ma) async {
    final list = await getAllCommunes();
    try {
      return list.firstWhere((c) => c.ma == ma);
    } catch (_) {
      return null;
    }
  }
}
