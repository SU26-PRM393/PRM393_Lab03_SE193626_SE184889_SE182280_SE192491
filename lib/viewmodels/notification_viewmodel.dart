import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:vietnam_map_flutter/firebase/notification_repository.dart';
import 'package:vietnam_map_flutter/models/notification_message.dart';

class NotificationViewModel extends ChangeNotifier {
  NotificationViewModel(this._userId) {
    _sub = NotificationRepository.instance
        .watchNotifications()
        .listen((raw) {
      _notifications = raw
          .map((m) => NotificationMessage.fromMap(m['id'] as String, m))
          .toList();
      notifyListeners();
    });
  }

  final String _userId;
  String get userId => _userId;
  StreamSubscription<List<Map<String, dynamic>>>? _sub;

  List<NotificationMessage> _notifications = [];
  List<NotificationMessage> get notifications => _notifications;

  int get unreadCount =>
      _notifications.where((n) => !n.isReadBy(_userId)).length;

  Future<void> markAsRead(String notificationId) {
    return NotificationRepository.instance.markAsRead(notificationId, _userId);
  }

  Future<void> markAllAsRead() {
    final unread = _notifications
        .where((n) => !n.isReadBy(_userId))
        .map((n) => n.id)
        .toList();
    if (unread.isEmpty) return Future.value();
    return NotificationRepository.instance.markAllAsRead(unread, _userId);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
