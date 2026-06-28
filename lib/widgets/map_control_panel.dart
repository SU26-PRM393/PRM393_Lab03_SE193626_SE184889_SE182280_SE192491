import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;

import 'package:vietnam_map_flutter/models/administrative_area.dart';
import 'package:vietnam_map_flutter/models/lower_level_place.dart';
import 'package:vietnam_map_flutter/models/map_boundary.dart';
import 'package:vietnam_map_flutter/viewmodels/vietnam_map_controller.dart';
import 'map_segmented_control.dart';

const _provinceCityLabel = 'Tỉnh/TP';
const _districtLabel = 'Quận/Huyện';
const _areaLabel = 'Diện tích';
const _populationLabel = 'Dân số';
const _densityLabel = 'Mật độ';
const _missingValueLabel = 'Chưa có';
const _kTeal = Color(0xFF0D9488);
const _kTealLight = Color(0xFFCCFBF1);
const _kBg = Color(0xFFF8FAFB);
const _kCardBg = Colors.white;
const _kRadius = 12.0;
const _kChipRadius = 20.0;

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
    final hasSelection = controller.selectedProvince != null ||
        controller.selectedLowerLevelPlace != null;
    final details = _LocationDetailsData.fromController(controller);

    Widget header;
    if (hasSelection && details != null) {
      header = _MapStickyHeader(
        title: details.title,
        showBack: true,
        onBack: () {
          if (details.selectedPlace != null) {
            controller.clearPlaceSelection();
          } else {
            controller.clearSelection();
          }
        },
        onClose: onClose ?? () {},
      );
    } else {
      header = _MapStickyHeader(
        title: 'Khám phá Việt Nam',
        showBack: false,
        onClose: onClose ?? () {},
      );
    }

    return Semantics(
      label: 'Công cụ tỉnh, thành phố và quận huyện',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _kBg,
          border: Border(
            right: BorderSide(color: Colors.grey.shade200, width: 1.5),
          ),
        ),
        child: Column(
          children: [
            header,
            Expanded(
              child: hasSelection && details != null
                  ? _LocationDetailsView(
                      controller: controller,
                      details: details,
                    )
                  : _ExploreView(
                      controller: controller,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapStickyHeader extends StatelessWidget {
  const _MapStickyHeader({
    required this.title,
    this.showBack = false,
    this.onBack,
    required this.onClose,
  });

  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _kCardBg,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          if (showBack) ...[
            _CircleBtn(
              icon: Icons.arrow_back_rounded,
              tooltip: 'Quay lại',
              onTap: onBack ?? () {},
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _CircleBtn(
            icon: Icons.close_rounded,
            tooltip: 'Đóng',
            onTap: onClose,
          ),
        ],
      ),
    );
  }
}

class _CircleBtn extends StatefulWidget {
  const _CircleBtn({required this.icon, required this.tooltip, required this.onTap});
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  State<_CircleBtn> createState() => _CircleBtnState();
}

class _CircleBtnState extends State<_CircleBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _hovered ? _kTealLight : Colors.grey.shade100,
            ),
            child: Icon(
              widget.icon,
              size: 18,
              color: _hovered ? _kTeal : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }
}

class _ExploreView extends StatefulWidget {
  const _ExploreView({required this.controller});
  final VietnamMapController controller;

  @override
  State<_ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<_ExploreView> {
  late final TextEditingController _searchTextController;

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController(text: widget.controller.controlSpace.searchText);
  }

