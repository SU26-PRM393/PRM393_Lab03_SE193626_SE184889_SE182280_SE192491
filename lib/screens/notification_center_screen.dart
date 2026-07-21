import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietnam_map_flutter/models/notification_message.dart';
import 'package:vietnam_map_flutter/models/campaign.dart';
import 'package:vietnam_map_flutter/models/event.dart';
import 'package:vietnam_map_flutter/models/school.dart';
import 'package:vietnam_map_flutter/services/auth_service.dart';
import 'package:vietnam_map_flutter/services/campaign_repository.dart';
import 'package:vietnam_map_flutter/viewmodels/notification_viewmodel.dart';
import 'package:vietnam_map_flutter/screens/campaign_management_screen.dart';
import 'package:vietnam_map_flutter/l10n/app_strings.dart';

class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({
    super.key,
    required this.userId,
    required this.currentUser,
  });

  final String userId;
  final AppUser currentUser;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationViewModel(userId),
      child: _NotificationBody(currentUser: currentUser),
    );
  }
}

enum _NotifFilter { all, created, updated, ended }

class _NotificationBody extends StatefulWidget {
  const _NotificationBody({required this.currentUser});

  final AppUser currentUser;

  @override
  State<_NotificationBody> createState() => _NotificationBodyState();
}

class _NotificationBodyState extends State<_NotificationBody> {
  _NotifFilter _filter = _NotifFilter.all;

  bool _matchesFilter(NotificationMessage n) => switch (_filter) {
        _NotifFilter.all => true,
        _NotifFilter.created => n.type.contains('created'),
        _NotifFilter.updated => n.type.contains('updated'),
        _NotifFilter.ended =>
          n.type.contains('ended') ||
              n.type.contains('completed') ||
              n.type.contains('deleted'),
      };

  String _filterLabel(BuildContext context, _NotifFilter f) => switch (f) {
        _NotifFilter.all => context.l10n.all,
        _NotifFilter.created => context.l10n.filterCreated,
        _NotifFilter.updated => context.l10n.filterUpdated,
        _NotifFilter.ended => context.l10n.filterEnded,
      };

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotificationViewModel>();
    final cs = Theme.of(context).colorScheme;

    final filtered = vm.notifications.where(_matchesFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.notificationsTitle),
        actions: [
          if (vm.unreadCount > 0)
            TextButton.icon(
              onPressed: vm.markAllAsRead,
              icon: const Icon(Icons.done_all, size: 18),
              label: Text(context.l10n.markAllAsRead),
            ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: _NotifFilter.values.map((f) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(_filterLabel(context, f)),
                    selected: _filter == f,
                    selectedColor: cs.primaryContainer,
                    checkmarkColor: cs.onPrimaryContainer,
                    labelStyle: TextStyle(
                      color: _filter == f
                          ? cs.onPrimaryContainer
                          : cs.onSurfaceVariant,
                      fontWeight: _filter == f
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    onSelected: (_) => setState(() => _filter = f),
                  ),
                );
              }).toList(),
            ),
          ),
          Divider(height: 1, color: cs.outlineVariant),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.notifications_none_outlined,
                            size: 64, color: cs.onSurfaceVariant),
                        const SizedBox(height: 12),
                        Text(
                          _filter == _NotifFilter.all
                              ? context.l10n.noNotifications
                              : context.l10n.noNotificationsOfType,
                          style: TextStyle(color: cs.onSurfaceVariant),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 16, endIndent: 16),
                    itemBuilder: (context, i) {
                      final n = filtered[i];
                      return _NotificationTile(
                        notification: n,
                        isRead: n.isReadBy(vm.userId),
                        onTap: () {
                          vm.markAsRead(n.id);
                          _navigateToCampaign(context, n);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _navigateToCampaign(
      BuildContext context, NotificationMessage notification) async {
    if (notification.campaignId.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final db = FirebaseFirestore.instance;

      // Fetch campaign
      final campaignSnap =
          await db.collection('campaigns').doc(notification.campaignId).get();
      if (!campaignSnap.exists) {
        if (context.mounted) Navigator.pop(context);
        return;
      }
      final campaign =
          Campaign.fromMap(campaignSnap.id, campaignSnap.data()!);

      // Fetch events for this campaign
      final eventsSnap = await db
          .collection('events')
          .where('campaignId', isEqualTo: notification.campaignId)
          .get();
      final events = eventsSnap.docs
          .map((d) => Event.fromMap(d.id, d.data()))
          .toList();

      // Fetch employees list
      final employees =
          await CampaignRepository.instance.getEmployees();

      if (!context.mounted) return;
      Navigator.pop(context); // close loading

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => _CampaignDetailPage(
            campaign: campaign,
            events: events,
            employees: employees,
            currentUser: widget.currentUser,
            highlightEventId: notification.eventId,
          ),
        ),
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.cannotOpenCampaign.replaceAll('{error}', e.toString()))),
        );
      }
    }
  }
}

/// Màn hình chi tiết 1 chiến dịch — hiện thị từ notification tap.
class _CampaignDetailPage extends StatelessWidget {
  const _CampaignDetailPage({
    required this.campaign,
    required this.events,
    required this.employees,
    required this.currentUser,
    this.highlightEventId,
  });

