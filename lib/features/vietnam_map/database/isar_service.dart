import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../model/province.dart';
import '../model/commune.dart';
import '../model/committee.dart';
import '../../../shared/performance/map_startup_trace.dart';

class IsarService {
  static Isar? _isar;
  static Future<void>? _initFuture;

  static Isar get isar {
    final instance = _isar;
    if (instance == null) {
      throw StateError('IsarService.init must complete before database use.');
    }
    return instance;
  }

  static set isar(Isar value) {
    _isar = value;
  }

  static bool get isInitialized => _isar != null;

  static Future<void> init() async {
    if (_isar != null) {
      return;
    }

    return _initFuture ??= MapStartupTrace.timeAsync('isar.init', () async {
      try {
        final dir = await MapStartupTrace.timeAsync(
          'isar.documentsDirectory',
          getApplicationDocumentsDirectory,
        );

        _isar = await MapStartupTrace.timeAsync(
          'isar.open',
          () => Isar.open(
            [
              ProvinceSchema,
              CommuneSchema,
              CommitteeSchema,
            ],
            directory: dir.path,
          ),
        );
      } catch (_) {
        _initFuture = null;
        rethrow;
      }
    });
  }
}
