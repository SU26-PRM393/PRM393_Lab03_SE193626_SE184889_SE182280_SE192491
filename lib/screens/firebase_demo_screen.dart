import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:vietnam_map_flutter/firebase/remote_config_service.dart';
import 'package:vietnam_map_flutter/services/pdf_export_service.dart';
import 'package:vietnam_map_flutter/viewmodels/province_stats_viewmodel.dart';
import 'package:vietnam_map_flutter/l10n/app_strings.dart';
import 'package:vietnam_map_flutter/utils/api_endpoints.dart';

// ── Firebase Console URLs — see lib/utils/api_endpoints.dart ─────────────────
const _kFcmUrl = FirebaseConsoleUrls.fcm;
const _kRemoteConfigUrl = FirebaseConsoleUrls.remoteConfig;
const _kStorageUrl = FirebaseConsoleUrls.pdfExports;
const _kCrashlyticsUrl = FirebaseConsoleUrls.crashlyticsAndroid;

Future<void> _openUrl(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    debugPrint('Could not open $url');
  }
}

class FirebaseDemoScreen extends StatefulWidget {
  const FirebaseDemoScreen({super.key, this.isAdmin = false});

  final bool isAdmin;

  @override
  State<FirebaseDemoScreen> createState() => _FirebaseDemoScreenState();
}

class _FirebaseDemoScreenState extends State<FirebaseDemoScreen> {
  // ── Remote Config state ────────────────────────────────────────────────────
  bool _refreshing = false;

  // ── Crashlytics state ──────────────────────────────────────────────────────
  String? _crashlyticsStatus;

  // ── PDF Export state ───────────────────────────────────────────────────────
  bool _exporting = false;
  String? _lastPdfUrl;

  static bool get _isMobile =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> _refreshConfig() async {
    setState(() => _refreshing = true);
    await RemoteConfigService.instance.init();
    if (mounted) setState(() => _refreshing = false);
  }

  void _forceCrash() {
    if (!_isMobile) {
      setState(() => _crashlyticsStatus = context.l10n.crashlyticsMobileOnly);
      return;
    }
    FirebaseCrashlytics.instance.crash();
  }

