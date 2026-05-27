import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/performance/map_startup_trace.dart';
import '../model/province.dart';
import '../model/commune.dart';
import '../model/committee.dart';
import 'isar_service.dart';

const int _defaultImportChunkSize = 250;

enum AdministrativeDataImportPhase {
  checking,
  provinces,
  communes,
  committees,
  ready,
  skipped,
}

typedef AdministrativeDataImportProgress = void Function(
  AdministrativeDataImportPhase phase,
);

class AdministrativeDataImportPlan {
  const AdministrativeDataImportPlan({
    required this.importProvinces,
    required this.importCommunes,
    required this.importCommittees,
  });

  final bool importProvinces;
  final bool importCommunes;
  final bool importCommittees;

  bool get shouldImport =>
      importProvinces || importCommunes || importCommittees;
}

class AdministrativeDataImportSummary {
  const AdministrativeDataImportSummary({
    required this.plan,
    required this.wasSkipped,
  });

  final AdministrativeDataImportPlan plan;
  final bool wasSkipped;
}

class ImportService {
  static AdministrativeDataImportPlan buildImportPlan({
    required bool imported,
    required int provincesCount,
    required int communesCount,
    required int committeesCount,
  }) {
    if (imported &&
        provincesCount > 0 &&
        communesCount > 0 &&
        committeesCount > 0) {
      return const AdministrativeDataImportPlan(
        importProvinces: false,
        importCommunes: false,
        importCommittees: false,
      );
    }

    return AdministrativeDataImportPlan(
      importProvinces: provincesCount == 0,
      importCommunes: communesCount == 0,
      importCommittees: committeesCount == 0,
    );
  }

  static Future<AdministrativeDataImportSummary> importDataIfNeeded({
    AdministrativeDataImportProgress? onProgress,
  }) async {
    onProgress?.call(AdministrativeDataImportPhase.checking);
    final prefs = await MapStartupTrace.timeAsync(
      'import.sharedPreferences',
      SharedPreferences.getInstance,
    );

    final imported = prefs.getBool('imported') ?? false;
    final counts = await MapStartupTrace.timeAsync(
      'import.existingCounts',
      () => Future.wait<int>([
        IsarService.isar.provinces.count(),
        IsarService.isar.communes.count(),
        IsarService.isar.committees.count(),
      ]),
    );

    final plan = buildImportPlan(
      imported: imported,
      provincesCount: counts[0],
      communesCount: counts[1],
      committeesCount: counts[2],
    );

    if (!plan.shouldImport) {
      if (!imported) {
        await prefs.setBool('imported', true);
      }
      onProgress?.call(AdministrativeDataImportPhase.skipped);
      return AdministrativeDataImportSummary(plan: plan, wasSkipped: true);
    }

    if (plan.importProvinces) {
      onProgress?.call(AdministrativeDataImportPhase.provinces);
      await MapStartupTrace.timeAsync(
        'import.provinces.total',
        () => importProvinces(),
      );
    }
    if (plan.importCommunes) {
      onProgress?.call(AdministrativeDataImportPhase.communes);
      await MapStartupTrace.timeAsync(
        'import.communes.total',
        () => importCommunes(),
      );
    }
    if (plan.importCommittees) {
      onProgress?.call(AdministrativeDataImportPhase.committees);
      await MapStartupTrace.timeAsync(
        'import.committees.total',
        () => importCommittees(),
      );
    }

    await prefs.setBool('imported', true);
    onProgress?.call(AdministrativeDataImportPhase.ready);
    return AdministrativeDataImportSummary(plan: plan, wasSkipped: false);
  }

  static Future<void> importProvinces([
    String? path,
    int chunkSize = _defaultImportChunkSize,
  ]) async {
    final data = await _loadJsonObjects(
      path: path,
      assetPath: 'lib/features/vietnam_map/assets/data/provinces.json',
      traceName: 'import.provinces',
    );
    final items = data.map(_provinceFromJson).toList(growable: false);
    await _writeProvinceChunks(items, chunkSize);
  }

  static Future<void> importCommunes([
    String? path,
    int chunkSize = _defaultImportChunkSize,
  ]) async {
    final data = await _loadJsonObjects(
      path: path,
      assetPath: 'lib/features/vietnam_map/assets/data/communes.json',
      traceName: 'import.communes',
    );
    final items = data.map(_communeFromJson).toList(growable: false);
    await _writeCommuneChunks(items, chunkSize);
  }

