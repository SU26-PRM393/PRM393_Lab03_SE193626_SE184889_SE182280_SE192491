import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String campaignId;
  final String name;
  final DateTime? date;
  final List<String> schoolIds;
  final List<String> assignedEmployeeIds;
  final int totalInteractions;
  final String status;
  final DateTime? createdAt;

  Event({
    required this.id,
    required this.campaignId,
    required this.name,
    this.date,
    required this.schoolIds,
    required this.assignedEmployeeIds,
    this.totalInteractions = 0,
    required this.status,
    this.createdAt,
  });

  factory Event.fromMap(String id, Map<String, dynamic> data) {
    return Event(
      id: id,
      campaignId: data['campaignId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      date: (data['date'] as Timestamp?)?.toDate(),
      schoolIds: List<String>.from(data['schoolIds'] ?? []),
      assignedEmployeeIds: List<String>.from(data['assignedEmployeeIds'] ?? []),
      totalInteractions: data['totalInteractions'] as int? ?? 0,
      status: data['status'] as String? ?? 'in-progress',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
