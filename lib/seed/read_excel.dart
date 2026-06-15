import 'dart:io';
import 'package:excel/excel.dart';

void main() {
  var file = "d:/Semesters/Summer2026/PRM393/Project/VietNam-Map-Flutter/Truong_THPT_2026_import_ready.xlsx";
  var bytes = File(file).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  for (var table in excel.tables.keys) {
    print("Table: $table");
    print("Max Columns: ${excel.tables[table]?.maxColumns}");
    print("Max Rows: ${excel.tables[table]?.maxRows}");
    
    int rowCount = 0;
    for (var row in excel.tables[table]!.rows) {
      if (rowCount < 5) {
        print(row.map((e) => e?.value).toList());
      }
      rowCount++;
    }
  }
}