  final Campaign campaign;
  final List<Event> events;
  final List<Map<String, String>> employees;
  final AppUser currentUser;
  final String? highlightEventId;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(campaign.name),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campaign info card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatusChip(status: campaign.status),
                  const SizedBox(height: 8),
                  Text(campaign.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  if (campaign.description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(campaign.description,
                        style: TextStyle(color: cs.onSurfaceVariant)),
                  ],
                  if (campaign.startDate != null || campaign.endDate != null) ...[
                    const SizedBox(height: 8),
                    Row(children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 14, color: cs.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        _formatDateRange(
                            context, campaign.startDate, campaign.endDate),
                        style: TextStyle(
                            fontSize: 13, color: cs.onSurfaceVariant),
                      ),
                    ]),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),
            Text('${context.l10n.eventsListTitle} (${events.length})',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            if (events.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(context.l10n.noEventsYet,
                      style: TextStyle(color: cs.onSurfaceVariant)),
                ),
              )
            else
              ...events.map((event) {
                final isHighlighted = event.id == highlightEventId;
                return _EventCard(
                  event: event,
                  isHighlighted: isHighlighted,
                  onTap: () async {
                    final school = event.schoolIds.isNotEmpty
                        ? await _fetchSchool(event.schoolIds.first)
                        : null;
                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventDetailScreen(
                          event: event,
                          school: school,
                          employees: employees,
                          currentUser: currentUser,
                        ),
                      ),
                    );
                  },
                );
              }),
          ],
        ),
      ),
    );
  }

  Future<School?> _fetchSchool(String schoolId) async {
    try {
      final schools =
          await CampaignRepository.instance.getSchoolsByIds([schoolId]);
      return schools.isNotEmpty ? schools.first : null;
    } catch (_) {
      return null;
    }
  }

  String _formatDateRange(BuildContext context, DateTime? start, DateTime? end) {
    String fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
    if (start != null && end != null) return '${fmt(start)} – ${fmt(end)}';
    if (start != null) return context.l10n.fromDate.replaceAll('{date}', fmt(start));
    if (end != null) return context.l10n.toDate.replaceAll('{date}', fmt(end));
    return '';
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({
    required this.event,
    required this.onTap,
    this.isHighlighted = false,
  });

  final Event event;
  final VoidCallback onTap;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: isHighlighted
            ? BorderSide(color: cs.primary, width: 2)
            : BorderSide.none,
      ),
      elevation: isHighlighted ? 3 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isHighlighted)
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(context.l10n.relatedNotification,
                            style: TextStyle(
                                fontSize: 10,
                                color: cs.primary,
                                fontWeight: FontWeight.bold)),
                      ),
                    Text(event.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 4),
                    _StatusChip(status: event.status, small: true),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, this.small = false});

  final String status;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'active' => ('Hoạt động', Colors.green),
      'completed' => ('Hoàn thành', Colors.blue),
      'canceled' => ('Đã hủy', Colors.red),
      'in-progress' => ('Đang diễn ra', Colors.orange),
      _ => (status, Colors.grey),
    };
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: small ? 6 : 8, vertical: small ? 2 : 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label,
          style: TextStyle(
              color: color,
              fontSize: small ? 10 : 12,
              fontWeight: FontWeight.w600)),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.isRead,
    required this.onTap,
  });

  final NotificationMessage notification;
  final bool isRead;
  final VoidCallback onTap;

  static IconData _iconForType(String type) {
    if (type.startsWith('campaign.created')) return Icons.add_circle_outline;
    if (type.startsWith('campaign.updated')) return Icons.edit_outlined;
    if (type.startsWith('campaign.started')) return Icons.play_circle_outline;
    if (type.startsWith('campaign.ended')) return Icons.check_circle_outline;
    if (type.startsWith('campaign.deleted')) return Icons.delete_outline;
    if (type.startsWith('event.created')) return Icons.event_outlined;
    if (type.startsWith('event.updated')) return Icons.edit_calendar_outlined;
    if (type.startsWith('event.started')) return Icons.event_available_outlined;
    if (type.startsWith('event.ended')) return Icons.event_busy_outlined;
    if (type.startsWith('event.deleted')) return Icons.delete_outline;
    if (type.startsWith('event.firstInteraction')) return Icons.people_outline;
    return Icons.notifications_outlined;
  }

  static Color _colorForType(String type, ColorScheme cs) {
    if (type.contains('deleted') || type.contains('canceled')) return Colors.red;
    if (type.contains('created') || type.contains('started')) return cs.primary;
    if (type.contains('updated')) return Colors.orange;
    if (type.contains('ended') || type.contains('completed')) return Colors.green;
    if (type.contains('firstInteraction')) return Colors.orange;
    return cs.primary;
  }

  String _timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final iconColor = _colorForType(notification.type, cs);
    final bgColor = isRead ? null : cs.primary.withValues(alpha: 0.06);

    return InkWell(
      onTap: onTap,
      child: Container(
        color: bgColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(_iconForType(notification.type),
                  color: iconColor, size: 20),
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
                          notification.title,
                          style: TextStyle(
                            fontWeight:
                                isRead ? FontWeight.normal : FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: cs.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.body,
                    style:
                        TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        _timeAgo(notification.createdAt),
                        style: TextStyle(
                            fontSize: 11, color: cs.onSurfaceVariant),
                      ),
                      if (notification.campaignId.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text('• Xem chiến dịch',
                            style: TextStyle(
                                fontSize: 11, color: cs.primary)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 16),
          ],
        ),
      ),
    );
  }
}
