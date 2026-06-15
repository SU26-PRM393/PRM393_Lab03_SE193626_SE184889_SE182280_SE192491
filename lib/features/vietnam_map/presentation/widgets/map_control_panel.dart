import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;

import '../../domain/administrative_area.dart';
import '../../domain/lower_level_place.dart';
import '../../domain/map_boundary.dart';
import '../vietnam_map_controller.dart';

const _provinceCityLabel = 'Tỉnh/TP';
const _districtLabel = 'Quận/Huyện';
const _areaLabel = 'Diện tích';
const _populationLabel = 'Dân số';
const _densityLabel = 'Mật độ';
const _missingValueLabel = 'Chưa có';

class MapControlPanel extends StatelessWidget {
  const MapControlPanel({
    required this.controller,
    this.onClose,
    super.key,
  });

  final VietnamMapController controller;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasSelection = controller.selectedProvince != null ||
        controller.selectedLowerLevelPlace != null;

    return Semantics(
      label: 'Công cụ tỉnh, thành phố và quận huyện',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            right: BorderSide(color: colorScheme.outlineVariant),
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (hasSelection)
              _LocationDetailsView(controller: controller, onClose: onClose)
            else ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Khám phá Việt Nam',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (onClose != null)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onClose,
                      tooltip: 'Đóng bảng điều khiển',
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Không gian bản đồ với công cụ tra cứu tỉnh, thành phố và quận huyện.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              const _SectionLabel(label: 'Tìm kiếm'),
              const SizedBox(height: 8),
              TextField(
                enabled: true,
                textInputAction: TextInputAction.search,
                onChanged: controller.updateSearchText,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  labelText: 'Tìm tỉnh, thành phố, quận huyện',
                  helperText: 'Nhập tên để lọc kết quả.',
                  suffixIcon: controller.controlSpace.searchText.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          tooltip: 'Xóa tìm kiếm',
                          onPressed: () => controller.updateSearchText(''),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              const _SectionLabel(label: 'Cấp hành chính'),
              const SizedBox(height: 8),
              SegmentedButton<AdministrativeAreaLevel>(
                segments: const [
                  ButtonSegment(
                    value: AdministrativeAreaLevel.all,
                    icon: Icon(Icons.public),
                    label: Text('Tất cả'),
                  ),
                  ButtonSegment(
                    value: AdministrativeAreaLevel.province,
                    icon: Icon(Icons.map),
                    label: Text(_provinceCityLabel),
                  ),
                  ButtonSegment(
                    value: AdministrativeAreaLevel.district,
                    icon: Icon(Icons.location_city),
                    label: Text(_districtLabel),
                  ),
                ],
                selected: {controller.controlSpace.selectedLevel},
                onSelectionChanged: (selection) {
                  controller.updateSelectedLevel(selection.first);
                },
              ),
              const SizedBox(height: 20),
              const _SectionLabel(label: 'Bộ lọc'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final chip in controller.controlSpace.filterChips)
                    FilterChip(
                      label: Text(_filterChipLabel(chip)),
                      selected: controller.isFilterChipSelected(chip),
                      onSelected: (_) => controller.toggleFilterChip(chip),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              const _SectionLabel(label: 'Sắp xếp'),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: DropdownMenu<String>(
                      enabled: true,
                      initialSelection: controller.controlSpace.sortOption,
                      leadingIcon: const Icon(Icons.sort),
                      label: const Text('Sắp xếp theo'),
                      onSelected: (value) {
                        controller.updateSortOption(value ?? 'Name');
                      },
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(value: 'Name', label: 'Tên'),
                        DropdownMenuEntry(value: 'Area', label: _areaLabel),
                        DropdownMenuEntry(
                          value: 'Population',
                          label: _populationLabel,
                        ),
                        DropdownMenuEntry(
                            value: 'Density', label: _densityLabel),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownMenu<AdministrativeAreaSortDirection>(
                      enabled: true,
                      initialSelection: controller.controlSpace.sortDirection,
                      leadingIcon: const Icon(Icons.swap_vert),
                      label: const Text('Thứ tự'),
                      onSelected: (value) {
                        controller.updateSortDirection(
                          value ?? AdministrativeAreaSortDirection.ascending,
                        );
                      },
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(
                          value: AdministrativeAreaSortDirection.ascending,
                          label: 'Từ thấp đến cao',
                        ),
                        DropdownMenuEntry(
                          value: AdministrativeAreaSortDirection.descending,
                          label: 'Từ cao đến thấp',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const _SectionLabel(label: 'Kết quả'),
              const SizedBox(height: 8),
              Card(
                margin: EdgeInsets.zero,
                color: colorScheme.primaryContainer.withAlpha(89),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.sort, color: colorScheme.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Sắp xếp: ${_sortOptionLabel(controller.controlSpace.sortOption)} • ${controller.controlSpace.sortDirection.label}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_showStartupDataMessage(controller)) ...[
                const SizedBox(height: 12),
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      _startupDataMessage(controller),
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              if (!controller.isBoundaryDataReady)
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      'Đang tải dữ liệu hành chính...',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                )
              else if (controller.filteredAdministrativeEntries.isEmpty)
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      'Không có địa điểm nào khớp với tìm kiếm, cấp hành chính hoặc bộ lọc hiện tại.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 240,
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount:
                          controller.filteredAdministrativeEntries.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final result =
                            controller.filteredAdministrativeEntries[index];
                        return ListTile(
                          dense: true,
                          title: Text(result.name),
                          subtitle:
                              Text('${result.levelLabel} • ${result.subtitle}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () =>
                              controller.selectAdministrativeEntry(result),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: colorScheme.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Tìm kiếm, cấp hành chính, bộ lọc và sắp xếp đang hoạt động. Chọn một kết quả để căn giữa trên bản đồ.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

String _filterChipLabel(String chip) {
  switch (chip) {
    case 'Province':
      return _provinceCityLabel;
    case 'City':
      return 'Thành phố';
    case 'District':
      return _districtLabel;
    default:
      return chip;
  }
}

String _sortOptionLabel(String option) {
  switch (option) {
    case 'Name':
      return 'Tên';
    case 'Area':
      return _areaLabel;
    case 'Population':
      return _populationLabel;
    case 'Density':
      return _densityLabel;
    default:
      return option;
  }
}

bool _showStartupDataMessage(VietnamMapController controller) {
  return controller.importStatus != AdministrativeImportStatus.idle &&
          controller.importStatus != AdministrativeImportStatus.ready &&
          controller.importStatus != AdministrativeImportStatus.skipped ||
      controller.metricsStatus == MapLoadStatus.loading ||
      controller.lowerLevelPlacesStatus == MapLoadStatus.loading;
}

String _startupDataMessage(VietnamMapController controller) {
  switch (controller.importStatus) {
    case AdministrativeImportStatus.checking:
      return 'Äang kiá»ƒm tra dá»¯ liá»‡u hÃ nh chÃ­nh trong ná»n...';
    case AdministrativeImportStatus.importingProvinces:
      return 'Äang náº¡p dá»¯ liá»‡u tá»‰nh/thÃ nh trong ná»n...';
    case AdministrativeImportStatus.importingCommunes:
      return 'Äang náº¡p dá»¯ liá»‡u xÃ£/phÆ°á»ng trong ná»n...';
    case AdministrativeImportStatus.importingCommittees:
      return 'Äang náº¡p dá»¯ liá»‡u á»§y ban trong ná»n...';
    case AdministrativeImportStatus.unavailable:
      return 'Dá»¯ liá»‡u chi tiáº¿t táº¡m thá»i khÃ´ng kháº£ dá»¥ng.';
    case AdministrativeImportStatus.idle:
    case AdministrativeImportStatus.ready:
    case AdministrativeImportStatus.skipped:
      break;
  }

  if (controller.metricsStatus == MapLoadStatus.loading) {
    return 'Äang cáº­p nháº­t sá»‘ liá»‡u diá»‡n tÃ­ch vÃ  dÃ¢n sá»‘ trong ná»n...';
  }
  if (controller.lowerLevelPlacesStatus == MapLoadStatus.loading) {
    return 'Äang náº¡p thÃªm Ä‘iá»ƒm xÃ£/phÆ°á»ng trong ná»n...';
  }

  return 'Äang náº¡p dá»¯ liá»‡u hÃ nh chÃ­nh trong ná»n...';
}

String _administrativeTypeLabel(String value) {
  switch (value.toLowerCase()) {
    case 'province':
      return _provinceCityLabel;
    case 'city':
      return 'Thành phố';
    case 'district':
      return _districtLabel;
    default:
      return value;
  }
}

class _LocationDetailsView extends StatelessWidget {
  const _LocationDetailsView({required this.controller, this.onClose});

  final VietnamMapController controller;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final details = _LocationDetailsData.fromController(controller);
    if (details == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LocationHeader(
          controller: controller,
          details: details,
          onClose: onClose,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            details.locationContext,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ),
        const SizedBox(height: 16),
        if (details.selectedProvince != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _CommuneVisibilityToggle(controller: controller),
          ),
          const SizedBox(height: 16),
        ],
        if (controller.isLoadingDetails)
          const _LocationDetailsLoading()
        else
          _LocationLoadedDetails(
            controller: controller,
            details: details,
          ),
      ],
    );
  }
}

class _LocationDetailsData {
  const _LocationDetailsData({
    required this.title,
    required this.typeLabel,
    required this.locationContext,
    required this.selectedProvince,
    required this.selectedPlace,
    required this.area,
    required this.population,
    required this.density,
    required this.capital,
    required this.decree,
    required this.decreeUrl,
    required this.predecessors,
    required this.address,
    required this.phone,
    required this.lowerLevelPlaces,
    this.macroRegion,
  });

  factory _LocationDetailsData.forPlace(
    VietnamMapController controller,
    ProvinceBoundary? selectedProvince,
    LowerLevelPlace selectedPlace,
  ) {
    final details = controller.selectedCommuneDetails;
    return _LocationDetailsData(
      title: selectedPlace.name,
      typeLabel: selectedPlace.level == 'ward' ? 'Phường' : 'Xã/Thị trấn',
      locationContext:
          '${selectedPlace.parentName}, ${selectedProvince?.name ?? ''}',
      selectedProvince: selectedProvince,
      selectedPlace: selectedPlace,
      area: details?.areaKm2,
      population: details?.population,
      density: details?.density,
      capital: details?.capital,
      decree: details?.decree,
      decreeUrl: details?.decreeUrl,
      predecessors: details?.predecessors,
      address: null,
      phone: null,
      lowerLevelPlaces: controller.selectedLowerLevelPlaces,
    );
  }

  factory _LocationDetailsData.forProvince(
    VietnamMapController controller,
    ProvinceBoundary selectedProvince,
  ) {
    final details = controller.selectedProvinceDetails;
    return _LocationDetailsData(
      title: selectedProvince.name,
      typeLabel: _administrativeTypeLabel(selectedProvince.level),
      locationContext: 'Việt Nam',
      selectedProvince: selectedProvince,
      selectedPlace: null,
      area: details?.areaKm2,
      population: details?.population,
      density: details?.density,
      capital: details?.capital,
      decree: details?.decree,
      decreeUrl: details?.decreeUrl,
      predecessors: details?.predecessors,
      address: details?.address,
      phone: details?.phone,
      lowerLevelPlaces: controller.selectedLowerLevelPlaces,
      macroRegion: details?.macroRegion,
    );
  }

  static _LocationDetailsData? fromController(
    VietnamMapController controller,
  ) {
    final selectedProvince = controller.selectedProvince;
    final selectedPlace = controller.selectedLowerLevelPlace;

    if (selectedPlace != null) {
      return _LocationDetailsData.forPlace(
        controller,
        selectedProvince,
        selectedPlace,
      );
    }

    if (selectedProvince != null) {
      return _LocationDetailsData.forProvince(controller, selectedProvince);
    }

    return null;
  }

  bool get showsCommuneList =>
      selectedPlace == null && lowerLevelPlaces.isNotEmpty;

  final String title;
  final String typeLabel;
  final String locationContext;
  final ProvinceBoundary? selectedProvince;
  final LowerLevelPlace? selectedPlace;
  final double? area;
  final int? population;
  final double? density;
  final String? capital;
  final String? decree;
  final String? decreeUrl;
  final String? predecessors;
  final String? address;
  final String? phone;
  final List<LowerLevelPlace> lowerLevelPlaces;
  final String? macroRegion;
}

class _LocationHeader extends StatelessWidget {
  const _LocationHeader({
    required this.controller,
    required this.details,
    this.onClose,
  });

  final VietnamMapController controller;
  final _LocationDetailsData details;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: details.selectedPlace != null
              ? 'Quay lại tỉnh/thành'
              : 'Quay lại tìm kiếm và bộ lọc',
          onPressed: _handleBack,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                details.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              _LocationBadges(details: details),
            ],
          ),
        ),
        if (onClose != null)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
            tooltip: 'Đóng bảng điều khiển',
          ),
      ],
    );
  }

  void _handleBack() {
    if (details.selectedPlace != null) {
      controller.clearPlaceSelection();
      return;
    }
    controller.clearSelection();
  }
}

