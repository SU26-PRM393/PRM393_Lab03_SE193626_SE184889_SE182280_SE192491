import 'package:flutter/material.dart';

import 'package:vietnam_map_flutter/models/campaign.dart';
import 'package:vietnam_map_flutter/models/event.dart';
import 'package:vietnam_map_flutter/models/interaction.dart';
import 'package:vietnam_map_flutter/viewmodels/vietnam_map_controller.dart';
import 'map_segmented_control.dart';

// ── Brand palette ──────────────────────────────────────────────────────
const _kTeal = Color(0xFF0D9488);
const _kTealLight = Color(0xFFCCFBF1);
const _kBg = Color(0xFFF8FAFB);
const _kCardBg = Colors.white;
const _kRadius = 12.0;
const _kChipRadius = 20.0;
const _kStatusInProgress = 'in-progress';
const _kStatusCompleted = 'completed';
const _kStatusCanceled = 'canceled';
const _kStatusDoneLabel = 'Hoàn thành';
const _kStatusCanceledLabel = 'Đã hủy';
const _kAllFilterLabel = 'Tất cả';

Color _statusColor(String s) => switch (s) {
      'active' || _kStatusInProgress => const Color(0xFF16A34A),
      _kStatusCompleted => const Color(0xFF2563EB),
      _kStatusCanceled => const Color(0xFF6B7280),
      'preparing' => const Color(0xFFF97316),
      _ => const Color(0xFF6B7280),
    };

String _statusLabel(String s) => switch (s) {
      'active' => 'Hoạt động',
      _kStatusInProgress => 'Đang diễn ra',
      _kStatusCompleted => _kStatusDoneLabel,
      _kStatusCanceled => _kStatusCanceledLabel,
      'preparing' => 'Chuẩn bị',
      _ => s,
    };

String _employeeSubtitle(String email, String id) {
  if (email.isNotEmpty) {
    return email;
  }

  final shortId = id.length > 8 ? id.substring(0, 8) : id;
  return 'ID: $shortId...';
}

// ══════════════════════════════════════════════════════════════════════
// Root panel
// ══════════════════════════════════════════════════════════════════════

class CampaignControlPanel extends StatelessWidget {
  const CampaignControlPanel({
    super.key,
    required this.controller,
    required this.onClose,
  });

  final VietnamMapController controller;
  final VoidCallback onClose;

  String get _title {
    if (controller.selectedEvent != null) {
      return 'Chi tiết sự kiện';
    }
    if (controller.selectedCampaign != null) {
      return 'Sự kiện';
    }
    return 'Chiến dịch';
  }

  int get _count => controller.selectedCampaign != null
      ? controller.selectedCampaignEvents.length
      : controller.campaigns.length;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _kBg,
        border:
            Border(right: BorderSide(color: Colors.grey.shade200, width: 1.5)),
      ),
      child: Column(children: [
        _StickyHeader(
          title: _title,
          count: controller.selectedEvent == null ? _count : null,
          showBack: controller.selectedCampaign != null,
          onBack: () {
            if (controller.selectedEvent != null) {
              controller.selectCampaign(controller.selectedCampaign!);
            } else {
              controller.deselectCampaign();
            }
          },
          onClose: onClose,
        ),
        Expanded(
          child: controller.isLoadingCampaigns || controller.isLoadingEvents
              ? _buildSkeleton()
              : _buildBody(),
        ),
      ]),
    );
  }

  Widget _buildBody() {
    if (controller.selectedEvent != null) {
      return _EventDetailView(
          event: controller.selectedEvent!, controller: controller);
    }
    if (controller.selectedCampaign != null) {
      return _EventListView(
        campaign: controller.selectedCampaign!,
        events: controller.selectedCampaignEvents,
        controller: controller,
        onEventSelected: controller.selectEvent,

      );
    }
    return _CampaignListView(
        campaigns: controller.campaigns,
        onCampaignSelected: controller.selectCampaign);
  }

  Widget _buildSkeleton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
          children: List.generate(
              4,
              (_) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      height: 88,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(_kRadius),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withAlpha(8), blurRadius: 8)
                          ]),
                      child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                  ))),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// Sticky Header
// ══════════════════════════════════════════════════════════════════════

