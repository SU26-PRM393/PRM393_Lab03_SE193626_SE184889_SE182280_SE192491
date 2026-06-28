import 'dart:io' show File, Platform, HttpException;
import 'dart:convert' show jsonDecode, base64Encode, base64Decode;
import 'dart:ui' show ImageFilter;
import 'package:image/image.dart' as img_pkg;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

import 'package:vietnam_map_flutter/services/campaign_repository.dart';
import 'package:vietnam_map_flutter/firebase/notification_repository.dart';
import 'package:vietnam_map_flutter/models/campaign.dart';
import 'package:vietnam_map_flutter/models/event.dart';
import 'package:vietnam_map_flutter/models/school.dart';
import 'package:vietnam_map_flutter/models/interaction.dart';
import 'package:vietnam_map_flutter/services/auth_service.dart';
import 'package:vietnam_map_flutter/models/event_interaction.dart';
import 'package:vietnam_map_flutter/models/checkin.dart';

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
  const CampaignManagementScreen({
    super.key,
    required this.currentUser,
  });

  final AppUser currentUser;

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
                            currentUser: widget.currentUser,
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
                      currentUser: widget.currentUser,
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
                showAction: widget.currentUser.isAdmin,
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
                if (widget.currentUser.isAdmin)
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
    if (widget.currentUser.isAdmin) {
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
                currentUser: widget.currentUser,
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
    } else {
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, eventsSnapshot) {
          if (eventsSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: _kTeal));
          }
          final userCampaignIds = (eventsSnapshot.data?.docs ?? [])
              .map((doc) => Event.fromMap(doc.id, doc.data()))
              .where((e) =>
                  e.assignedEmployeeIds.contains(widget.currentUser.uid) ||
                  e.hostId == widget.currentUser.uid)
              .map((e) => e.campaignId)
              .toSet();

          return StreamBuilder<List<Campaign>>(
            stream: _repo.watchCampaigns(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: _kTeal));
              }
              var campaigns = snapshot.data ?? const <Campaign>[];
              campaigns = campaigns.where((c) => userCampaignIds.contains(c.id)).toList();

              if (_searchQuery.trim().isNotEmpty) {
                campaigns = campaigns
                    .where((c) =>
                        c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
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
                    currentUser: widget.currentUser,
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
        },
      );
    }
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
    required this.currentUser,
  });

  final Campaign campaign;
  final ValueChanged<Campaign> onCampaignChanged;
  final AppUser currentUser;

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
        var events = snapshot.data ?? const <Event>[];
        if (!widget.currentUser.isAdmin) {
          events = events
              .where((e) =>
                  e.assignedEmployeeIds.contains(widget.currentUser.uid) ||
                  e.hostId == widget.currentUser.uid)
              .toList();
        }
        final totalEvents = events.length;
        final completedEvents = events.where((e) => e.status == 'completed').length;
        final participants = events.fold<int>(0, (sum, e) => sum + e.totalInteractions);
        final staffCount = events.expand((e) => e.assignedEmployeeIds).toSet().length;

        final allEventsCompletedOrCanceled = events.isNotEmpty &&
            events.every((e) => e.status == 'completed' || e.status == 'canceled');
        final canCompleteCampaign = campaign.status != 'completed' &&
            campaign.status != 'canceled' &&
            allEventsCompletedOrCanceled;

        Widget _buildCampaignActions() {
          if (!widget.currentUser.isAdmin) return const SizedBox.shrink();

          return Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.end,
            children: [
              if (campaign.status == 'preparing')
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    final updated = campaign.copyWith(status: 'active');
                    await _repo.saveCampaign(updated);
                    widget.onCampaignChanged(updated);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã bắt đầu chiến dịch.')),
                      );
                    }
                  },
                  icon: const Icon(Icons.play_arrow, size: 18),
                  label: const Text('Bắt đầu chiến dịch', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              if (canCompleteCampaign)
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Hoàn thành chiến dịch?'),
                        content: const Text('Bạn có chắc chắn muốn đánh dấu chiến dịch này là hoàn thành?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Hủy'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Xác nhận'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      final updated = campaign.copyWith(status: 'completed');
                      await _repo.saveCampaign(updated);
                      widget.onCampaignChanged(updated);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Chiến dịch đã hoàn thành.')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Hoàn thành chiến dịch', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              if (campaign.status != 'completed' && campaign.status != 'canceled')
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Hủy chiến dịch?'),
                        content: const Text('Tất cả các sự kiện thuộc chiến dịch này cũng sẽ bị hủy. Bạn có chắc chắn?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Hủy'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: FilledButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text('Hủy chiến dịch'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      final updated = campaign.copyWith(status: 'canceled');
                      await _repo.saveCampaign(updated);
                      widget.onCampaignChanged(updated);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Chiến dịch và các sự kiện đã bị hủy.')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.cancel_outlined, size: 18),
                  label: const Text('Hủy chiến dịch', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              if (campaign.status == 'completed' || campaign.status == 'canceled')
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Tiếp tục chiến dịch?'),
                        content: const Text('Bạn có chắc chắn muốn khôi phục chiến dịch này về trạng thái hoạt động?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Hủy'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Xác nhận'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      final updated = campaign.copyWith(status: 'active');
                      await _repo.saveCampaign(updated);
                      widget.onCampaignChanged(updated);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Chiến dịch đã được đưa về trạng thái hoạt động.')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.settings_backup_restore, size: 18),
                  label: const Text('Quay lại hoạt động', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: _kTeal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _openEventForm(context),
                icon: const Icon(Icons.add_circle_outline, size: 18),
                label: const Text('Thêm event', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          );
        }

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
                        _buildCampaignActions(),
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: headerContent),
                      const SizedBox(width: 16),
                      _buildCampaignActions(),
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
                  currentUser: widget.currentUser,
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
    await NotificationRepository.instance.publishEventDeleted(
      campaignId: event.campaignId,
      eventId: event.id,
      eventName: event.name,
    );
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
    required this.currentUser,
  });

  final Campaign campaign;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final AppUser currentUser;

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
                          if (widget.currentUser.isAdmin) ...[
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
    required this.currentUser,
    required this.onEdit,
    required this.onDelete,
  });

  final Event event;
  final List<School> schools;
  final List<Map<String, String>> employees;
  final AppUser currentUser;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final school = event.schoolIds.isEmpty
        ? null
        : schools.where((s) => s.id == event.schoolIds.first).firstOrNull;

    final canManage = currentUser.isAdmin || event.hostId == currentUser.uid;

    final hostEmployee = employees.firstWhere(
      (e) => e['id'] == event.hostId,
      orElse: () => <String, String>{},
    );
    final hostName = hostEmployee['name'] ?? 'Chưa xác định';

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
                        Icon(Icons.person_pin_circle_outlined, size: 16, color: Colors.grey.shade500),
                        const SizedBox(width: 6),
                        Text(
                          'Người chủ trì: $hostName',
                          style: TextStyle(
                            color: cs.onSurfaceVariant,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                            currentUser: currentUser,
                          ),
                        ),
                      );
                    },
                  ),
                  if (canManage) ...[
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
                ],
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
    _status = campaign?.status ?? 'preparing';
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

double _getFallbackLatitude(String schoolId) {
  final hash = schoolId.hashCode;
  return 21.0278 + (hash % 100) / 1000.0;
}