class _LocationBadges extends StatelessWidget {
  const _LocationBadges({required this.details});

  final _LocationDetailsData details;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        _LocationBadge(
          color: Theme.of(context).colorScheme.primaryContainer,
          textColor: Theme.of(context).colorScheme.onPrimaryContainer,
          label: details.typeLabel.toUpperCase(),
        ),
        if (details.macroRegion != null)
          _LocationBadge(
            color: Theme.of(context).colorScheme.secondaryContainer,
            textColor: Theme.of(context).colorScheme.onSecondaryContainer,
            label: details.macroRegion!.replaceAll('_', ' ').toUpperCase(),
          ),
      ],
    );
  }
}

class _LocationBadge extends StatelessWidget {
  const _LocationBadge({
    required this.color,
    required this.textColor,
    required this.label,
  });

  final Color color;
  final Color textColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 9,
            ),
      ),
    );
  }
}

class _LocationDetailsLoading extends StatelessWidget {
  const _LocationDetailsLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(strokeWidth: 3),
            SizedBox(height: 12),
            Text('Đang tải chi tiết từ cơ sở dữ liệu...'),
          ],
        ),
      ),
    );
  }
}

class _LocationLoadedDetails extends StatelessWidget {
  const _LocationLoadedDetails({
    required this.controller,
    required this.details,
  });