class _StickyHeader extends StatelessWidget {
  const _StickyHeader(
      {required this.title,
      this.count,
      required this.showBack,
      required this.onBack,
      required this.onClose});
  final String title;
  final int? count;
  final bool showBack;
  final VoidCallback onBack;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
          color: _kCardBg,
          border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
      child: Row(children: [
        if (showBack) ...[
          _CircleBtn(
              icon: Icons.arrow_back_rounded,
              tooltip: 'Quay lại',
              onTap: onBack),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Row(children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3)),
            if (count != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: _kTealLight,
                    borderRadius: BorderRadius.circular(10)),
                child: Text('$count',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _kTeal)),
              ),
            ],
          ]),
        ),
        _CircleBtn(icon: Icons.close_rounded, tooltip: 'Đóng', onTap: onClose),
      ]),
    );
  }
}

class _CircleBtn extends StatefulWidget {
  const _CircleBtn(
      {required this.icon, required this.tooltip, required this.onTap});
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
            child: Icon(widget.icon,
                size: 18, color: _hovered ? _kTeal : Colors.grey.shade700),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// Search field
// ══════════════════════════════════════════════════════════════════════

class _SearchField extends StatelessWidget {
  const _SearchField(
      {required this.hint, required this.value, required this.onChanged});
  final String hint;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon:
              Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 20),
          suffixIcon: value.isEmpty
              ? null
              : IconButton(
                  icon: Icon(Icons.close_rounded,
                      size: 18, color: Colors.grey.shade400),
                  onPressed: () => onChanged(''),
                ),
          filled: true,
          fillColor: _kCardBg,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_kChipRadius),
              borderSide: BorderSide(color: Colors.grey.shade200)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_kChipRadius),
              borderSide: BorderSide(color: Colors.grey.shade200)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_kChipRadius),
              borderSide: const BorderSide(color: _kTeal, width: 1.5)),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// Status filter chips
// ══════════════════════════════════════════════════════════════════════

class _StatusChips extends StatelessWidget {
  const _StatusChips(
      {required this.options, required this.selected, required this.onChanged});
  final Map<String, String> options;
  final String selected;
  final ValueChanged<String> onChanged;

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

class _StatusChipButton extends StatefulWidget {
  const _StatusChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

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
                BoxShadow(
                    color: _kTeal.withAlpha(10),
                    blurRadius: 4,
                    offset: const Offset(0, 1))
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

// ══════════════════════════════════════════════════════════════════════
// Status badge
// ══════════════════════════════════════════════════════════════════════

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final c = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: c.withAlpha(20), borderRadius: BorderRadius.circular(6)),
      child: Text(_statusLabel(status),
          style:
              TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: c)),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// Result card with hover
// ══════════════════════════════════════════════════════════════════════

class _ResultCard extends StatefulWidget {
  const _ResultCard(
      {required this.title,
      required this.status,
      required this.line2,
      this.line3,
      required this.onTap});
  final String title, status, line2;
  final String? line3;
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
            ),
            boxShadow: [
              if (_hovered)
                BoxShadow(
                    color: Colors.black.withAlpha(12),
                    blurRadius: 12,
                    offset: const Offset(0, 4))
              else
                BoxShadow(
                    color: Colors.black.withAlpha(6),
                    blurRadius: 6,
                    offset: const Offset(0, 2)),
            ],
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Flexible(
                  child: Text(widget.title,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 8),
              _StatusBadge(status: widget.status),
            ]),
            const SizedBox(height: 6),
            Text(widget.line2,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            if (widget.line3 != null) ...[
              const SizedBox(height: 4),
              Text(widget.line3!,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ]),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// Empty state
// ══════════════════════════════════════════════════════════════════════

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
          decoration: BoxDecoration(
              color: Colors.grey.shade100, shape: BoxShape.circle),
          child: Icon(Icons.search_off_rounded,
              size: 32, color: Colors.grey.shade400),
        ),
        const SizedBox(height: 16),
        Text(title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// Campaign List
// ══════════════════════════════════════════════════════════════════════

const _kCampaignFilters = {
  'all': _kAllFilterLabel,
  'active': 'Hoạt động',
  _kStatusCompleted: _kStatusDoneLabel,
  _kStatusCanceled: _kStatusCanceledLabel,
};

class _CampaignListView extends StatefulWidget {
  const _CampaignListView(
      {required this.campaigns, required this.onCampaignSelected});
  final List<Campaign> campaigns;
  final ValueChanged<Campaign> onCampaignSelected;

  @override
  State<_CampaignListView> createState() => _CampaignListViewState();
}

class _CampaignListViewState extends State<_CampaignListView> {
  String _search = '';
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.campaigns.where((c) {
      if (_filter != 'all' && c.status != _filter) return false;
      if (_search.isNotEmpty &&
          !c.name.toLowerCase().contains(_search.toLowerCase()) &&
          !c.description.toLowerCase().contains(_search.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();

    return Column(children: [
      // Sticky search + filters
      Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
            color: _kBg,
            border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _SearchField(
              hint: 'Tìm kiếm chiến dịch...',
              value: _search,
              onChanged: (v) => setState(() => _search = v)),
          const SizedBox(height: 12),
          _StatusChips(
              options: _kCampaignFilters,
              selected: _filter,
              onChanged: (v) => setState(() => _filter = v)),
        ]),
      ),
      // Results
      Expanded(
        child: filtered.isEmpty
            ? const _EmptyState(
                title: 'Không tìm thấy chiến dịch',
                subtitle: 'Thử thay đổi từ khóa hoặc bộ lọc trạng thái.')
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final c = filtered[i];
                  final dateRange = c.startDate != null
                      ? '${c.startDate!.day}/${c.startDate!.month}/${c.startDate!.year}${c.endDate != null ? ' – ${c.endDate!.day}/${c.endDate!.month}/${c.endDate!.year}' : ''}'
                      : 'Chưa xác định';
                  return _ResultCard(
                    title: c.name,
                    status: c.status,
                    line2: dateRange,
                    line3: c.description.isNotEmpty ? c.description : null,
                    onTap: () => widget.onCampaignSelected(c),
                  );
                },
              ),
      ),
    ]);
  }
}

