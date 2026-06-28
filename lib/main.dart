import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vietnam_map_flutter/firebase/firebase_options.dart';
import 'package:vietnam_map_flutter/utils/map_startup_trace.dart';
import 'package:vietnam_map_flutter/firebase/notification_service.dart';
import 'package:vietnam_map_flutter/firebase/remote_config_service.dart';
import 'package:vietnam_map_flutter/screens/map_app.dart';

// Phải đăng ký trước runApp() — Firebase gọi handler này trong isolate riêng
// khi app ở background và nhận FCM message
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Đăng ký background message handler trước Firebase.initializeApp
  // @pragma('vm:entry-point') đảm bảo hàm không bị tree-shake khi build release
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Fetch Remote Config ngay khi khởi động — nếu lỗi sẽ tự dùng default values
  await RemoteConfigService.instance.init();

  // Khởi tạo FCM: xin quyền + lấy token (chỉ chạy trên Android/iOS)
  await NotificationService.instance.init();

  // Crashlytics: chỉ bật trên mobile (Android/iOS) — không hỗ trợ Windows/Web
  if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS)) {
    // Bật collection kể cả trong debug để có thể test
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    // Gửi tất cả Flutter framework errors lên Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Gửi uncaught async errors (bên ngoài Flutter framework) lên Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      final errorStr = error.toString();
      if (errorStr.contains('Cancelled') ||
          errorStr.contains('CancellationException')) {
        debugPrint('Asynchronous task cancelled gracefully: $error');
        return true;
      }
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } else {
    // Desktop/Web: chỉ bỏ qua cancellations, không gọi Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      final errorStr = error.toString();
      if (errorStr.contains('Cancelled') ||
          errorStr.contains('CancellationException')) {
        debugPrint('Asynchronous task cancelled gracefully: $error');
        return true;
      }
      return false;
    };
  }

  MapStartupTrace.instant('app.runApp');
  runApp(const MapApp());
}