  final VietnamMapController controller;
  final _LocationDetailsData details;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _LocationStatsRow(details: details),
        const SizedBox(height: 20),
        if (details.capital != null && details.capital!.isNotEmpty)
          _InfoRow(
            icon: Icons.location_city_outlined,
            label: details.selectedPlace != null ? 'Trụ sở' : 'Thủ phủ',
            value: details.capital!,
          ),
        if (details.address != null && details.address!.isNotEmpty)
          _InfoRow(
            icon: Icons.home_outlined,
            label: 'Địa chỉ',
            value: details.address!,
          ),
        if (details.phone != null && details.phone!.isNotEmpty)
          _InfoRow(
            icon: Icons.phone_outlined,
            label: 'Điện thoại',
            value: details.phone!,
          ),
        if (details.decree != null && details.decree!.isNotEmpty)
          _DecreeInfoSection(decree: details.decree!, url: details.decreeUrl),
        if (details.predecessors != null && details.predecessors!.isNotEmpty)
          _PredecessorsInfoSection(predecessors: details.predecessors!),
        if (details.showsCommuneList)
          _CommuneListSection(
            places: details.lowerLevelPlaces,
            onPlaceSelected: controller.selectLowerLevelPlace,
          ),
        const SizedBox(height: 24),
        _CenterLocationButton(
          controller: controller,
          details: details,
        ),
      ],
    );
  }
}