// ══════════════════════════════════════════════════════════════════════
// Event List
// ══════════════════════════════════════════════════════════════════════

const _kEventFilters = {
  'all': _kAllFilterLabel,
  _kStatusInProgress: 'Đang diễn ra',
  _kStatusCompleted: _kStatusDoneLabel,
  _kStatusCanceled: _kStatusCanceledLabel,
};

class _EventListView extends StatefulWidget {
  const _EventListView({
    required this.campaign,
    required this.events,
    required this.controller,
    required this.onEventSelected,
  });

  final Campaign campaign;
  final List<Event> events;
  final VietnamMapController controller;
  final ValueChanged<Event> onEventSelected;

  @override
  State<_EventListView> createState() => _EventListViewState();
}


class _EventListViewState extends State<_EventListView> {
  String _search = '';
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final c = widget.campaign;
    final dateRange = c.startDate != null
        ? '${c.startDate!.day}/${c.startDate!.month}/${c.startDate!.year}${c.endDate != null ? ' – ${c.endDate!.day}/${c.endDate!.month}/${c.endDate!.year}' : ''}'
        : 'Chưa xác định';

    final filtered = widget.events.where((e) {
      if (_filter != 'all' && e.status != _filter) return false;
      if (_search.isNotEmpty &&
          !e.name.toLowerCase().contains(_search.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();

    return CustomScrollView(
      slivers: [
        // Campaign details card
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF0D9488), Color(0xFF0F766E)]),
              borderRadius: BorderRadius.circular(_kRadius),
              boxShadow: [
                BoxShadow(
                  color: _kTeal.withAlpha(20),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        c.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusBadgeLight(status: c.status),
                  ],
                ),
                if (c.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    c.description,
                    style: const TextStyle(
                        fontSize: 13, color: Colors.white70, height: 1.4),
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined,
                        size: 14, color: Colors.white70),
                    const SizedBox(width: 6),
                    Text(
                      dateRange,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Section Title for events
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                const Text(
                  'Sự kiện trong chiến dịch',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    '${widget.events.length}',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Search & filter block
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            decoration: BoxDecoration(
                color: _kBg,
                border:
                    Border(bottom: BorderSide(color: Colors.grey.shade100))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _SearchField(
                  hint: 'Tìm kiếm sự kiện...',
                  value: _search,
                  onChanged: (v) => setState(() => _search = v)),
              const SizedBox(height: 12),
              _StatusChips(options: _kEventFilters, selected: _filter, onChanged: (v) => setState(() => _filter = v)),
              const SizedBox(height: 12),
              AnimatedBuilder(
                animation: widget.controller,
                builder: (context, _) {
                  return SizedBox(
                    width: double.infinity,
                    child: MapSegmentedControl<MapEventVisibility>(
                      value: widget.controller.eventVisibility,
                      onChanged: widget.controller.updateEventVisibility,
                      segments: const [
                        MapSegmentedOption(
                          value: MapEventVisibility.detail,
                          icon: Icons.done_rounded,
                          label: 'Hiện chi tiết',
                        ),
                        MapSegmentedOption(
                          value: MapEventVisibility.dot,
                          icon: Icons.apps_rounded,
                          label: 'Hiện chấm',
                        ),
                        MapSegmentedOption(
                          value: MapEventVisibility.hide,
                          icon: Icons.visibility_off_outlined,
                          label: 'Ẩn tất cả',
                        ),
                      ],
                    ),
                  );
                },
              ),
            ]),
          ),
        ),

        // Event items list
        if (filtered.isEmpty)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: _EmptyState(
                title: 'Không tìm thấy sự kiện',
                subtitle: 'Thử thay đổi từ khóa hoặc bộ lọc trạng thái.',
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final e = filtered[i];
                  final dateStr = e.date != null
                      ? '${e.date!.day}/${e.date!.month}/${e.date!.year}'
                      : '';
                  final school = e.schoolIds.isEmpty
                      ? null
                      : widget.controller.eventSchools[e.schoolIds.first];
                  final location = school == null
                      ? 'Địa điểm: Chưa xác định'
                      : 'Địa điểm: ${school.schoolName} - ${school.communeName}, ${school.provinceName}';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ResultCard(
                      title: e.name,
                      status: e.status,
                      line2:
                          dateStr.isNotEmpty ? dateStr : 'Chưa xác định ngày',
                      line3: '$location | Tương tác: ${e.totalInteractions}',
                      onTap: () => widget.onEventSelected(e),
                    ),
                  );
                },
                childCount: filtered.length,
              ),
            ),
          ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// Event Detail
