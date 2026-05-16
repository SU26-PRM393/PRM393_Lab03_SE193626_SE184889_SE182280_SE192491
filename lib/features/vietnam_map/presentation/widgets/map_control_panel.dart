import 'package:flutter/material.dart';

import '../../domain/administrative_area.dart';

class MapControlPanel extends StatelessWidget {
  const MapControlPanel({
    required this.controlSpace,
    required this.onInactiveInteraction,
    super.key,
  });

  final AdministrativeAreaControlSpace controlSpace;
  final VoidCallback onInactiveInteraction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      label: 'Reserved province city district tools',
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
            Text(
              'Viet Nam Explorer',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Map-first workspace with room for province, city, and district tools.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            const _SectionLabel(label: 'Search'),
            const SizedBox(height: 8),
            TextField(
              enabled: false,
              onTap: onInactiveInteraction,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Search provinces, cities, districts',
                helperText: 'Reserved for a later feature',
              ),
            ),
            const SizedBox(height: 20),
            const _SectionLabel(label: 'Level'),
            const SizedBox(height: 8),
            SegmentedButton<AdministrativeAreaLevel>(
              segments: const [
                ButtonSegment(
                  value: AdministrativeAreaLevel.all,
                  icon: Icon(Icons.public),
                  label: Text('All'),
                ),
                ButtonSegment(
                  value: AdministrativeAreaLevel.province,
                  icon: Icon(Icons.map),
                  label: Text('Province'),
                ),
                ButtonSegment(
                  value: AdministrativeAreaLevel.district,
                  icon: Icon(Icons.location_city),
                  label: Text('District'),
                ),
              ],
              selected: {controlSpace.selectedLevel},
              onSelectionChanged: null,
            ),
            const SizedBox(height: 20),
            const _SectionLabel(label: 'Filters'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final chip in controlSpace.filterChips)
                  FilterChip(
                    label: Text(chip),
                    selected: false,
                    onSelected: null,
                  ),
              ],
            ),
            const SizedBox(height: 20),
            const _SectionLabel(label: 'Sort'),
            const SizedBox(height: 8),
            DropdownMenu<String>(
              enabled: false,
              initialSelection: controlSpace.sortOption,
              leadingIcon: const Icon(Icons.sort),
              label: const Text('Sort by'),
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: 'Name', label: 'Name'),
                DropdownMenuEntry(value: 'Area', label: 'Area'),
                DropdownMenuEntry(value: 'Population', label: 'Population'),
              ],
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
                        'Search, filter, and sort controls are visual placeholders in this UI slice.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
