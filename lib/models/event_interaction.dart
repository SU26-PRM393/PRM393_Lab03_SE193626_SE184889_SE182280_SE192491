import 'package:cloud_firestore/cloud_firestore.dart';

class EventInteraction {
  const EventInteraction({
    required this.id,
    required this.eventId,
    required this.employeeId,
    required this.targetType,
    required this.targetName,
    required this.notes,
    this.createdAt,
  });

  final String id;
  final String eventId;
  final String employeeId;
  final String targetType;
  final String targetName;
  final String notes;
  final DateTime? createdAt;

  factory EventInteraction.fromMap(String id, Map<String, dynamic> data) {
    return EventInteraction(
      id: id,
      eventId: data['eventId'] as String? ?? '',
      employeeId: data['employeeId'] as String? ?? '',
      targetType: data['targetType'] as String? ?? 'student',
      targetName: data['targetName'] as String? ?? '',
      notes: data['notes'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'employeeId': employeeId,
      'targetType': targetType,
      'targetName': targetName.trim(),
      'notes': notes.trim(),
    };
  }
}
