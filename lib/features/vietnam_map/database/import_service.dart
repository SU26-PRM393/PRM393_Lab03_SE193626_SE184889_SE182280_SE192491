import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/province.dart';
import '../model/commune.dart';
import '../model/committee.dart';
import 'isar_service.dart';

class ImportService {
  static Future<void> importDataIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();

    final imported = prefs.getBool('imported') ?? false;

    if (imported) return;

    await importProvinces();
    await importCommunes();
    await importCommittees();

    await prefs.setBool('imported', true);
  }

  static Future<void> importProvinces([String? path]) async {
    final String jsonString;
    if (path != null) {
      final file = File(path);
      jsonString = await file.readAsString();
    } else {
      jsonString = await rootBundle
          .loadString('lib/features/vietnam_map/assets/data/provinces.json');
    }

    final List<dynamic> data = json.decode(jsonString);

    final items = data.map((e) {
      return Province()
        ..dataId = e['id']
        ..ma = e['ma'] ?? ''
        ..ten = e['ten'] ?? ''
        ..type = e['type']
        ..tenShort = e['ten_short']
        ..areaKm2 = (e['area_km2'] as num?)?.toDouble()
        ..population = e['population']
        ..density = (e['density'] as num?)?.toDouble()
        ..capital = e['capital']
        ..address = e['address']
        ..phone = e['phone']
        ..decree = e['decree']
        ..decreeUrl = e['decree_url']
        ..predecessors = e['predecessors']
        ..parentMa = e['parent_ma']
        ..parentTen = e['parent_ten']
        ..centroidLon = (e['centroid_lon'] as num?)?.toDouble()
        ..centroidLat = (e['centroid_lat'] as num?)?.toDouble()
        ..geomType = e['geom_type']
        ..nVertices = e['n_vertices']
        ..macroRegion = e['macro_region']
        ..embedText = e['embed_text']
        ..parentTenXa = e['parent_ten_xa']
        ..bbox = (e['bbox'] as List<dynamic>?)
            ?.map((x) => (x as num).toDouble())
            .toList()
        ..predecessorsList = (e['predecessors_list'] as List<dynamic>?)
            ?.map((x) => x.toString())
            .toList()
        ..keywords = (e['keywords'] as List<dynamic>?)
            ?.map((x) => x.toString())
            .toList();
    }).toList();

    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.provinces.putAll(items);
    });
  }

  static Future<void> importCommunes([String? path]) async {
    final String jsonString;

    if (path != null) {
      final file = File(path);
      jsonString = await file.readAsString();
    } else {
      jsonString = await rootBundle.loadString(
        'lib/features/vietnam_map/assets/data/communes.json',
      );
    }

    final List<dynamic> data = json.decode(jsonString);

    final items = data.map((e) {
      return Commune()
        ..dataId = e['id']
        ..ma = e['ma'] ?? ''
        ..ten = e['ten'] ?? ''
        ..type = e['type']
        ..tenShort = e['ten_short']
        ..areaKm2 = (e['area_km2'] as num?)?.toDouble()
        ..population = e['population']
        ..density = (e['density'] as num?)?.toDouble()
        ..capital = e['capital']
        ..decree = e['decree']
        ..decreeUrl = e['decree_url']
        ..predecessors = e['predecessors']
        ..parentMa = e['parent_ma']
        ..parentTen = e['parent_ten']
        ..centroidLon = (e['centroid_lon'] as num?)?.toDouble()
        ..centroidLat = (e['centroid_lat'] as num?)?.toDouble()
        ..geomType = e['geom_type']
        ..nVertices = e['n_vertices']
        ..macroRegion = e['macro_region']
        ..embedText = e['embed_text']
        ..parentTenXa = e['parent_ten_xa']
        ..bbox = (e['bbox'] as List<dynamic>?)
            ?.map((x) => (x as num).toDouble())
            .toList()
        ..predecessorsList = (e['predecessors_list'] as List<dynamic>?)
            ?.map((x) => x.toString())
            .toList()
        ..keywords = (e['keywords'] as List<dynamic>?)
            ?.map((x) => x.toString())
            .toList();
    }).toList();

    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.communes.putAll(items);
    });
  }

  static Future<void> importCommittees([String? path]) async {
    final String jsonString;

    if (path != null) {
      final file = File(path);
      jsonString = await file.readAsString();
    } else {
      jsonString = await rootBundle.loadString(
        'lib/features/vietnam_map/assets/data/committees.json',
      );
    }

    final List<dynamic> data = json.decode(jsonString);

    final items = data.map((e) {
      return Committee()
        ..dataId = e['id']
        ..ten = e['ten'] ?? ''
        ..type = e['type']
        ..tenShort = e['ten_short']
        ..parentMa = e['parent_ma']
        ..parentTen = e['parent_ten']
        ..centroidLon = (e['centroid_lon'] as num?)?.toDouble()
        ..centroidLat = (e['centroid_lat'] as num?)?.toDouble()
        ..geomType = e['geom_type']
        ..macroRegion = e['macro_region']
        ..embedText = e['embed_text']
        ..keywords = (e['keywords'] as List<dynamic>?)
            ?.map((x) => x.toString())
            .toList();
    }).toList();

    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.committees.putAll(items);
    });
  }
}