  static Future<void> importCommittees([
    String? path,
    int chunkSize = _defaultImportChunkSize,
  ]) async {
    final data = await _loadJsonObjects(
      path: path,
      assetPath: 'lib/features/vietnam_map/assets/data/committees.json',
      traceName: 'import.committees',
    );
    final items = data.map(_committeeFromJson).toList(growable: false);
    await _writeCommitteeChunks(items, chunkSize);
  }
}

Future<List<Map<String, dynamic>>> _loadJsonObjects({
  required String? path,
  required String assetPath,
  required String traceName,
}) async {
  final jsonString = await MapStartupTrace.timeAsync(
    '$traceName.read',
    () async {
      if (path != null) {
        return File(path).readAsString();
      }

      return rootBundle.loadString(assetPath);
    },
  );

  return MapStartupTrace.timeAsync(
    '$traceName.decode',
    () => compute(_decodeJsonObjectList, jsonString),
    arguments: {'bytes': jsonString.length},
  );
}

List<Map<String, dynamic>> _decodeJsonObjectList(String raw) {
  final decoded = json.decode(raw) as List<dynamic>;
  return [
    for (final item in decoded) Map<String, dynamic>.from(item as Map),
  ];
}

Province _provinceFromJson(Map<String, dynamic> e) {
  return Province()
    ..dataId = _stringOrEmpty(e['id'])
    ..ma = _stringOrEmpty(e['ma'])
    ..ten = _stringOrEmpty(e['ten'])
    ..type = _stringOrNull(e['type'])
    ..tenShort = _stringOrNull(e['ten_short'])
    ..areaKm2 = _doubleOrNull(e['area_km2'])
    ..population = _intOrNull(e['population'])
    ..density = _doubleOrNull(e['density'])
    ..capital = _stringOrNull(e['capital'])
    ..address = _stringOrNull(e['address'])
    ..phone = _stringOrNull(e['phone'])
    ..decree = _stringOrNull(e['decree'])
    ..decreeUrl = _stringOrNull(e['decree_url'])
    ..predecessors = _stringOrNull(e['predecessors'])
    ..parentMa = _stringOrNull(e['parent_ma'])
    ..parentTen = _stringOrNull(e['parent_ten'])
    ..centroidLon = _doubleOrNull(e['centroid_lon'])
    ..centroidLat = _doubleOrNull(e['centroid_lat'])
    ..geomType = _stringOrNull(e['geom_type'])
    ..nVertices = _intOrNull(e['n_vertices'])
    ..macroRegion = _stringOrNull(e['macro_region'])
    ..embedText = _stringOrNull(e['embed_text'])
    ..parentTenXa = _stringOrNull(e['parent_ten_xa'])
    ..bbox = _doubleListOrNull(e['bbox'])
    ..predecessorsList = _stringListOrNull(e['predecessors_list'])
    ..keywords = _stringListOrNull(e['keywords']);
}

Commune _communeFromJson(Map<String, dynamic> e) {
  return Commune()
    ..dataId = _stringOrEmpty(e['id'])
    ..ma = _stringOrEmpty(e['ma'])
    ..ten = _stringOrEmpty(e['ten'])
    ..type = _stringOrNull(e['type'])
    ..tenShort = _stringOrNull(e['ten_short'])
    ..areaKm2 = _doubleOrNull(e['area_km2'])
    ..population = _intOrNull(e['population'])
    ..density = _doubleOrNull(e['density'])
    ..capital = _stringOrNull(e['capital'])
    ..address = _stringOrNull(e['address'])
    ..phone = _stringOrNull(e['phone'])
    ..decree = _stringOrNull(e['decree'])
    ..decreeUrl = _stringOrNull(e['decree_url'])
    ..predecessors = _stringOrNull(e['predecessors'])
    ..nPredecessors = _intOrNull(e['n_predecessors'])
    ..parentMa = _stringOrNull(e['parent_ma'])
    ..parentTen = _stringOrNull(e['parent_ten'])
    ..centroidLon = _doubleOrNull(e['centroid_lon'])
    ..centroidLat = _doubleOrNull(e['centroid_lat'])
    ..geomType = _stringOrNull(e['geom_type'])
    ..nVertices = _intOrNull(e['n_vertices'])
    ..macroRegion = _stringOrNull(e['macro_region'])
    ..embedText = _stringOrNull(e['embed_text'])
    ..parentTenXa = _stringOrNull(e['parent_ten_xa'])
    ..bbox = _doubleListOrNull(e['bbox'])
    ..predecessorsList = _stringListOrNull(e['predecessors_list'])
    ..keywords = _stringListOrNull(e['keywords']);
}