// ══════════════════════════════════════════════════════════════════════

class _EventDetailView extends StatefulWidget {
  const _EventDetailView({required this.event, required this.controller});
  final Event event;
  final VietnamMapController controller;

  @override
  State<_EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<_EventDetailView> {
  final _targetNameController = TextEditingController();
  final _notesController = TextEditingController();
  String _targetType = 'student';

  @override
  void dispose() {
    _targetNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitInteraction() async {
    final targetName = _targetNameController.text.trim();
    final notes = _notesController.text.trim();
    if (targetName.isEmpty || notes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nhập người tương tác và nội dung.')),
      );
      return;
    }

    await widget.controller.createInteractionForSelectedEvent(
      targetType: _targetType,
      targetName: targetName,
      notes: notes,
    );
    if (!mounted) return;
    if (widget.controller.campaignActionMessage == 'Đã ghi nhận tương tác.') {
      _targetNameController.clear();
      _notesController.clear();
    }
    final message = widget.controller.campaignActionMessage;
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      widget.controller.clearCampaignActionMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final controller = widget.controller;
    String schoolName = 'N/A',
        provinceName = 'N/A',
        communeName = 'N/A',
        address = 'N/A';
    if (event.schoolIds.isNotEmpty) {
      final school = controller.eventSchools[event.schoolIds.first];
      if (school != null) {
        schoolName = school.schoolName;
        provinceName = school.provinceName;
        communeName = school.communeName;
        address = school.address;
      }
    }
    final dateStr = event.date != null ? '${event.date!.day}/${event.date!.month}/${event.date!.year}' : 'N/A';

    final allInteractions = controller.eventInteractions;
    final filteredInteractions = controller.selectedEmployeeFilterId == null
        ? allInteractions
        : allInteractions.where((i) => i.employeeId == controller.selectedEmployeeFilterId).toList();

    return ListView(padding: const EdgeInsets.all(16), children: [
      // Hero card
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF0D9488), Color(0xFF0F766E)]),
          borderRadius: BorderRadius.circular(_kRadius),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(event.name,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 8),
          Row(children: [
            _StatusBadgeLight(status: event.status),
            const SizedBox(width: 10),
            Text(dateStr,
                style: const TextStyle(fontSize: 13, color: Colors.white70)),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.location_on_outlined,
                size: 14, color: Colors.white60),
            const SizedBox(width: 4),
            Expanded(
                child: Text('$provinceName, $communeName',
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                    overflow: TextOverflow.ellipsis)),
          ]),
        ]),
      ),
      const SizedBox(height: 16),

      // Info card
      _InfoCard(children: [
        _InfoItem(
            icon: Icons.school_outlined, label: 'Trường', value: schoolName),
        _InfoItem(icon: Icons.home_outlined, label: 'Địa chỉ', value: address),
        _InfoItem(
            icon: Icons.touch_app_outlined,
            label: 'Tổng tương tác',
            value: '${event.totalInteractions}'),
      ]),
      const SizedBox(height: 16),

      const _SectionTitle(label: 'Tạo tương tác'),
      const SizedBox(height: 8),
      if (controller.appUser == null)
        const _EmptyState(
          title: 'Chưa đăng nhập',
          subtitle: 'Cần tài khoản nhân viên để tạo tương tác cho sự kiện.',
        )
      else if (!event.assignedEmployeeIds.contains(controller.appUser!.uid))
        const _InfoCard(children: [
          _InfoItem(
            icon: Icons.lock_outline,
            label: 'Quyền',
            value: 'Bạn chưa được gán vào sự kiện này.',
          ),
        ])
      else
        _InteractionForm(
          targetNameController: _targetNameController,
          notesController: _notesController,
          targetType: _targetType,
          isSaving: controller.isSavingInteraction,
          onTargetTypeChanged: (value) => setState(() => _targetType = value),
          onSubmit: _submitInteraction,
        ),
      const SizedBox(height: 16),

      // Employee section
      _SectionTitle(
          label: 'Nhân viên phụ trách',
          count: event.assignedEmployeeIds.length),
      const SizedBox(height: 8),
      if (event.assignedEmployeeIds.isEmpty)
        const _EmptyState(
            title: 'Chưa phân công',
            subtitle: 'Không có nhân viên nào được phân công cho sự kiện này.')
      else
        ...event.assignedEmployeeIds.map((id) {
          final name = controller.employeeNames[id] ?? 'Không rõ';
          final email = controller.employeeEmails[id] ?? '';
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _EmployeeCard(
              name: name,
              id: id,
              email: email,
              isSelected: controller.selectedEmployeeFilterId == id,
              onTap: () => controller.toggleEmployeeFilter(id),
            ),
          );
        }),
      const SizedBox(height: 20),

      // Interactions section
      _SectionTitle(
        label: 'Danh sách tương tác',
        count: controller.isLoadingInteractions ? null : filteredInteractions.length,
      ),
      const SizedBox(height: 8),
      if (controller.isLoadingInteractions)
        const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        )
      else if (filteredInteractions.isEmpty)
        _EmptyState(
          title: controller.selectedEmployeeFilterId != null
              ? 'Không có tương tác từ nhân viên này'
              : 'Chưa có tương tác',
          subtitle: controller.selectedEmployeeFilterId != null
              ? 'Nhân viên được chọn chưa thực hiện tương tác nào cho sự kiện này.'
              : 'Sự kiện này chưa ghi nhận tương tác nào.',
        )
      else
        ...filteredInteractions.map((i) {
          final targetName = i.targetName.isNotEmpty
              ? i.targetName
              : (controller.interactionTargetNames[i.targetId] ?? 'Không rõ');
          final employeeName = controller.employeeNames[i.employeeId] ?? 'Không rõ';
          return _InteractionCard(
            interaction: i,
            targetName: targetName,
            employeeName: employeeName,
          );
        }),
    ]);
  }
}

