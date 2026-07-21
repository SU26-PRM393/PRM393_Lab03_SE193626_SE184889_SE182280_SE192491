import 'package:flutter/material.dart';

const _kTeal = Color(0xFF0D9488);

/// Event status values and their Vietnamese labels.
const _kStatuses = <(String, String, IconData)>[
  ('in-progress', 'Đang diễn ra', Icons.play_circle_outline),
  ('preparing', 'Sắp diễn ra', Icons.schedule_outlined),
  ('completed', 'Đã kết thúc', Icons.check_circle_outline),
  ('canceled', 'Đã hủy', Icons.cancel_outlined),
];

Color _statusColor(String status) => switch (status) {
      'in-progress' => const Color(0xFF16A34A),
      'preparing' => const Color(0xFFF97316),
      'completed' => const Color(0xFF2563EB),
      'canceled' => const Color(0xFF6B7280),
      _ => const Color(0xFF6B7280),
    };

/// A bottom sheet panel for filtering map event markers by status.
///
/// Shows as a persistent modal bottom sheet. Emits the new filter set via
/// [onStatusFilterChanged] on every chip toggle.
class MapFilterSheet extends StatefulWidget {
  const MapFilterSheet({
    required this.selectedStatuses,
    required this.onStatusFilterChanged,
    required this.onClose,
    super.key,
  });

  /// The currently selected status values (empty = show all).
  final Set<String> selectedStatuses;

  /// Called when the user toggles a status chip.
  final ValueChanged<Set<String>> onStatusFilterChanged;

  final VoidCallback onClose;

  @override
  State<MapFilterSheet> createState() => _MapFilterSheetState();
}

class _MapFilterSheetState extends State<MapFilterSheet> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<String>.from(widget.selectedStatuses);
  }

  void _toggle(String status) {
    setState(() {
      if (_selected.contains(status)) {
        _selected.remove(status);
      } else {
        _selected.add(status);
      }
    });
    widget.onStatusFilterChanged(Set<String>.from(_selected));
  }

  void _clearAll() {
    setState(() => _selected.clear());
    widget.onStatusFilterChanged({});
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasFilter = _selected.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Handle bar ─────────────────────────────────────────────
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Header row ─────────────────────────────────────────────
              Row(
                children: [
                  const Icon(_kFilterIcon, size: 18, color: _kTeal),
                  const SizedBox(width: 8),
                  Text(
                    'Lọc sự kiện trên bản đồ',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const Spacer(),
                  if (hasFilter)
                    TextButton.icon(
                      onPressed: _clearAll,
                      icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
                      label: const Text('Xóa bộ lọc'),
                      style: TextButton.styleFrom(
                        foregroundColor: cs.error,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  IconButton(
                    onPressed: widget.onClose,
                    icon: const Icon(Icons.close_rounded),
                    visualDensity: VisualDensity.compact,
                    color: cs.onSurfaceVariant,
                    tooltip: 'Đóng',
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // ── Status chips ───────────────────────────────────────────
              Text(
                'Trạng thái sự kiện',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (value, label, icon) in _kStatuses)
                    _StatusChip(
                      label: label,
                      icon: icon,
                      color: _statusColor(value),
                      selected: _selected.contains(value),
                      onTap: () => _toggle(value),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // ── Active filter summary ──────────────────────────────────
              if (hasFilter) ...[
                const Divider(height: 1),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 14, color: cs.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Đang hiển thị ${_selected.length} trong '
                        '${_kStatuses.length} loại trạng thái.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

const _kFilterIcon = Icons.filter_list_rounded;

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.15) : cs.surfaceContainerLow,
          border: Border.all(
            color: selected ? color : cs.outlineVariant,
            width: selected ? 1.6 : 1.0,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? Icons.check_circle_rounded : icon,
              size: 15,
              color: selected ? color : cs.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? color : cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
