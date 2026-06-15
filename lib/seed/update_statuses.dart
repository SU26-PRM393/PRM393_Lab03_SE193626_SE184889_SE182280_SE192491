import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

Future<void> updateStatuses() async {
  debugPrint('--- BẮT ĐẦU CẬP NHẬT STATUS ---');
  final db = FirebaseFirestore.instance;

  try {
    // 1. Chuyển campaign 'draft' thành 'completed' (hoặc 'active')
    final campaignQuery = await db.collection('campaigns').where('status', isEqualTo: 'draft').get();
    for (var doc in campaignQuery.docs) {
      await doc.reference.update({'status': 'canceled'});
    }
    debugPrint('Đã cập nhật \${campaignQuery.docs.length} campaigns từ draft sang canceled.');

    // 2. Thêm status ngẫu nhiên cho tất cả các sự kiện chưa có status
    final eventQuery = await db.collection('events').get();
    int eventsUpdated = 0;
    
    for (int i = 0; i < eventQuery.docs.length; i++) {
      var doc = eventQuery.docs[i];
      final data = doc.data();
      if (!data.containsKey('status') || data['status'] == null) {
        String newStatus = 'completed';
        if (i % 3 == 0) newStatus = 'in-progress';
        if (i % 3 == 2) newStatus = 'canceled';
        
        await doc.reference.update({'status': newStatus});
        eventsUpdated++;
      }
    }
    debugPrint('Đã cập nhật status cho \$eventsUpdated sự kiện cũ.');

  } catch (e) {
    debugPrint('Lỗi: \$e');
  }

  debugPrint('--- HOÀN TẤT CẬP NHẬT STATUS ---');
}