// ── Detail sub-widgets ─────────────────────────────────────────────

class _InteractionForm extends StatelessWidget {
  const _InteractionForm({
    required this.targetNameController,
    required this.notesController,
    required this.targetType,
    required this.isSaving,
    required this.onTargetTypeChanged,
    required this.onSubmit,
  });

  final TextEditingController targetNameController;
  final TextEditingController notesController;
  final String targetType;
  final bool isSaving;
  final ValueChanged<String> onTargetTypeChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(_kRadius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            initialValue: targetType,
            decoration: InputDecoration(
              labelText: 'Đối tượng',
              border: inputBorder,
              enabledBorder: inputBorder,
            ),
            items: const [
              DropdownMenuItem(value: 'student', child: Text('Học sinh')),
              DropdownMenuItem(value: 'person', child: Text('Nhân sự trường')),
              DropdownMenuItem(value: 'relative', child: Text('Phụ huynh')),
            ],
            onChanged: isSaving
                ? null
                : (value) {
                    if (value != null) onTargetTypeChanged(value);
                  },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: targetNameController,
            enabled: !isSaving,
            decoration: InputDecoration(
              labelText: 'Người tương tác',
              border: inputBorder,
              enabledBorder: inputBorder,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: notesController,
            enabled: !isSaving,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Nội dung tương tác',
              border: inputBorder,
              enabledBorder: inputBorder,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: isSaving ? null : onSubmit,
            icon: isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add_comment_outlined, size: 18),
            label: Text(isSaving ? 'Đang lưu...' : 'Ghi nhận tương tác'),
          ),
        ],
      ),
    );
  }
}