  @override
  void didUpdateWidget(_ExploreView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller.controlSpace.searchText != _searchTextController.text) {
      _searchTextController.text = widget.controller.controlSpace.searchText;
    }
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Không gian bản đồ với công cụ tra cứu tỉnh, thành phố và quận huyện.',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.4),
        ),
        const SizedBox(height: 16),

        // Hiển thị section
        const _SectionLabel(label: 'Hiển thị tỉnh'),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: MapSegmentedControl<bool>(
            value: controller.showProvinceLabels,
            onChanged: controller.toggleProvinceLabels,
            segments: const [
              MapSegmentedOption(
                value: true,
                icon: Icons.done_rounded,
                label: 'Hiện chi tiết',
              ),
              MapSegmentedOption(
                value: false,
                icon: Icons.visibility_off_outlined,
                label: 'Ẩn tất cả',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Search section
        const _SectionLabel(label: 'Tìm kiếm'),
        const SizedBox(height: 8),
        _MapSearchField(
          hint: 'Tìm tỉnh, thành phố, quận huyện...',
          controller: _searchTextController,
          onChanged: controller.updateSearchText,
        ),
        const SizedBox(height: 16),

        // Cấp hành chính
        const _SectionLabel(label: 'Cấp hành chính'),
        const SizedBox(height: 8),
        _SegmentedChips<AdministrativeAreaLevel>(
          options: const {
            AdministrativeAreaLevel.all: 'Tất cả',
            AdministrativeAreaLevel.province: _provinceCityLabel,
            AdministrativeAreaLevel.district: _districtLabel,
          },
          selected: controller.controlSpace.selectedLevel,
          onChanged: controller.updateSelectedLevel,
        ),
        const SizedBox(height: 16),

        // Bộ lọc
        const _SectionLabel(label: 'Bộ lọc'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: controller.controlSpace.filterChips.map((chip) {
            final active = controller.isFilterChipSelected(chip);
            return _StatusChipButton(
              label: _filterChipLabel(chip),
              selected: active,
              onTap: () => controller.toggleFilterChip(chip),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // Sắp xếp
        const _SectionLabel(label: 'Sắp xếp'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _SaaSDropdown<String>(
                value: controller.controlSpace.sortOption,
                label: 'Sắp xếp theo',
                icon: Icons.sort,
                items: const [
                  DropdownMenuItem(value: 'Name', child: Text('Tên')),
                  DropdownMenuItem(value: 'Area', child: Text(_areaLabel)),
                  DropdownMenuItem(value: 'Population', child: Text(_populationLabel)),
                  DropdownMenuItem(value: 'Density', child: Text(_densityLabel)),
                ],
                onChanged: (value) {
                  controller.updateSortOption(value ?? 'Name');
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SaaSDropdown<AdministrativeAreaSortDirection>(
                value: controller.controlSpace.sortDirection,
                label: 'Thứ tự',
                icon: Icons.swap_vert,
                items: const [
                  DropdownMenuItem(
                    value: AdministrativeAreaSortDirection.ascending,
                    child: Text('Tăng dần'),
                  ),
                  DropdownMenuItem(
                    value: AdministrativeAreaSortDirection.descending,
                    child: Text('Giảm dần'),
                  ),
                ],
                onChanged: (value) {
                  controller.updateSortDirection(
                    value ?? AdministrativeAreaSortDirection.ascending,
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Kết quả
        Row(
          children: [
            const _SectionLabel(label: 'Kết quả'),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
              child: Text(
                '${controller.filteredAdministrativeEntries.length}',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        if (_showStartupDataMessage(controller)) ...[
          _InfoBar(
            icon: Icons.info_outline,
            text: _startupDataMessage(controller),
          ),
          const SizedBox(height: 12),
        ],

        if (!controller.isBoundaryDataReady)
          const _InfoBar(
            icon: Icons.hourglass_empty,
            text: 'Đang tải dữ liệu hành chính...',
          )
        else if (controller.filteredAdministrativeEntries.isEmpty)
          const _EmptyState(
            title: 'Không tìm thấy địa điểm',
            subtitle: 'Thử thay đổi từ khóa hoặc bộ lọc của bạn.',
          )
        else
          ...controller.filteredAdministrativeEntries.map((result) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ResultCard(
                title: result.name,
                status: _administrativeTypeLabel(result.levelLabel),
                line2: result.subtitle,
                onTap: () => controller.selectAdministrativeEntry(result),
              ),
            );
          }),
      ],
    );
  }
}

class _MapSearchField extends StatefulWidget {
  const _MapSearchField({required this.hint, required this.controller, required this.onChanged});
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  State<_MapSearchField> createState() => _MapSearchFieldState();
}

class _MapSearchFieldState extends State<_MapSearchField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 20),
          suffixIcon: widget.controller.text.isEmpty ? null : IconButton(
            icon: Icon(Icons.close_rounded, size: 18, color: Colors.grey.shade400),
            onPressed: () {
              widget.controller.clear();
              widget.onChanged('');
            },
          ),
          filled: true,
          fillColor: _kCardBg,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(_kChipRadius), borderSide: BorderSide(color: Colors.grey.shade200)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(_kChipRadius), borderSide: BorderSide(color: Colors.grey.shade200)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(_kChipRadius), borderSide: const BorderSide(color: _kTeal, width: 1.5)),
        ),
      ),
    );
  }
}

class _StatusChipButton extends StatefulWidget {
  const _StatusChipButton({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_StatusChipButton> createState() => _StatusChipButtonState();
}

class _StatusChipButtonState extends State<_StatusChipButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected;
    Color bg;
    Color borderCol;
    Color textCol;

    if (active) {
      bg = _hovered ? _kTeal.withAlpha(220) : _kTeal;
      borderCol = _hovered ? _kTeal.withAlpha(220) : _kTeal;
      textCol = Colors.white;
    } else {
      bg = _hovered ? _kTealLight.withAlpha(100) : _kCardBg;
      borderCol = _hovered ? _kTeal.withAlpha(120) : Colors.grey.shade300;
      textCol = _hovered ? _kTeal : Colors.grey.shade600;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(_kChipRadius),
            border: Border.all(color: borderCol),
            boxShadow: [
              if (_hovered && !active)
                BoxShadow(color: _kTeal.withAlpha(10), blurRadius: 4, offset: const Offset(0, 1))
            ],
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: textCol,
            ),
          ),
        ),
      ),
    );
  }
}