Committee _committeeFromJson(Map<String, dynamic> e) {
  return Committee()
    ..dataId = _stringOrEmpty(e['id'])
    ..ma = _stringOrEmpty(e['ma'])
    ..ten = _stringOrEmpty(e['ten'])
    ..type = _stringOrNull(e['type'])
    ..tenShort = _stringOrNull(e['ten_short'])
    ..areaKm2 = _doubleOrNull(e['area_km2'])
    ..population = _intOrNull(e['population'])
    ..density = _doubleOrNull(e['density'])
    ..capital = _stringOrNull(e['capital'])
    ..address = _stringOrNull(e['address'])
    ..phone = _stringOrNull(e['phone'])
    ..decree = _stringOrNull(e['decree'])
    ..decreeUrl = _stringOrNull(e['decree_url'])
    ..predecessors = _stringOrNull(e['predecessors'])
    ..nPredecessors = _intOrNull(e['n_predecessors'])
    ..parentMa = _stringOrNull(e['parent_ma'])
    ..parentTen = _stringOrNull(e['parent_ten'])
    ..centroidLon = _doubleOrNull(e['centroid_lon'])
    ..centroidLat = _doubleOrNull(e['centroid_lat'])
    ..geomType = _stringOrNull(e['geom_type'])
    ..nVertices = _intOrNull(e['n_vertices'])
    ..macroRegion = _stringOrNull(e['macro_region'])
    ..predecessorsList = _stringListOrNull(e['predecessors_list'])
    ..bbox = _doubleListOrNull(e['bbox'])
    ..keywords = _stringListOrNull(e['keywords'])
    ..embedText = _stringOrNull(e['embed_text'])
    ..parentTenXa = _stringOrNull(e['parent_ten_xa']);
}

Future<void> _writeProvinceChunks(List<Province> items, int chunkSize) async {
  for (var index = 0; index < items.length; index += chunkSize) {
    final end = (index + chunkSize).clamp(0, items.length);
    final chunk = items.sublist(index, end);
    await MapStartupTrace.timeAsync(
      'import.provinces.writeChunk',
      () => IsarService.isar.writeTxn(() async {
        await IsarService.isar.provinces.putAll(chunk);
      }),
      arguments: {'count': chunk.length, 'start': index},
    );
    await Future<void>.delayed(Duration.zero);
  }
}

Future<void> _writeCommuneChunks(List<Commune> items, int chunkSize) async {
  for (var index = 0; index < items.length; index += chunkSize) {
    final end = (index + chunkSize).clamp(0, items.length);
    final chunk = items.sublist(index, end);
    await MapStartupTrace.timeAsync(
      'import.communes.writeChunk',
      () => IsarService.isar.writeTxn(() async {
        await IsarService.isar.communes.putAll(chunk);
      }),
      arguments: {'count': chunk.length, 'start': index},
    );
    await Future<void>.delayed(Duration.zero);
  }
}

Future<void> _writeCommitteeChunks(List<Committee> items, int chunkSize) async {
  for (var index = 0; index < items.length; index += chunkSize) {
    final end = (index + chunkSize).clamp(0, items.length);
    final chunk = items.sublist(index, end);
    await MapStartupTrace.timeAsync(
      'import.committees.writeChunk',
      () => IsarService.isar.writeTxn(() async {
        await IsarService.isar.committees.putAll(chunk);
      }),
      arguments: {'count': chunk.length, 'start': index},
    );
    await Future<void>.delayed(Duration.zero);
  }
}

String _stringOrEmpty(Object? value) => value?.toString() ?? '';

String? _stringOrNull(Object? value) => value?.toString();

int? _intOrNull(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return null;
}

double? _doubleOrNull(Object? value) {
  if (value is num) {
    return value.toDouble();
  }
  return null;
}

List<double>? _doubleListOrNull(Object? value) {
  if (value is! List) {
    return null;
  }

  return [
    for (final item in value)
      if (item is num) item.toDouble(),
  ];
}

List<String>? _stringListOrNull(Object? value) {
  if (value is! List) {
    return null;
  }

  return [for (final item in value) item.toString()];
}
