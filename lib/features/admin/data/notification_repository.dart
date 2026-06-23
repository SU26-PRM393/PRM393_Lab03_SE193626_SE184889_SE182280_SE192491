import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationRepository {
  NotificationRepository._();
  static final instance = NotificationRepository._();

  final _db = FirebaseFirestore.instance;

  Future<void> publishCampaignChange({
    required String campaignId,
    required String campaignName,
    required String status,
  }) async {
    final action = switch (status) {
      'active' => 'started',
      'completed' => 'ended',
      'canceled' => 'ended',
      _ => null,
    };
    if (action == null) return;

    await _publish(
      type: 'campaign.$action',
      title: action == 'started' ? 'Chiến dịch bắt đầu' : 'Chiến dịch kết thúc',
      body: campaignName,
      campaignId: campaignId,
    );
  }

  Future<void> publishEventChange({
    required String campaignId,
    required String eventId,
    required String eventName,
    required String status,
  }) async {
    final action = switch (status) {
      'in-progress' => 'started',
      'completed' => 'ended',
      'canceled' => 'ended',
      _ => null,
    };
    if (action == null) return;

    await _publish(
      type: 'event.$action',
      title: action == 'started' ? 'Sự kiện bắt đầu' : 'Sự kiện kết thúc',
      body: eventName,
      campaignId: campaignId,
      eventId: eventId,
    );
  }

  Future<void> publishFirstInteraction({
    required String campaignId,
    required String eventId,
    required String eventName,
  }) {
    return _publish(
      type: 'event.firstInteraction',
      title: 'Sự kiện có tương tác đầu tiên',
      body: eventName,
      campaignId: campaignId,
      eventId: eventId,
    );
  }

  Future<void> _publish({
    required String type,
    required String title,
    required String body,
    required String campaignId,
    String? eventId,
  }) {
    return _db.collection('notifications').add({
      'type': type,
      'title': title,
      'body': body,
      'campaignId': campaignId,
      if (eventId != null) 'eventId': eventId,
      'createdAt': FieldValue.serverTimestamp(),
      'readBy': <String>[],
    });
  }
}
