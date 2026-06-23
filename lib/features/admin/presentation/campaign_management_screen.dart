import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/campaign_repository.dart';
import '../domain/campaign.dart';
import '../domain/event.dart';
import '../domain/school.dart';
import '../domain/interaction.dart';

// ── Design Tokens & Palette ──────────────────────────────────────────
const _kTeal = Color(0xFF0D9488);
const _kTealLight = Color(0xFFF2FBF9);
const _kBg = Color(0xFFF8FAFB);
const _kCardBg = Colors.white;
const _kRadius = 14.0;
const _kBorderRadius = 12.0;

InputDecoration _dialogInputDecoration(String labelText) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade200),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _kTeal, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}

class CampaignManagementScreen extends StatefulWidget {
  const CampaignManagementScreen({super.key});

  @override
  State<CampaignManagementScreen> createState() =>
      _CampaignManagementScreenState();
}

class _CampaignManagementScreenState extends State<CampaignManagementScreen> {
  final _repo = CampaignRepository.instance;
  Campaign? _selectedCampaign;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: _kBg,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLeftPanel(cs),
                Expanded(
                  child: _selectedCampaign == null
                      ? const _EmptyPanel(
                          icon: Icons.event_note_outlined,
                          title: 'Chọn một chiến dịch',
                          subtitle: 'Danh sách sự kiện và thống kê chi tiết sẽ hiển thị ở đây.',
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 16, right: 24, bottom: 24),
                          child: _EventPane(
                            campaign: _selectedCampaign!,
                            onCampaignChanged: (campaign) {
                              setState(() => _selectedCampaign = campaign);
                            },
                          ),
                        ),
                ),
              ],
            );
          }

          // Mobile View
          if (_selectedCampaign != null) {
            return Column(
              children: [
                _MobileBackBar(
                  title: _selectedCampaign!.name,
                  onBack: () => setState(() => _selectedCampaign = null),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _EventPane(
                      campaign: _selectedCampaign!,
                      onCampaignChanged: (c) => setState(() => _selectedCampaign = c),
                    ),
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              _HeaderBar(
                title: 'Chiến dịch',
                actionLabel: 'Tạo chiến dịch',
                icon: Icons.add,
                onAction: () => _openCampaignForm(),
              ),
              _buildSearchBox(cs),
              Expanded(child: _buildCampaignList(cs, false)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLeftPanel(ColorScheme cs) {
    return Container(
      width: 350,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(_kRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Chiến dịch',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                IconButton(
                  tooltip: 'Tạo chiến dịch mới',
                  style: IconButton.styleFrom(
                    backgroundColor: _kTeal.withOpacity(0.1),
                    foregroundColor: _kTeal,
                  ),
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: () => _openCampaignForm(),
                ),
              ],
            ),
          ),
          _buildSearchBox(cs),
          const Divider(height: 1, thickness: 1),
          Expanded(child: _buildCampaignList(cs, true)),
        ],
      ),
    );
  }

  Widget _buildSearchBox(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextFormField(
        initialValue: _searchQuery,
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Tìm kiếm chiến dịch...',
          hintStyle: const TextStyle(fontSize: 15),
          prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
          isDense: true,
          fillColor: _kBg,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _kTeal, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildCampaignList(ColorScheme cs, bool isDesktop) {
    return StreamBuilder<List<Campaign>>(
      stream: _repo.watchCampaigns(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: _kTeal));
        }
        var campaigns = snapshot.data ?? const <Campaign>[];
        if (_searchQuery.trim().isNotEmpty) {
          campaigns = campaigns
              .where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();
        }

        if (campaigns.isEmpty) {
          return const _EmptyPanel(
            icon: Icons.campaign_outlined,
            title: 'Chưa có chiến dịch',
            subtitle: 'Không tìm thấy chiến dịch nào.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: campaigns.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final campaign = campaigns[index];
            final selected = _selectedCampaign?.id == campaign.id;
            return _CampaignTile(
              campaign: campaign,
              selected: selected,
              onTap: () {
                setState(() => _selectedCampaign = campaign);
              },
              onEdit: () => _openCampaignForm(campaign: campaign),
              onDelete: () => _confirmDeleteCampaign(campaign),
            );
          },
        );
      },
    );
  }

  Future<void> _openCampaignForm({Campaign? campaign}) async {
    final saved = await showDialog<Campaign>(
      context: context,
      builder: (_) => _CampaignFormDialog(campaign: campaign),
    );
    if (saved == null) return;

    await _repo.saveCampaign(saved);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(campaign == null
            ? 'Đã tạo chiến dịch.'
            : 'Đã cập nhật chiến dịch.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _confirmDeleteCampaign(Campaign campaign) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        title: const Text('Xóa chiến dịch?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          'Chiến dịch "${campaign.name}" và các event bên trong sẽ bị xóa.',
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    await _repo.deleteCampaign(campaign.id);
    if (!mounted) return;
    if (_selectedCampaign?.id == campaign.id) {
      setState(() => _selectedCampaign = null);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã xóa chiến dịch.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _EventPane extends StatefulWidget {
  const _EventPane({
    required this.campaign,
    required this.onCampaignChanged,
  });

  final Campaign campaign;
  final ValueChanged<Campaign> onCampaignChanged;

  @override
  State<_EventPane> createState() => _EventPaneState();
}

class _EventPaneState extends State<_EventPane> {
  final _repo = CampaignRepository.instance;
  late Future<_EventFormOptions> _optionsFuture;

  @override
  void initState() {
    super.initState();
    _optionsFuture = _loadOptions();
  }

  @override
  void didUpdateWidget(covariant _EventPane oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.campaign.id != widget.campaign.id) {
      _optionsFuture = _loadOptions();
    }
  }

  Future<_EventFormOptions> _loadOptions() async {
    final results = await Future.wait([
      _repo.getAllSchools(),
      _repo.getEmployees(),
    ]);
    return _EventFormOptions(
      schools: results[0] as List<School>,
      employees: results[1] as List<Map<String, String>>,
    );
  }

  @override
  Widget build(BuildContext context) {
    final campaign = widget.campaign;
    final cs = Theme.of(context).colorScheme;

    return StreamBuilder<List<Event>>(
      key: ValueKey(campaign.id),
      stream: _repo.watchEventsForCampaign(campaign.id),
      builder: (context, snapshot) {
        final events = snapshot.data ?? const <Event>[];
        final totalEvents = events.length;
        final completedEvents = events.where((e) => e.status == 'completed').length;
        final participants = events.fold<int>(0, (sum, e) => sum + e.totalInteractions);
        final staffCount = events.expand((e) => e.assignedEmployeeIds).toSet().length;

        final headerCard = Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _kCardBg,
            borderRadius: BorderRadius.circular(_kRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, headerConstraints) {
                  final isMobileWidth = headerConstraints.maxWidth < 600;
                  final headerContent = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              campaign.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _StatusPill(status: campaign.status),
                        ],
                      ),
                      if (campaign.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          campaign.description,
                          style: TextStyle(
                            color: cs.onSurfaceVariant,
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 16, color: cs.onSurfaceVariant),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _formatRange(campaign.startDate, campaign.endDate),
                              style: TextStyle(
                                color: cs.onSurfaceVariant,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );

                  if (isMobileWidth) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        headerContent,
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: _kTeal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => _openEventForm(context),
                          icon: const Icon(Icons.add_circle_outline, size: 20),
                          label: const Text('Thêm event', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: headerContent),
                      const SizedBox(width: 16),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: _kTeal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _openEventForm(context),
                        icon: const Icon(Icons.add_circle_outline, size: 20),
                        label: const Text('Thêm event', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              // Grid of Stats Cards
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 650;
                  if (isWide) {
                    return Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Sự kiện',
                            '$totalEvents',
                            Icons.event_note,
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Hoàn thành',
                            '$completedEvents',
                            Icons.check_circle_outline,
                            Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Tương tác',
                            '$participants',
                            Icons.people_outline,
                            Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Nhân viên',
                            '$staffCount',
                            Icons.badge_outlined,
                            _kTeal,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Sự kiện',
                                '$totalEvents',
                                Icons.event_note,
                                Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                'Hoàn thành',
                                '$completedEvents',
                                Icons.check_circle_outline,
                                Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Tương tác',
                                '$participants',
                                Icons.people_outline,
                                Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                'Nhân viên',
                                '$staffCount',
                                Icons.badge_outlined,
                                _kTeal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        );

        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              headerCard,
              const SizedBox(height: 20),
              const Center(child: CircularProgressIndicator(color: _kTeal)),
            ],
          );
        }

        return FutureBuilder<_EventFormOptions>(
          future: _optionsFuture,
          builder: (context, optionsSnapshot) {
            final options = optionsSnapshot.data;
            final schools = options?.schools ?? const <School>[];
            final employees = options?.employees ?? const <Map<String, String>>[];

            if (events.isEmpty) {
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  headerCard,
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: _kCardBg,
                      borderRadius: BorderRadius.circular(_kRadius),
                    ),
                    child: const _EmptyPanel(
                      icon: Icons.event_available_outlined,
                      title: 'Chưa có event',
                      subtitle: 'Tạo event đầu tiên và phân công nhân sự.',
                    ),
                  ),
                ],
              );
            }

            return ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: events.length + 1,
              separatorBuilder: (_, index) => SizedBox(height: index == 0 ? 20 : 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return headerCard;
                }
                final event = events[index - 1];
                return _EventTile(
                  event: event,
                  schools: schools,
                  employees: employees,
                  onEdit: () => _openEventForm(context, event: event),
                  onDelete: () => _confirmDeleteEvent(event),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _kBg,
        borderRadius: BorderRadius.circular(_kBorderRadius),
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openEventForm(BuildContext context, {Event? event}) async {
    final options = await _optionsFuture;
    if (!context.mounted) return;
    final saved = await showDialog<Event>(
      context: context,
      builder: (_) => _EventFormDialog(
        campaignId: widget.campaign.id,
        event: event,
        schools: options.schools,
        employees: options.employees,
      ),
    );
    if (saved == null) return;

    await _repo.saveEvent(saved);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(event == null ? 'Đã tạo event.' : 'Đã cập nhật event.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _confirmDeleteEvent(Event event) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        title: const Text('Xóa event?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Event "${event.name}" sẽ bị xóa khỏi chiến dịch.', style: const TextStyle(fontSize: 15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    await _repo.deleteEvent(event.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã xóa event.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _CampaignTile extends StatefulWidget {
  const _CampaignTile({
    required this.campaign,
    required this.selected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Campaign campaign;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<_CampaignTile> createState() => _CampaignTileState();
}

class _CampaignTileState extends State<_CampaignTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final repo = CampaignRepository.instance;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -2.0 : 0.0),
        decoration: BoxDecoration(
          color: widget.selected 
              ? _kTealLight 
              : (_isHovered ? Colors.grey.shade50 : _kCardBg),
          borderRadius: BorderRadius.circular(_kBorderRadius),
          border: Border.all(
            color: widget.selected 
                ? _kTeal 
                : (_isHovered ? _kTeal.withOpacity(0.3) : Colors.grey.shade100),
            width: widget.selected ? 1.5 : 1.0,
          ),
          boxShadow: [
            if (widget.selected)
              BoxShadow(
                color: _kTeal.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            else if (_isHovered)
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_kBorderRadius),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.selected)
                  Container(
                    width: 4,
                    color: _kTeal,
                  ),
                Expanded(
                  child: InkWell(
                    onTap: widget.onTap,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: (widget.selected ? _kTeal : Colors.grey).withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.campaign_rounded,
                                  size: 18,
                                  color: widget.selected ? _kTeal : Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.campaign.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _StatusPill(status: widget.campaign.status),
                              StreamBuilder<List<Event>>(
                                stream: repo.watchEventsForCampaign(widget.campaign.id),
                                builder: (context, snapshot) {
                                  final count = snapshot.data?.length ?? 0;
                                  return Text(
                                    '$count event',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey.shade500),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  _formatRange(widget.campaign.startDate, widget.campaign.endDate),
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                tooltip: 'Sửa chiến dịch',
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.grey),
                                onPressed: widget.onEdit,
                              ),
                              IconButton(
                                tooltip: 'Xóa chiến dịch',
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(Icons.delete_outline_outlined, size: 18, color: Colors.redAccent),
                                onPressed: widget.onDelete,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({
    required this.event,
    required this.schools,
    required this.employees,
    required this.onEdit,
    required this.onDelete,
  });

  final Event event;
  final List<School> schools;
  final List<Map<String, String>> employees;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final school = event.schoolIds.isEmpty
        ? null
        : schools.where((s) => s.id == event.schoolIds.first).firstOrNull;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(_kBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _kTeal.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.event_available_outlined, color: _kTeal, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatusPill(status: event.status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_outlined, size: 16, color: Colors.grey.shade500),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            school == null
                                ? 'Địa điểm: Chưa xác định'
                                : '${school.schoolName}, ${school.communeName}, ${school.provinceName}',
                            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 15, color: Colors.grey.shade500),
                        const SizedBox(width: 6),
                        Text(
                          _formatDate(event.date),
                          style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.touch_app_outlined, size: 16, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          '${event.totalInteractions} tương tác',
                          style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.people_outline_outlined, size: 16, color: Colors.grey.shade500),
                        const SizedBox(width: 6),
                        Text(
                          event.assignedEmployeeIds.isEmpty
                              ? 'Chưa phân công nhân viên'
                              : 'Số nhân viên phụ trách: ${event.assignedEmployeeIds.length}',
                          style: TextStyle(
                            color: cs.onSurfaceVariant,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 8,
            runSpacing: 8,
            children: [
              _ActionButton(
                icon: Icons.info_outline,
                label: 'Chi tiết',
                color: Colors.blue,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailScreen(
                        event: event,
                        school: school,
                        employees: employees,
                      ),
                    ),
                  );
                },
              ),
              _ActionButton(
                icon: Icons.edit_outlined,
                label: 'Sửa',
                color: Colors.grey.shade700,
                onPressed: onEdit,
              ),
              _ActionButton(
                icon: Icons.delete_outline,
                label: 'Xóa',
                color: Colors.red,
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withOpacity(0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          visualDensity: VisualDensity.compact,
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _CampaignFormDialog extends StatefulWidget {
  const _CampaignFormDialog({this.campaign});

  final Campaign? campaign;

  @override
  State<_CampaignFormDialog> createState() => _CampaignFormDialogState();
}

class _CampaignFormDialogState extends State<_CampaignFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late String _status;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final campaign = widget.campaign;
    _nameController = TextEditingController(text: campaign?.name ?? '');
    _descriptionController =
        TextEditingController(text: campaign?.description ?? '');
    _status = campaign?.status ?? 'active';
    _startDate = campaign?.startDate;
    _endDate = campaign?.endDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 4.0),
        child: Text(
          widget.campaign == null ? 'Tạo chiến dịch' : 'Sửa chiến dịch',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width > 500 ? 460.0 : MediaQuery.of(context).size.width * 0.85,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.65,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(fontSize: 15),
                  decoration: _dialogInputDecoration('Tên chiến dịch'),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Nhập tên' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _descriptionController,
                  minLines: 2,
                  maxLines: 4,
                  style: const TextStyle(fontSize: 15),
                  decoration: _dialogInputDecoration('Mô tả'),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: _status,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                  decoration: _dialogInputDecoration('Trạng thái'),
                  items: const [
                    DropdownMenuItem(value: 'active', child: Text('Hoạt động')),
                    DropdownMenuItem(
                        value: 'completed', child: Text('Hoàn thành')),
                    DropdownMenuItem(value: 'canceled', child: Text('Đã hủy')),
                    DropdownMenuItem(value: 'draft', child: Text('Nháp')),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _status = value);
                  },
                ),
                const SizedBox(height: 16),
                _DateRow(
                  label: 'Bắt đầu',
                  value: _startDate,
                  onPick: (value) => setState(() => _startDate = value),
                ),
                _DateRow(
                  label: 'Kết thúc',
                  value: _endDate,
                  onPick: (value) => setState(() => _endDate = value),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade600,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: _kTeal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.pop(
              context,
              Campaign(
                id: widget.campaign?.id ?? '',
                name: _nameController.text,
                description: _descriptionController.text,
                startDate: _startDate,
                endDate: _endDate,
                status: _status,
                createdAt: widget.campaign?.createdAt,
              ),
            );
          },
          child: const Text('Lưu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ),
      ],
    );
  }
}

class _EventFormDialog extends StatefulWidget {
  const _EventFormDialog({
    required this.campaignId,
    required this.schools,
    required this.employees,
    this.event,
  });

  final String campaignId;
  final Event? event;
  final List<School> schools;
  final List<Map<String, String>> employees;

  @override
  State<_EventFormDialog> createState() => _EventFormDialogState();
}

class _EventFormDialogState extends State<_EventFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late String _status;
  DateTime? _date;
  String? _schoolId;
  late Set<String> _employeeIds;

  @override
  void initState() {
    super.initState();
    final event = widget.event;
    _nameController = TextEditingController(text: event?.name ?? '');
    _status = event?.status ?? 'in-progress';
    _date = event?.date;
    final candidateSchoolId = event?.schoolIds.isNotEmpty == true
        ? event!.schoolIds.first
        : (widget.schools.isNotEmpty ? widget.schools.first.id : null);
    final schoolExists = candidateSchoolId != null &&
        widget.schools.any((s) => s.id == candidateSchoolId);
    _schoolId = schoolExists ? candidateSchoolId : (widget.schools.isNotEmpty ? widget.schools.first.id : null);
    _employeeIds = {...?event?.assignedEmployeeIds};
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 4.0),
        child: Text(
          widget.event == null ? 'Tạo event' : 'Sửa event',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width > 560 ? 520.0 : MediaQuery.of(context).size.width * 0.85,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.65,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(fontSize: 15),
                  decoration: _dialogInputDecoration('Tên event'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Nhập tên event'
                      : null,
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: _status,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                  decoration: _dialogInputDecoration('Trạng thái'),
                  items: const [
                    DropdownMenuItem(
                      value: 'in-progress',
                      child: Text('Đang diễn ra'),
                    ),
                    DropdownMenuItem(
                      value: 'completed',
                      child: Text('Hoàn thành'),
                    ),
                    DropdownMenuItem(value: 'canceled', child: Text('Đã hủy')),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _status = value);
                  },
                ),
                const SizedBox(height: 16),
                _DateRow(
                  label: 'Ngày diễn ra',
                  value: _date,
                  onPick: (value) => setState(() => _date = value),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _schoolId,
                  isExpanded: true,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                  decoration: _dialogInputDecoration('Địa điểm'),
                  items: widget.schools
                      .map(
                        (school) => DropdownMenuItem(
                          value: school.id,
                          child: Text(
                            '${school.schoolName} - ${school.communeName}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _schoolId = value),
                  validator: (value) => value == null ? 'Chọn địa điểm' : null,
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nhân viên phụ trách',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.employees.length,
                    separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
                    itemBuilder: (context, idx) {
                      final employee = widget.employees[idx];
                      final id = employee['id'] ?? '';
                      return CheckboxListTile(
                        dense: true,
                        value: _employeeIds.contains(id),
                        title: Text(employee['name'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        subtitle: Text(employee['email'] ?? '', style: const TextStyle(fontSize: 13)),
                        onChanged: (selected) {
                          setState(() {
                            if (selected == true) {
                              _employeeIds.add(id);
                            } else {
                              _employeeIds.remove(id);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade600,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: _kTeal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.pop(
              context,
              Event(
                id: widget.event?.id ?? '',
                campaignId: widget.campaignId,
                name: _nameController.text,
                date: _date,
                schoolIds: _schoolId == null ? const [] : [_schoolId!],
                assignedEmployeeIds: _employeeIds.toList(),
                totalInteractions: widget.event?.totalInteractions ?? 0,
                status: _status,
                createdAt: widget.event?.createdAt,
              ),
            );
          },
          child: const Text('Lưu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ),
      ],
    );
  }
}

class _MobileBackBar extends StatelessWidget {
  const _MobileBackBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        border: Border(bottom: BorderSide(color: cs.outlineVariant)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBack,
            tooltip: 'Quay lại',
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({
    required this.title,
    required this.actionLabel,
    required this.icon,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final IconData icon;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        border: Border(bottom: BorderSide(color: cs.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: _kTeal),
            onPressed: onAction,
            icon: Icon(icon, size: 20),
            label: Text(actionLabel, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (status) {
      'active' || 'in-progress' => (const Color(0xFF16A34A), Icons.play_circle_filled_outlined),
      'completed' => (const Color(0xFF2563EB), Icons.check_circle_outlined),
      'canceled' => (const Color(0xFFDC2626), Icons.cancel_outlined),
      'draft' => (const Color(0xFF4B5563), Icons.edit_note_outlined),
      _ => (Theme.of(context).colorScheme.outline, Icons.help_outline),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            _statusLabel(status),
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: cs.outline),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventFormOptions {
  const _EventFormOptions({
    required this.schools,
    required this.employees,
  });

  final List<School> schools;
  final List<Map<String, String>> employees;
}

String _formatDate(DateTime? date) {
  if (date == null) return 'Chưa xác định';
  return '${date.day}/${date.month}/${date.year}';
}

String _formatRange(DateTime? start, DateTime? end) {
  if (start == null && end == null) return 'Chưa xác định thời gian';
  if (end == null) return _formatDate(start);
  return '${_formatDate(start)} - ${_formatDate(end)}';
}

String _statusLabel(String status) => switch (status) {
      'active' => 'Hoạt động',
      'in-progress' => 'Đang diễn ra',
      'completed' => 'Hoàn thành',
      'canceled' => 'Đã hủy',
      'draft' => 'Nháp',
      _ => status,
    };

class _DateRow extends StatelessWidget {
  const _DateRow({
    required this.label,
    required this.value,
    required this.onPick,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onPick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                    fontSize: 15,
                  ),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: value != null ? _formatDate(value) : 'Chưa chọn',
                  style: TextStyle(
                    color: value != null ? Colors.black87 : Colors.grey.shade600,
                    fontWeight: value != null ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: _kTeal,
              side: const BorderSide(color: _kTeal, width: 1),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: _kTeal.withOpacity(0.04),
            ),
            icon: const Icon(Icons.calendar_today_outlined, size: 14),
            label: const Text('Chọn', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: value ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                onPick(picked);
              }
            },
          ),
        ],
      ),
    );
  }
}

// ── Event Detail Screen ──────────────────────────────────────────────
class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({
    super.key,
    required this.event,
    required this.school,
    required this.employees,
  });

  final Event event;
  final School? school;
  final List<Map<String, String>> employees;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final _repo = CampaignRepository.instance;
  Map<String, String> _targetNames = {};
  bool _isLoadingTargetNames = true;
  List<School> _cachedSchools = []; // Cache list of schools to make Edit dialog open instantly

  // Filter toolbar states
  String _timelineSearch = '';
  String _targetTypeFilter = 'all'; // 'all', 'student', 'relative', 'person', 'other'
  bool _sortNewest = true;
  String? _selectedEmployeeFilterId; // State for filtering interactions by employee card

  late Stream<DocumentSnapshot<Map<String, dynamic>>> _eventStream;
  late Stream<List<Interaction>> _interactionsStream;

  @override
  void initState() {
    super.initState();
    _eventStream = _watchEvent(widget.event.id);
    _interactionsStream = _repo.getInteractionsStreamForEvent(widget.event.id);
    _loadTargetNames();
    _loadSchools();
  }

  Future<void> _loadSchools() async {
    try {
      final schools = await _repo.getAllSchools();
      if (mounted) {
        setState(() {
          _cachedSchools = schools;
        });
      }
    } catch (_) {}
  }

  Future<void> _loadTargetNames() async {
    try {
      final interactions = await _repo.getInteractionsForEvent(widget.event.id);
      final refs = interactions.map((i) => {'type': i.targetType, 'id': i.targetId}).toList();
      final names = await _repo.getTargetNames(refs);
      if (mounted) {
        setState(() {
          _targetNames = names;
          _isLoadingTargetNames = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingTargetNames = false);
      }
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> _watchEvent(String id) {
    return FirebaseFirestore.instance.collection('events').doc(id).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final employeeNameMap = {
      for (final emp in widget.employees) emp['id'] ?? '': emp['name'] ?? 'Unknown'
    };

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _eventStream,
      builder: (context, eventSnapshot) {
        final snap = eventSnapshot.data;
        final event = snap != null && snap.exists
            ? Event.fromMap(snap.id, snap.data()!)
            : widget.event;

        return StreamBuilder<List<Interaction>>(
          stream: _interactionsStream,
          builder: (context, interactionsSnapshot) {
            if (interactionsSnapshot.connectionState == ConnectionState.waiting || _isLoadingTargetNames) {
              return Scaffold(
                backgroundColor: _kBg,
                appBar: AppBar(
                  title: Text(
                    event.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  elevation: 0.5,
                ),
                body: const Center(
                  child: CircularProgressIndicator(color: _kTeal),
                ),
              );
            }

            final interactions = interactionsSnapshot.data ?? const [];

            return Scaffold(
              backgroundColor: _kBg,
              appBar: AppBar(
                title: Text(
                  event.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                elevation: 0.5,
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width < 600 ? 12.0 : 24.0),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1400),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 950;
                        if (isWide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left Sidebar (Event overview and quick stats)
                              SizedBox(
                                width: 400,
                                child: _buildSidebar(context, event, widget.school, interactions, employeeNameMap),
                              ),
                              const SizedBox(width: 24),
                              // Right Timeline column
                              Expanded(
                                child: _buildTimelineSection(context, event, interactions, employeeNameMap),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildSidebar(context, event, widget.school, interactions, employeeNameMap),
                              const SizedBox(height: 24),
                              _buildTimelineSection(context, event, interactions, employeeNameMap),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSidebar(
    BuildContext context,
    Event event,
    School? school,
    List<Interaction> interactions,
    Map<String, String> employeeNameMap,
  ) {
    final cs = Theme.of(context).colorScheme;
    final totalInteractions = interactions.length;
    final studentsCount = interactions.where((i) => i.targetType == 'student').length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Event Summary Card
        Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: _kCardBg,
            borderRadius: BorderRadius.circular(_kRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatusPill(status: event.status),
                  Text(
                    _formatDate(event.date),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                event.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              _buildDetailRow(
                Icons.location_on_outlined,
                'Địa điểm',
                school == null
                    ? 'Chưa xác định'
                    : '${school.schoolName}\n${school.communeName}, ${school.provinceName}',
              ),
              const SizedBox(height: 20),
              // Action Buttons Row (Edit, Export Report, Delete)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: () => _editEvent(context, event),
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('Sửa', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue.shade700,
                        side: BorderSide(color: Colors.blue.shade200),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: () => _exportReport(context, event),
                      icon: const Icon(Icons.description_outlined, size: 16),
                      label: const Text('Xuất BC', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.08),
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(10),
                    ),
                    onPressed: () => _deleteEvent(context, event),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    tooltip: 'Xóa event',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Quick Stats Cards Grid (2x2)
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.6,
          children: [
            _buildSidebarStatCard(
              'Tổng tương tác',
              '$totalInteractions',
              Icons.touch_app_outlined,
              Colors.blue,
            ),
            _buildSidebarStatCard(
              'Học sinh tiếp cận',
              '$studentsCount',
              Icons.school_outlined,
              Colors.purple,
            ),
            _buildSidebarStatCard(
              'Nhân viên',
              '${event.assignedEmployeeIds.length}',
              Icons.badge_outlined,
              Colors.orange,
            ),
            _buildSidebarStatCard(
              'Trạng thái',
              '',
              Icons.check_circle_outline,
              _kTeal,
              customValue: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: _StatusPill(status: event.status),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Employee List Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Nhân viên phụ trách',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${event.assignedEmployeeIds.length}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (event.assignedEmployeeIds.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Text(
              'Chưa phân công nhân viên nào.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          )
        else
          Column(
            children: event.assignedEmployeeIds.map((empId) {
              final name = employeeNameMap[empId] ?? 'Không rõ';
              final email = widget.employees.firstWhere((e) => e['id'] == empId, orElse: () => {})['email'] ?? '';
              final isSelected = _selectedEmployeeFilterId == empId;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _DetailEmployeeCard(
                  name: name,
                  id: empId,
                  email: email,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      if (_selectedEmployeeFilterId == empId) {
                        _selectedEmployeeFilterId = null;
                      } else {
                        _selectedEmployeeFilterId = empId;
                      }
                    });
                  },
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildSidebarStatCard(String label, String value, IconData icon, Color color, {Widget? customValue}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          customValue ??
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
                overflow: TextOverflow.ellipsis,
              ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection(
    BuildContext context,
    Event event,
    List<Interaction> interactions,
    Map<String, String> employeeNameMap,
  ) {
    // filter by search query
    var list = [...interactions];
    if (_timelineSearch.isNotEmpty) {
      list = list.where((i) {
        final tName = _targetNames[i.targetId]?.toLowerCase() ?? '';
        final notes = i.notes.toLowerCase();
        final search = _timelineSearch.toLowerCase();
        return tName.contains(search) || notes.contains(search);
      }).toList();
    }
    // filter by targetType
    if (_targetTypeFilter != 'all') {
      list = list.where((i) => i.targetType == _targetTypeFilter).toList();
    }
    // filter by selected employee card
    if (_selectedEmployeeFilterId != null) {
      list = list.where((i) => i.employeeId == _selectedEmployeeFilterId).toList();
    }
    // sort
    list.sort((a, b) {
      final tA = a.timestamp ?? DateTime.fromMillisecondsSinceEpoch(0);
      final tB = b.timestamp ?? DateTime.fromMillisecondsSinceEpoch(0);
      return _sortNewest ? tB.compareTo(tA) : tA.compareTo(tB);
    });

    // group by date
    final Map<String, List<Interaction>> grouped = {};
    for (final i in list) {
      final dateStr = i.timestamp != null
          ? '${i.timestamp!.day}/${i.timestamp!.month}/${i.timestamp!.year}'
          : 'Không rõ ngày';
      grouped.putIfAbsent(dateStr, () => []).add(i);
    }

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(_kRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lịch sử tương tác (${list.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          // Filter Toolbar
          _buildToolbar(),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 8),
          if (list.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: _EmptyPanel(
                icon: Icons.chat_bubble_outline,
                title: 'Không tìm thấy tương tác',
                subtitle: 'Thử thay đổi từ khóa tìm kiếm hoặc bộ lọc.',
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: grouped.length,
              itemBuilder: (context, gIdx) {
                final date = grouped.keys.elementAt(gIdx);
                final groupList = grouped[date]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0, bottom: 8.0, left: 8.0),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 8),
                          Text(
                            date,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...List.generate(groupList.length, (idx) {
                      final interaction = groupList[idx];
                      final tName = _targetNames[interaction.targetId] ?? 'Không rõ';
                      final eName = employeeNameMap[interaction.employeeId] ?? 'Không rõ';
                      final isLast = gIdx == grouped.length - 1 && idx == groupList.length - 1;
                      return _TimelineItem(
                        interaction: interaction,
                        targetName: tName,
                        employeeName: eName,
                        isLast: isLast,
                      );
                    }),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                initialValue: _timelineSearch,
                onChanged: (val) => setState(() => _timelineSearch = val),
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm tương tác...',
                  hintStyle: const TextStyle(fontSize: 14),
                  prefixIcon: const Icon(Icons.search, size: 18),
                  isDense: true,
                  fillColor: _kBg,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: _kTeal, width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _kBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<bool>(
                  value: _sortNewest,
                  style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold),
                  onChanged: (val) {
                    if (val != null) setState(() => _sortNewest = val);
                  },
                  items: const [
                    DropdownMenuItem(value: true, child: Text('Mới nhất')),
                    DropdownMenuItem(value: false, child: Text('Cũ nhất')),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('all', 'Tất cả'),
              const SizedBox(width: 8),
              _buildFilterChip('student', 'Học sinh'),
              const SizedBox(width: 8),
              _buildFilterChip('relative', 'Phụ huynh'),
              const SizedBox(width: 8),
              _buildFilterChip('person', 'Cán bộ'),
              const SizedBox(width: 8),
              _buildFilterChip('other', 'Khác'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final selected = _targetTypeFilter == value;
    return ChoiceChip(
      selected: selected,
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.grey.shade700,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
      selectedColor: _kTeal,
      backgroundColor: _kBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: selected ? Colors.transparent : Colors.grey.shade200,
        ),
      ),
      onSelected: (val) {
        if (val) setState(() => _targetTypeFilter = value);
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: _kTeal),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _editEvent(BuildContext context, Event event) async {
    final schools = _cachedSchools.isNotEmpty ? _cachedSchools : await _repo.getAllSchools();
    if (!context.mounted) return;
    final saved = await showDialog<Event>(
      context: context,
      builder: (_) => _EventFormDialog(
        campaignId: event.campaignId,
        event: event,
        schools: schools,
        employees: widget.employees,
      ),
    );
    if (saved != null) {
      await _repo.saveEvent(saved);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã cập nhật event.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _deleteEvent(BuildContext context, Event event) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        title: const Text('Xóa event?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Event "${event.name}" sẽ bị xóa khỏi chiến dịch.', style: const TextStyle(fontSize: 15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    await _repo.deleteEvent(event.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã xóa event.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context); // Pop back to CampaignManagementScreen
  }

  void _exportReport(BuildContext context, Event event) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng xuất báo cáo đang được phát triển.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _TimelineItem extends StatefulWidget {
  const _TimelineItem({
    required this.interaction,
    required this.targetName,
    required this.employeeName,
    required this.isLast,
  });

  final Interaction interaction;
  final String targetName;
  final String employeeName;
  final bool isLast;

  @override
  State<_TimelineItem> createState() => _TimelineItemState();
}

class _TimelineItemState extends State<_TimelineItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final interaction = widget.interaction;
    final typeLabel = switch (interaction.targetType) {
      'student' => 'Học sinh',
      'relative' => 'Phụ huynh',
      'person' => 'Cán bộ',
      _ => 'Khác',
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
        ? '${interaction.timestamp!.hour.toString().padLeft(2, '0')}:${interaction.timestamp!.minute.toString().padLeft(2, '0')}'
        : '--:--';

    return TweenAnimationBuilder<double>(
      key: ValueKey(interaction.id),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 15 * (1 - value)),
            child: child,
          ),
        );
      },
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Timeline Connector Column
            SizedBox(
              width: 32,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (!widget.isLast)
                    Positioned(
                      top: 24,
                      bottom: 0,
                      child: Container(
                        width: 1.5,
                        color: Colors.grey.shade200,
                      ),
                    ),
                  Positioned(
                    top: 14,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: typeColor,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: typeColor.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Right Side Card Content
            Expanded(
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: _isHovered ? Colors.grey.shade50 : _kCardBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isHovered ? typeColor.withOpacity(0.3) : Colors.grey.shade200,
                      width: 1,
                    ),
                    boxShadow: [
                      if (_isHovered)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      else
                        BoxShadow(
                          color: Colors.black.withOpacity(0.01),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                          const SizedBox(width: 8),
                          Text(
                            widget.targetName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            timeStr,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      if (interaction.notes.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          interaction.notes,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.person_outline, size: 14, color: Colors.grey.shade400),
                          const SizedBox(width: 4),
                          Text(
                            'Thực hiện: ${widget.employeeName}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailEmployeeCard extends StatefulWidget {
  const _DetailEmployeeCard({
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
  State<_DetailEmployeeCard> createState() => _DetailEmployeeCardState();
}

class _DetailEmployeeCardState extends State<_DetailEmployeeCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected;
    return TweenAnimationBuilder<double>(
      key: ValueKey(widget.id),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(-10 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: MouseRegion(
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
                  ? _kTeal.withOpacity(0.12)
                  : (_hovered ? _kTealLight.withOpacity(0.8) : Colors.white),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: active
                    ? _kTeal
                    : (_hovered ? _kTeal.withOpacity(0.5) : Colors.grey.shade200),
                width: active ? 1.5 : 1,
              ),
              boxShadow: [
                if (active || _hovered)
                  BoxShadow(
                    color: _kTeal.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                else
                  BoxShadow(
                    color: Colors.black.withOpacity(0.01),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: active ? _kTeal : _kTealLight,
                  child: Text(
                    widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '?',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: active ? Colors.white : _kTeal,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.email.isNotEmpty
                            ? widget.email
                            : 'ID: ${widget.id.length > 8 ? widget.id.substring(0, 8) : widget.id}...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (active)
                  const Icon(Icons.check_circle, size: 18, color: _kTeal)
                else
                  Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: _hovered ? _kTeal : Colors.grey.shade400,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
