import 'package:flutter/material.dart';

import '../data/campaign_repository.dart';
import '../domain/campaign.dart';
import '../domain/event.dart';
import '../domain/school.dart';

class CampaignManagementScreen extends StatefulWidget {
  const CampaignManagementScreen({super.key});

  @override
  State<CampaignManagementScreen> createState() =>
      _CampaignManagementScreenState();
}

class _CampaignManagementScreenState extends State<CampaignManagementScreen> {
  final _repo = CampaignRepository.instance;
  Campaign? _selectedCampaign;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        SizedBox(
          width: 360,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: cs.outlineVariant)),
            ),
            child: Column(
              children: [
                _HeaderBar(
                  title: 'Chiến dịch',
                  actionLabel: 'Thêm',
                  icon: Icons.add,
                  onAction: () => _openCampaignForm(),
                ),
                Expanded(
                  child: StreamBuilder<List<Campaign>>(
                    stream: _repo.watchCampaigns(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final campaigns = snapshot.data ?? const <Campaign>[];
                      if (campaigns.isEmpty) {
                        return const _EmptyPanel(
                          icon: Icons.campaign_outlined,
                          title: 'Chưa có chiến dịch',
                          subtitle: 'Tạo chiến dịch đầu tiên để quản lý event.',
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: campaigns.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
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
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: _selectedCampaign == null
              ? const _EmptyPanel(
                  icon: Icons.event_note_outlined,
                  title: 'Chọn một chiến dịch',
                  subtitle: 'Danh sách sự kiện sẽ hiển thị ở đây.',
                )
              : _EventPane(
                  campaign: _selectedCampaign!,
                  onCampaignChanged: (campaign) {
                    setState(() => _selectedCampaign = campaign);
                  },
                ),
        ),
      ],
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
      ),
    );
  }

  Future<void> _confirmDeleteCampaign(Campaign campaign) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa chiến dịch?'),
        content: Text(
          'Chiến dịch "${campaign.name}" và các event bên trong sẽ bị xóa.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
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
      const SnackBar(content: Text('Đã xóa chiến dịch.')),
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

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            border: Border(bottom: BorderSide(color: cs.outlineVariant)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          campaign.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        _StatusPill(status: campaign.status),
                      ],
                    ),
                    if (campaign.description.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        campaign.description,
                        style: TextStyle(color: cs.onSurfaceVariant),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Text(
                      _formatRange(campaign.startDate, campaign.endDate),
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: () => _openEventForm(context),
                icon: const Icon(Icons.add),
                label: const Text('Thêm event'),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Event>>(
            key: ValueKey(campaign.id),
            stream: _repo.watchEventsForCampaign(campaign.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final events = snapshot.data ?? const <Event>[];
              if (events.isEmpty) {
                return const _EmptyPanel(
                  icon: Icons.event_busy_outlined,
                  title: 'Chưa có event',
                  subtitle: 'Tạo event và gán nhân viên để bắt đầu.',
                );
              }
              return FutureBuilder<_EventFormOptions>(
                future: _optionsFuture,
                builder: (context, optionsSnapshot) {
                  final options = optionsSnapshot.data;
                  return ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: events.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return _EventTile(
                        event: event,
                        schools: options?.schools ?? const <School>[],
                        employees:
                            options?.employees ?? const <Map<String, String>>[],
                        onEdit: () => _openEventForm(context, event: event),
                        onAssign: () => _openAssignEmployees(context, event),
                        onDelete: () => _confirmDeleteEvent(event),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
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
      ),
    );
  }

  Future<void> _openAssignEmployees(BuildContext context, Event event) async {
    final options = await _optionsFuture;
    if (!context.mounted) return;
    final selected = await showDialog<List<String>>(
      context: context,
      builder: (_) => _AssignEmployeesDialog(
        employees: options.employees,
        selectedIds: event.assignedEmployeeIds,
      ),
    );
    if (selected == null) return;

    await _repo.assignEmployeesToEvent(event.id, selected);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã cập nhật nhân viên phụ trách.')),
    );
  }

  Future<void> _confirmDeleteEvent(Event event) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa event?'),
        content: Text('Event "${event.name}" sẽ bị xóa khỏi chiến dịch.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    await _repo.deleteEvent(event.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xóa event.')),
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
      title:
          Text(widget.campaign == null ? 'Tạo chiến dịch' : 'Sửa chiến dịch'),
      content: SizedBox(
        width: 460,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tên chiến dịch'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Nhập tên' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Mô tả'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(labelText: 'Trạng thái'),
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
              const SizedBox(height: 12),
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        FilledButton(
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
          child: const Text('Lưu'),
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
    _schoolId = event?.schoolIds.isNotEmpty == true
        ? event!.schoolIds.first
        : (widget.schools.isNotEmpty ? widget.schools.first.id : null);
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
      title: Text(widget.event == null ? 'Tạo event' : 'Sửa event'),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Tên event'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Nhập tên event'
                      : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _status,
                  decoration: const InputDecoration(labelText: 'Trạng thái'),
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
                const SizedBox(height: 12),
                _DateRow(
                  label: 'Ngày diễn ra',
                  value: _date,
                  onPick: (value) => setState(() => _date = value),
                ),
                DropdownButtonFormField<String>(
                  initialValue: _schoolId,
                  decoration: const InputDecoration(labelText: 'Địa điểm'),
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
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nhân viên phụ trách',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const SizedBox(height: 6),
                ...widget.employees.map((employee) {
                  final id = employee['id'] ?? '';
                  return CheckboxListTile(
                    dense: true,
                    value: _employeeIds.contains(id),
                    title: Text(employee['name'] ?? 'Unknown'),
                    subtitle: Text(employee['email'] ?? ''),
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
                }),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        FilledButton(
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
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}

class _AssignEmployeesDialog extends StatefulWidget {
  const _AssignEmployeesDialog({
    required this.employees,
    required this.selectedIds,
  });

  final List<Map<String, String>> employees;
  final List<String> selectedIds;

  @override
  State<_AssignEmployeesDialog> createState() => _AssignEmployeesDialogState();
}

class _AssignEmployeesDialogState extends State<_AssignEmployeesDialog> {
  late final Set<String> _selectedIds = {...widget.selectedIds};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Gán nhân viên'),
      content: SizedBox(
        width: 420,
        child: ListView(
          shrinkWrap: true,
          children: widget.employees.map((employee) {
            final id = employee['id'] ?? '';
            return CheckboxListTile(
              value: _selectedIds.contains(id),
              title: Text(employee['name'] ?? 'Unknown'),
              subtitle: Text(employee['email'] ?? ''),
              onChanged: (selected) {
                setState(() {
                  if (selected == true) {
                    _selectedIds.add(id);
                  } else {
                    _selectedIds.remove(id);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _selectedIds.toList()),
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}

class _CampaignTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: selected ? cs.primaryContainer : cs.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      campaign.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  _StatusPill(status: campaign.status),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                campaign.description.isEmpty
                    ? _formatRange(campaign.startDate, campaign.endDate)
                    : campaign.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: 'Sửa',
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    tooltip: 'Xóa',
                    icon: const Icon(Icons.delete_outline, size: 18),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
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
    required this.onAssign,
    required this.onDelete,
  });

  final Event event;
  final List<School> schools;
  final List<Map<String, String>> employees;
  final VoidCallback onEdit;
  final VoidCallback onAssign;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final school = event.schoolIds.isEmpty
        ? null
        : schools.where((s) => s.id == event.schoolIds.first).firstOrNull;
    final assignedNames = event.assignedEmployeeIds.map((id) {
      final employee = employees.where((e) => e['id'] == id).firstOrNull;
      return employee?['name'] ?? id;
    }).join(', ');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.event_available_outlined, color: cs.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      event.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    _StatusPill(status: event.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  school == null
                      ? 'Địa điểm: Chưa xác định'
                      : 'Địa điểm: ${school.schoolName}, ${school.communeName}, ${school.provinceName}',
                  style: TextStyle(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ngày: ${_formatDate(event.date)} | Tương tác: ${event.totalInteractions}',
                  style: TextStyle(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                Text(
                  assignedNames.isEmpty
                      ? 'Nhân viên: Chưa phân công'
                      : 'Nhân viên: $assignedNames',
                  style: TextStyle(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Wrap(
            spacing: 4,
            children: [
              IconButton(
                tooltip: 'Gán nhân viên',
                icon: const Icon(Icons.group_add_outlined),
                onPressed: onAssign,
              ),
              IconButton(
                tooltip: 'Sửa',
                icon: const Icon(Icons.edit_outlined),
                onPressed: onEdit,
              ),
              IconButton(
                tooltip: 'Xóa',
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
    return Row(
      children: [
        SizedBox(width: 110, child: Text(label)),
        Expanded(child: Text(_formatDate(value))),
        TextButton.icon(
          icon: const Icon(Icons.calendar_month_outlined, size: 18),
          label: const Text('Chọn'),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2035),
            );
            onPick(picked);
          },
        ),
      ],
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
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          FilledButton.icon(
            onPressed: onAction,
            icon: Icon(icon, size: 18),
            label: Text(actionLabel),
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
    final color = switch (status) {
      'active' || 'in-progress' => const Color(0xFF16A34A),
      'completed' => const Color(0xFF2563EB),
      'canceled' => const Color(0xFF6B7280),
      'draft' => const Color(0xFFF97316),
      _ => Theme.of(context).colorScheme.outline,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _statusLabel(status),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
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
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.onSurfaceVariant),
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