class _StatusBadgeLight extends StatelessWidget {
  const _StatusBadgeLight({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: Colors.white.withAlpha(25),
          borderRadius: BorderRadius.circular(6)),
      child: Text(_statusLabel(status),
          style: const TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label, this.count});
  final String label;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(label,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: -0.2)),
      if (count != null) ...[
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8)),
          child: Text('$count',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600)),
        ),
      ],
    ]);
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: _kCardBg,
          borderRadius: BorderRadius.circular(_kRadius),
          border: Border.all(color: Colors.grey.shade200)),
      child: Column(children: [
        for (int i = 0; i < children.length; i++) ...[
          if (i > 0) Divider(height: 20, color: Colors.grey.shade100),
          children[i],
        ],
      ]),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem(
      {required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 16, color: _kTeal),
      const SizedBox(width: 10),
      SizedBox(
          width: 90,
          child: Text(label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500))),
      Expanded(
          child: Text(value,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
    ]);
  }
}

class _EmployeeCard extends StatefulWidget {
  const _EmployeeCard({
    required this.name,
    required this.id,
    required this.email,
    required this.isSelected,
    required this.onTap,
  });
  final String name, id, email;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<_EmployeeCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: active
                ? _kTeal.withAlpha(40)
                : (_hovered ? _kTealLight.withAlpha(80) : _kCardBg),
            borderRadius: BorderRadius.circular(_kRadius),
            border: Border.all(
              color: active
                  ? _kTeal
                  : (_hovered ? _kTeal.withAlpha(80) : Colors.grey.shade200),
              width: active ? 1.5 : 1,
            ),
            boxShadow: [
              if (active || _hovered)
                BoxShadow(color: _kTeal.withAlpha(15), blurRadius: 10, offset: const Offset(0, 2))
              else
                BoxShadow(
                    color: Colors.black.withAlpha(4),
                    blurRadius: 4,
                    offset: const Offset(0, 1)),
            ],
          ),
          child: Row(children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: active ? _kTeal : _kTealLight,
              child: Text(
                widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: active ? Colors.white : _kTeal,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              Text(
                _employeeSubtitle(widget.email, widget.id),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ])),
            if (active)
              const Icon(Icons.check_circle, size: 18, color: _kTeal)
            else
              Icon(Icons.chevron_right, size: 18, color: _hovered ? _kTeal : Colors.grey.shade400),
          ]),
        ),
      ),
    );
  }
}

class _InteractionCard extends StatelessWidget {
  const _InteractionCard({required this.interaction, required this.targetName, required this.employeeName});
  final Interaction interaction;
  final String targetName;
  final String employeeName;

  @override
  Widget build(BuildContext context) {
    final typeLabel = switch (interaction.targetType) {
      'student' => 'Học sinh',
      'relative' => 'Phụ huynh',
      'person' => 'Cán bộ',
      _ => 'Đối tượng khác',
    };

    final typeColor = switch (interaction.targetType) {
      'student' => Colors.blue.shade700,
      'relative' => Colors.purple.shade700,
      'person' => Colors.amber.shade800,
      _ => Colors.grey.shade700,
    };

    final typeBg = switch (interaction.targetType) {
      'student' => Colors.blue.shade50,
      'relative' => Colors.purple.shade50,
      'person' => Colors.amber.shade50,
      _ => Colors.grey.shade50,
    };

    final timeStr = interaction.timestamp != null
        ? '${interaction.timestamp!.hour.toString().padLeft(2, '0')}:${interaction.timestamp!.minute.toString().padLeft(2, '0')} ${interaction.timestamp!.day}/${interaction.timestamp!.month}/${interaction.timestamp!.year}'
        : 'Không rõ thời gian';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(_kRadius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: typeBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  typeLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: typeColor,
                  ),
                ),
              ),
              Text(
                timeStr,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            targetName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (interaction.notes.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              interaction.notes,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ],
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.person_outline, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(
                'Thực hiện: $employeeName',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
