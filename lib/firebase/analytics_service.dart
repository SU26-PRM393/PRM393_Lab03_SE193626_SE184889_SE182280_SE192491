import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Wrapper cho Firebase Analytics — tất cả màn hình gọi qua đây.
/// Tương tự @Service trong Spring Boot: UI không gọi FirebaseAnalytics trực tiếp.
class AnalyticsService {
  AnalyticsService._();
  static final instance = AnalyticsService._();

  final _analytics = FirebaseAnalytics.instance;

  // ── Auth events ────────────────────────────────────────────────────────────

  Future<void> logLogin(String method) async {
    await _safe(() => _analytics.logLogin(loginMethod: method));
  }

  Future<void> logSignUp(String method) async {
    await _safe(() => _analytics.logSignUp(signUpMethod: method));
  }

  // ── Map events ─────────────────────────────────────────────────────────────

  /// Ghi lại khi user chọn 1 tỉnh trên bản đồ
  Future<void> logProvinceViewed({
    required String provinceMa,
    required String provinceName,
  }) async {
    await _safe(() => _analytics.logEvent(
          name: 'province_viewed',
          parameters: {
            'province_ma': provinceMa,
            'province_name': provinceName,
          },
        ));
  }

  // ── Stats events ───────────────────────────────────────────────────────────

  /// Ghi lại khi user mở tab Thống Kê
  Future<void> logStatsScreenViewed() async {
    await _safe(() => _analytics.logScreenView(
          screenName: 'stats_screen',
          screenClass: 'StatsScreen',
        ));
  }

  /// Ghi lại khi user bấm vào 1 cột biểu đồ
  Future<void> logChartBarTapped({
    required String chartType,
    required String provinceName,
  }) async {
    await _safe(() => _analytics.logEvent(
          name: 'chart_bar_tapped',
          parameters: {
            'chart_type': chartType,
            'province_name': provinceName,
          },
        ));
  }

  // ── Campaign events ────────────────────────────────────────────────────────

  /// Ghi lại khi user xem chi tiết 1 campaign
  Future<void> logCampaignViewed(String campaignId) async {
    await _safe(() => _analytics.logEvent(
          name: 'campaign_viewed',
          parameters: {'campaign_id': campaignId},
        ));
  }

  /// Ghi lại khi user check-in thành công
  Future<void> logCheckinSubmitted({
    required String eventId,
    required double distanceMeters,
  }) async {
    await _safe(() => _analytics.logEvent(
          name: 'checkin_submitted',
          parameters: {
            'event_id': eventId,
            'distance_meters': distanceMeters,
          },
        ));
  }

  // ── Screen view helper ─────────────────────────────────────────────────────

  Future<void> logScreenView(String screenName) async {
    await _safe(() => _analytics.logScreenView(screenName: screenName));
  }

  // ── Internal safe wrapper ──────────────────────────────────────────────────

  /// Bọc mọi lời gọi Analytics trong try/catch.
  /// Analytics lỗi không được làm crash app.
  Future<void> _safe(Future<void> Function() fn) async {
    try {
      await fn();
    } catch (e) {
      debugPrint('[Analytics] error: $e');
    }
  }
}