class _SegmentedChips<T> extends StatelessWidget {
  const _SegmentedChips({
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final Map<T, String> options;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: options.entries.map((e) {
        return _StatusChipButton(
          label: e.value,
          selected: selected == e.key,
          onTap: () => onChanged(e.key),
        );
      }).toList(),
    );
  }
}

class _SaaSDropdown<T> extends StatelessWidget {
  const _SaaSDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.label,
    required this.icon,
  });
  
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(4), blurRadius: 4, offset: const Offset(0, 1)),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Colors.grey.shade600),
          hint: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87),
          isExpanded: true,
        ),
      ),
    );
  }
}

class _ResultCard extends StatefulWidget {
  const _ResultCard({
    required this.title,
    required this.status,
    required this.line2,
    required this.onTap,
  });

  final String title, status, line2;
  final VoidCallback onTap;

  @override
  State<_ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<_ResultCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _hovered ? Colors.grey.shade100 : _kCardBg,
            borderRadius: BorderRadius.circular(_kRadius),
            border: Border.all(
              color: _hovered ? _kTeal.withAlpha(100) : Colors.grey.shade200,
              width: 1,
            ),
            boxShadow: [
              if (_hovered)
                BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 12, offset: const Offset(0, 4))
              else
                BoxShadow(color: Colors.black.withAlpha(6), blurRadius: 6, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.title,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _kTealLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.status,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _kTeal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.line2,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, size: 18, color: _hovered ? _kTeal : Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBar extends StatelessWidget {
  const _InfoBar({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _kTealLight.withAlpha(50),
        borderRadius: BorderRadius.circular(_kRadius),
        border: Border.all(color: _kTealLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _kTeal, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: _kTeal, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.subtitle});
  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
          child: Icon(Icons.search_off_rounded, size: 32, color: Colors.grey.shade400),
        ),
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
      ]),
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
  const _LocationDetailsView({required this.controller, required this.details});

  final VietnamMapController controller;
  final _LocationDetailsData details;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            details.locationContext,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ),
        const SizedBox(height: 12),
        _LocationBadges(details: details),
        const SizedBox(height: 16),
        if (details.selectedProvince != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
