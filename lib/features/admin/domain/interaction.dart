import 'package:cloud_firestore/cloud_firestore.dart';

class Interaction {
  final String id;
  final String eventId;
  final String employeeId;
  final String targetType;
  final String targetId;
  final String notes;
  final DateTime? timestamp;

  Interaction({
    required this.id,
    required this.eventId,
    required this.employeeId,
    required this.targetType,
    required this.targetId,
    required this.notes,
    this.timestamp,
  });

  factory Interaction.fromMap(String id, Map<String, dynamic> data) {
    return Interaction(
      id: id,
      eventId: data['eventId'] as String? ?? '',
      employeeId: data['employeeId'] as String? ?? '',
      targetType: data['targetType'] as String? ?? '',
      targetId: data['targetId'] as String? ?? '',
      notes: data['notes'] as String? ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
    );
  }
}
