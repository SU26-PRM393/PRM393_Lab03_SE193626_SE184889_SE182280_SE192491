import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

/// Service đọc cấu hình động từ Firebase Remote Config.
/// Gọi [init] một lần khi app khởi động — sau đó đọc giá trị qua getters.
class RemoteConfigService {
  RemoteConfigService._();
  static final instance = RemoteConfigService._();

  final _rc = FirebaseRemoteConfig.instance;

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
    try {
      await _rc.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        // debug: luôn fetch mới; release: cache 1 giờ để tiết kiệm quota
        minimumFetchInterval:
            kDebugMode ? Duration.zero : const Duration(hours: 1),
      ));

      await _rc.setDefaults(_defaults);

      // Fetch + activate ngay khi khởi động
      await _rc.fetchAndActivate();

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

  /// Số tỉnh hiển thị mặc định trên biểu đồ (default: 10)
  int get provinceCount => _rc.getInt(_keyProvinceCount);

  /// Khoảng cách tối đa để check-in hợp lệ tính bằng mét (default: 500)
  double get checkinDistanceMeters => _rc.getDouble(_keyCheckinDistance);

  /// Có bật tính năng export PDF không (default: false)
  bool get isPdfExportEnabled => _rc.getBool(_keyEnablePdf);

  /// ID của campaign được ghim lên đầu (default: rỗng)
  String get featuredCampaignId => _rc.getString(_keyFeaturedCampaign);
}
