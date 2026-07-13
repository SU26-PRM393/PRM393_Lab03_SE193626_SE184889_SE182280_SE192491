import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vietnam_map_flutter/screens/map_app.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Mock Firebase Core Pigeon channel — thay thế kết nối native thật
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
  });

  testWidgets('Map app smoke test - shows login screen when unauthenticated',
      (tester) async {
    await tester.pumpWidget(const MapApp());
    // Pump để AuthController xử lý auth state stream (firebase_auth trả về null → unauthenticated)
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Sau khi thêm Firebase Auth, app hiển thị LoginScreen thay vì map trực tiếp
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Bản đồ Việt Nam'), findsOneWidget);
    expect(find.text('Đăng nhập để tiếp tục'), findsOneWidget);
  });
}
