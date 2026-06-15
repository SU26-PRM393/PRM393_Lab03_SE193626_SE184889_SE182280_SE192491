import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/campaign.dart';
import '../domain/event.dart';
import '../domain/school.dart';

class CampaignRepository {
  CampaignRepository._();
  static final instance = CampaignRepository._();

  final _db = FirebaseFirestore.instance;

  Future<List<Campaign>> getAllCampaigns() async {
    final snapshot = await _db.collection('campaigns').get();
    return snapshot.docs
        .map((doc) => Campaign.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<List<Event>> getEventsForCampaign(String campaignId) async {
    final snapshot = await _db
        .collection('events')
        .where('campaignId', isEqualTo: campaignId)
        .get();
    return snapshot.docs
        .map((doc) => Event.fromMap(doc.id, doc.data()))
        .toList();
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

  Future<Map<String, Map<String, String>>> getUserDetailsByIds(List<String> userIds) async {
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
}
