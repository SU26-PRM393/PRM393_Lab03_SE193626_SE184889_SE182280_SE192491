import 'package:cloud_firestore/cloud_firestore.dart';

class Campaign {
  final String id;
  final String name;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String status;
  final DateTime? createdAt;

  Campaign({
    required this.id,
    required this.name,
    required this.description,
    this.startDate,
    this.endDate,
    required this.status,
    this.createdAt,
  });

  factory Campaign.fromMap(String id, Map<String, dynamic> data) {
    return Campaign(
      id: id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      startDate: (data['startDate'] as Timestamp?)?.toDate(),
      endDate: (data['endDate'] as Timestamp?)?.toDate(),
      status: data['status'] as String? ?? 'active',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
