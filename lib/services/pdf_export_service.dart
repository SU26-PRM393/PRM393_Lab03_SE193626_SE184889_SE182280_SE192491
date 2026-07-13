import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:vietnam_map_flutter/viewmodels/province_stats_viewmodel.dart';

const _kProvinceHeaderLabel = 'Tỉnh/Thành';

/// Tạo báo cáo PDF từ dữ liệu thống kê và upload lên Firebase Storage.
/// Trả về download URL để người dùng tải về hoặc chia sẻ.
class PdfExportService {
  PdfExportService._();
  static final instance = PdfExportService._();

  /// Tạo PDF + upload Storage → trả về download URL.
  /// Ném exception nếu upload thất bại.
  Future<String> exportAndUpload(ProvinceStatsViewModel vm) async {
    final pdfBytes = await _buildPdf(vm);
    final url = await _uploadToStorage(pdfBytes);
    return url;
  }

  // ── PDF generation ─────────────────────────────────────────────────────────

  Future<Uint8List> _buildPdf(ProvinceStatsViewModel vm) async {
    // Load font hỗ trợ tiếng Việt đầy đủ — Noto Sans từ Google Fonts
    final fontRegular = await PdfGoogleFonts.notoSansRegular();
    final fontBold = await PdfGoogleFonts.notoSansBold();

    final doc = pw.Document(
      theme: pw.ThemeData.withFont(base: fontRegular, bold: fontBold),
    );
    final now = DateTime.now();
    final dateStr =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (_) => _buildHeader(dateStr),
        footer: (ctx) => _buildFooter(ctx),
        build: (ctx) => [
          _sectionTitle('Tổng Quan'),
          pw.SizedBox(height: 8),
          _summaryTable(vm),
          pw.SizedBox(height: 20),
          _sectionTitle('Top ${vm.top10Population.length} Tỉnh/Thành Theo Dân Số'),
          pw.SizedBox(height: 8),
          _provincesTable(
            headers: ['#', _kProvinceHeaderLabel, 'Dân số'],
            rows: vm.top10Population.asMap().entries.map((e) => [
              '${e.key + 1}',
              e.value.ten,
              '${((e.value.population ?? 0) / 1e6).toStringAsFixed(2)}M',
            ]).toList(),
          ),
          pw.SizedBox(height: 20),
          _sectionTitle('Top ${vm.top10Area.length} Tỉnh/Thành Theo Diện Tích'),
          pw.SizedBox(height: 8),
          _provincesTable(
            headers: ['#', _kProvinceHeaderLabel, 'Diện tích (km²)'],
            rows: vm.top10Area.asMap().entries.map((e) => [
              '${e.key + 1}',
              e.value.ten,
              e.value.areaKm2?.toStringAsFixed(0) ?? '-',
            ]).toList(),
          ),
          pw.SizedBox(height: 20),
          _sectionTitle('Top ${vm.top10Density.length} Tỉnh/Thành Theo Mật Độ Dân Số'),
          pw.SizedBox(height: 8),
          _provincesTable(
            headers: ['#', _kProvinceHeaderLabel, 'Mật độ (ng/km²)'],
            rows: vm.top10Density.asMap().entries.map((e) => [
              '${e.key + 1}',
              e.value.ten,
              e.value.density?.toStringAsFixed(0) ?? '-',
            ]).toList(),
          ),
          pw.SizedBox(height: 20),
          _sectionTitle('Phân Bố Vùng Miền'),
          pw.SizedBox(height: 8),
          _provincesTable(
            headers: ['Vùng miền', 'Số tỉnh/thành'],
            rows: vm.regionStats
                .map((r) => [r.name, r.count.toString()])
                .toList(),
          ),
          pw.SizedBox(height: 20),
          _sectionTitle('Phân Loại Đơn Vị Hành Chính'),
          pw.SizedBox(height: 8),
          _provincesTable(
            headers: ['Loại', 'Số lượng'],
            rows: vm.typeStats
                .map((t) => [t.name, t.count.toString()])
                .toList(),
          ),
        ],
      ),
    );

    return doc.save();
  }

  pw.Widget _buildHeader(String dateStr) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'BÁO CÁO THỐNG KÊ TỈNH THÀNH VIỆT NAM',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromHex('1B6B5A'),
              ),
            ),
            pw.Text(dateStr,
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
          ],
        ),
        pw.Divider(color: PdfColor.fromHex('1B6B5A'), thickness: 1.5),
        pw.SizedBox(height: 8),
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context ctx) {
    return pw.Column(
      children: [
        pw.Divider(color: PdfColors.grey400),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('VietNam Map Flutter',
                style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
            pw.Text('Trang ${ctx.pageNumber}/${ctx.pagesCount}',
                style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
          ],
        ),
      ],
    );
  }

  pw.Widget _sectionTitle(String title) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('E8F5F1'),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 11,
          fontWeight: pw.FontWeight.bold,
          color: PdfColor.fromHex('1B6B5A'),
        ),
      ),
    );
  }

  pw.Widget _summaryTable(ProvinceStatsViewModel vm) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColor.fromHex('1B6B5A')),
          children: ['Chỉ số', 'Giá trị'].map((h) => pw.Padding(
            padding: const pw.EdgeInsets.all(6),
            child: pw.Text(h,
                style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white)),
          )).toList(),
        ),
        _summaryRow('Tổng số tỉnh/thành', '${vm.totalProvinces}'),
        _summaryRow('Tổng dân số',
            '${(vm.totalPopulation / 1e6).toStringAsFixed(1)} triệu người'),
        _summaryRow('Tổng diện tích',
            '${(vm.totalAreaKm2 / 1000).toStringAsFixed(1)}K km²'),
        _summaryRow('Mật độ trung bình',
            '${vm.avgDensity.toStringAsFixed(0)} người/km²'),
      ],
    );
  }

  pw.TableRow _summaryRow(String label, String value) {
    return pw.TableRow(children: [
      pw.Padding(
        padding: const pw.EdgeInsets.all(6),
        child: pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(6),
        child: pw.Text(value,
            style: pw.TextStyle(
                fontSize: 10, fontWeight: pw.FontWeight.bold)),
      ),
    ]);
  }

  pw.Widget _provincesTable({
    required List<String> headers,
    required List<List<String>> rows,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColor.fromHex('2E7D6B')),
          children: headers.map((h) => pw.Padding(
            padding: const pw.EdgeInsets.all(5),
            child: pw.Text(h,
                style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white)),
          )).toList(),
        ),
        ...rows.asMap().entries.map((entry) => pw.TableRow(
          decoration: pw.BoxDecoration(
            color: entry.key.isEven ? PdfColors.white : PdfColor.fromHex('F5FAF8'),
          ),
          children: entry.value.map((cell) => pw.Padding(
            padding: const pw.EdgeInsets.all(5),
            child: pw.Text(cell, style: const pw.TextStyle(fontSize: 9)),
          )).toList(),
        )),
      ],
    );
  }

  // ── Firebase Storage upload ────────────────────────────────────────────────

  Future<String> _uploadToStorage(Uint8List pdfBytes) async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final path = 'pdf_exports/$uid/${timestamp}_stats.pdf';

    final ref = FirebaseStorage.instance.ref(path);
    final task = await ref.putData(
      pdfBytes,
      SettableMetadata(contentType: 'application/pdf'),
    );

    final url = await task.ref.getDownloadURL();
    debugPrint('[PdfExport] uploaded → $url');
    return url;
  }
}
