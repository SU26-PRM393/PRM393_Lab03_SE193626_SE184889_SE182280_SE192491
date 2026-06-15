import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../model/commune.dart';
import '../model/province.dart';

/// Nguồn dữ liệu duy nhất cho provinces và communes từ Firestore.
/// Tương tự @Repository trong Spring Boot — controller không gọi Firestore trực tiếp.
///
/// In-memory cache: sau lần đọc đầu tiên, data nằm trong RAM
/// nên các lần gọi tiếp theo trả về ngay lập tức (0 network).
/// Firestore offline persistence cũng cache ở tầng SDK nên khi
/// mở app lần 2 không cần mạng.
class FirestoreRepository {
  FirestoreRepository._() {
    try {
      _db.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
    } catch (e) {
      debugPrint('Error enabling Firestore persistence: $e');
    }
  }
  
  static final instance = FirestoreRepository._();

  final _db = FirebaseFirestore.instance;

  List<Province>? _provincesCache;
  List<Commune>? _communesCache;

  /// Lấy tất cả tỉnh/thành (34 documents)
  Future<List<Province>> getAllProvinces() async {
    if (_provincesCache != null) {
      debugPrint('[Firestore] provinces → RAM cache (0 reads)');
      return _provincesCache!;
    }

    // 1. Thử lấy từ cache của Firestore trước (không dùng mạng)
    try {
      final snapshot = await _db.collection('provinces').get(const GetOptions(source: Source.cache));
      if (snapshot.docs.isNotEmpty) {
        debugPrint('[Firestore] provinces → OFFLINE cache (${snapshot.docs.length} reads)');
        _provincesCache = snapshot.docs
            .map((doc) => Province.fromMap(doc.data()))
            .toList();
        return _provincesCache!;
      }
    } catch (e) {
      debugPrint('[Firestore] provinces offline cache empty or not supported: $e');
    }

    // 2. Fallback: Nếu cache trống, đọc từ file local assets
    try {
      debugPrint('[Firestore] provinces → Tải từ local asset provinces.json (0 reads)');
      final raw = await rootBundle.loadString('lib/features/vietnam_map/assets/data/provinces.json');
      final decoded = jsonDecode(raw) as List<dynamic>;
      _provincesCache = decoded
          .map((item) => Province.fromMap(item as Map<String, dynamic>))
          .toList();
      
      // Kích hoạt tải ngầm từ server để lưu cache cho lần sau
      _preloadProvincesOfflineCache();
      
      return _provincesCache!;
    } catch (e) {
      debugPrint('[Firestore] Lỗi đọc file local provinces.json: $e');
    }

    // 3. Fallback cuối cùng: tải trực tiếp từ server
    final snapshot = await _db.collection('provinces').get();
    debugPrint('[Firestore] provinces → NETWORK (${snapshot.docs.length} reads)');
    _provincesCache = snapshot.docs
        .map((doc) => Province.fromMap(doc.data()))
        .toList();
    return _provincesCache!;
  }

  void _preloadProvincesOfflineCache() {
    _db.collection('provinces').get(const GetOptions(source: Source.server)).then((snapshot) {
      debugPrint('[Firestore] provinces → Đã hoàn thành tải ngầm từ NETWORK (${snapshot.docs.length} docs) để lưu cache');
    }).catchError((e) {
      debugPrint('[Firestore] Lỗi tải ngầm provinces từ NETWORK: $e');
    });
  }

  /// Lấy tất cả xã/phường (3,321 documents)
  Future<List<Commune>> getAllCommunes() async {
    if (_communesCache != null) {
      debugPrint('[Firestore] communes → RAM cache (0 reads)');
      return _communesCache!;
    }

    // 1. Thử lấy từ cache của Firestore trước (không dùng mạng)
    try {
      final snapshot = await _db.collection('communes').get(const GetOptions(source: Source.cache));
      if (snapshot.docs.isNotEmpty) {
        debugPrint('[Firestore] communes → OFFLINE cache (${snapshot.docs.length} reads)');
        _communesCache = snapshot.docs
            .map((doc) => Commune.fromMap(doc.data()))
            .toList();
        return _communesCache!;
      }
    } catch (e) {
      debugPrint('[Firestore] communes offline cache empty or not supported: $e');
    }

    // 2. Fallback: Nếu cache trống, đọc từ file local assets
    try {
      debugPrint('[Firestore] communes → Tải từ local asset communes.json (0 reads)');
      final raw = await rootBundle.loadString('lib/features/vietnam_map/assets/data/communes.json');
      final decoded = jsonDecode(raw) as List<dynamic>;
      _communesCache = decoded
          .map((item) => Commune.fromMap(item as Map<String, dynamic>))
          .toList();

      // Kích hoạt tải ngầm từ server để lưu cache cho lần sau
      _preloadCommunesOfflineCache();

      return _communesCache!;
    } catch (e) {
      debugPrint('[Firestore] Lỗi đọc file local communes.json: $e');
    }

    // 3. Fallback cuối cùng: tải trực tiếp từ server
    final snapshot = await _db.collection('communes').get();
    debugPrint('[Firestore] communes → NETWORK (${snapshot.docs.length} reads)');
    _communesCache = snapshot.docs
        .map((doc) => Commune.fromMap(doc.data()))
        .toList();
    return _communesCache!;
  }

  void _preloadCommunesOfflineCache() {
    _db.collection('communes').get(const GetOptions(source: Source.server)).then((snapshot) {
      debugPrint('[Firestore] communes → Đã hoàn thành tải ngầm từ NETWORK (${snapshot.docs.length} docs) để lưu cache');
    }).catchError((e) {
      debugPrint('[Firestore] Lỗi tải ngầm communes từ NETWORK: $e');
    });
  }

  /// Lấy chi tiết 1 tỉnh theo mã — dùng in-memory cache nếu đã có
  Future<Province?> getProvinceByMa(String ma) async {
    final cached = _provincesCache;
    if (cached != null) {
      try {
        return cached.firstWhere((p) => p.ma == ma);
      } catch (_) {
        return null;
      }
    }
    // Chưa có cache → query thẳng 1 document
    final snapshot = await _db
        .collection('provinces')
        .where('ma', isEqualTo: ma)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return Province.fromMap(snapshot.docs.first.data());
  }

  /// Lấy chi tiết 1 xã/phường theo mã — dùng in-memory cache nếu đã có
  Future<Commune?> getCommuneByMa(String ma) async {
    final cached = _communesCache;
    if (cached != null) {
      try {
        return cached.firstWhere((c) => c.ma == ma);
      } catch (_) {
        return null;
      }
    }
    // Chưa có cache → query thẳng 1 document
    final snapshot = await _db
        .collection('communes')
        .where('ma', isEqualTo: ma)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return Commune.fromMap(snapshot.docs.first.data());
  }
}
