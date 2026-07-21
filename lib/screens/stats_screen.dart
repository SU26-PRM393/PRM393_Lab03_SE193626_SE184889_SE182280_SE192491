import 'dart:math' show log, ln10, pow;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:vietnam_map_flutter/firebase/analytics_service.dart';
import 'package:vietnam_map_flutter/services/pdf_export_service.dart';
import 'package:vietnam_map_flutter/firebase/remote_config_service.dart';
import 'package:vietnam_map_flutter/viewmodels/province_stats_viewmodel.dart';
import 'package:vietnam_map_flutter/l10n/app_strings.dart';
import 'package:vietnam_map_flutter/models/province.dart';

Map<String, String> _getRegionDisplayNames(BuildContext context) {
  final l10n = context.l10n;
  return {
    'red_river_delta': l10n.regionRedRiverDelta,
    'northern_midlands': l10n.regionNorthernMidlands,
    'central_coast': l10n.regionCentralCoast,
    'central_highlands': l10n.regionCentralHighlands,
    'southeast': l10n.regionSoutheast,
    'mekong_delta': l10n.regionMekongDelta,
  };
}

const _chartColors = [
  Color(0xFF378ADD),
  Color(0xFF1D9E75),
  Color(0xFFD85A30),
  Color(0xFFBA7517),
  Color(0xFF7F77DD),
  Color(0xFFD4537E),
];

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key, this.isAdmin = false});

  /// Chỉ admin mới thấy nút xuất PDF
  final bool isAdmin;

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logStatsScreenViewed();
  }

  Future<void> _exportPdf(ProvinceStatsViewModel vm) async {
    setState(() => _exporting = true);
    try {
      final url = await PdfExportService.instance.exportAndUpload(vm);
      if (!mounted) return;
      final l10n = context.l10n;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.exportPdfSuccess),
          action: SnackBarAction(
            label: l10n.openPdf,
            onPressed: () => launchUrl(
              Uri.parse(url),
              mode: LaunchMode.externalApplication,
            ),
          ),
          duration: const Duration(seconds: 6),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final errorMsg = context.l10n.exportPdfError.replaceAll('{error}', e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProvinceStatsViewModel(),
      child: _StatsBody(
        onExport: _exportPdf,
        exporting: _exporting,
        showExportButton:
            widget.isAdmin && RemoteConfigService.instance.isPdfExportEnabled,
      ),
    );
  }
}

class _StatsBody extends StatelessWidget {
  const _StatsBody({
    required this.onExport,
    required this.exporting,
    required this.showExportButton,
    this.isEmbedded = false,
    this.showUserCard = false,
    this.userCount,
    this.showMapCard = false,
  });

  final Future<void> Function(ProvinceStatsViewModel vm) onExport;
  final bool exporting;
  final bool showExportButton;
  final bool isEmbedded;
  final bool showUserCard;
  final int? userCount;
  final bool showMapCard;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProvinceStatsViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.error != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Lỗi: ${vm.error}',
                    style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
                ElevatedButton(
                    onPressed: vm.reload, child: const Text('Thử lại')),
              ],
            ),
          );
        }
        {
          final col = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildContentChildren(context, vm),
          );
          if (isEmbedded) return col;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: col,
          );
        }
      },
    );
  }

  List<Widget> _buildContentChildren(
      BuildContext context, ProvinceStatsViewModel vm) {
    return [
      if (showExportButton)
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: exporting ? null : () => onExport(vm),
            icon: exporting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.picture_as_pdf_outlined),
            label: Text(exporting ? context.l10n.exporting : context.l10n.exportPdf),
          ),
        ),
      if (showExportButton) const SizedBox(height: 16),
      _buildStatsCards(
        context,
        vm,
        showUserCard: showUserCard,
        userCount: userCount,
        showMapCard: showMapCard,
      ),
      const SizedBox(height: 28),
      _SectionTitle(context.l10n.top10Population),
      const SizedBox(height: 12),
      _TopProvincesBarChart(
        provinces: vm.top10Population,
        getValue: (p) => (p.population ?? 0).toDouble(),
        formatLabel: (v) => '${(v / 1000000).toStringAsFixed(1)}M',
        color: const Color(0xFF378ADD),
      ),
      const SizedBox(height: 28),
      _SectionTitle(context.l10n.top10Area),
      const SizedBox(height: 12),
      _TopProvincesBarChart(
        provinces: vm.top10Area,
        getValue: (p) => p.areaKm2 ?? 0,
        formatLabel: (v) => '${v.toStringAsFixed(0)} km²',
        color: const Color(0xFF1D9E75),
      ),
      const SizedBox(height: 28),
      _SectionTitle(context.l10n.top10Density),
      const SizedBox(height: 12),
      _TopProvincesBarChart(
        provinces: vm.top10Density,
        getValue: (p) => p.density ?? 0,
        formatLabel: (v) => v.toStringAsFixed(0),
        color: const Color(0xFF7F77DD),
      ),
      const SizedBox(height: 28),
      LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth > 600;
          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionTitle(context.l10n.regionDistribution),
                      const SizedBox(height: 12),
                      _RegionPieChart(regionStats: vm.regionStats),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionTitle(context.l10n.unitClassification),
                      const SizedBox(height: 12),
                      _TypePieChart(typeStats: vm.typeStats),
                    ],
                  ),
                ),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle(context.l10n.regionDistribution),
              const SizedBox(height: 12),
              _RegionPieChart(regionStats: vm.regionStats),
              const SizedBox(height: 28),
              _SectionTitle(context.l10n.unitClassification),
              const SizedBox(height: 12),
              _TypePieChart(typeStats: vm.typeStats),
            ],
          );
        },
      ),
      const SizedBox(height: 20),
    ];
  }
}

