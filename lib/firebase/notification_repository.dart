import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vietnam_map_flutter/firebase/fcm_admin_service.dart';

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

  Future<void> publishCampaignUpdated({
    required String campaignId,
    required String campaignName,
  }) {
    return _publish(
      type: 'campaign.updated',
      title: 'Chiến dịch được cập nhật',
      body: campaignName,
      campaignId: campaignId,
    );
  }

  Future<void> publishCampaignCreated({
    required String campaignId,
    required String campaignName,
  }) {
    return _publish(
      type: 'campaign.created',
      title: 'Chiến dịch mới',
      body: campaignName,
      campaignId: campaignId,
    );
  }

  Future<void> publishCampaignDeleted({
    required String campaignId,
    required String campaignName,
  }) {
    return _publish(
      type: 'campaign.deleted',
      title: 'Chiến dịch đã xóa',
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

  Future<void> publishEventCreated({
    required String campaignId,
    required String eventId,
    required String eventName,
  }) {
    return _publish(
      type: 'event.created',
      title: 'Sự kiện mới được tạo',
      body: eventName,
      campaignId: campaignId,
      eventId: eventId,
    );
  }

  Future<void> publishEventUpdated({
    required String campaignId,
    required String eventId,
    required String eventName,
  }) {
    return _publish(
      type: 'event.updated',
      title: 'Sự kiện được cập nhật',
      body: eventName,
      campaignId: campaignId,
      eventId: eventId,
    );
  }

  Future<void> publishEventDeleted({
    required String campaignId,
    required String eventId,
    required String eventName,
  }) {
    return _publish(
      type: 'event.deleted',
      title: 'Sự kiện đã bị xóa',
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
  }) async {
    // Lưu vào Firestore trước — luôn thành công dù FCM push có lỗi hay không
    await _db.collection('notifications').add({
      'type': type,
      'title': title,
      'body': body,
      'campaignId': campaignId,
      if (eventId != null) 'eventId': eventId,
      'createdAt': FieldValue.serverTimestamp(),
      'readBy': <String>[],
    });

    // Gửi FCM push đến tất cả thiết bị đã subscribe topic all_users
    await FcmAdminService.instance.sendToTopic(
      topic: 'all_users',
      title: title,
      body: body,
      data: {
        'type': type,
        'campaignId': campaignId,
        if (eventId != null) 'eventId': eventId,
      },
    );
  }

  Stream<List<Map<String, dynamic>>> watchNotifications({int limit = 50}) {
    return _db
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList());
  }

  Future<void> markAsRead(String notificationId, String userId) {
    return _db.collection('notifications').doc(notificationId).update({
      'readBy': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> markAllAsRead(List<String> ids, String userId) async {
    final batch = _db.batch();
    for (final id in ids) {
      batch.update(_db.collection('notifications').doc(id), {
        'readBy': FieldValue.arrayUnion([userId]),
      });
    }
    await batch.commit();
  }
}
