import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/database/isar_service.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/model/province.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/model/commune.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/model/committee.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/database/import_service.dart';
import 'dart:io';

void main() {
  setUpAll(() async {
    // Initialize Isar for testing
    await Isar.initializeIsarCore(download: true);

    final tempDir = Directory.systemTemp.createTempSync('isar_test');

    IsarService.isar = await Isar.open(
      [
        ProvinceSchema,
        CommuneSchema,
        CommitteeSchema,
      ],
      directory: tempDir.path,
    );
  });

  tearDownAll(() async {
    await IsarService.isar.close();
  });

  group('Isar Data Consistency Tests', () {
    test('Can import and verify all real Provinces', () async {
      // Use the absolute path or relative path to the json file for the test
      final jsonPath = 'lib/features/vietnam_map/assets/data/provinces.json';

      await ImportService.importProvinces(jsonPath);

      final count = await IsarService.isar.provinces.count();
      print('Total provinces imported from JSON: $count');

      expect(count, greaterThan(0));

      final hanoi = await IsarService.isar.provinces
          .filter()
          .tenEqualTo('Thủ đô Hà Nội')
          .findFirst();

      if (hanoi != null) {
        print('Verified: ${hanoi.ten} exists in database.');
      }
    });

    test('Can write and read a Province', () async {
      final province = Province()
        ..dataId = 'test_unique_1'
        ..ma = '99'
        ..ten = 'Test Province'
        ..capital = 'Test Capital';

      await IsarService.isar.writeTxn(() async {
        await IsarService.isar.provinces.put(province);
      });

      final savedProvince =
          await IsarService.isar.provinces.filter().maEqualTo('99').findFirst();

      expect(savedProvince, isNotNull);
      expect(savedProvince!.ten, equals('Test Province'));
    });

    test('Can write and read a Commune', () async {
      final commune = Commune()
        ..dataId = 'commune_1'
        ..ma = '00001'
        ..ten = 'Tràng Tiền'
        ..parentMa = '001';

      await IsarService.isar.writeTxn(() async {
        await IsarService.isar.communes.put(commune);
      });

      final savedCommune = await IsarService.isar.communes
          .filter()
          .maEqualTo('00001')
          .findFirst();

      expect(savedCommune, isNotNull);
      expect(savedCommune!.ten, equals('Tràng Tiền'));
    });

    test('Can write and read a Committee', () async {
      final committee = Committee()
        ..dataId = 'committee_1'
        ..ten = 'Ủy ban nhân dân';

      await IsarService.isar.writeTxn(() async {
        await IsarService.isar.committees.put(committee);
      });

      final savedCommittee = await IsarService.isar.committees
          .filter()
          .tenEqualTo('Ủy ban nhân dân')
          .findFirst();

      expect(savedCommittee, isNotNull);
      expect(savedCommittee!.ten, equals('Ủy ban nhân dân'));
    });

    test('Can fetch all provinces', () async {
      final count = await IsarService.isar.provinces.count();
      print('Total provinces in database: $count');

      final allProvinces = await IsarService.isar.provinces.where().findAll();
      for (var p in allProvinces) {
        print('Province: ${p.ten} (${p.ma})');
      }
    });
  });
}
