import 'dart:convert';
import 'dart:typed_data';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/data/firestore_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreRepository repository;

  setUp(() async {
    fakeFirestore = FakeFirebaseFirestore();
    repository = FirestoreRepository.forTesting(fakeFirestore);

    // Evict cache
    rootBundle.evict('lib/features/vietnam_map/assets/data/provinces.json');
    rootBundle.evict('lib/features/vietnam_map/assets/data/communes.json');

    // Mock asset bundle responses
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets',
      (ByteData? message) async {
        if (message == null) return null;
        final key = utf8.decode(message.buffer.asUint8List());
        if (key.contains('provinces.json')) {
          return ByteData.view(
            Uint8List.fromList(utf8.encode(
              '[{"ma": "01", "ten": "Hà Nội", "dien_tich": 3358.6, "dan_so": 8053663, "mat_do": 2398.0}]'
            )).buffer,
          );
        } else if (key.contains('communes.json')) {
          return ByteData.view(
            Uint8List.fromList(utf8.encode(
              '[{"ma": "00001", "ten": "Phường Phan Chu Trinh", "dien_tich": 1.2, "dan_so": 15000, "mat_do": 12500.0}]'
            )).buffer,
          );
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets',
      null,
    );
  });

  group('FirestoreRepository', () {
    test('getAllProvinces loads, caches, and returns provinces', () async {
      final firstLoad = await repository.getAllProvinces();
      expect(firstLoad.length, 1);
      expect(firstLoad[0].ma, '01');
      expect(firstLoad[0].ten, 'Hà Nội');

      // Change mock asset data to verify cache is hit next time
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        (ByteData? message) async {
          return ByteData.view(Uint8List.fromList(utf8.encode('[]')).buffer);
        },
      );

      final secondLoad = await repository.getAllProvinces();
      expect(secondLoad.length, 1); // should still be 1 due to cache
      expect(secondLoad[0].ma, '01');
    });

    test('getAllCommunes loads, caches, and returns communes', () async {
      final firstLoad = await repository.getAllCommunes();
      expect(firstLoad.length, 1);
      expect(firstLoad[0].ma, '00001');
      expect(firstLoad[0].ten, 'Phường Phan Chu Trinh');

      // Change mock asset data to verify cache is hit next time
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        (ByteData? message) async {
          return ByteData.view(Uint8List.fromList(utf8.encode('[]')).buffer);
        },
      );

      final secondLoad = await repository.getAllCommunes();
      expect(secondLoad.length, 1); // should still be 1 due to cache
      expect(secondLoad[0].ma, '00001');
    });

    test('getProvinceByMa returns correct province or null', () async {
      final province = await repository.getProvinceByMa('01');
      expect(province, isNotNull);
      expect(province!.ten, 'Hà Nội');

      final nonExistent = await repository.getProvinceByMa('99');
      expect(nonExistent, isNull);
    });

    test('getCommuneByMa returns correct commune or null', () async {
      final commune = await repository.getCommuneByMa('00001');
      expect(commune, isNotNull);
      expect(commune!.ten, 'Phường Phan Chu Trinh');

      final nonExistent = await repository.getCommuneByMa('99999');
      expect(nonExistent, isNull);
    });

    test('getAllProvinces returns empty list and handles exceptions', () async {
      rootBundle.evict('lib/features/vietnam_map/assets/data/provinces.json');
      // Mock loader to return null (failure to load)
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        (ByteData? message) async {
          return null;
        },
      );

      final errorRepo = FirestoreRepository.forTesting(fakeFirestore);
      final result = await errorRepo.getAllProvinces();
      expect(result, isEmpty);
    });

    test('getAllCommunes returns empty list and handles exceptions', () async {
      rootBundle.evict('lib/features/vietnam_map/assets/data/communes.json');
      // Mock loader to return null (failure to load)
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        (ByteData? message) async {
          return null;
        },
      );

      final errorRepo = FirestoreRepository.forTesting(fakeFirestore);
      final result = await errorRepo.getAllCommunes();
      expect(result, isEmpty);
    });
  });
}
