import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

Future<void> diversifyEvents() async {
  debugPrint('--- BẮT ĐẦU DIVERSIFY EVENTS & INTERACTIONS ---');
  final db = FirebaseFirestore.instance;
  final random = Random();

  try {
    // 1. Lấy danh sách tất cả các user có role là 'user' (không lấy admin)
    final userQuery = await db.collection('users').where('role', isEqualTo: 'user').get();
    if (userQuery.docs.isEmpty) {
      debugPrint('Không có user nào trong hệ thống!');
      return;
    }
    
    // Lọc bỏ những user bị disable
    final List<String> userIds = userQuery.docs
        .where((d) => d.data()['disabled'] != true)
        .map((d) => d.id)
        .toList();
        
    if (userIds.isEmpty) {
      debugPrint('Không có user (active) nào để làm employee!');
      return;
    }
    
    debugPrint('Đã tìm thấy ${userIds.length} users (active) để làm employee.');

    // 1.5 Lấy danh sách trường học
    final schoolQuery = await db.collection('schools').limit(100).get();
    final List<String> schoolIds = schoolQuery.docs.map((d) => d.id).toList();
    if (schoolIds.isNotEmpty) {
      schoolIds.shuffle(random);
    }

    // 2. Cập nhật Events
    final eventQuery = await db.collection('events').get();
    int eventsUpdated = 0;
    
    for (var doc in eventQuery.docs) {
      // Chọn ngẫu nhiên từ 1 đến 3 nhân viên (không vượt quá số lượng user có sẵn)
      int numAssignees = random.nextInt(3) + 1;
      if (numAssignees > userIds.length) numAssignees = userIds.length;
      
      // Trộn ngẫu nhiên danh sách user và lấy N user đầu tiên
      final shuffledUsers = List<String>.from(userIds)..shuffle(random);
      final assignedEmployeeIds = shuffledUsers.take(numAssignees).toList();
      
      final assignedSchoolIds = schoolIds.isNotEmpty 
          ? [schoolIds[eventsUpdated % schoolIds.length]] 
          : <String>[];
      
      await doc.reference.update({
        'assignedEmployeeIds': assignedEmployeeIds,
        if (assignedSchoolIds.isNotEmpty) 'schoolIds': assignedSchoolIds,
      });
      eventsUpdated++;
    }
    debugPrint('Đã cập nhật $eventsUpdated sự kiện với nhân viên và trường học đa dạng.');

    // 3. Cập nhật Interactions
    final interactionQuery = await db.collection('interactions').get();
    int interactionsUpdated = 0;
    
    for (var doc in interactionQuery.docs) {
      // Chọn ngẫu nhiên 1 nhân viên thực hiện tương tác này
      final randomEmployeeId = userIds[random.nextInt(userIds.length)];
      
      await doc.reference.update({
        'employeeId': randomEmployeeId,
      });
      interactionsUpdated++;
    }
    debugPrint('Đã cập nhật \$interactionsUpdated tương tác với nhân viên ngẫu nhiên.');

  } catch (e) {
    debugPrint('Lỗi: \$e');
  }

  debugPrint('--- HOÀN TẤT DIVERSIFY ---');
}