double _getFallbackLongitude(String schoolId) {
  final hash = schoolId.hashCode;
  return 105.8342 + (hash % 100) / 1000.0;
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
  late final TextEditingController _latController;
  late final TextEditingController _lngController;
  late String _status;
  DateTime? _date;
  String? _schoolId;
  String? _hostId;
  late Set<String> _employeeIds;

  @override
  void initState() {
    super.initState();
    final event = widget.event;
    _nameController = TextEditingController(text: event?.name ?? '');
    _latController = TextEditingController(text: event?.latitude?.toString() ?? '');
    _lngController = TextEditingController(text: event?.longitude?.toString() ?? '');
    _status = event?.status ?? 'preparing';
    _date = event?.date;
    _hostId = event?.hostId;
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
    _latController.dispose();
    _lngController.dispose();
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
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: _hostId,
                  isExpanded: true,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                  decoration: _dialogInputDecoration('Người chủ trì (Main Host)'),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Chưa phân công host'),
                    ),
                    ...widget.employees
                        .where((emp) => !_employeeIds.contains(emp['id']) || emp['id'] == _hostId)
                        .map(
                      (emp) => DropdownMenuItem<String>(
                        value: emp['id'],
                        child: Text('${emp['name']} (${emp['email']})'),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _hostId = value;
                      if (value != null) {
                        _employeeIds.remove(value);
                      }
                    });
                  },
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _latController,
                        style: const TextStyle(fontSize: 15),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: _dialogInputDecoration('Vĩ độ (Lat)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _lngController,
                        style: const TextStyle(fontSize: 15),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: _dialogInputDecoration('Kinh độ (Lng)'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: 'Lấy vị trí hiện tại',
                      icon: const Icon(Icons.my_location, color: _kTeal),
                      onPressed: () async {
                        try {
                          final pos = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high,
                          );
                          setState(() {
                            _latController.text = pos.latitude.toString();
                            _lngController.text = pos.longitude.toString();
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Lỗi định vị: $e')),
                          );
                        }
                      },
                    ),
                  ],
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
                      final isHost = id == _hostId;
                      return CheckboxListTile(
                        dense: true,
                        value: isHost ? false : _employeeIds.contains(id),
                        enabled: !isHost,
                        title: Text(
                          employee['name'] ?? 'Unknown',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isHost ? Colors.grey : Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          isHost 
                              ? 'Đang là Người chủ trì (Host)' 
                              : (employee['email'] ?? ''),
                          style: TextStyle(
                            fontSize: 13,
                            color: isHost ? Colors.orange.shade700 : Colors.grey.shade600,
                            fontWeight: isHost ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        onChanged: isHost
                            ? null
                            : (selected) {
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
            double? lat = double.tryParse(_latController.text);
            double? lng = double.tryParse(_lngController.text);

            if (lat == null || lng == null) {
              if (_schoolId != null) {
                lat = _getFallbackLatitude(_schoolId!);
                lng = _getFallbackLongitude(_schoolId!);
              }
            }

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
                hostId: _hostId,
                latitude: lat,
                longitude: lng,
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
    this.showAction = true,
  });

  final String title;
  final String actionLabel;
  final IconData icon;
  final VoidCallback onAction;
  final bool showAction;

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
          if (showAction)
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
      'preparing' => (const Color(0xFFF59E0B), Icons.schedule_outlined),
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
      'preparing' => 'Chuẩn bị',
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
    required this.currentUser,
  });

  final Event event;
  final School? school;
  final List<Map<String, String>> employees;
  final AppUser currentUser;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> with SingleTickerProviderStateMixin {
  final _repo = CampaignRepository.instance;
  Map<String, String> _targetNames = {};
  bool _isLoadingTargetNames = true;
  List<School> _cachedSchools = []; // Cache list of schools to make Edit dialog open instantly
  late TabController _tabController;

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
    _tabController = TabController(length: 2, vsync: this);
    _eventStream = _watchEvent(widget.event.id);
    _interactionsStream = _repo.getInteractionsStreamForEvent(widget.event.id);
    _loadTargetNames();
    _loadSchools();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  bool _isIncrementalLoading = false;

  Future<void> _loadMissingTargetNames(List<Map<String, String>> refs) async {
    if (_isIncrementalLoading || refs.isEmpty) return;
    _isIncrementalLoading = true;
    try {
      final names = await _repo.getTargetNames(refs);
      if (mounted) {
        setState(() {
          _targetNames.addAll(names);
        });
      }
    } catch (_) {
    } finally {
      _isIncrementalLoading = false;
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> _watchEvent(String id) {
    return FirebaseFirestore.instance.collection('events').doc(id).snapshots();
  }

  Future<Position?> _getCurrentLocation({double? defaultLat, double? defaultLng}) async {
    if (Platform.isWindows) {
      // Windows desktops lack physical GPS hardware. Return fallback/event coordinates to prevent hanging.
      return Position(
        latitude: defaultLat ?? 21.0285,
        longitude: defaultLng ?? 105.8542,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Dịch vụ định vị GPS bị tắt. Vui lòng bật định vị trên thiết bị.';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Quyền định vị bị từ chối.';
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw 'Quyền định vị bị từ chối vĩnh viễn.';
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).timeout(const Duration(seconds: 7));
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

            // Fetch any missing target names incrementally in the background
            final missingRefs = interactions
                .where((i) => i.targetId.isNotEmpty && !_targetNames.containsKey(i.targetId))
                .map((i) => {'type': i.targetType, 'id': i.targetId})
                .toList();
            if (missingRefs.isNotEmpty && !_isIncrementalLoading) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _loadMissingTargetNames(missingRefs);
              });
            }

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
              body: Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width < 600 ? 12.0 : 24.0),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1400),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 950;
                        
                        final sidebar = _buildSidebar(context, event, widget.school, interactions, employeeNameMap);
                        
                        final mainContent = Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              color: Colors.white,
                              child: TabBar(
                                controller: _tabController,
                                labelColor: _kTeal,
                                unselectedLabelColor: Colors.grey,
                                indicatorColor: _kTeal,
                                tabs: const [
                                  Tab(text: 'Tương tác & Lịch sử'),
                                  Tab(text: 'Điểm danh & Check-in'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  _buildTimelineSection(context, event, interactions, employeeNameMap),
                                  _buildCheckInSection(context, event, employeeNameMap),
                                ],
                              ),
                            ),
                          ],
                        );

                        if (isWide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 400,
                                child: sidebar,
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: mainContent,
                              ),
                            ],
                          );
                        } else {
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                sidebar,
                                const SizedBox(height: 24),
                                SizedBox(
                                  height: 650,
                                  child: mainContent,
                                ),
                              ],
                            ),
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
    final isHostOrAdmin = widget.currentUser.isAdmin || event.hostId == widget.currentUser.uid;

    return SingleChildScrollView(
      child: Column(
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
              if (event.hostId != null) ...[
                const SizedBox(height: 16),
                _buildDetailRow(
                  Icons.person_pin_circle_outlined,
                  'Người chủ trì (Host)',
                  employeeNameMap[event.hostId] ?? 'Không rõ',
                ),
              ],
              if (isHostOrAdmin) ...[
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
                if (event.status == 'preparing') ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: _kTeal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            await FirebaseFirestore.instance.collection('events').doc(event.id).update({
                              'status': 'in-progress',
                              'updatedAt': FieldValue.serverTimestamp(),
                            });
                            await NotificationRepository.instance.publishEventChange(
                              campaignId: event.campaignId,
                              eventId: event.id,
                              eventName: event.name,
                              status: 'in-progress',
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Đã bắt đầu sự kiện.')),
                              );
                            }
                          },
                          icon: const Icon(Icons.play_circle_outline, size: 18),
                          label: const Text('Bắt đầu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Hủy sự kiện?'),
                                content: const Text('Bạn có chắc chắn muốn hủy sự kiện này?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Quay lại'),
                                  ),
                                  FilledButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    style: FilledButton.styleFrom(backgroundColor: Colors.red),
                                    child: const Text('Hủy sự kiện'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await FirebaseFirestore.instance.collection('events').doc(event.id).update({
                                'status': 'canceled',
                                'updatedAt': FieldValue.serverTimestamp(),
                              });
                              await NotificationRepository.instance.publishEventChange(
                                campaignId: event.campaignId,
                                eventId: event.id,
                                eventName: event.name,
                                status: 'canceled',
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Đã hủy sự kiện.')),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.cancel_outlined, size: 18),
                          label: const Text('Hủy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ),
                    ],
                  ),
                ] else if (event.status == 'in-progress') ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.orange.shade800,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Kết thúc sự kiện?'),
                                content: const Text('Sau khi kết thúc, nhân viên sẽ không thể check-in sự kiện này nữa.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Hủy'),
                                  ),
                                  FilledButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Xác nhận'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await FirebaseFirestore.instance.collection('events').doc(event.id).update({
                                'status': 'completed',
                                'updatedAt': FieldValue.serverTimestamp(),
                              });
                              await NotificationRepository.instance.publishEventChange(
                                campaignId: event.campaignId,
                                eventId: event.id,
                                eventName: event.name,
                                status: 'completed',
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Đã kết thúc sự kiện.')),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.stop_circle_outlined, size: 18),
                          label: const Text('Kết thúc', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Hủy sự kiện?'),
                                content: const Text('Bạn có chắc chắn muốn hủy sự kiện này?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Quay lại'),
                                  ),
                                  FilledButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    style: FilledButton.styleFrom(backgroundColor: Colors.red),
                                    child: const Text('Hủy sự kiện'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await FirebaseFirestore.instance.collection('events').doc(event.id).update({
                                'status': 'canceled',
                                'updatedAt': FieldValue.serverTimestamp(),
                              });
                              await NotificationRepository.instance.publishEventChange(
                                campaignId: event.campaignId,
                                eventId: event.id,
                                eventName: event.name,
                                status: 'canceled',
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Đã hủy sự kiện.')),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.cancel_outlined, size: 18),
                          label: const Text('Hủy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ),
                    ],
                  ),
                ] else if (event.status == 'completed' || event.status == 'canceled') ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.teal.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Tiếp tục sự kiện?'),
                            content: const Text('Bạn có chắc chắn muốn khôi phục sự kiện này về trạng thái đang diễn ra?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Hủy'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Xác nhận'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await FirebaseFirestore.instance.collection('events').doc(event.id).update({
                            'status': 'in-progress',
                            'updatedAt': FieldValue.serverTimestamp(),
                          });
                          await NotificationRepository.instance.publishEventChange(
                            campaignId: event.campaignId,
                            eventId: event.id,
                            eventName: event.name,
                            status: 'in-progress',
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Sự kiện đã được khôi phục về trạng thái đang diễn ra.')),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.settings_backup_restore, size: 18),
                      label: const Text('Quay lại hoạt động', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ],
              ],
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
        if (event.hostId != null) ...[
          const SizedBox(height: 24),
          // Host Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Người chủ trì (Host)',
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
                  '1',
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
          Builder(
            builder: (context) {
              final hostName = employeeNameMap[event.hostId] ?? 'Không rõ';
              final hostMap = widget.employees.firstWhere((e) => e['id'] == event.hostId, orElse: () => <String, String>{});
              final hostEmail = hostMap['email'] ?? '';
              final isSelected = _selectedEmployeeFilterId == event.hostId;
              return _DetailEmployeeCard(
                name: hostName,
                id: event.hostId!,
                email: hostEmail,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    if (_selectedEmployeeFilterId == event.hostId) {
                      _selectedEmployeeFilterId = null;
                    } else {
                      _selectedEmployeeFilterId = event.hostId;
                    }
                  });
                },
              );
            }
          ),
        ],
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
              final employeeMap = widget.employees.firstWhere((e) => e['id'] == empId, orElse: () => <String, String>{});
              final email = employeeMap['email'] ?? '';
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
    ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lịch sử tương tác (${list.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              if (event.status != 'completed')
                TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: _kTeal.withOpacity(0.08),
                    foregroundColor: _kTeal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text(
                    'Thêm tương tác',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => _openAddInteractionDialog(context, event),
                ),
            ],
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
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
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
                        final tName = interaction.targetName.isNotEmpty
                            ? interaction.targetName
                            : (_targetNames[interaction.targetId] ?? 'Không rõ');
                        final eName = employeeNameMap[interaction.employeeId] ?? 'Không rõ';
                        final isLast = gIdx == grouped.length - 1 && idx == groupList.length - 1;
                        final canDelete = widget.currentUser.isAdmin || interaction.employeeId == widget.currentUser.uid;
                        return _TimelineItem(
                          interaction: interaction,
                          targetName: tName,
                          employeeName: eName,
                          isLast: isLast,
                          canDelete: canDelete,
                          onDelete: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                title: const Text('Xóa tương tác?', style: TextStyle(fontWeight: FontWeight.bold)),
                                content: const Text('Bạn có chắc chắn muốn xóa tương tác này? Hành động này không thể khôi phục.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Hủy'),
                                  ),
                                  FilledButton(
                                    style: FilledButton.styleFrom(backgroundColor: Colors.red),
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Xóa'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              try {
                                await CampaignRepository.instance.deleteInteraction(interaction.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Đã xóa tương tác.')),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Lỗi: $e')),
                                  );
                                }
                              }
                            }
                          },
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openAddInteractionDialog(BuildContext context, Event event) async {
    // Show a loading indicator while fetching targets in the background
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: _kTeal)),
    );
    
    final schoolId = event.schoolIds.isNotEmpty ? event.schoolIds.first : null;
    List<Map<String, dynamic>> studentsList = [];
    List<Map<String, dynamic>> personsList = [];
    List<Map<String, dynamic>> relativesList = [];
    try {
      // Fetch students globally
      final studentsSnap = await FirebaseFirestore.instance
          .collection('students')
          .get();
      studentsList = studentsSnap.docs.map((doc) => {
        'id': doc.id,
        'name': doc.data()['name'] ?? 'Không rõ',
        'className': doc.data()['className'] ?? '',
        'studentCode': doc.data()['studentCode'] ?? '',
        'schoolId': doc.data()['schoolId'] ?? '',
      }).toList();

      // Fetch persons globally
      final pSnap = await FirebaseFirestore.instance
          .collection('persons')
          .get();
      personsList = pSnap.docs.map((doc) => {
        'id': doc.id,
        'name': doc.data()['name'] ?? 'Không rõ',
        'email': doc.data()['email'] ?? '',
        'phone': doc.data()['phone'] ?? '',
        'roleType': doc.data()['roleType'] ?? '',
        'schoolId': doc.data()['schoolId'] ?? '',
      }).toList();

      // Sort students and persons so that matches for the event's schoolId appear first
      if (schoolId != null) {
        studentsList.sort((a, b) {
          final aMatch = a['schoolId'] == schoolId ? 0 : 1;
          final bMatch = b['schoolId'] == schoolId ? 0 : 1;
          return aMatch.compareTo(bMatch);
        });
        personsList.sort((a, b) {
          final aMatch = a['schoolId'] == schoolId ? 0 : 1;
          final bMatch = b['schoolId'] == schoolId ? 0 : 1;
          return aMatch.compareTo(bMatch);
        });
      }

       // Fetch relatives
      final rSnap = await FirebaseFirestore.instance
          .collection('relatives')
          .get();
      relativesList = rSnap.docs.map((doc) => {
        'id': doc.id,
        'name': doc.data()['name'] ?? 'Không rõ',
        'phone': doc.data()['phone'] ?? '',
        'relationship': doc.data()['relationship'] ?? '',
        'studentId': doc.data()['studentId'] ?? '',
      }).toList();

      // Ensure all school details of students and persons are cached
      final List<String> schoolIdsToFetch = [];
      for (final s in studentsList) {
        final String sid = s['schoolId'] ?? '';
        if (sid.isNotEmpty && !_cachedSchools.any((sch) => sch.id == sid) && !schoolIdsToFetch.contains(sid)) {
          schoolIdsToFetch.add(sid);
        }
      }
      for (final p in personsList) {
        final String sid = p['schoolId'] ?? '';
        if (sid.isNotEmpty && !_cachedSchools.any((sch) => sch.id == sid) && !schoolIdsToFetch.contains(sid)) {
          schoolIdsToFetch.add(sid);
        }
      }
      if (schoolIdsToFetch.isNotEmpty) {
        final fetched = await _repo.getSchoolsByIds(schoolIdsToFetch);
        if (mounted) {
          setState(() {
            _cachedSchools.addAll(fetched);
          });
        }
      }
    } catch (_) {}
    
    if (context.mounted) {
      Navigator.pop(context); // Dismiss loading dialog
    }

    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final notesController = TextEditingController();
    
    // Student fields
    final classNameController = TextEditingController();
    final studentCodeController = TextEditingController();
    
    // Relative fields
    final phoneController = TextEditingController();
    String relationship = 'mother';
    String? selectedStudentId;
    
    // Person fields
    final emailController = TextEditingController();
    final personPhoneController = TextEditingController();
    String roleType = 'teacher';

    final searchTargetController = TextEditingController();
    final searchSchoolController = TextEditingController();
    final searchStudentController = TextEditingController();

    String targetType = 'student';
    String? selectedTargetId;

    final initialSchool = event.schoolIds.isNotEmpty ? event.schoolIds.first : null;
    String? selectedSchoolId = initialSchool;

    if (!context.mounted) return;

    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final isExisting = selectedTargetId != null;
            bool isSaving = false;

            // Filter target lists based on search query
            final query = searchTargetController.text.toLowerCase().trim();

            final filteredStudents = (query.isEmpty || targetType != 'student')
                ? <Map<String, dynamic>>[]
                : studentsList.where((s) {
                    final name = (s['name'] as String).toLowerCase();
                    final className = (s['className'] as String).toLowerCase();
                    final studentCode = (s['studentCode'] as String).toLowerCase();
                    return name.contains(query) || className.contains(query) || studentCode.contains(query);
                  }).take(5).toList();

            final filteredRelatives = (query.isEmpty || targetType != 'relative')
                ? <Map<String, dynamic>>[]
                : relativesList.where((r) {
                    final name = (r['name'] as String).toLowerCase();
                    final phone = (r['phone'] as String).toLowerCase();
                    return name.contains(query) || phone.contains(query);
                  }).take(5).toList();

            final filteredPersons = (query.isEmpty || targetType != 'person')
                ? <Map<String, dynamic>>[]
                : personsList.where((p) {
                    final name = (p['name'] as String).toLowerCase();
                    final email = (p['email'] as String).toLowerCase();
                    final phone = (p['phone'] as String).toLowerCase();
                    return name.contains(query) || email.contains(query) || phone.contains(query);
                  }).take(5).toList();

             final schoolQuery = searchSchoolController.text.toLowerCase().trim();
            final filteredSchools = schoolQuery.isEmpty
                ? <School>[]
                : _cachedSchools.where((sch) {
                    return sch.schoolName.toLowerCase().contains(schoolQuery);
                  }).take(5).toList();

            final studentSearchQuery = searchStudentController.text.toLowerCase().trim();
            final filteredStudentsForRelative = studentSearchQuery.isEmpty
                ? <Map<String, dynamic>>[]
                : studentsList.where((s) {
                    final name = (s['name'] as String).toLowerCase();
                    final className = (s['className'] as String).toLowerCase();
                    final studentCode = (s['studentCode'] as String).toLowerCase();
                    return name.contains(studentSearchQuery) || className.contains(studentSearchQuery) || studentCode.contains(studentSearchQuery);
                  }).take(5).toList();

            bool isFormValid() {
              if (nameController.text.trim().isEmpty) return false;
              if (targetType == 'student') {
                if (classNameController.text.trim().isEmpty) return false;
                if (studentCodeController.text.trim().isEmpty) return false;
                if (selectedSchoolId == null && !isExisting) return false;
              } else if (targetType == 'person') {
                if (personPhoneController.text.trim().isEmpty) return false;
                if (emailController.text.trim().isEmpty || !emailController.text.contains('@')) return false;
                if (selectedSchoolId == null && !isExisting) return false;
              } else if (targetType == 'relative') {
                if (phoneController.text.trim().isEmpty) return false;
                if (selectedStudentId == null && !isExisting) return false;
              }
              return true;
            }

            final canSubmit = isFormValid();

            Widget buildFieldLabel(String label, {bool isRequired = false}) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    if (isRequired) ...[
                      const SizedBox(width: 4),
                      Text('*', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ],
                  ],
                ),
              );
            }

            InputDecoration premiumInputDecoration({required String hintText, IconData? prefixIcon, Widget? suffixIcon}) {
              return InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey.shade500, size: 20) : null,
                suffixIcon: suffixIcon,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _kTeal, width: 2.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.red.shade400, width: 2.0),
                ),
              );
            }

            return Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                width: 760,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 60,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(28),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _kTeal.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.chat_bubble_outline, color: _kTeal, size: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Thêm tương tác mới',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Ghi nhận thông tin tương tác với học sinh, phụ huynh hoặc cán bộ.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.grey.shade400),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const Divider(height: 32, thickness: 1),

                        // Section 1 — Đối tượng
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ĐỐI TƯỢNG TƯƠNG TÁC',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 12),
                              buildFieldLabel('Chọn loại đối tượng'),
                              DropdownButtonFormField<String>(
                                value: targetType,
                                decoration: premiumInputDecoration(hintText: 'Chọn đối tượng'),
                                items: const [
                                  DropdownMenuItem(value: 'student', child: Text('Học sinh')),
                                  DropdownMenuItem(value: 'relative', child: Text('Phụ huynh')),
                                  DropdownMenuItem(value: 'person', child: Text('Cán bộ trường')),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    setDialogState(() {
                                      targetType = val;
                                      selectedTargetId = null;
                                      nameController.clear();
                                      classNameController.clear();
                                      studentCodeController.clear();
                                      phoneController.clear();
                                      relationship = 'mother';
                                      selectedStudentId = null;
                                      emailController.clear();
                                      personPhoneController.clear();
                                      roleType = 'teacher';
                                      searchTargetController.clear();
                                    });
                                  }
                                },
                              ),
                              if (selectedTargetId != null) ...[
                                const SizedBox(height: 14),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.teal.shade50.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.teal.shade200),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.teal.shade100,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          targetType == 'student'
                                              ? Icons.school_outlined
                                              : targetType == 'relative'
                                                  ? Icons.people_outline
                                                  : Icons.badge_outlined,
                                          color: _kTeal,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Đã chọn ${targetType == 'student' ? 'Học sinh' : targetType == 'relative' ? 'Phụ huynh' : 'Cán bộ'} từ hệ thống',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.teal.shade800,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              nameController.text,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(20),
                                          onTap: () {
                                            setDialogState(() {
                                              selectedTargetId = null;
                                              nameController.clear();
                                              classNameController.clear();
                                              studentCodeController.clear();
                                              phoneController.clear();
                                              relationship = 'mother';
                                              selectedStudentId = null;
                                              emailController.clear();
                                              personPhoneController.clear();
                                              roleType = 'teacher';
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.red.shade200),
                                            ),
                                            child: Icon(Icons.close, color: Colors.red.shade600, size: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ] else ...[
                                const SizedBox(height: 14),
                                buildFieldLabel('Tìm kiếm đối tượng có sẵn (nếu có)'),
                                TextFormField(
                                  controller: searchTargetController,
                                  decoration: premiumInputDecoration(
                                    hintText: 'Tìm kiếm theo tên, mã hoặc số điện thoại...',
                                    prefixIcon: Icons.search,
                                    suffixIcon: searchTargetController.text.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(Icons.clear, size: 18),
                                            onPressed: () {
                                              setDialogState(() {
                                                searchTargetController.clear();
                                              });
                                            },
                                          )
                                        : null,
                                  ),
                                  onChanged: (val) {
                                    setDialogState(() {});
                                  },
                                ),
                                if (searchTargetController.text.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    constraints: const BoxConstraints(maxHeight: 200),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey.shade200),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: ListView(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        children: [
                                          ...filteredStudents.map((s) {
                                            final school = _cachedSchools.firstWhere(
                                              (sch) => sch.id == s['schoolId'],
                                              orElse: () => School(id: '', provinceCode: '', provinceName: '', communeCode: '', communeName: '', schoolCode: '', schoolName: '', address: '', region: ''),
                                            );
                                            final schoolInfo = school.schoolName.isNotEmpty ? ' • ${school.schoolName}' : '';
                                            return ListTile(
                                              dense: true,
                                              leading: const Icon(Icons.school, color: Colors.blue),
                                              title: Text(s['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                                              subtitle: Text('Học sinh • Lớp ${s['className']}$schoolInfo'),
                                              onTap: () {
                                                setDialogState(() {
                                                  selectedTargetId = s['id'];
                                                  targetType = 'student';
                                                  nameController.text = s['name'] ?? '';
                                                  classNameController.text = s['className'] ?? '';
                                                  studentCodeController.text = s['studentCode'] ?? '';
                                                  selectedSchoolId = (s['schoolId'] as String?)?.isNotEmpty == true ? s['schoolId'] : null;
                                                  searchTargetController.clear();
                                                });
                                              },
                                            );
                                          }),
                                          ...filteredPersons.map((p) {
                                            final school = _cachedSchools.firstWhere(
                                              (sch) => sch.id == p['schoolId'],
                                              orElse: () => School(id: '', provinceCode: '', provinceName: '', communeCode: '', communeName: '', schoolCode: '', schoolName: '', address: '', region: ''),
                                            );
                                            final schoolInfo = school.schoolName.isNotEmpty ? ' • ${school.schoolName}' : '';
                                            return ListTile(
                                              dense: true,
                                              leading: const Icon(Icons.badge, color: Colors.orange),
                                              title: Text(p['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                                              subtitle: Text('Cán bộ • ${p['roleType'] == 'teacher' ? 'Giáo viên' : p['roleType'] == 'principal' ? 'Hiệu trưởng' : 'Nhân viên'}$schoolInfo'),
                                              onTap: () {
                                                setDialogState(() {
                                                  selectedTargetId = p['id'];
                                                  targetType = 'person';
                                                  nameController.text = p['name'] ?? '';
                                                  emailController.text = p['email'] ?? '';
                                                  personPhoneController.text = p['phone'] ?? '';
                                                  roleType = p['roleType'] ?? 'teacher';
                                                  selectedSchoolId = (p['schoolId'] as String?)?.isNotEmpty == true ? p['schoolId'] : null;
                                                  searchTargetController.clear();
                                                });
                                              },
                                            );
                                          }),
                                          ...filteredRelatives.map((r) {
                                            final relatedStudent = studentsList.firstWhere(
                                              (s) => s['id'] == r['studentId'],
                                              orElse: () => {},
                                            );
                                            final school = relatedStudent.isNotEmpty
                                                ? _cachedSchools.firstWhere(
                                                    (sch) => sch.id == relatedStudent['schoolId'],
                                                    orElse: () => School(id: '', provinceCode: '', provinceName: '', communeCode: '', communeName: '', schoolCode: '', schoolName: '', address: '', region: ''),
                                                  )
                                                : null;
                                            final studentInfo = relatedStudent.isNotEmpty
                                                ? ' • Con: ${relatedStudent['name']} (Mã: ${relatedStudent['studentCode']}, Lớp: ${relatedStudent['className']}${school != null && school.schoolName.isNotEmpty ? ', Trường: ${school.schoolName}' : ''})'
                                                : '';
                                            return ListTile(
                                              dense: true,
                                              leading: const Icon(Icons.people, color: Colors.purple),
                                              title: Text(r['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                                              subtitle: Text('Phụ huynh$studentInfo • SĐT: ${r['phone']}'),
                                              onTap: () {
                                                setDialogState(() {
                                                  selectedTargetId = r['id'];
                                                  targetType = 'relative';
                                                  nameController.text = r['name'] ?? '';
                                                  phoneController.text = r['phone'] ?? '';
                                                  relationship = r['relationship'] ?? 'mother';
                                                  selectedStudentId = r['studentId'] ?? '';
                                                  searchTargetController.clear();
                                                });
                                              },
                                            );
                                          }),
                                          if (filteredStudents.isEmpty && filteredPersons.isEmpty && filteredRelatives.isEmpty)
                                            const Padding(
                                              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                                              child: Text(
                                                'Không tìm thấy kết quả phù hợp',
                                                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Section 2 — Thông tin chi tiết
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'THÔNG TIN NGƯỜI ĐƯỢC TƯƠNG TÁC',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              buildFieldLabel(
                                targetType == 'student'
                                    ? 'Tên học sinh'
                                    : targetType == 'relative'
                                        ? 'Tên phụ huynh'
                                        : 'Tên cán bộ',
                                isRequired: true,
                              ),
                              TextFormField(
                                controller: nameController,
                                enabled: !isExisting,
                                decoration: premiumInputDecoration(
                                  hintText: targetType == 'student'
                                      ? 'Nhập họ và tên học sinh...'
                                      : targetType == 'relative'
                                          ? 'Nhập họ và tên phụ huynh...'
                                          : 'Nhập họ và tên cán bộ...',
                                  prefixIcon: Icons.person_outline,
                                ),
                                validator: (val) => val == null || val.trim().isEmpty ? 'Vui lòng nhập tên' : null,
                                onChanged: (_) => setDialogState(() {}),
                              ),
                              
                              if (targetType == 'student') ...[
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          buildFieldLabel('Lớp học', isRequired: true),
                                          TextFormField(
                                            controller: classNameController,
                                            enabled: !isExisting,
                                            decoration: premiumInputDecoration(hintText: 'VD: 12A1', prefixIcon: Icons.class_outlined),
                                            validator: (val) => val == null || val.trim().isEmpty ? 'Nhập lớp học' : null,
                                            onChanged: (_) => setDialogState(() {}),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          buildFieldLabel('Mã học sinh', isRequired: true),
                                          TextFormField(
                                            controller: studentCodeController,
                                            enabled: !isExisting,
                                            decoration: premiumInputDecoration(hintText: 'VD: HS1023', prefixIcon: Icons.badge_outlined),
                                            validator: (val) => val == null || val.trim().isEmpty ? 'Nhập mã học sinh' : null,
                                            onChanged: (_) => setDialogState(() {}),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                buildFieldLabel('Trường học', isRequired: true),
                                if (selectedSchoolId != null) ...[
                                  (() {
                                    final sch = _cachedSchools.firstWhere(
                                      (s) => s.id == selectedSchoolId,
                                      orElse: () => School(id: '', provinceCode: '', provinceName: '', communeCode: '', communeName: '', schoolCode: '', schoolName: 'Không rõ', address: '', region: ''),
                                    );
                                    return Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: Colors.blue.shade200),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade100,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(Icons.school, color: Colors.blue.shade700, size: 24),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Trường học đã chọn',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.blue.shade800,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  sch.schoolName,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade600),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        sch.address.isNotEmpty ? sch.address : '${sch.communeName}, ${sch.provinceName}',
                                                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (!isExisting)
                                            Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius: BorderRadius.circular(20),
                                                onTap: () => setDialogState(() => selectedSchoolId = null),
                                                child: Container(
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: Colors.red.shade200),
                                                  ),
                                                  child: Icon(Icons.close, color: Colors.red.shade600, size: 16),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  })(),
                                ] else ...[
                                  TextFormField(
                                    controller: searchSchoolController,
                                    decoration: premiumInputDecoration(
                                      hintText: 'Tìm kiếm trường học...',
                                      prefixIcon: Icons.search,
                                      suffixIcon: searchSchoolController.text.isNotEmpty
                                          ? IconButton(
                                              icon: const Icon(Icons.clear, size: 18),
                                              onPressed: () {
                                                setDialogState(() {
                                                  searchSchoolController.clear();
                                                });
                                              },
                                            )
                                          : null,
                                    ),
                                    onChanged: (val) {
                                      setDialogState(() {});
                                    },
                                  ),
                                  if (searchSchoolController.text.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Container(
                                      constraints: const BoxConstraints(maxHeight: 180),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey.shade200),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.04),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: ListView(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          children: [
                                            ...filteredSchools.map((sch) => ListTile(
                                                  dense: true,
                                                  leading: const Icon(Icons.location_city, color: Colors.blue),
                                                  title: Text(sch.schoolName, style: const TextStyle(fontWeight: FontWeight.w600)),
                                                  subtitle: Text(
                                                    sch.address.isNotEmpty ? sch.address : '${sch.communeName}, ${sch.provinceName}',
                                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  onTap: () {
                                                    setDialogState(() {
                                                      selectedSchoolId = sch.id;
                                                      searchSchoolController.clear();
                                                    });
                                                  },
                                                )),
                                            if (filteredSchools.isEmpty)
                                              const Padding(
                                                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                                child: Text(
                                                  'Không tìm thấy trường học nào',
                                                  style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Section 2 (Cán bộ / Phụ huynh)
                        if (targetType == 'person') ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          buildFieldLabel('Số điện thoại', isRequired: true),
                                          TextFormField(
                                            controller: personPhoneController,
                                            enabled: !isExisting,
                                            decoration: premiumInputDecoration(hintText: 'VD: 0987654321', prefixIcon: Icons.phone_outlined),
                                            keyboardType: TextInputType.phone,
                                            validator: (val) => val == null || val.trim().isEmpty ? 'Nhập số điện thoại' : null,
                                            onChanged: (_) => setDialogState(() {}),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          buildFieldLabel('Vai trò', isRequired: true),
                                          DropdownButtonFormField<String>(
                                            value: roleType,
                                            decoration: premiumInputDecoration(hintText: 'Chọn vai trò'),
                                            items: const [
                                              DropdownMenuItem(value: 'principal', child: Text('Hiệu trưởng')),
                                              DropdownMenuItem(value: 'teacher', child: Text('Giáo viên')),
                                              DropdownMenuItem(value: 'staff', child: Text('Nhân viên')),
                                              DropdownMenuItem(value: 'other', child: Text('Khác')),
                                            ],
                                            onChanged: !isExisting
                                                ? (val) {
                                                    if (val != null) {
                                                      setDialogState(() => roleType = val);
                                                    }
                                                  }
                                                : null,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                buildFieldLabel('Email', isRequired: true),
                                TextFormField(
                                  controller: emailController,
                                  enabled: !isExisting,
                                  decoration: premiumInputDecoration(hintText: 'VD: email@school.edu.vn', prefixIcon: Icons.mail_outline),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) return 'Nhập email';
                                    if (!val.contains('@')) return 'Email không hợp lệ';
                                    return null;
                                  },
                                  onChanged: (_) => setDialogState(() {}),
                                ),
                                const SizedBox(height: 14),
                                buildFieldLabel('Trường học', isRequired: true),
                                if (selectedSchoolId != null) ...[
                                  (() {
                                    final sch = _cachedSchools.firstWhere(
                                      (s) => s.id == selectedSchoolId,
                                      orElse: () => School(id: '', provinceCode: '', provinceName: '', communeCode: '', communeName: '', schoolCode: '', schoolName: 'Không rõ', address: '', region: ''),
                                    );
                                    return Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: Colors.blue.shade200),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade100,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(Icons.school, color: Colors.blue.shade700, size: 24),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Trường học đã chọn',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.blue.shade800,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  sch.schoolName,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade600),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        sch.address.isNotEmpty ? sch.address : '${sch.communeName}, ${sch.provinceName}',
                                                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (!isExisting)
                                            Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius: BorderRadius.circular(20),
                                                onTap: () => setDialogState(() => selectedSchoolId = null),
                                                child: Container(
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: Colors.red.shade200),
                                                  ),
                                                  child: Icon(Icons.close, color: Colors.red.shade600, size: 16),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  })(),
                                ] else ...[
                                  TextFormField(
                                    controller: searchSchoolController,
                                    decoration: premiumInputDecoration(
                                      hintText: 'Tìm kiếm trường học...',
                                      prefixIcon: Icons.search,
                                      suffixIcon: searchSchoolController.text.isNotEmpty
                                          ? IconButton(
                                              icon: const Icon(Icons.clear, size: 18),
                                              onPressed: () {
                                                setDialogState(() {
                                                  searchSchoolController.clear();
                                                });
                                              },
                                            )
                                          : null,
                                    ),
                                    onChanged: (val) {
                                      setDialogState(() {});
                                    },
                                  ),
                                  if (searchSchoolController.text.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Container(
                                      constraints: const BoxConstraints(maxHeight: 180),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey.shade200),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.04),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: ListView(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          children: [
                                            ...filteredSchools.map((sch) => ListTile(
                                                  dense: true,
                                                  leading: const Icon(Icons.location_city, color: Colors.blue),
                                                  title: Text(sch.schoolName, style: const TextStyle(fontWeight: FontWeight.w600)),
                                                  subtitle: Text(
                                                    sch.address.isNotEmpty ? sch.address : '${sch.communeName}, ${sch.provinceName}',
                                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  onTap: () {
                                                    setDialogState(() {
                                                      selectedSchoolId = sch.id;
                                                      searchSchoolController.clear();
                                                    });
                                                  },
                                                )),
                                            if (filteredSchools.isEmpty)
                                              const Padding(
                                                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                                child: Text(
                                                  'Không tìm thấy trường học nào',
                                                  style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ),
                        ] else if (targetType == 'relative') ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          buildFieldLabel('Số điện thoại', isRequired: true),
                                          TextFormField(
                                            controller: phoneController,
                                            enabled: !isExisting,
                                            decoration: premiumInputDecoration(hintText: 'VD: 0912345678', prefixIcon: Icons.phone_outlined),
                                            keyboardType: TextInputType.phone,
                                            validator: (val) => val == null || val.trim().isEmpty ? 'Nhập số điện thoại' : null,
                                            onChanged: (_) => setDialogState(() {}),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          buildFieldLabel('Mối quan hệ', isRequired: true),
                                          DropdownButtonFormField<String>(
                                            value: relationship,
                                            decoration: premiumInputDecoration(hintText: 'Chọn mối quan hệ'),
                                            items: const [
                                              DropdownMenuItem(value: 'mother', child: Text('Mẹ')),
                                              DropdownMenuItem(value: 'father', child: Text('Bố')),
                                              DropdownMenuItem(value: 'other', child: Text('Khác')),
                                            ],
                                            onChanged: !isExisting
                                                ? (val) {
                                                    if (val != null) {
                                                      setDialogState(() => relationship = val);
                                                    }
                                                  }
                                                : null,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                buildFieldLabel('Học sinh liên quan', isRequired: true),
                                if (selectedStudentId != null) ...[
                                  (() {
                                    final st = studentsList.firstWhere((s) => s['id'] == selectedStudentId, orElse: () => {});
                                    if (st.isEmpty) return const SizedBox.shrink();
                                    final school = _cachedSchools.firstWhere(
                                      (sch) => sch.id == st['schoolId'],
                                      orElse: () => School(id: '', provinceCode: '', provinceName: '', communeCode: '', communeName: '', schoolCode: '', schoolName: '', address: '', region: ''),
                                    );
                                    return Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: Colors.blue.shade200),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade100,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(Icons.school, color: Colors.blue.shade700, size: 24),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Học sinh liên quan đã chọn',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.blue.shade800,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${st['name']} (${st['className']})',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                if (school.schoolName.isNotEmpty) ...[
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    school.schoolName,
                                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                          if (!isExisting)
                                            Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius: BorderRadius.circular(20),
                                                onTap: () => setDialogState(() => selectedStudentId = null),
                                                child: Container(
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: Colors.red.shade200),
                                                  ),
                                                  child: Icon(Icons.close, color: Colors.red.shade600, size: 16),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  })(),
                                ] else ...[
                                  TextFormField(
                                    controller: searchStudentController,
                                    decoration: premiumInputDecoration(
                                      hintText: 'Tìm học sinh liên quan...',
                                      prefixIcon: Icons.search,
                                      suffixIcon: searchStudentController.text.isNotEmpty
                                          ? IconButton(
                                              icon: const Icon(Icons.clear, size: 18),
                                              onPressed: () {
                                                setDialogState(() {
                                                  searchStudentController.clear();
                                                });
                                              },
                                            )
                                          : null,
                                    ),
                                    onChanged: (val) {
                                      setDialogState(() {});
                                    },
                                  ),
                                  if (searchStudentController.text.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Container(
                                      constraints: const BoxConstraints(maxHeight: 200),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey.shade200),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.04),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: ListView(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          children: [
                                            ...filteredStudentsForRelative.map((s) {
                                              final school = _cachedSchools.firstWhere(
                                                (sch) => sch.id == s['schoolId'],
                                                orElse: () => School(id: '', provinceCode: '', provinceName: '', communeCode: '', communeName: '', schoolCode: '', schoolName: '', address: '', region: ''),
                                              );
                                              final schoolInfo = school.schoolName.isNotEmpty ? ' • ${school.schoolName}' : '';
                                              return ListTile(
                                                dense: true,
                                                leading: const Icon(Icons.school, color: Colors.blue),
                                                title: Text(s['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                                                subtitle: Text('Lớp ${s['className']} • Mã: ${s['studentCode']}$schoolInfo'),
                                                onTap: () {
                                                  setDialogState(() {
                                                    selectedStudentId = s['id'];
                                                    searchStudentController.clear();
                                                  });
                                                },
                                              );
                                            }),
                                            if (filteredStudentsForRelative.isEmpty)
                                              const Padding(
                                                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                                child: Text(
                                                  'Không tìm thấy học sinh nào',
                                                  style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),

                        // Section 3 — Ghi chú
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildFieldLabel('Ghi chú chi tiết'),
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  TextFormField(
                                    controller: notesController,
                                    maxLength: 500,
                                    buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                                    decoration: premiumInputDecoration(
                                      hintText: 'Nhập nội dung tương tác, ghi chú hoặc thông tin quan trọng...',
                                    ),
                                    minLines: 4,
                                    maxLines: 5,
                                    onChanged: (_) => setDialogState(() {}),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12, bottom: 12),
                                    child: Text(
                                      '${notesController.text.length}/500',
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Footer Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: isSaving ? null : () => Navigator.pop(context),
                              child: Text(
                                'Hủy',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: _kTeal,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              onPressed: (!canSubmit || isSaving)
                                  ? null
                                  : () async {
                                      setDialogState(() => isSaving = true);
                                      try {
                                        if (selectedSchoolId == null && !isExisting && (targetType == 'student' || targetType == 'person')) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Vui lòng chọn trường học')),
                                          );
                                          setDialogState(() => isSaving = false);
                                          return;
                                        }
                                        
                                        if (selectedStudentId == null && !isExisting && targetType == 'relative') {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Vui lòng chọn học sinh liên quan')),
                                          );
                                          setDialogState(() => isSaving = false);
                                          return;
                                        }
                                        
                                        final schoolId = selectedSchoolId;
                                        String? targetCollection;
                                        Map<String, dynamic>? targetData;

                                        if (!isExisting) {
                                          if (targetType == 'student') {
                                            targetCollection = 'students';
                                            targetData = {
                                              'name': nameController.text.trim(),
                                              'className': classNameController.text.trim(),
                                              'studentCode': studentCodeController.text.trim(),
                                              'schoolId': schoolId,
                                            };
                                          } else if (targetType == 'relative') {
                                            targetCollection = 'relatives';
                                            targetData = {
                                              'name': nameController.text.trim(),
                                              'phone': phoneController.text.trim(),
                                              'relationship': relationship,
                                              'studentId': selectedStudentId ?? '',
                                            };
                                          } else if (targetType == 'person') {
                                            targetCollection = 'persons';
                                            targetData = {
                                              'name': nameController.text.trim(),
                                              'email': emailController.text.trim(),
                                              'phone': personPhoneController.text.trim(),
                                              'roleType': roleType,
                                              'schoolId': schoolId,
                                            };
                                          }
                                        }

                                        final interaction = EventInteraction(
                                          id: '',
                                          eventId: event.id,
                                          employeeId: widget.currentUser.uid,
                                          targetType: targetType,
                                          targetName: nameController.text.trim(),
                                          notes: notesController.text.trim(),
                                          createdAt: DateTime.now(),
                                        );

                                        await _repo.createInteraction(
                                          event: event,
                                          interaction: interaction,
                                          targetCollection: targetCollection,
                                          targetData: targetData,
                                          existingTargetId: selectedTargetId,
                                        );
                                        _loadTargetNames();
                                        if (context.mounted) {
                                          Navigator.pop(context); // Close dialog
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Đã thêm tương tác mới.')),
                                          );
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Đã xảy ra lỗi: $e')),
                                          );
                                        }
                                      } finally {
                                        if (context.mounted) {
                                          setDialogState(() => isSaving = false);
                                        }
                                      }
                                    },
                              child: isSaving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Text(
                                      'Lưu tương tác',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curve = CurvedAnimation(parent: anim1, curve: Curves.easeOutBack);
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(curve),
            child: FadeTransition(
              opacity: anim1,
              child: child,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckInSection(BuildContext context, Event event, Map<String, String> employeeNameMap) {
    final isAssigned = event.assignedEmployeeIds.contains(widget.currentUser.uid) ||
        event.hostId == widget.currentUser.uid;

    return StreamBuilder<List<CheckIn>>(
      stream: _repo.watchCheckInsForEvent(event.id),
      builder: (context, checkinSnapshot) {
        final checkIns = checkinSnapshot.data ?? [];
        final CheckIn? myCheckIn = checkIns.cast<CheckIn?>().firstWhere(
          (c) => c?.employeeId == widget.currentUser.uid,
          orElse: () => null,
        );

        return ListView(
          children: [
            if (isAssigned) ...[
              _buildMyCheckInCard(context, event, myCheckIn),
              const SizedBox(height: 20),
            ],
            _buildAllCheckInsCard(context, event, checkIns, employeeNameMap),
          ],
        );
      },
    );
  }

  Widget _buildMyCheckInCard(BuildContext context, Event event, CheckIn? myCheckIn) {
    final hasCheckedIn = myCheckIn != null;
    final isCompleted = event.status == 'completed';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hasCheckedIn ? _kTeal.withOpacity(0.5) : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasCheckedIn ? Icons.check_circle_outlined : Icons.alarm_on_outlined,
                color: hasCheckedIn ? _kTeal : Colors.orange,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                hasCheckedIn ? 'Bạn đã điểm danh thành công!' : 'Điểm danh sự kiện',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (hasCheckedIn) ...[
            Text('Thời gian: ${myCheckIn.timestamp.hour.toString().padLeft(2, '0')}:${myCheckIn.timestamp.minute.toString().padLeft(2, '0')} - ngày ${myCheckIn.timestamp.day}/${myCheckIn.timestamp.month}/${myCheckIn.timestamp.year}'),
            const SizedBox(height: 4),
            Text('Vị trí check-in: ${myCheckIn.latitude.toStringAsFixed(5)}, ${myCheckIn.longitude.toStringAsFixed(5)} (Khoảng cách: ${(myCheckIn.distanceMeters / 1000.0).toStringAsFixed(2)} km)'),
            const SizedBox(height: 12),
            if (myCheckIn.photoUrl.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (dialogCtx) => Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppBar(
                                title: Text('Ảnh minh chứng: ${myCheckIn.employeeName}'),
                                automaticallyImplyLeading: false,
                                actions: [
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => Navigator.pop(dialogCtx),
                                  ),
                                ],
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black87,
                                elevation: 0.5,
                              ),
                              Container(
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery.of(dialogCtx).size.height * 0.7,
                                ),
                                child: _buildCheckInImage(
                                  myCheckIn.photoUrl,
                                  fit: BoxFit.contain,
                                  interactive: true,
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: _buildCheckInImage(
                    myCheckIn.photoUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _deleteMyCheckIn(context, myCheckIn),
                icon: const Icon(Icons.delete_forever_outlined, color: Colors.red),
                label: const Text('Xóa lượt điểm danh (Để test lại)', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ] else ...[
            const Text(
              'Yêu cầu:\n- Chụp ảnh minh chứng tại địa điểm.\n- Hệ thống tự động xác minh GPS của bạn trong bán kính 1km so với sự kiện.',
              style: TextStyle(color: Colors.black87, height: 1.4, fontSize: 14),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: isCompleted ? Colors.grey : _kTeal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: isCompleted ? null : () => _startCheckInFlow(context, event),
                icon: const Icon(Icons.pin_drop_outlined),
                label: Text(
                  isCompleted ? 'Sự kiện đã kết thúc' : 'Tiến hành Check-in',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _startCheckInFlow(BuildContext context, Event event) async {
    final imagePicker = ImagePicker();
    XFile? image;
    Position? currentPos;
    bool isLocating = true;
    bool simulateProximity = false;
    double? calculatedDistance;
    String? error;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            // Fetch location once when opening dialog
            if (currentPos == null && isLocating && error == null) {
              _getCurrentLocation().then((pos) {
                setDialogState(() {
                  currentPos = pos;
                  isLocating = false;
                  if (pos != null && event.latitude != null && event.longitude != null) {
                    calculatedDistance = Geolocator.distanceBetween(
                      pos.latitude,
                      pos.longitude,
                      event.latitude!,
                      event.longitude!,
                    );
                  } else if (pos == null) {
                    error = 'Không thể lấy vị trí hiện tại. Vui lòng bật định vị.';
                  }
                });
              }).catchError((err) {
                setDialogState(() {
                  error = err.toString();
                  isLocating = false;
                });
              });
            }

            final distKm = calculatedDistance != null ? (calculatedDistance! / 1000.0) : null;
            final isNear = (calculatedDistance != null && calculatedDistance! <= 1000.0) || simulateProximity;
            final canSubmit = image != null && currentPos != null && isNear && !isLocating;

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('Xác thực Check-in', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isLocating) ...[
                        const Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: _kTeal),
                            ),
                            SizedBox(width: 12),
                            Text('Đang lấy vị trí GPS...', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ] else if (error != null) ...[
                        Text('Lỗi: $error', style: const TextStyle(color: Colors.red, fontSize: 14)),
                      ] else if (currentPos != null) ...[
                        Row(
                          children: [
                            const Icon(Icons.my_location, color: _kTeal, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Vị trí hiện tại: ${currentPos!.latitude.toStringAsFixed(5)}, ${currentPos!.longitude.toStringAsFixed(5)}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              isNear ? Icons.check_circle_outline : Icons.error_outline,
                              color: isNear ? Colors.green : Colors.red,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                distKm != null
                                    ? 'Khoảng cách: ${distKm.toStringAsFixed(2)} km '
                                        '(${isNear ? 'Hợp lệ (<1km)' : 'Ngoài phạm vi 1km'})'
                                    : 'Không có thông tin tọa độ sự kiện',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isNear ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),
                      const Text('Ảnh chụp minh chứng địa điểm:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      if (image != null)
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: kIsWeb
                                  ? Image.network(image!.path, height: 160, width: double.infinity, fit: BoxFit.cover)
                                  : Image.file(File(image!.path), height: 160, width: double.infinity, fit: BoxFit.cover),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.black.withOpacity(0.5),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.close, size: 16, color: Colors.white),
                                  onPressed: () => setDialogState(() => image = null),
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 80),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () async {
                            final source = await showModalBottomSheet<ImageSource>(
                              context: dialogCtx,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              builder: (sheetCtx) => SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Chọn nguồn ảnh minh chứng',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ListTile(
                                        leading: const CircleAvatar(
                                          backgroundColor: Color(0xFFF3F4F6),
                                          child: Icon(Icons.photo_library_outlined, color: _kTeal),
                                        ),
                                        title: const Text(
                                          'Chọn từ thư viện (Gallery)',
                                          style: TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        subtitle: const Text('Chọn ảnh screenshot vị trí đã chụp'),
                                        onTap: () => Navigator.pop(sheetCtx, ImageSource.gallery),
                                      ),
                                      const SizedBox(height: 8),
                                      ListTile(
                                        leading: const CircleAvatar(
                                          backgroundColor: Color(0xFFF3F4F6),
                                          child: Icon(Icons.camera_alt_outlined, color: _kTeal),
                                        ),
                                        title: const Text(
                                          'Chụp ảnh trực tiếp (Camera)',
                                          style: TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        subtitle: const Text('Chụp ảnh thực tế tại địa điểm'),
                                        onTap: () => Navigator.pop(sheetCtx, ImageSource.camera),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );

                            if (source != null) {
                              final file = await imagePicker.pickImage(
                                source: source,
                                maxWidth: 640,
                                imageQuality: 40,
                              );
                              if (file != null) {
                                setDialogState(() => image = file);
                              }
                            }
                          },
                          icon: const Icon(Icons.add_a_photo_outlined, color: _kTeal),
                          label: const Text('Chọn / Chụp ảnh minh chứng', style: TextStyle(color: _kTeal)),
                        ),
                      const SizedBox(height: 16),
                      // Development Simulation Toggle
                      Row(
                        children: [
                          Checkbox(
                            value: simulateProximity,
                            onChanged: (val) {
                              if (val != null) {
                                setDialogState(() => simulateProximity = val);
                              }
                            },
                          ),
                          const Expanded(
                            child: Text(
                              'Giả lập vị trí ở gần (<1km) [Dev Mode]',
                              style: TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Hủy'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: _kTeal),
                  onPressed: !canSubmit
                      ? null
                      : () async {
                          final navigator = Navigator.of(context);
                          final scaffoldMessenger = ScaffoldMessenger.of(context);

                          // Close check-in inputs dialog
                          navigator.pop();

                          // Show loading indicator using root navigator context
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(child: CircularProgressIndicator(color: _kTeal)),
                          );

                          String photoUrl = '';
                          try {
                            if (image != null) {
                              final rawBytes = await File(image!.path).readAsBytes();
                              List<int> bytes = rawBytes;
                              try {
                                final decoded = img_pkg.decodeImage(rawBytes);
                                if (decoded != null) {
                                  var resized = decoded;
                                  if (decoded.width > 600) {
                                    resized = img_pkg.copyResize(decoded, width: 600);
                                  }
                                  bytes = img_pkg.encodeJpg(resized, quality: 40);
                                }
                              } catch (compErr) {
                                debugPrint('Dart image compression failed: $compErr');
                              }
                              photoUrl = 'data:image/jpeg;base64,' + base64Encode(bytes);
                            }
                          } catch (e) {
                            // Fallback to high quality mock URL if conversion fails
                            photoUrl = 'https://picsum.photos/400/300';
                          }

                          final checkIn = CheckIn(
                            id: '',
                            eventId: event.id,
                            employeeId: widget.currentUser.uid,
                            employeeName: widget.currentUser.name,
                            photoUrl: photoUrl,
                            latitude: simulateProximity ? (event.latitude ?? 21.0278) : currentPos!.latitude,
                            longitude: simulateProximity ? (event.longitude ?? 105.8342) : currentPos!.longitude,
                            distanceMeters: simulateProximity ? 350.0 : (calculatedDistance ?? 0.0),
                            timestamp: DateTime.now(),
                          );

                          try {
                            await _repo.submitCheckIn(checkIn).timeout(const Duration(seconds: 15));
                          } catch (e) {
                            debugPrint('Check-in submission failed: $e');
                            navigator.pop(); // Close loading dialog
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text('Lỗi điểm danh: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // Safely close the loading dialog using captured navigator
                          navigator.pop();

                          scaffoldMessenger.showSnackBar(
                            const SnackBar(content: Text('Điểm danh check-in thành công!')),
                          );
                        },
                  child: const Text('Điểm danh'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<String> _uploadToFirebaseStorageRest(File file, String remotePath) async {
    final bucket = Firebase.app().options.storageBucket;
    final encodedPath = Uri.encodeComponent(remotePath);
    final url = Uri.parse('https://firebasestorage.googleapis.com/v0/b/$bucket/o?uploadType=media&name=$encodedPath');

    // Get Firebase Auth ID token
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();

    final bytes = await file.readAsBytes();
    final headers = {
      'Content-Type': 'image/jpeg',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.post(url, headers: headers, body: bytes).timeout(const Duration(seconds: 12));
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final downloadTokens = data['downloadTokens'];
      if (downloadTokens != null) {
        return 'https://firebasestorage.googleapis.com/v0/b/$bucket/o/$encodedPath?alt=media&token=$downloadTokens';
      }
      return 'https://firebasestorage.googleapis.com/v0/b/$bucket/o/$encodedPath?alt=media';
    } else {
      throw HttpException('REST upload failed: ${response.statusCode} ${response.body}');
    }
  }

  Widget _buildCheckInImage(String photoUrl, {double? height, double? width, BoxFit fit = BoxFit.cover, bool interactive = false}) {
    Widget img;
    if (photoUrl.startsWith('data:image') || !photoUrl.startsWith('http')) {
      try {
        final base64Str = photoUrl.contains(',') ? photoUrl.split(',').last : photoUrl;
        final bytes = base64Decode(base64Str.trim());
        img = Image.memory(
          bytes,
          height: height,
          width: width,
          fit: fit,
          errorBuilder: (_, err, ___) => _buildErrorImage(height, width, errorMsg: 'Lỗi vẽ ảnh: $err'),
        );
      } catch (e) {
        img = _buildErrorImage(height, width, errorMsg: 'Lỗi giải mã base64: $e (Lực dài: ${photoUrl.length})');
      }
    } else {
      img = Image.network(
        photoUrl,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (_, err, ___) => _buildErrorImage(height, width, errorMsg: 'Lỗi tải ảnh mạng: $err'),
      );
    }

    if (interactive) {
      return InteractiveViewer(child: img);
    }
    return img;
  }

  Widget _buildErrorImage(double? height, double? width, {String? errorMsg}) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      color: Colors.grey.shade100,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.broken_image_outlined, color: Colors.grey),
          if (errorMsg != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                errorMsg,
                style: const TextStyle(color: Colors.red, fontSize: 10),
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _deleteMyCheckIn(BuildContext context, CheckIn myCheckIn) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa lượt điểm danh này để thực hiện check-in lại?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: _kTeal)),
      );

      try {
        await FirebaseFirestore.instance.collection('checkins').doc(myCheckIn.id).delete();

        if (!Platform.isWindows && myCheckIn.photoUrl.isNotEmpty && !myCheckIn.photoUrl.contains('picsum.photos') && myCheckIn.photoUrl.startsWith('http')) {
          try {
            await FirebaseStorage.instance.refFromURL(myCheckIn.photoUrl).delete();
          } catch (_) {}
        }
      } catch (_) {}

      navigator.pop(); // Close loading
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Đã xóa lượt điểm danh thành công!')),
      );
    }
  }

  Widget _buildAllCheckInsCard(BuildContext context, Event event, List<CheckIn> checkIns, Map<String, String> employeeNameMap) {
    final isHostOrAdmin = widget.currentUser.isAdmin || event.hostId == widget.currentUser.uid;
    final isAssignee = event.assignedEmployeeIds.contains(widget.currentUser.uid);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Danh sách điểm danh',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: _kTealLight, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  '${checkIns.length} nhân viên',
                  style: const TextStyle(color: _kTeal, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (checkIns.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'Chưa có nhân viên nào điểm danh.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: checkIns.length,
              separatorBuilder: (_, __) => const Divider(height: 16),
              itemBuilder: (context, idx) {
                final checkIn = checkIns[idx];
                final employee = widget.employees.firstWhere(
                  (e) => e['id'] == checkIn.employeeId,
                  orElse: () => <String, String>{},
                );
                final email = employee['email'] ?? '';
                final isSelf = checkIn.employeeId == widget.currentUser.uid;

                return Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: isSelf ? _kTeal : Colors.grey.shade100,
                      child: Text(
                        checkIn.employeeName.isNotEmpty ? checkIn.employeeName[0].toUpperCase() : '?',
                        style: TextStyle(
                          color: isSelf ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            checkIn.employeeName + (isSelf ? ' (Bạn)' : ''),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            email,
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'K/cách: ${(checkIn.distanceMeters / 1000.0).toStringAsFixed(2)} km - lúc '
                            '${checkIn.timestamp.hour.toString().padLeft(2, '0')}:${checkIn.timestamp.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    if (isHostOrAdmin || isSelf || isAssignee)
                      IconButton(
                        tooltip: 'Xem minh chứng ảnh',
                        icon: const Icon(Icons.image_outlined, color: _kTeal),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              clipBehavior: Clip.antiAlias,
                              child: Container(
                                constraints: const BoxConstraints(maxWidth: 600),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppBar(
                                      title: Text('Ảnh minh chứng: ${checkIn.employeeName}'),
                                      automaticallyImplyLeading: false,
                                      actions: [
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () => Navigator.pop(context),
                                        ),
                                      ],
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black87,
                                      elevation: 0.5,
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxHeight: MediaQuery.of(context).size.height * 0.7,
                                      ),
                                      child: _buildCheckInImage(
                                        checkIn.photoUrl,
                                        fit: BoxFit.contain,
                                        interactive: true,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
    final canManage = widget.currentUser.isAdmin || event.hostId == widget.currentUser.uid;
    if (!canManage) return;

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
    final canManage = widget.currentUser.isAdmin || event.hostId == widget.currentUser.uid;
    if (!canManage) return;

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
    await NotificationRepository.instance.publishEventDeleted(
      campaignId: event.campaignId,
      eventId: event.id,
      eventName: event.name,
    );
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
    required this.canDelete,
    required this.onDelete,
  });

  final Interaction interaction;
  final String targetName;
  final String employeeName;
  final bool isLast;
  final bool canDelete;
  final VoidCallback onDelete;

  @override
  State<_TimelineItem> createState() => _TimelineItemState();
}

class _TimelineItemState extends State<_TimelineItem> {
  bool _isHovered = false;

  Future<Map<String, dynamic>> _fetchTargetDetails() async {
    final interaction = widget.interaction;
    final Map<String, dynamic> details = {};
    
    if (interaction.targetId.isEmpty || interaction.targetType.isEmpty) {
      return details;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection(
            interaction.targetType == 'student'
                ? 'students'
                : interaction.targetType == 'relative'
                    ? 'relatives'
                    : 'persons'
          )
          .doc(interaction.targetId)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        details.addAll(data);

        // Fetch school details if schoolId is present
        final schoolId = data['schoolId'] as String?;
        if (schoolId != null && schoolId.isNotEmpty) {
          final schoolDoc = await FirebaseFirestore.instance
              .collection('schools')
              .doc(schoolId)
              .get();
          if (schoolDoc.exists && schoolDoc.data() != null) {
            details['schoolName'] = schoolDoc.data()!['schoolName'] ?? 'Không rõ trường';
            details['communeName'] = schoolDoc.data()!['communeName'] ?? '';
            details['provinceName'] = schoolDoc.data()!['provinceName'] ?? '';
          }
        }

        // Fetch student details if this is a relative and studentId is present
        final studentId = data['studentId'] as String?;
        if (interaction.targetType == 'relative' && studentId != null && studentId.isNotEmpty) {
          final studentDoc = await FirebaseFirestore.instance
              .collection('students')
              .doc(studentId)
              .get();
          if (studentDoc.exists && studentDoc.data() != null) {
            details['studentName'] = studentDoc.data()!['name'] ?? 'Không rõ';
            details['studentClass'] = studentDoc.data()!['className'] ?? '';
            details['studentCode'] = studentDoc.data()!['studentCode'] ?? '';
            
            // Fetch school of that student
            final studSchoolId = studentDoc.data()!['schoolId'] as String?;
            if (studSchoolId != null && studSchoolId.isNotEmpty) {
              final schoolDoc = await FirebaseFirestore.instance
                  .collection('schools')
                  .doc(studSchoolId)
                  .get();
              if (schoolDoc.exists && schoolDoc.data() != null) {
                details['schoolName'] = schoolDoc.data()!['schoolName'] ?? 'Không rõ trường';
                details['communeName'] = schoolDoc.data()!['communeName'] ?? '';
                details['provinceName'] = schoolDoc.data()!['provinceName'] ?? '';
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching target details: $e');
    }

    return details;
  }

  void _showInteractionDetails(BuildContext context) {
    final interaction = widget.interaction;
    final typeLabel = switch (interaction.targetType) {
      'student' => 'Học sinh',
      'relative' => 'Phụ huynh',
      'person' => 'Cán bộ trường',
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

    final dateStr = interaction.timestamp != null
        ? '${interaction.timestamp!.hour.toString().padLeft(2, '0')}:${interaction.timestamp!.minute.toString().padLeft(2, '0')} - ngày ${interaction.timestamp!.day}/${interaction.timestamp!.month}/${interaction.timestamp!.year}'
        : 'Chưa rõ thời gian';

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            width: 760,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 60,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            padding: const EdgeInsets.all(28),
            child: FutureBuilder<Map<String, dynamic>>(
              future: _fetchTargetDetails(),
              builder: (context, snapshot) {
                final isLoading = snapshot.connectionState == ConnectionState.waiting;
                final data = snapshot.data ?? {};

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: typeColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              interaction.targetType == 'student'
                                  ? Icons.school_outlined
                                  : interaction.targetType == 'relative'
                                      ? Icons.people_outline
                                      : Icons.badge_outlined,
                              color: typeColor,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Chi tiết tương tác',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Thông tin chi tiết về cuộc tương tác đã ghi nhận trong chiến dịch.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.grey.shade400),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const Divider(height: 32, thickness: 1),

                      if (isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 60),
                          child: Center(
                            child: CircularProgressIndicator(color: _kTeal),
                          ),
                        )
                      else ...[
                        // Section 1 — Đối tượng tương tác
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'ĐỐI TƯỢNG TƯƠNG TÁC',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: typeBg,
                                      borderRadius: BorderRadius.circular(6),
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
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.person_outline, color: typeColor, size: 20),
                                  const SizedBox(width: 10),
                                  Text(
                                    widget.targetName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              
                              if (interaction.targetType == 'student') ...[
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildDetailCard(
                                        icon: Icons.class_outlined,
                                        label: 'Lớp học',
                                        value: data['className']?.toString().isNotEmpty == true
                                            ? data['className']
                                            : '(Chưa cập nhật)',
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildDetailCard(
                                        icon: Icons.badge_outlined,
                                        label: 'Mã học sinh',
                                        value: data['studentCode']?.toString().isNotEmpty == true
                                            ? data['studentCode']
                                            : '(Chưa cập nhật)',
                                      ),
                                    ),
                                  ],
                                ),
                                if (data['schoolName']?.toString().isNotEmpty == true) ...[
                                  const SizedBox(height: 14),
                                  _buildSchoolEntityCard(
                                    schoolName: data['schoolName'],
                                    address: data['communeName'] != null && data['communeName'].toString().isNotEmpty
                                        ? '${data['communeName']}, ${data['provinceName'] ?? ""}'
                                        : '',
                                  ),
                                ],
                              ] else if (interaction.targetType == 'person') ...[
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildDetailCard(
                                        icon: Icons.work_outline,
                                        label: 'Vai trò/Chức vụ',
                                        value: data['roleType']?.toString().isNotEmpty == true
                                            ? (data['roleType'] == 'teacher'
                                                ? 'Giáo viên'
                                                : data['roleType'] == 'principal'
                                                    ? 'Hiệu trưởng'
                                                    : data['roleType'] == 'staff'
                                                        ? 'Nhân viên'
                                                        : data['roleType'])
                                            : '(Chưa cập nhật)',
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildDetailCard(
                                        icon: Icons.phone_outlined,
                                        label: 'Số điện thoại',
                                        value: data['phone']?.toString().isNotEmpty == true
                                            ? data['phone']
                                            : '(Chưa cập nhật)',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _buildDetailCard(
                                  icon: Icons.mail_outline,
                                  label: 'Email liên hệ',
                                  value: data['email']?.toString().isNotEmpty == true
                                      ? data['email']
                                      : '(Chưa cập nhật)',
                                ),
                                if (data['schoolName']?.toString().isNotEmpty == true) ...[
                                  const SizedBox(height: 14),
                                  _buildSchoolEntityCard(
                                    schoolName: data['schoolName'],
                                    address: data['communeName'] != null && data['communeName'].toString().isNotEmpty
                                        ? '${data['communeName']}, ${data['provinceName'] ?? ""}'
                                        : '',
                                  ),
                                ],
                              ] else if (interaction.targetType == 'relative') ...[
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildDetailCard(
                                        icon: Icons.people_outline,
                                        label: 'Mối quan hệ',
                                        value: data['relationship']?.toString().isNotEmpty == true
                                            ? (data['relationship'] == 'mother'
                                                ? 'Mẹ'
                                                : data['relationship'] == 'father'
                                                    ? 'Bố'
                                                    : data['relationship'])
                                            : '(Chưa cập nhật)',
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildDetailCard(
                                        icon: Icons.phone_outlined,
                                        label: 'Số điện thoại',
                                        value: data['phone']?.toString().isNotEmpty == true
                                            ? data['phone']
                                            : '(Chưa cập nhật)',
                                      ),
                                    ),
                                  ],
                                ),
                                if (data['studentName'] != null) ...[
                                  const SizedBox(height: 14),
                                  _buildRelatedStudentCard(
                                    studentName: data['studentName'],
                                    studentCode: data['studentCode'] ?? '',
                                    className: data['studentClass'] ?? '',
                                    schoolName: data['schoolName'] ?? '',
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Section 2 — Thông tin thực hiện
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'THÔNG TIN THỰC HIỆN',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildDetailCard(
                                      icon: Icons.person_outline,
                                      label: 'Người thực hiện',
                                      value: widget.employeeName,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildDetailCard(
                                      icon: Icons.access_time_outlined,
                                      label: 'Thời gian tương tác',
                                      value: dateStr,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Section 3 — Ghi chú
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'NỘI DUNG GHI CHÚ',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Text(
                                  interaction.notes.isNotEmpty ? interaction.notes : '(Không có ghi chú)',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Footer Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: _kTeal,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Đóng',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curve = CurvedAnimation(parent: anim1, curve: Curves.easeOutBack);
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(curve),
            child: FadeTransition(
              opacity: anim1,
              child: child,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailCard({required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade500),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchoolEntityCard({required String schoolName, required String address}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.school, color: Colors.blue.shade700, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trường học',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  schoolName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                if (address.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          address,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedStudentCard({required String studentName, required String studentCode, required String className, required String schoolName}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.purple.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.school_outlined, color: Colors.purple.shade700, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Học sinh liên quan',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.purple.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$studentName (Mã: $studentCode) • Lớp: $className',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                if (schoolName.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    schoolName,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
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
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: GestureDetector(
                  onTap: () => _showInteractionDetails(context),
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
                          if (widget.canDelete) ...[
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: widget.onDelete,
                              borderRadius: BorderRadius.circular(4),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.delete_outline,
                                  size: 16,
                                  color: Colors.red.shade400,
                                ),
                              ),
                            ),
                          ],
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
