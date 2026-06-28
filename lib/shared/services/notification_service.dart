import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Callback để UI hiện thông báo khi app đang mở (foreground).
/// Truyền vào [init] từ màn hình root.
typedef OnForegroundMessage = void Function(String title, String body);

/// Xử lý toàn bộ luồng FCM — chỉ hoạt động trên Android/iOS.
/// Tương tự @Service trong Spring Boot: các màn hình không gọi FirebaseMessaging trực tiếp.
class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _fm = FirebaseMessaging.instance;

  static bool get _isMobile =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  /// Gọi 1 lần trong main() sau Firebase.initializeApp().
  /// [onForeground] nhận title + body của message khi app đang mở.
  Future<void> init({OnForegroundMessage? onForeground}) async {
    if (!_isMobile) {
      debugPrint('[FCM] không hỗ trợ trên nền tảng này');
      return;
    }

    // 1. Xin quyền hiện notification (bắt buộc trên iOS, Android 13+)
    final settings = await _fm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('[FCM] permission: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('[FCM] user từ chối quyền notification');
      return;
    }

    // 2. Lấy FCM token của thiết bị — dùng để gửi push đến đúng máy
    final token = await _fm.getToken();
    debugPrint('[FCM] device token: $token');

    // 3. Lắng nghe message khi app đang MỞ (foreground)
    FirebaseMessaging.onMessage.listen((message) {
      final title = message.notification?.title ?? '(no title)';
      final body = message.notification?.body ?? '';
      debugPrint('[FCM] foreground message — title: $title | body: $body');
      onForeground?.call(title, body);
    });

    // 4. Lắng nghe khi user BẤM vào notification (app ở background/terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('[FCM] notification tapped: ${message.notification?.title}');
      // TODO: navigate đến màn hình phù hợp theo message.data['route']
    });

    // 5. Kiểm tra notification khởi động app từ terminated state
    final initial = await _fm.getInitialMessage();
    if (initial != null) {
      debugPrint('[FCM] app opened from notification: ${initial.notification?.title}');
    }
  }

  /// FCM token của thiết bị hiện tại.
  /// Dùng trong Firebase Console → "Send test message" để test.
  Future<String?> getToken() async {
    if (!_isMobile) return null;
    return _fm.getToken();
  }
}

/// Handler chạy ở background isolate — phải là top-level function (không phải method).
/// Firebase tự gọi khi app ở background và có message đến.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[FCM] background message: ${message.notification?.title}');
  // Không gọi UI ở đây vì isolate riêng biệt — chỉ xử lý data thuần
}
