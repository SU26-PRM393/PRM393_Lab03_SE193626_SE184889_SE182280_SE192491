import 'package:flutter_test/flutter_test.dart';
import 'package:vietnam_map_flutter/app/map_app.dart';

void main() {
  testWidgets('Map app shell smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MapApp());

    expect(find.text('Viet Nam Explorer'), findsOneWidget);
    expect(find.byTooltip('Recenter on Viet Nam'), findsOneWidget);
  });
}
