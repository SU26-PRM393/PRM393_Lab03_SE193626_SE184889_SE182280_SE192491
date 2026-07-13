// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:vietnam_map_flutter/screens/stats_screen.dart';

void main() {
  patrolTest(
    'dashboard statistics displayed correctly',
    ($) async {
      await $.tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Thống Kê'),
                    SizedBox(height: 24),
                    StatsEmbeddedContent(
                      showMapCard: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await $.tester.pumpAndSettle();

      await _waitForText(
        $.tester,
        find.text('Top 10 tỉnh/thành theo dân số'),
        timeout: const Duration(seconds: 30),
      );

      expect(
        find.text('Thống Kê'),
        findsOneWidget,
        reason: 'Statistics heading should be displayed.',
      );

      expect(
        find.text('Top 10 tỉnh/thành theo dân số'),
        findsOneWidget,
        reason: 'Top 10 provinces by population should be visible.',
      );

      expect(
        find.text('Top 10 tỉnh/thành theo diện tích'),
        findsOneWidget,
        reason: 'Top 10 provinces by area should be visible.',
      );

      expect(
        find.text('Top 10 tỉnh/thành theo mật độ dân số'),
        findsOneWidget,
        reason: 'Top 10 provinces by density should be visible.',
      );

      await _scrollDownToViewMoreStats($);

      expect(
        find.text('Phân bố vùng miền'),
        findsOneWidget,
        reason: 'Region distribution chart should be visible.',
      );

      expect(
        find.text('Phân loại đơn vị'),
        findsOneWidget,
        reason: 'Unit type classification chart should be visible.',
      );

      expect(
        find.text('Lỗi'),
        findsNothing,
        reason: 'No error messages should be displayed.',
      );
    },
  );
}

Future<void> _scrollDownToViewMoreStats(PatrolIntegrationTester $) async {
  final scrollableFinder = find.byType(SingleChildScrollView);

  if (scrollableFinder.evaluate().isEmpty) {
    return;
  }

  await $.tester.drag(
    scrollableFinder.first,
    const Offset(0, -300),
  );
  await $.tester.pumpAndSettle();
}

Future<void> _waitForText(
  WidgetTester tester,
  Finder finder, {
  required Duration timeout,
}) async {
  final startedAt = DateTime.now();

  while (finder.evaluate().isEmpty) {
    if (DateTime.now().difference(startedAt) > timeout) {
      fail('Timed out waiting for text after ${timeout.inSeconds} seconds.');
    }

    await tester.pump(const Duration(milliseconds: 100));
  }
}


