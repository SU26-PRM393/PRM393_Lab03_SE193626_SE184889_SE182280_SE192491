import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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
  FirestoreRepository._();
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
    final snapshot = await _db.collection('provinces').get();
    final source = snapshot.metadata.isFromCache ? 'OFFLINE cache' : 'NETWORK';
    debugPrint('[Firestore] provinces → $source (${snapshot.docs.length} reads)');
    _provincesCache = snapshot.docs
        .map((doc) => Province.fromMap(doc.data()))
        .toList();
    return _provincesCache!;
  }

  /// Lấy tất cả xã/phường (3,321 documents)
  Future<List<Commune>> getAllCommunes() async {
    if (_communesCache != null) {
      debugPrint('[Firestore] communes → RAM cache (0 reads)');
      return _communesCache!;
    }
    final snapshot = await _db.collection('communes').get();
    final source = snapshot.metadata.isFromCache ? 'OFFLINE cache' : 'NETWORK';
    debugPrint('[Firestore] communes → $source (${snapshot.docs.length} reads)');
    _communesCache = snapshot.docs
        .map((doc) => Commune.fromMap(doc.data()))
        .toList();
    return _communesCache!;
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