class _LocationStatsRow extends StatelessWidget {
  const _LocationStatsRow({required this.details});

  final _LocationDetailsData details;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.square_foot_outlined,
              label: _areaLabel,
              value: details.area != null
                  ? '${_formatDouble(details.area)} km²'
                  : _missingValueLabel,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StatCard(
              icon: Icons.people_outline,
              label: _populationLabel,
              value: details.population != null
                  ? _formatNumber(details.population)
                  : _missingValueLabel,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StatCard(
              icon: Icons.density_medium_outlined,
              label: _densityLabel,
              value: details.density != null
                  ? '${_formatDouble(details.density)}/km²'
                  : _missingValueLabel,
            ),
          ),
        ],
      ),
    );
  }
}

class _DecreeInfoSection extends StatelessWidget {
  const _DecreeInfoSection({
    required this.decree,
    required this.url,
  });

  final String decree;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final decreeUrl = url;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        _InfoSection(
          title: 'Nghị quyết / Cơ sở pháp lý',
          icon: Icons.gavel_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                decree,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (decreeUrl != null && decreeUrl.isNotEmpty) ...[
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  icon: const Icon(Icons.copy_all, size: 16),
                  label: const Text('Sao chép liên kết nguồn'),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: decreeUrl));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Đã sao chép liên kết nghị quyết vào bảng tạm!',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PredecessorsInfoSection extends StatelessWidget {
  const _PredecessorsInfoSection({required this.predecessors});

  final String predecessors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        _InfoSection(
          title: 'Lịch sử hình thành',
          icon: Icons.history_outlined,
          child: Text(
            predecessors,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
        ),
      ],
    );
  }
}

class _CenterLocationButton extends StatelessWidget {
  const _CenterLocationButton({
    required this.controller,
    required this.details,
  });

