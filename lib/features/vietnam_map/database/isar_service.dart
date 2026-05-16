import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../model/province.dart';
import '../model/commune.dart';
import '../model/committee.dart';

class IsarService {
  static late Isar isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open(
      [
        ProvinceSchema,
        CommuneSchema,
        CommitteeSchema,
      ],
      directory: dir.path,
    );
  }
}
