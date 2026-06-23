import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/campaign.dart';
import '../domain/event.dart';
import '../domain/event_interaction.dart';
import '../domain/school.dart';
import '../domain/interaction.dart';
import 'notification_repository.dart';

class CampaignRepository {
  CampaignRepository._();
  static final instance = CampaignRepository._();

  final _db = FirebaseFirestore.instance;

  Future<List<Campaign>> getAllCampaigns() async {
    final snapshot = await _db
        .collection('campaigns')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => Campaign.fromMap(doc.id, doc.data()))
        .toList();
  }

  Stream<List<Campaign>> watchCampaigns() {
    return _db
        .collection('campaigns')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Campaign.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<String> saveCampaign(Campaign campaign) async {
    final data = campaign.toMap();
    final docRef = campaign.id.isEmpty
        ? _db.collection('campaigns').doc()
        : _db.collection('campaigns').doc(campaign.id);

    final before = campaign.id.isEmpty ? null : await docRef.get();
    final previousStatus = before?.data()?['status'] as String?;

    await docRef.set({
      ...data,
      if (campaign.id.isEmpty) 'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (previousStatus != campaign.status) {
      await NotificationRepository.instance.publishCampaignChange(
        campaignId: docRef.id,
        campaignName: campaign.name,
        status: campaign.status,
      );
    }
    return docRef.id;
  }

  Future<void> deleteCampaign(String campaignId) async {
    final events = await getEventsForCampaign(campaignId);
    final batch = _db.batch();
    for (final event in events) {
      batch.delete(_db.collection('events').doc(event.id));
    }
    batch.delete(_db.collection('campaigns').doc(campaignId));
    await batch.commit();
  }

  Future<List<Event>> getEventsForCampaign(String campaignId) async {
    final snapshot = await _db
        .collection('events')
        .where('campaignId', isEqualTo: campaignId)
        .get();
    final events =
        snapshot.docs.map((doc) => Event.fromMap(doc.id, doc.data())).toList();
    events.sort((a, b) {
      final left = a.date ?? DateTime.fromMillisecondsSinceEpoch(0);
      final right = b.date ?? DateTime.fromMillisecondsSinceEpoch(0);
      return left.compareTo(right);
    });
    return events;
  }

  Stream<List<Event>> watchEventsForCampaign(String campaignId) {
    return _db
        .collection('events')
        .where('campaignId', isEqualTo: campaignId)
        .snapshots()
        .map((snapshot) {
      final events = snapshot.docs
          .map((doc) => Event.fromMap(doc.id, doc.data()))
          .toList();
      events.sort((a, b) {
        final left = a.date ?? DateTime.fromMillisecondsSinceEpoch(0);
        final right = b.date ?? DateTime.fromMillisecondsSinceEpoch(0);
        return left.compareTo(right);
      });
      return events;
    });
  }

  Future<String> saveEvent(Event event) async {
    final data = event.toMap();
    final docRef = event.id.isEmpty
        ? _db.collection('events').doc()
        : _db.collection('events').doc(event.id);

    final before = event.id.isEmpty ? null : await docRef.get();
    final previousStatus = before?.data()?['status'] as String?;

    await docRef.set({
      ...data,
      if (event.id.isEmpty) 'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (previousStatus != event.status) {
      await NotificationRepository.instance.publishEventChange(
        campaignId: event.campaignId,
        eventId: docRef.id,
        eventName: event.name,
        status: event.status,
      );
    }
    return docRef.id;
  }

  Future<void> deleteEvent(String eventId) {
    return _db.collection('events').doc(eventId).delete();
  }

  Future<void> assignEmployeesToEvent(
    String eventId,
    List<String> employeeIds,
  ) {
    return _db.collection('events').doc(eventId).update({
      'assignedEmployeeIds': employeeIds,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> createInteraction(Event event, EventInteraction interaction) {
    return _db.runTransaction((transaction) async {
      final eventRef = _db.collection('events').doc(event.id);
      final eventSnapshot = await transaction.get(eventRef);
      final currentTotal =
          eventSnapshot.data()?['totalInteractions'] as int? ?? 0;
      final interactionRef = _db.collection('interactions').doc();

      transaction.set(interactionRef, {
        ...interaction.toMap(),
        'targetId': interactionRef.id,
        'createdAt': FieldValue.serverTimestamp(),
        'timestamp': FieldValue.serverTimestamp(),
      });
      transaction.update(eventRef, {
        'totalInteractions': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (currentTotal == 0) {
        final notificationRef = _db.collection('notifications').doc();
        transaction.set(notificationRef, {
          'type': 'event.firstInteraction',
          'title': 'Sự kiện có tương tác đầu tiên',
          'body': event.name,
          'campaignId': event.campaignId,
          'eventId': event.id,
          'createdAt': FieldValue.serverTimestamp(),
          'readBy': <String>[],
        });
      }
    });
  }

  Stream<List<EventInteraction>> watchInteractionsForEvent(String eventId) {
    return _db
        .collection('interactions')
        .where('eventId', isEqualTo: eventId)
        .snapshots()
        .map((snapshot) {
      final interactions = snapshot.docs
          .map((doc) => EventInteraction.fromMap(doc.id, doc.data()))
          .toList();
      interactions.sort((a, b) {
        final left = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final right = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return right.compareTo(left);
      });
      return interactions;
    });
  }

  Future<List<School>> getAllSchools() async {
    final snapshot =
        await _db.collection('schools').orderBy('schoolName').limit(500).get();
    return snapshot.docs
        .map((doc) => School.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<List<Map<String, String>>> getEmployees() async {
    final snapshot = await _db.collection('users').orderBy('name').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'name': data['name'] as String? ?? 'Unknown',
        'email': data['email'] as String? ?? '',
        'role': data['role'] as String? ?? 'user',
      };
    }).toList();
  }

  Future<List<School>> getSchoolsByIds(List<String> schoolIds) async {
    if (schoolIds.isEmpty) return [];

    // Firestore 'in' query supports up to 10 items.
    // If an event has more than 10 schools, we need to chunk it.
    final List<School> schools = [];
    final chunkSize = 10;

    for (var i = 0; i < schoolIds.length; i += chunkSize) {
      final chunk = schoolIds.sublist(
        i,
        i + chunkSize > schoolIds.length ? schoolIds.length : i + chunkSize,
      );

      final snapshot = await _db
          .collection('schools')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      schools.addAll(
        snapshot.docs.map((doc) => School.fromMap(doc.id, doc.data())),
      );
    }

    return schools;
  }

  Future<Map<String, String>> getUserNamesByIds(List<String> userIds) async {
    if (userIds.isEmpty) return {};

    final Map<String, String> names = {};
    final chunkSize = 10;

    for (var i = 0; i < userIds.length; i += chunkSize) {
      final chunk = userIds.sublist(
        i,
        i + chunkSize > userIds.length ? userIds.length : i + chunkSize,
      );

      final snapshot = await _db
          .collection('users')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        names[doc.id] = data['name'] as String? ?? 'Unknown';
      }
    }

    return names;
  }

  Future<Map<String, Map<String, String>>> getUserDetailsByIds(
      List<String> userIds) async {
    if (userIds.isEmpty) return {};

    final Map<String, Map<String, String>> details = {};
    final chunkSize = 10;

    for (var i = 0; i < userIds.length; i += chunkSize) {
      final chunk = userIds.sublist(
        i,
        i + chunkSize > userIds.length ? userIds.length : i + chunkSize,
      );

      final snapshot = await _db
          .collection('users')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        details[doc.id] = {
          'name': data['name'] as String? ?? 'Unknown',
          'email': data['email'] as String? ?? '',
        };
      }
    }

    return details;
  }

  Future<List<Interaction>> getInteractionsForEvent(String eventId) async {
    final snapshot = await _db
        .collection('interactions')
        .where('eventId', isEqualTo: eventId)
        .get();
    return snapshot.docs
        .map((doc) => Interaction.fromMap(doc.id, doc.data()))
        .toList();
  }

  Stream<List<Interaction>> getInteractionsStreamForEvent(String eventId) {
    return _db
        .collection('interactions')
        .where('eventId', isEqualTo: eventId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Interaction.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<Map<String, String>> getTargetNames(List<Map<String, String>> targetRefs) async {
    if (targetRefs.isEmpty) return {};

    final Map<String, String> names = {};
    
    // Group by targetType
    final Map<String, List<String>> grouped = {};
    for (var ref in targetRefs) {
      final type = ref['type'];
      final id = ref['id'];
      if (type != null && id != null) {
        grouped.putIfAbsent(type, () => []).add(id);
      }
    }

    // For each type, fetch in chunks of 10
    for (var entry in grouped.entries) {
      final collectionName = switch (entry.key) {
        'student' => 'students',
        'person' => 'persons',
        'relative' => 'relatives',
        _ => null,
      };
      if (collectionName == null) continue;

      final ids = entry.value;
      const chunkSize = 10;
      for (var i = 0; i < ids.length; i += chunkSize) {
        final chunk = ids.sublist(
          i,
          i + chunkSize > ids.length ? ids.length : i + chunkSize,
        );
        final snapshot = await _db
            .collection(collectionName)
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        for (var doc in snapshot.docs) {
          names[doc.id] = doc.data()['name'] as String? ?? 'Unknown';
        }
      }
    }

    return names;
  }
}