  Future<void> _exportPdf(ProvinceStatsViewModel vm) async {
    setState(() => _exporting = true);
    try {
      final url = await PdfExportService.instance.exportAndUpload(vm);
      if (mounted) {
        setState(() => _lastPdfUrl = url);
        final l10n = context.l10n;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportPdfSuccess),
            action: SnackBarAction(
              label: l10n.openPdf,
              onPressed: () => launchUrl(Uri.parse(url),
                  mode: LaunchMode.externalApplication),
            ),
            duration: const Duration(seconds: 6),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final errorMsg =
            context.l10n.exportPdfError.replaceAll('{error}', e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProvinceStatsViewModel(),
      child: Consumer<ProvinceStatsViewModel>(
        builder: (context, vm, _) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _remoteConfigSection(),
              const SizedBox(height: 28),
              _crashlyticsSection(context),
              const SizedBox(height: 28),
              _fcmSection(context),
              if (widget.isAdmin &&
                  RemoteConfigService.instance.isPdfExportEnabled) ...[
                const SizedBox(height: 28),
                _pdfExportSection(context, vm),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ── Remote Config ──────────────────────────────────────────────────────────

  Widget _remoteConfigSection() {
    final rc = RemoteConfigService.instance;
    return _Section(
      icon: Icons.tune_outlined,
      title: 'Remote Config',
      subtitle:
          'Cấu hình động từ Firebase — thay đổi trên Console không cần cập nhật app',
      consoleUrl: _kRemoteConfigUrl,
      consoleTip: 'Chỉnh sửa & xem Remote Config Dashboard',
      action: _refreshing
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2))
          : IconButton(
              tooltip: 'Fetch config mới',
              icon: const Icon(Icons.refresh),
              onPressed: _refreshConfig,
            ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _ConfigCard(
            label: 'Số tỉnh hiển thị trên biểu đồ',
            key_: 'default_chart_province_count',
            value: rc.provinceCount.toString(),
            icon: Icons.bar_chart_outlined,
          ),
          _ConfigCard(
            label: 'Bật xuất PDF',
            key_: 'enable_pdf_export',
            value: rc.isPdfExportEnabled ? 'true' : 'false',
            icon: Icons.picture_as_pdf_outlined,
            valueColor: rc.isPdfExportEnabled ? Colors.green : Colors.red,
          ),
          _ConfigCard(
            label: 'Khoảng cách check-in tối đa',
            key_: 'max_checkin_distance_meters',
            value: '${rc.checkinDistanceMeters.toStringAsFixed(0)} m',
            icon: Icons.location_on_outlined,
          ),
        ],
      ),
    );
  }

  // ── Crashlytics ────────────────────────────────────────────────────────────

  Widget _crashlyticsSection(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return _Section(
      icon: Icons.bug_report_outlined,
      title: 'Crashlytics',
      subtitle: _isMobile
          ? 'Test báo cáo lỗi lên Firebase Crashlytics (chỉ Android/iOS)'
          : '${context.l10n.crashlyticsMobileOnly} — đang chạy trên desktop/web',
      consoleUrl: _kCrashlyticsUrl,
      consoleTip: 'Xem báo cáo lỗi trên Firebase Crashlytics Dashboard',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_crashlyticsStatus != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: cs.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline,
                      color: cs.primary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_crashlyticsStatus!,
                        style: const TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: _isMobile ? _forceCrash : null,
                icon: const Icon(Icons.dangerous_outlined, size: 18),
                label: const Text('Force Crash (chỉ mobile)'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Sau khi bấm, mở Firebase Console → Crashlytics để xem báo cáo.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // ── FCM ────────────────────────────────────────────────────────────────────

  Widget _fcmSection(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return _Section(
      icon: Icons.notifications_active_outlined,
      title: 'FCM — Firebase Cloud Messaging',
      subtitle:
          'Gửi thông báo push đến người dùng. Vì không thể gửi trực tiếp từ app, hãy dùng Firebase Console.',
      consoleUrl: _kFcmUrl,
      consoleTip: 'Mở Firebase Console để gửi thông báo FCM',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.tertiaryContainer.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: cs.tertiary.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline,
                    color: cs.tertiary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cách gửi thông báo FCM',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: cs.onTertiaryContainer,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '1. Nhấn nút "Mở Firebase Console" bên dưới\n'
                        '2. Chọn "Create your first campaign"\n'
                        '3. Điền tiêu đề, nội dung thông báo\n'
                        '4. Chọn target: All apps hoặc theo topic\n'
                        '5. Nhấn "Review" → "Publish"',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.7,
                          color: cs.onTertiaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () => _openUrl(_kFcmUrl),
            icon: const Icon(Icons.open_in_new, size: 16),
            label: const Text('Mở Firebase Console — Gửi thông báo'),
            style: FilledButton.styleFrom(
              backgroundColor: cs.tertiary,
              foregroundColor: cs.onTertiary,
            ),
          ),
        ],
      ),
    );
  }

  // ── PDF Export ─────────────────────────────────────────────────────────────

  Widget _pdfExportSection(BuildContext context, ProvinceStatsViewModel vm) {
    final cs = Theme.of(context).colorScheme;
    return _Section(
      icon: Icons.picture_as_pdf_outlined,
      title: 'Xuất Báo Cáo PDF',
      subtitle:
          'Tạo báo cáo thống kê tỉnh thành và lưu lên Firebase Storage',
      consoleUrl: _kStorageUrl,
      consoleTip: 'Xem các file PDF đã xuất trên Firebase Storage',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_lastPdfUrl != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cs.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: cs.secondary.withValues(alpha: 0.35)),
              ),
              child: Row(
                children: [
                  Icon(Icons.link, color: cs.secondary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _lastPdfUrl!,
                      style: const TextStyle(fontSize: 11),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () => launchUrl(
                      Uri.parse(_lastPdfUrl!),
                      mode: LaunchMode.externalApplication,
                    ),
                    child: const Text('Mở'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          FilledButton.icon(
            onPressed:
                (vm.isLoading || _exporting) ? null : () => _exportPdf(vm),
            icon: _exporting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.download_outlined),
            label: Text(_exporting
                ? 'Đang tạo PDF...'
                : vm.isLoading
                    ? 'Đang tải dữ liệu...'
                    : 'Tạo & Tải lên Storage'),
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  const _Section({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
    this.action,
    this.consoleUrl,
    this.consoleTip,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? action;
  final String? consoleUrl;
  final String? consoleTip;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──
          Row(
            children: [
              Icon(icon, color: cs.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              if (action != null) action!,
              // ── Firebase Console quick-link ──
              if (consoleUrl != null) ...[
                const SizedBox(width: 4),
                Tooltip(
                  message: consoleTip ?? 'Mở Firebase Console',
                  child: OutlinedButton.icon(
                    onPressed: () => _openUrl(consoleUrl!),
                    icon: const Icon(Icons.open_in_new, size: 14),
                    label: const Text(
                      'Firebase Console',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF8F00),
                      side: const BorderSide(color: Color(0xFFFF8F00)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle,
              style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
          const Divider(height: 20),
          child,
        ],
      ),
    );
  }
}

class _ConfigCard extends StatelessWidget {
  const _ConfigCard({
    required this.label,
    required this.key_,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  final String label;
  final String key_;
  final String value;
  final IconData icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 200,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: cs.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  key_,
                  style: TextStyle(
                      fontSize: 10,
                      color: cs.onSurfaceVariant,
                      fontFamily: 'monospace'),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: valueColor ?? cs.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
              maxLines: 2),
        ],
      ),
    );
  }
}
