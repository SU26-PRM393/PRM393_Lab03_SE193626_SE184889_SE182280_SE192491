// ignore_for_file: avoid_print

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
        ..parentMa = '001'
        ..address = '123 Test St'
        ..phone = '0987654321'
        ..nPredecessors = 5;

      await IsarService.isar.writeTxn(() async {
        await IsarService.isar.communes.put(commune);
      });

      final savedCommune = await IsarService.isar.communes
          .filter()
          .maEqualTo('00001')
          .findFirst();

      expect(savedCommune, isNotNull);
      expect(savedCommune!.ten, equals('Tràng Tiền'));
      expect(savedCommune.address, equals('123 Test St'));
      expect(savedCommune.phone, equals('0987654321'));
      expect(savedCommune.nPredecessors, equals(5));
    });

    test('Can write and read a Committee', () async {
      final committee = Committee()
        ..dataId = 'committee_1'
        ..ma = 'comm_ma_1'
        ..ten = 'Ủy ban nhân dân'
        ..address = '456 Committee Rd'
        ..phone = '0123456789'
        ..areaKm2 = 12.34
        ..population = 5678
        ..density = 459.9
        ..nPredecessors = 2;

      await IsarService.isar.writeTxn(() async {
        await IsarService.isar.committees.put(committee);
      });

      final savedCommittee = await IsarService.isar.committees
          .filter()
          .tenEqualTo('Ủy ban nhân dân')
          .findFirst();

      expect(savedCommittee, isNotNull);
      expect(savedCommittee!.ten, equals('Ủy ban nhân dân'));
      expect(savedCommittee.ma, equals('comm_ma_1'));
      expect(savedCommittee.address, equals('456 Committee Rd'));
      expect(savedCommittee.phone, equals('0123456789'));
      expect(savedCommittee.areaKm2, equals(12.34));
      expect(savedCommittee.population, equals(5678));
      expect(savedCommittee.density, equals(459.9));
      expect(savedCommittee.nPredecessors, equals(2));
    });

    test('Can fetch all provinces', () async {
      final count = await IsarService.isar.provinces.count();
      print('Total provinces in database: $count');

      final allProvinces = await IsarService.isar.provinces.where().findAll();
      for (var p in allProvinces) {
        print('Province: ${p.ten} (${p.ma})');
      }
    });
    test('Can import and verify all real Communes', () async {
      final jsonPath = 'lib/features/vietnam_map/assets/data/communes.json';

      await ImportService.importCommunes(jsonPath);

      final count = await IsarService.isar.communes.count();

      print('Total communes imported from JSON: $count');

      expect(count, greaterThan(0));

      final baDinh = await IsarService.isar.communes
          .filter()
          .tenEqualTo('Phường Ba Đình')
          .findFirst();

      expect(baDinh, isNotNull);
      print('Verified commune: ${baDinh!.ten}');
      expect(baDinh.decree, equals('Nghị quyết số 1656/NQ-UBTVQH15'));
      expect(baDinh.nPredecessors, equals(11));

      final hoangSa = await IsarService.isar.communes
          .filter()
          .maEqualTo('20333')
          .findFirst();
      expect(hoangSa, isNotNull);
      expect(hoangSa!.ten, equals('Đặc khu Hoàng Sa'));
      expect(hoangSa.parentMa, equals('48'));
      print('Verified commune: ${hoangSa.ten} (${hoangSa.ma})');

      final truongSa = await IsarService.isar.communes
          .filter()
          .maEqualTo('22736')
          .findFirst();
      expect(truongSa, isNotNull);
      expect(truongSa!.ten, equals('Đặc khu Trường Sa'));
      expect(truongSa.parentMa, equals('56'));
      print('Verified commune: ${truongSa.ten} (${truongSa.ma})');
    });
    test('Can import and verify all real Committees', () async {
      final jsonPath = 'lib/features/vietnam_map/assets/data/committees.json';

      await ImportService.importCommittees(jsonPath);

      final count = await IsarService.isar.committees.count();

      print('Total committees imported from JSON: $count');

      expect(count, greaterThan(0));

      final phuQuoc = await IsarService.isar.committees
          .filter()
          .tenEqualTo('Đặc khu Phú Quốc')
          .findFirst();

      expect(phuQuoc, isNotNull);
      print('Verified committee: ${phuQuoc!.ten}');
      expect(phuQuoc.ma, equals(''));
      expect(phuQuoc.population, equals(157629));
      expect(phuQuoc.nPredecessors, equals(1));
    });
  });
}
