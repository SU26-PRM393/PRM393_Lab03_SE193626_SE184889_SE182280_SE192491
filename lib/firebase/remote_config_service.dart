import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

/// Service đọc cấu hình động từ Firebase Remote Config.
/// Gọi [init] một lần khi app khởi động — sau đó đọc giá trị qua getters.
class RemoteConfigService {
  RemoteConfigService._();
  static final instance = RemoteConfigService._();

  // ── Tên các key phải khớp chính xác với Firebase Console ──────────────────
  static const _keyProvinceCount = 'default_chart_province_count';
  static const _keyCheckinDistance = 'max_checkin_distance_meters';
  static const _keyEnablePdf = 'enable_pdf_export';
  static const _keyFeaturedCampaign = 'featured_campaign_id';

  // ── Giá trị mặc định dùng khi chưa fetch được từ Firebase ─────────────────
  // Phải trùng với Default value trên Console
  static const _defaults = {
    _keyProvinceCount: 10,
    _keyCheckinDistance: 500.0,
    _keyEnablePdf: false,
    _keyFeaturedCampaign: '',
  };

  /// Gọi 1 lần trong main() sau Firebase.initializeApp()
  Future<void> init() async {
    if (Firebase.apps.isEmpty) {
      debugPrint('[RemoteConfig] Firebase chưa khởi tạo, dùng defaults cục bộ.');
      return;
    }

    final rc = FirebaseRemoteConfig.instance;

    try {
      await rc.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        // debug: luôn fetch mới; release: cache 1 giờ để tiết kiệm quota
        minimumFetchInterval:
            kDebugMode ? Duration.zero : const Duration(hours: 1),
      ));

      await rc.setDefaults(_defaults);

      // Fetch + activate ngay khi khởi động
      await rc.fetchAndActivate();

      debugPrint('[RemoteConfig] fetch thành công — '
          'province_count=$provinceCount, '
          'checkin_distance=${checkinDistanceMeters}m, '
          'pdf_export=$isPdfExportEnabled');
    } catch (e) {
      // Nếu lỗi mạng → dùng default values, app vẫn chạy bình thường
      debugPrint('[RemoteConfig] fetch thất bại, dùng defaults: $e');
    }
  }

  // ── Getters — đọc giá trị sau khi fetch ───────────────────────────────────

  FirebaseRemoteConfig? get _remoteConfigOrNull {
    if (Firebase.apps.isEmpty) {
      return null;
    }

    return FirebaseRemoteConfig.instance;
  }

  /// Số tỉnh hiển thị mặc định trên biểu đồ (default: 10)
  int get provinceCount =>
      _remoteConfigOrNull?.getInt(_keyProvinceCount) ??
      _defaults[_keyProvinceCount]! as int;

  /// Khoảng cách tối đa để check-in hợp lệ tính bằng mét (default: 500)
  double get checkinDistanceMeters =>
      _remoteConfigOrNull?.getDouble(_keyCheckinDistance) ??
      _defaults[_keyCheckinDistance]! as double;

  /// Có bật tính năng export PDF không (default: false)
  bool get isPdfExportEnabled =>
      _remoteConfigOrNull?.getBool(_keyEnablePdf) ??
      _defaults[_keyEnablePdf]! as bool;

  /// ID của campaign được ghim lên đầu (default: rỗng)
  String get featuredCampaignId =>
      _remoteConfigOrNull?.getString(_keyFeaturedCampaign) ??
      _defaults[_keyFeaturedCampaign]! as String;
}