  final VietnamMapController controller;
  final _LocationDetailsData details;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.center_focus_strong_outlined),
        label: const Text('Căn giữa vị trí trên bản đồ'),
        onPressed: _centerLocation,
      ),
    );
  }

  void _centerLocation() {
    final selectedPlace = details.selectedPlace;
    if (selectedPlace != null) {
      controller.selectLowerLevelPlace(selectedPlace);
      return;
    }

    final selectedProvince = details.selectedProvince;
    if (selectedProvince != null) {
      controller.selectProvinceAt(selectedProvince.labelCoordinate);
    }
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: colorScheme.surfaceContainerHighest.withAlpha(128),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: colorScheme.outlineVariant.withAlpha(128),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, size: 18, color: colorScheme.primary),
            const SizedBox(height: 6),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      color: colorScheme.surfaceContainerHighest.withAlpha(64),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: colorScheme.outlineVariant.withAlpha(64),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _CommuneListSection extends StatefulWidget {
  const _CommuneListSection({
    required this.places,
    required this.onPlaceSelected,
  });

  final List<LowerLevelPlace> places;
  final ValueChanged<LowerLevelPlace> onPlaceSelected;

  @override
  State<_CommuneListSection> createState() => _CommuneListSectionState();
}

class _CommuneListSectionState extends State<_CommuneListSection> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final filteredPlaces = widget.places.where((place) {
      if (_searchQuery.isEmpty) return true;
      final nameLower = place.name.toLowerCase();
      final queryLower = _searchQuery.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.list_alt_outlined, size: 16, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'Xã/Phường (${widget.places.length})',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, size: 18),
            hintText: 'Tìm xã/phường...',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
          ),
          onChanged: (val) {
            setState(() {
              _searchQuery = val;
            });
          },
        ),
        const SizedBox(height: 8),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border:
                Border.all(color: colorScheme.outlineVariant.withAlpha(128)),
            borderRadius: BorderRadius.circular(8),
            color: colorScheme.surfaceContainerHighest.withAlpha(64),
          ),
          child: filteredPlaces.isEmpty
              ? const Center(
                  child: Text('Không có xã/phường nào khớp với tìm kiếm.'),
                )
              : ListView.builder(
                  itemCount: filteredPlaces.length,
                  itemExtent: 44,
                  itemBuilder: (context, index) {
                    final place = filteredPlaces[index];
                    final levelName =
                        place.level == 'ward' ? 'Phường' : 'Xã/Thị trấn';
                    return ListTile(
                      dense: true,
                      title: Text(
                        place.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer.withAlpha(128),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          levelName,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                            fontSize: 9,
                          ),
                        ),
                      ),
                      onTap: () => widget.onPlaceSelected(place),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

String _formatNumber(int? value) {
  if (value == null) return _missingValueLabel;
  return value.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
}

String _formatDouble(double? value, {int decimalPlaces = 1}) {
  if (value == null) return _missingValueLabel;
  return value.toStringAsFixed(decimalPlaces);
}

class _CommuneVisibilityToggle extends StatelessWidget {
  const _CommuneVisibilityToggle({required this.controller});

  final VietnamMapController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasChosenCommune = controller.selectedLowerLevelPlace != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.layers_outlined, size: 16, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'Lớp hiển thị bản đồ',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<CommuneVisibilityMode>(
            style: const ButtonStyle(
              visualDensity: VisualDensity.compact,
            ),
            segments: [
              const ButtonSegment<CommuneVisibilityMode>(
                value: CommuneVisibilityMode.details,
                icon: Icon(Icons.grid_view_outlined, size: 16),
                label: Text('Hiện chi tiết', style: TextStyle(fontSize: 11)),
                tooltip:
                    'Hiển thị tất cả xã/phường trên bản đồ với nhãn khi đủ mức thu phóng',
              ),
              ButtonSegment<CommuneVisibilityMode>(
                value: CommuneVisibilityMode.dots,
                icon: Icon(
                  hasChosenCommune
                      ? Icons.gps_fixed_outlined
                      : Icons.blur_on_outlined,
                  size: 16,
                ),
                label: const Text('Hiện chấm', style: TextStyle(fontSize: 11)),
                tooltip: hasChosenCommune
                    ? 'Hiển thị chi tiết xã/phường đã chọn, các xã/phường khác dưới dạng chấm'
                    : 'Hiển thị tất cả xã/phường dưới dạng chấm và ẩn nhãn',
              ),
              const ButtonSegment<CommuneVisibilityMode>(
                value: CommuneVisibilityMode.hide,
                icon: Icon(Icons.visibility_off_outlined, size: 16),
                label: Text('Ẩn tất cả', style: TextStyle(fontSize: 11)),
                tooltip: 'Ẩn tất cả xã/phường trên bản đồ',
              ),
            ],
            selected: {controller.communeVisibilityMode},
            onSelectionChanged: (Set<CommuneVisibilityMode> newSelection) {
              controller.setCommuneVisibilityMode(newSelection.first);
            },
          ),
        ),
      ],
    );
  }
}
