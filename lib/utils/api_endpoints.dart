// Tập trung toàn bộ URL, API endpoint, Firestore collection name,
// Firebase Storage path prefix, và Firebase Console URL tại một nơi.
//
// CÁCH SỬ DỤNG:
// ```dart
// import 'package:vietnam_map_flutter/utils/api_endpoints.dart';
//
// // Firestore
// FirebaseFirestore.instance.collection(FirestoreCollections.events);
//
// // Storage
// FirebaseStorage.instance.ref(StoragePaths.pdfExport(uid, timestamp));
//
// // Firebase Console link
// launchUrl(Uri.parse(FirebaseConsoleUrls.fcm));
// ```

// ── Firebase Project ──────────────────────────────────────────────────────────

abstract final class FirebaseProject {
  /// Firebase project ID — dùng xuyên suốt các URL
  static const String id = 'vietmap-flutter';

  /// Firebase Storage bucket
  static const String storageBucket = '$id.firebasestorage.app';
}

// ── Firestore Collection Names ────────────────────────────────────────────────

abstract final class FirestoreCollections {
  /// Người dùng hệ thống
  static const String users = 'users';

  /// Chiến dịch tuyển sinh
  static const String campaigns = 'campaigns';

  /// Sự kiện thuộc chiến dịch
  static const String events = 'events';

  /// Trường THPT
  static const String schools = 'schools';

  /// Học sinh
  static const String students = 'students';

  /// Phụ huynh / người thân
  static const String relatives = 'relatives';

  /// Cán bộ / giáo viên
  static const String persons = 'persons';

  /// Lượt check-in
  static const String checkins = 'checkins';

  /// Lượt check-out
  static const String checkouts = 'checkouts';

  /// Tương tác (interactions)
  static const String interactions = 'interactions';

  /// Thông báo trong app
  static const String notifications = 'notifications';
}

// ── Firebase Firestore Field Keys ─────────────────────────────────────────────

abstract final class FirestoreFields {
  // ── users
  static const String role = 'role';
  static const String isDisabled = 'isDisabled';

  // ── events
  static const String campaignId = 'campaignId';
  static const String schoolId = 'schoolId';
  static const String assignedUserId = 'assignedUserId';
  static const String startDate = 'startDate';
  static const String endDate = 'endDate';
  static const String status = 'status';

  // ── checkins / checkouts
  static const String eventId = 'eventId';
  static const String userId = 'userId';
  static const String createdAt = 'createdAt';
  static const String photoUrl = 'photoUrl';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';

  // ── notifications
  static const String recipientId = 'recipientId';
  static const String isRead = 'isRead';
  static const String timestamp = 'timestamp';
}

// ── Firebase Storage Paths ────────────────────────────────────────────────────

abstract final class StoragePaths {
  /// Thư mục chứa ảnh check-in / check-out
  static const String checkinsFolder = 'checkin_photos';
  static const String checkoutsFolder = 'checkout_photos';

  /// Thư mục chứa ảnh hồ sơ người dùng
  static const String avatarsFolder = 'avatars';

  /// Thư mục chứa file PDF xuất báo cáo
  static const String pdfExportsFolder = 'pdf_exports';

  /// Path đầy đủ cho file PDF theo UID và timestamp
  static String pdfExport(String uid, int timestampMs) =>
      '$pdfExportsFolder/$uid/${timestampMs}_stats.pdf';

  /// Path cho ảnh check-in
  static String checkinPhoto(String eventId, String userId, int timestampMs) =>
      '$checkinsFolder/$eventId/$userId/$timestampMs.jpg';

  /// Path cho ảnh check-out
  static String checkoutPhoto(String eventId, String userId, int timestampMs) =>
      '$checkoutsFolder/$eventId/$userId/$timestampMs.jpg';
}

// ── Google / Firebase REST API Endpoints ─────────────────────────────────────

abstract final class GoogleApiEndpoints {
  /// OAuth2 token endpoint (dùng trong FCM Admin Service)
  static const String oauth2Token = 'https://oauth2.googleapis.com/token';

  /// OAuth2 scope cho Firebase Messaging
  static const String fcmScope =
      'https://www.googleapis.com/auth/firebase.messaging';

  /// FCM HTTP v1 API — gửi push notification qua server
  static String fcmSend(String projectId) =>
      'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

  /// Convenience getter dùng project ID mặc định
  static String get fcmSendDefault => fcmSend(FirebaseProject.id);
}

// ── Firebase Console URLs ─────────────────────────────────────────────────────

abstract final class FirebaseConsoleUrls {
  static const String _base =
      'https://console.firebase.google.com/u/0/project/${FirebaseProject.id}';

  /// Compose & gửi FCM notification
  static const String fcm = '$_base/notification/compose';

  /// Remote Config dashboard
  static const String remoteConfig = '$_base/config/env/firebase';

  /// Firebase Storage — thư mục pdf_exports
  static const String pdfExports =
      '$_base/storage/${FirebaseProject.storageBucket}/files/~2F${StoragePaths.pdfExportsFolder}';

  /// Crashlytics — issues Android, 7 ngày gần nhất
  static const String crashlyticsAndroid =
      '$_base/crashlytics/app/android:com.example.vietnam_map_flutter'
      '/issues?time=7d&state=open&types=crash&tag=all&sort=eventCount';

  /// Firestore Database
  static const String firestore = '$_base/firestore/databases/-default-/data';

  /// Authentication — quản lý người dùng
  static const String auth = '$_base/authentication/users';

  /// Firebase Storage — root
  static const String storage =
      '$_base/storage/${FirebaseProject.storageBucket}/files';
}

// ── Map Tile URLs ─────────────────────────────────────────────────────────────
// Các URL này cũng được khai báo trong MapConstants — đây là tham chiếu
// tập trung; MapConstants giữ nguyên để tránh breaking change.

abstract final class MapTileUrls {
  /// CARTO Voyager — không nhãn (dùng làm nền cho bản đồ phân vùng)
  static const String cartoVoyagerNoLabels =
      'https://a.basemaps.cartocdn.com/rastertiles/voyager_nolabels/{z}/{x}/{y}.png';

  /// CARTO Voyager — có nhãn (chế độ Light)
  static const String cartoVoyagerLight =
      'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png';

  /// CARTO Dark All (chế độ Dark)
  static const String cartoDark =
      'https://a.basemaps.cartocdn.com/rastertiles/dark_all/{z}/{x}/{y}.png';

  /// Esri World Imagery (chế độ Satellite)
  static const String esriSatellite =
      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';

  /// NDA Maps style URL (VietMap SDK)
  static const String ndaMapsStyle =
      'https://maptiles.ndamaps.vn/styles/day-v1/style.json?apikey={key}';

  /// Attribution strings
  static const String cartoAttribution =
      '© OpenStreetMap contributors, © CARTO';
  static const String esriAttribution =
      'Tiles © Esri — Source: Esri, Maxar, Earthstar Geographics, and the GIS User Community';
  static const String ndaMapsAttribution = '© NDAMaps, © Openmap.vn';
}

// ── External / Placeholder URLs ───────────────────────────────────────────────

abstract final class ExternalUrls {
  /// Ảnh placeholder cho check-in / check-out khi test trên Windows
  /// (Windows không có camera API)
  static const String picsumPlaceholder = 'https://picsum.photos/400/300';
}
