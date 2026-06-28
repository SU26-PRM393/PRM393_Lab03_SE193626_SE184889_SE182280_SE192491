import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationMessage {
  final String id;
  final String type;
  final String title;
  final String body;
  final String campaignId;
  final String? eventId;
  final DateTime? createdAt;
  final List<String> readBy;

  const NotificationMessage({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.campaignId,
    this.eventId,
    this.createdAt,
    this.readBy = const [],
  });

  factory NotificationMessage.fromMap(String id, Map<String, dynamic> data) {
    return NotificationMessage(
      id: id,
      type: data['type'] as String? ?? '',
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      campaignId: data['campaignId'] as String? ?? '',
      eventId: data['eventId'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      readBy: List<String>.from(data['readBy'] as List? ?? []),
    );
  }

  bool isReadBy(String userId) => readBy.contains(userId);
}