// ── Module-level helpers ──────────────────────────────────────────────────────

String _fmt(double v) {
  if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
  return v.toStringAsFixed(0);
}

Widget _buildStatsCards(
  BuildContext context,
  ProvinceStatsViewModel vm, {
  bool showUserCard = false,
  int? userCount,
  bool showMapCard = false,
}) {
  final cs = Theme.of(context).colorScheme;
  return Wrap(
    spacing: 12,
    runSpacing: 12,
    children: [
      if (showUserCard)
        _StatCard(
          icon: Icons.group_outlined,
          label: context.l10n.users,
          value: userCount == null ? '...' : '$userCount',
          color: cs.primaryContainer,
          iconColor: cs.onPrimaryContainer,
        ),
      if (showMapCard)
        _StatCard(
          icon: Icons.map_outlined,
          label: context.l10n.map,
          value: context.l10n.map == 'Map' ? 'Vietnam' : 'Việt Nam', // Quick logic for dynamic string

          color: cs.secondaryContainer,
          iconColor: cs.onSecondaryContainer,
        ),
      _StatCard(
        icon: Icons.location_city_outlined,
        label: context.l10n.provinces,
        value: vm.totalProvinces.toString(),
        color: cs.tertiaryContainer,
        iconColor: cs.onTertiaryContainer,
      ),
      _StatCard(
        icon: Icons.people_outline,
        label: context.l10n.populationMillions,
        value: (vm.totalPopulation / 1e6).toStringAsFixed(1),
        color: cs.surfaceContainerHighest,
        iconColor: cs.onSurface,
      ),
      _StatCard(
        icon: Icons.map_outlined,
        label: context.l10n.areaSqKm,
        value: _fmt(vm.totalAreaKm2),
        color: cs.primaryContainer,
        iconColor: cs.onPrimaryContainer,
      ),
      _StatCard(
        icon: Icons.people_alt_outlined,
        label: context.l10n.avgDensity,
        value: vm.avgDensity.toStringAsFixed(0),
        color: cs.secondaryContainer,
        iconColor: cs.onSecondaryContainer,
      ),
    ],
  );
}

