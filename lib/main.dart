import 'package:cloud_firestore/cloud_firestore.dart';
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

const _isFlutterTest = bool.fromEnvironment('FLUTTER_TEST');
const _isPatrolTest =
  bool.fromEnvironment('PATROL_TEST') ||
  bool.fromEnvironment('PATROL_ENABLE_TEST_CHECKIN');

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

  // Auto-create school close to target coordinates if not exists
  _checkAndCreateSchools();

  // Fetch Remote Config ngay khi khởi động — nếu lỗi sẽ tự dùng default values
  await RemoteConfigService.instance.init();

  // Khởi tạo FCM: xin quyền + lấy token (chỉ chạy trên Android/iOS)
  await NotificationService.instance.init();

  // Crashlytics: chỉ bật trên mobile (Android/iOS) — không hỗ trợ Windows/Web
    if (!_isFlutterTest &&
      !_isPatrolTest &&
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
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

Future<void> _checkAndCreateSchools() async {
  try {
    // 1. Existing THPT Gia Định (HCMC)
    final q1 = await FirebaseFirestore.instance
        .collection('schools')
        .where('schoolCode', isEqualTo: 'THPT-GiaDinh')
        .get();
    if (q1.docs.isEmpty) {
      final ref = FirebaseFirestore.instance.collection('schools').doc();
      await ref.set({
        'id': ref.id,
        'provinceCode': '79',
        'provinceName': 'Thành phố Hồ Chí Minh',
        'communeCode': '27361',
        'communeName': 'Phường 25',
        'schoolCode': 'THPT-GiaDinh',
        'schoolName': 'Trường THPT Gia Định (Hồ Chí Minh)',
        'address': '195/29 Đường Nguyễn Văn Thương, Phường 25, Bình Thạnh, TP. HCM',
        'region': 'Khu vực 3',
        'latitude': 10.817691666541055,
        'longitude': 106.69800667278207,
      });
    }

    // 2. School 1: TH Đông Hòa - Cơ sở 1 (Near - ~88m)
    final q2 = await FirebaseFirestore.instance
        .collection('schools')
        .where('schoolCode', isEqualTo: 'TH-DongHoa-CS1')
        .get();
    if (q2.docs.isEmpty) {
      final ref = FirebaseFirestore.instance.collection('schools').doc();
      await ref.set({
        'id': ref.id,
        'provinceCode': '74',
        'provinceName': 'Tỉnh Bình Dương',
        'communeCode': '26476',
        'communeName': 'Phường Đông Hòa',
        'schoolCode': 'TH-DongHoa-CS1',
        'schoolName': 'Trường TH Đông Hòa - Cơ sở 1',
        'address': 'Đường Lưu Hữu Phước, Đông Hòa, Dĩ An, Bình Dương (Cách 88m)',
        'region': 'Khu vực 2',
        'latitude': 10.8797,
        'longitude': 106.8012,
      });
    }

    // 3. School 2: THCS Đông Hòa (Near - ~277m)
    final q3 = await FirebaseFirestore.instance
        .collection('schools')
        .where('schoolCode', isEqualTo: 'THCS-DongHoa')
        .get();
    if (q3.docs.isEmpty) {
      final ref = FirebaseFirestore.instance.collection('schools').doc();
      await ref.set({
        'id': ref.id,
        'provinceCode': '74',
        'provinceName': 'Tỉnh Bình Dương',
        'communeCode': '26476',
        'communeName': 'Phường Đông Hòa',
        'schoolCode': 'THCS-DongHoa',
        'schoolName': 'Trường THCS Đông Hòa',
        'address': 'Khu phố Tây A, Đông Hòa, Dĩ An, Bình Dương (Cách 277m)',
        'region': 'Khu vực 2',
        'latitude': 10.8764,
        'longitude': 106.8012,
      });
    }

    // 4. School 3: TH Đông Hòa B (Far - ~1.2km - Can't check in)
    final q4 = await FirebaseFirestore.instance
        .collection('schools')
        .where('schoolCode', isEqualTo: 'TH-DongHoaB')
        .get();
    if (q4.docs.isEmpty) {
      final ref = FirebaseFirestore.instance.collection('schools').doc();
      await ref.set({
        'id': ref.id,
        'provinceCode': '74',
        'provinceName': 'Tỉnh Bình Dương',
        'communeCode': '26476',
        'communeName': 'Phường Đông Hòa',
        'schoolCode': 'TH-DongHoaB',
        'schoolName': 'Trường TH Đông Hòa B',
        'address': 'Khu phố Tân Lập, Đông Hòa, Dĩ An, Bình Dương (Cách 1.23km)',
        'region': 'Khu vực 2',
        'latitude': 10.8900,
        'longitude': 106.8012,
      });
    } else {
      final docId = q4.docs.first.id;
      await FirebaseFirestore.instance
          .collection('schools')
          .doc(docId)
          .update({
            'schoolName': 'Trường TH Đông Hòa B',
            'latitude': 10.8900,
            'longitude': 106.8012,
            'address': 'Khu phố Tân Lập, Đông Hòa, Dĩ An, Bình Dương (Cách 1.23km)',
          });
    }

    // Ensure all 4 events for 'Chiến dịch Mùa hè xanh 2026' are correctly linked to our schools
    final campaignQuery = await FirebaseFirestore.instance
        .collection('campaigns')
        .where('name', isEqualTo: 'Chiến dịch Mùa hè xanh 2026')
        .get();

    if (campaignQuery.docs.isNotEmpty) {
      final campaignId = campaignQuery.docs.first.id;
      
      // Get our 4 schools
      final schoolsQuery = await FirebaseFirestore.instance
          .collection('schools')
          .where('schoolCode', whereIn: ['TH-DongHoa-CS1', 'THCS-DongHoa', 'TH-DongHoaB', 'THPT-GiaDinh'])
          .get();
          
      final schoolMap = {for (var doc in schoolsQuery.docs) doc['schoolCode'] as String: doc['id'] as String};
      
      if (schoolMap.isNotEmpty) {
        final eventsQuery = await FirebaseFirestore.instance
            .collection('events')
            .where('campaignId', isEqualTo: campaignId)
            .get();

        if (eventsQuery.docs.isEmpty) {
          // Define the 4 events
          final eventSpecs = [
            {
              'name': 'Sự kiện ngoại khóa số 1 (CD 2)',
              'schoolCode': 'TH-DongHoa-CS1',
              'status': 'in-progress',
            },
            {
              'name': 'Sự kiện ngoại khóa số 2 (CD 2)',
              'schoolCode': 'THCS-DongHoa',
              'status': 'completed',
            },
            {
              'name': 'Sự kiện ngoại khóa lần thứ 3',
              'schoolCode': 'TH-DongHoaB',
              'status': 'in-progress',
            },
            {
              'name': 'Sự kiện ngoại khóa số 4 (CD 2)',
              'schoolCode': 'THPT-GiaDinh',
              'status': 'in-progress',
            },
          ];

          // Find employee id to assign
          final userQuery = await FirebaseFirestore.instance.collection('users').limit(1).get();
          final employeeId = userQuery.docs.isNotEmpty ? userQuery.docs.first.id : 'mock_employee_id';

          for (var spec in eventSpecs) {
            final schoolId = schoolMap[spec['schoolCode']];
            if (schoolId != null) {
              final ref = FirebaseFirestore.instance.collection('events').doc();
              await ref.set({
                'id': ref.id,
                'campaignId': campaignId,
                'name': spec['name'],
                'date': Timestamp.now(),
                'schoolIds': [schoolId],
                'assignedEmployeeIds': [employeeId],
                'totalInteractions': 0,
                'status': spec['status'],
                'createdAt': FieldValue.serverTimestamp(),
              });
            }
          }
        }
      }
    }
    
    debugPrint('All mock schools initialized/checked.');
  } catch (e) {
    debugPrint('Error auto-creating schools: $e');
  }
}
