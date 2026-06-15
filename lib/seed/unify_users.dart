import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

Future<void> unifyUsers() async {
  debugPrint('--- BẮT ĐẦU UNIFY USERS ---');
  final db = FirebaseFirestore.instance;

  final emailsToUpdate = {
    'admin@prm.com': {'name': 'Administrator', 'role': 'admin'},
    'user@prm.com': {'name': 'Regular User', 'role': 'user'},
  };

  for (final email in emailsToUpdate.keys) {
    try {
      final query = await db.collection('users').where('email', isEqualTo: email).get();
      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        final data = doc.data();
        
        // Cập nhật các trường còn thiếu hoặc đồng bộ hóa structure
        final updates = <String, dynamic>{};
        
        if (!data.containsKey('name') || data['name'] == null || data['name'] == '') {
          updates['name'] = emailsToUpdate[email]!['name'];
        }
        
        if (!data.containsKey('role') || data['role'] == null || data['role'] == '') {
          updates['role'] = emailsToUpdate[email]!['role'];
        }
        
        if (!data.containsKey('createdAt') || data['createdAt'] == null) {
          updates['createdAt'] = FieldValue.serverTimestamp();
        }

        if (updates.isNotEmpty) {
          await doc.reference.update(updates);
          debugPrint('Đã cập nhật \$email: \$updates');
        } else {
          debugPrint('\$email đã đúng chuẩn, không cần cập nhật.');
        }
      } else {
        debugPrint('Không tìm thấy tài khoản \$email trong Firestore.');
      }
    } catch (e) {
      debugPrint('Lỗi khi cập nhật \$email: \$e');
    }
  }

  debugPrint('--- HOÀN TẤT UNIFY USERS ---');
}
