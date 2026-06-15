import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

Future<void> seedDatabase() async {
  debugPrint('--- BẮT ĐẦU SEED DỮ LIỆU ---');
  final db = FirebaseFirestore.instance;

  // 1. Seed Schools
  debugPrint('Đang đọc file schools.json...');
  try {
    final file = File('d:/Semesters/Summer2026/PRM393/Project/VietNam-Map-Flutter/schools.json');
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final List<dynamic> data = jsonDecode(jsonString);

      debugPrint('Đã tải ${data.length} trường. Đang đẩy lên Firestore...');
      
      var batch = db.batch();
      var count = 0;
      var totalImported = 0;

      for (var row in data) {
        final schoolDoc = db.collection('schools').doc();
        batch.set(schoolDoc, {
          'id': row['STT'],
          'provinceCode': row['Mã Tỉnh/TP'],
          'provinceName': row['Tên Tỉnh/TP'],
          'communeCode': row['Mã Xã/ Phường'],
          'communeName': row['Tên Xã/Phường'],
          'schoolCode': row['Mã Trường'],
          'schoolName': row['Tên Trường'],
          'address': row['Địa Chỉ'],
          'region': row['Khu Vực'],
        });

        count++;
        totalImported++;

        if (count >= 500) {
          await batch.commit();
          batch = db.batch();
          count = 0;
          debugPrint('Đã insert $totalImported trường...');
        }
      }
      
      if (count > 0) {
        await batch.commit();
        debugPrint('Đã insert xong tổng cộng $totalImported trường.');
      }
    } else {
      debugPrint('Không tìm thấy file schools.json!');
    }
  } catch (e) {
    debugPrint('Lỗi khi seed schools: $e');
  }

  // Lấy 6 schools ngẫu nhiên làm gốc cho mock data
  final schoolQuery = await db.collection('schools').limit(6).get();
  if (schoolQuery.docs.isEmpty) {
    debugPrint('Không có school nào để gán mock data. Dừng seed.');
    return;
  }
  final schoolIdsList = schoolQuery.docs.map((doc) => doc.id).toList();
  String getSchoolId(int index) => schoolIdsList[index % schoolIdsList.length];

  // Lấy 1 user admin hiện tại (hoặc user bất kỳ) làm employee
  final userQuery = await db.collection('users').limit(1).get();
  final employeeId = userQuery.docs.isNotEmpty ? userQuery.docs.first.id : 'mock_employee_id';

  // 2. Tạo 2 Campaigns
  debugPrint('Đang tạo Campaigns & Events...');
  final c1 = db.collection('campaigns').doc();
  await c1.set({
    'name': 'Chiến dịch Tuyển sinh 2026 đợt 1',
    'description': 'Tư vấn tuyển sinh các trường THPT khu vực Hà Nội',
    'startDate': FieldValue.serverTimestamp(),
    'endDate': FieldValue.serverTimestamp(),
    'status': 'active',
    'createdAt': FieldValue.serverTimestamp(),
  });

  final c2 = db.collection('campaigns').doc();
  await c2.set({
    'name': 'Chiến dịch Mùa hè xanh 2026',
    'description': 'Hoạt động ngoại khóa hỗ trợ học sinh',
    'startDate': FieldValue.serverTimestamp(),
    'endDate': FieldValue.serverTimestamp(),
    'status': 'completed',
    'createdAt': FieldValue.serverTimestamp(),
  });

  // 3. Tạo 3 Events cho mỗi Campaign
  final List<String> eventIds = [];
  for (int i = 1; i <= 3; i++) {
    final e1 = db.collection('events').doc();
    eventIds.add(e1.id);
    await e1.set({
      'campaignId': c1.id,
      'name': 'Sự kiện tư vấn số $i (CD 1)',
      'date': FieldValue.serverTimestamp(),
      'schoolIds': [getSchoolId((i - 1) * 2)],
      'assignedEmployeeIds': [employeeId],
      'totalInteractions': 0,
      'status': i == 1 ? 'in-progress' : 'completed',
      'createdAt': FieldValue.serverTimestamp(),
    });

    final e2 = db.collection('events').doc();
    eventIds.add(e2.id);
    await e2.set({
      'campaignId': c2.id,
      'name': 'Sự kiện ngoại khóa số $i (CD 2)',
      'date': FieldValue.serverTimestamp(),
      'schoolIds': [getSchoolId((i - 1) * 2 + 1)],
      'assignedEmployeeIds': [employeeId],
      'totalInteractions': 0,
      'status': i == 3 ? 'canceled' : 'completed',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // 4. Tạo 10 Students, 10 Persons, 10 Relatives
  debugPrint('Đang tạo Students, Persons, Relatives...');
  final List<String> studentIds = [];
  final List<String> personIds = [];
  final List<String> relativeIds = [];

  for (int i = 1; i <= 10; i++) {
    // Person
    final pDoc = db.collection('persons').doc();
    personIds.add(pDoc.id);
    await pDoc.set({
      'schoolId': getSchoolId(0),
      'name': 'Giáo viên $i',
      'roleType': i % 2 == 0 ? 'principal' : 'teacher',
      'phone': '098800000$i',
      'email': 'giaovien$i@school.com',
    });

    // Student
    final sDoc = db.collection('students').doc();
    studentIds.add(sDoc.id);
    await sDoc.set({
      'schoolId': getSchoolId(0),
      'studentCode': 'HS2026_00$i',
      'name': 'Học sinh $i',
      'className': '12A${i % 3 + 1}',
    });

    // Relative (gắn vào student)
    final rDoc = db.collection('relatives').doc();
    relativeIds.add(rDoc.id);
    await rDoc.set({
      'studentId': sDoc.id,
      'name': 'Phụ huynh $i',
      'relationship': i % 2 == 0 ? 'father' : 'mother',
      'phone': '097700000$i',
    });
  }

  // 5. Tạo 10 Interactions
  debugPrint('Đang tạo Interactions...');
  int totalAdded = 0;
  for (int i = 0; i < 10; i++) {
    final iDoc = db.collection('interactions').doc();
    
    // Phân bổ target ngẫu nhiên
    String targetType = 'student';
    String targetId = studentIds[i];
    if (i % 3 == 1) {
      targetType = 'person';
      targetId = personIds[i];
    } else if (i % 3 == 2) {
      targetType = 'relative';
      targetId = relativeIds[i];
    }

    // Chọn 1 event (ví dụ event đầu tiên)
    final evId = eventIds[0];

    await iDoc.set({
      'eventId': evId,
      'employeeId': employeeId,
      'targetType': targetType,
      'targetId': targetId,
      'notes': 'Ghi chú tương tác lần ${i + 1} với $targetType',
      'timestamp': FieldValue.serverTimestamp(),
    });

    totalAdded++;
  }

  // Cập nhật lại số interaction cho event đầu tiên
  if (totalAdded > 0) {
    await db.collection('events').doc(eventIds[0]).update({
      'totalInteractions': FieldValue.increment(totalAdded),
    });
  }

  debugPrint('--- HOÀN TẤT SEED DỮ LIỆU ---');
}
