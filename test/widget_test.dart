import 'package:flutter_test/flutter_test.dart';
import 'package:vietnam_map_flutter/app/map_app.dart';

void main() {
  testWidgets('Map app shell smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MapApp());

    expect(find.text('Khám phá Việt Nam'), findsOneWidget);
    expect(find.byTooltip('Căn giữa về Việt Nam'), findsOneWidget);
  });
}