// ── Stat card ────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 26),
          const SizedBox(height: 10),
          Text(value,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: iconColor)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(fontSize: 11, color: iconColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

// ── Section title ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

// ── Chart axis helpers ───────────────────────────────────────────────────────

/// Tính interval "đẹp" để y-axis chia đều ~5 bước, tránh label đè nhau.
double _niceInterval(double maxVal) {
  if (maxVal <= 0) return 1;
  final raw = maxVal / 5;
  final exp = (log(raw) / ln10).floor();
  final magnitude = pow(10, exp).toDouble();
  final ratio = raw / magnitude;
  if (ratio <= 2) return 2 * magnitude;
  if (ratio <= 5) return 5 * magnitude;
  return 10 * magnitude;
}

/// Làm tròn maxY lên bội số của interval để label trên cùng không bị cắt.
double _niceMax(double maxVal) {
  final interval = _niceInterval(maxVal);
  return (maxVal / interval).ceil() * interval;
}

// ── Top provinces bar chart ──────────────────────────────────────────────────

class _TopProvincesBarChart extends StatelessWidget {
  const _TopProvincesBarChart({
    required this.provinces,
    required this.getValue,
    required this.formatLabel,
    required this.color,
  });

  final List<Province> provinces;
  final double Function(Province) getValue;
  final String Function(double) formatLabel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (provinces.isEmpty) return const SizedBox.shrink();

    final maxVal = provinces.map(getValue).reduce((a, b) => a > b ? a : b);
    final chartMax = _niceMax(maxVal);
    final chartInterval = _niceInterval(maxVal);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: SizedBox(
        height: 240,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: chartMax,
            barGroups: [
              for (int i = 0; i < provinces.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: getValue(provinces[i]),
                      color: color,
                      width: 18,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                ),
            ],
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 56,
                  getTitlesWidget: (val, meta) {
                    final i = val.toInt();
                    if (i < 0 || i >= provinces.length) {
                      return const SizedBox.shrink();
                    }
                    final label =
                        provinces[i].tenShort ?? provinces[i].ten;
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Text(
                          label,
                          style: const TextStyle(fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 68,
                  interval: chartInterval,
                  getTitlesWidget: (val, meta) => SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      formatLabel(val),
                      style: const TextStyle(fontSize: 10),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
            ),
            gridData: const FlGridData(
              show: true,
              drawVerticalLine: false,
            ),
            borderData: FlBorderData(show: false),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final p = provinces[group.x];
                  return BarTooltipItem(
                    '${p.ten}\n${formatLabel(rod.toY)}',
                    const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Region pie chart ─────────────────────────────────────────────────────────

class _RegionPieChart extends StatelessWidget {
  const _RegionPieChart({required this.regionStats});
  final List<RegionStat> regionStats;

  @override
  Widget build(BuildContext context) {
    if (regionStats.isEmpty) return const SizedBox.shrink();
    final total = regionStats.fold(0, (s, r) => s + r.count);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sections: [
                  for (int i = 0; i < regionStats.length; i++)
                    PieChartSectionData(
                      value: regionStats[i].count.toDouble(),
                      color: _chartColors[i % _chartColors.length],
                      title:
                          '${(regionStats[i].count / total * 100).toStringAsFixed(0)}%',
                      radius: 65,
                      titleStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 28,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _Legend(
            items: [
              for (int i = 0; i < regionStats.length; i++)
                _LegendItem(
                  color: _chartColors[i % _chartColors.length],
                  label:
                      '${_getRegionDisplayNames(context)[regionStats[i].name] ?? regionStats[i].name} (${regionStats[i].count})',
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Type pie chart ───────────────────────────────────────────────────────────

class _TypePieChart extends StatelessWidget {
  const _TypePieChart({required this.typeStats});
  final List<TypeStat> typeStats;

  @override
  Widget build(BuildContext context) {
    if (typeStats.isEmpty) return const SizedBox.shrink();
    final total = typeStats.fold(0, (s, t) => s + t.count);

    const typeColors = [
      Color(0xFFD85A30),
      Color(0xFFBA7517),
      Color(0xFF639922),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sections: [
                  for (int i = 0; i < typeStats.length; i++)
                    PieChartSectionData(
                      value: typeStats[i].count.toDouble(),
                      color: typeColors[i % typeColors.length],
                      title:
                          '${(typeStats[i].count / total * 100).toStringAsFixed(0)}%',
                      radius: 65,
                      titleStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 28,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _Legend(
            items: [
              for (int i = 0; i < typeStats.length; i++)
                _LegendItem(
                  color: typeColors[i % typeColors.length],
                  label: '${typeStats[i].name} (${typeStats[i].count})',
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Legend ───────────────────────────────────────────────────────────────────

class _LegendItem {
  const _LegendItem({required this.color, required this.label});
  final Color color;
  final String label;
}

class _Legend extends StatelessWidget {
  const _Legend({required this.items});
  final List<_LegendItem> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: [
        for (final item in items)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 5),
              Text(item.label,
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
      ],
    );
  }
}

// ── Embeddable stats widget ───────────────────────────────────────────────────

/// Nhúng nội dung thống kê vào bên trong ScrollView cha mà không tạo scroll mới.
class StatsEmbeddedContent extends StatelessWidget {
  const StatsEmbeddedContent({
    super.key,
    this.showUserCard = false,
    this.userCount,
    this.showMapCard = false,
  });

  final bool showUserCard;
  final int? userCount;
  final bool showMapCard;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProvinceStatsViewModel(),
      child: _StatsBody(
        onExport: (_) async {},
        exporting: false,
        showExportButton: false,
        isEmbedded: true,
        showUserCard: showUserCard,
        userCount: userCount,
        showMapCard: showMapCard,
      ),
    );
  }
}
