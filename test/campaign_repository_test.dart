import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vietnam_map_flutter/features/admin/data/campaign_repository.dart';
import 'package:vietnam_map_flutter/features/admin/domain/campaign.dart';
import 'package:vietnam_map_flutter/features/admin/domain/event.dart';
import 'package:vietnam_map_flutter/features/admin/domain/school.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late CampaignRepository repository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    repository = CampaignRepository.forTesting(fakeFirestore);
  });

  group('CampaignRepository', () {
    test('getAllCampaigns returns list of campaigns from firestore', () async {
      final campaignData = {
        'name': 'Campaign 1',
        'description': 'Desc 1',
        'startDate': Timestamp.fromDate(DateTime(2026, 6, 1)),
        'endDate': Timestamp.fromDate(DateTime(2026, 6, 30)),
        'status': 'active',
      };
      await fakeFirestore.collection('campaigns').doc('camp-1').set(campaignData);

      final result = await repository.getAllCampaigns();
      expect(result.length, 1);
      expect(result[0].id, 'camp-1');
      expect(result[0].name, 'Campaign 1');
      expect(result[0].description, 'Desc 1');
      expect(result[0].status, 'active');
    });

    test('getEventsForCampaign returns events filtered by campaignId', () async {
      await fakeFirestore.collection('events').doc('event-1').set({
        'campaignId': 'camp-1',
        'name': 'Event 1',
        'schoolIds': ['s1'],
        'assignedUserIds': ['u1'],
      });
      await fakeFirestore.collection('events').doc('event-2').set({
        'campaignId': 'camp-2',
        'name': 'Event 2',
        'schoolIds': ['s2'],
        'assignedUserIds': ['u2'],
      });

      final result = await repository.getEventsForCampaign('camp-1');
      expect(result.length, 1);
      expect(result[0].id, 'event-1');
      expect(result[0].name, 'Event 1');
    });

    test('getSchoolsByIds handles empty input and chunks queries properly', () async {
      // Empty input
      final emptyResult = await repository.getSchoolsByIds([]);
      expect(emptyResult, isEmpty);

      // Add 12 schools (so it chunks into 10 + 2 queries)
      final schoolIds = <String>[];
      for (var i = 1; i <= 12; i++) {
        final id = 'school-$i';
        schoolIds.add(id);
        await fakeFirestore.collection('schools').doc(id).set({
          'name': 'School $i',
          'province': 'Province $i',
          'district': 'District $i',
          'commune': 'Commune $i',
          'address': 'Address $i',
          'latitude': 10.0 + i,
          'longitude': 106.0 + i,
          'type': 'THPT',
        });
      }

      final result = await repository.getSchoolsByIds(schoolIds);
      expect(result.length, 12);
      expect(result.map((s) => s.id).toList(), containsAll(schoolIds));
    });

    test('getUserNamesByIds handles empty and chunks queries', () async {
      final emptyResult = await repository.getUserNamesByIds([]);
      expect(emptyResult, isEmpty);

      final userIds = <String>[];
      for (var i = 1; i <= 12; i++) {
        final id = 'user-$i';
        userIds.add(id);
        await fakeFirestore.collection('users').doc(id).set({
          'name': 'User $i',
        });
      }

      final result = await repository.getUserNamesByIds(userIds);
      expect(result.length, 12);
      expect(result['user-1'], 'User 1');
      expect(result['user-12'], 'User 12');
    });

    test('getUserDetailsByIds handles empty and chunks queries', () async {
      final emptyResult = await repository.getUserDetailsByIds([]);
      expect(emptyResult, isEmpty);

      final userIds = <String>[];
      for (var i = 1; i <= 12; i++) {
        final id = 'user-$i';
        userIds.add(id);
        await fakeFirestore.collection('users').doc(id).set({
          'name': 'User $i',
          'email': 'user$i@test.com',
        });
      }

      final result = await repository.getUserDetailsByIds(userIds);
      expect(result.length, 12);
      expect(result['user-1']?['name'], 'User 1');
      expect(result['user-1']?['email'], 'user1@test.com');
    });
  });
}
