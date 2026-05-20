import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;

import '../../domain/administrative_area.dart';
import '../../domain/lower_level_place.dart';
import '../vietnam_map_controller.dart';

class MapControlPanel extends StatelessWidget {
  const MapControlPanel({
    required this.controller,
    super.key,
  });

  final VietnamMapController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasSelection = controller.selectedProvince != null ||
        controller.selectedLowerLevelPlace != null;

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
            if (hasSelection)
              _LocationDetailsView(controller: controller)
            else ...[
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
                onTap: controller.acknowledgeInactiveControl,
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
                selected: {controller.controlSpace.selectedLevel},
                onSelectionChanged: null,
              ),
              const SizedBox(height: 20),
              const _SectionLabel(label: 'Filters'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final chip in controller.controlSpace.filterChips)
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
                initialSelection: controller.controlSpace.sortOption,
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

class _LocationDetailsView extends StatelessWidget {
  const _LocationDetailsView({required this.controller});

  final VietnamMapController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final selectedProvince = controller.selectedProvince;
    final selectedPlace = controller.selectedLowerLevelPlace;
    
    final String title;
    final String typeLabel;
    final String locationContext;
    final String? macroRegion;
    
    if (selectedPlace != null) {
      title = selectedPlace.name;
      typeLabel = selectedPlace.level == 'ward' ? 'Phường' : 'Xã/Thị trấn';
      locationContext = '${selectedPlace.parentName}, ${selectedProvince?.name ?? ''}';
      macroRegion = null;
    } else if (selectedProvince != null) {
      title = selectedProvince.name;
      typeLabel = selectedProvince.level;
      locationContext = 'Việt Nam';
      macroRegion = controller.selectedProvinceDetails?.macroRegion;
    } else {
      return const SizedBox.shrink();
    }

    final double? area = selectedPlace != null
        ? controller.selectedCommuneDetails?.areaKm2
        : controller.selectedProvinceDetails?.areaKm2;

    final int? population = selectedPlace != null
        ? controller.selectedCommuneDetails?.population
        : controller.selectedProvinceDetails?.population;

    final double? density = selectedPlace != null
        ? controller.selectedCommuneDetails?.density
        : controller.selectedProvinceDetails?.density;

    final String? capital = selectedPlace != null
        ? controller.selectedCommuneDetails?.capital
        : controller.selectedProvinceDetails?.capital;

    final String? decree = selectedPlace != null
        ? controller.selectedCommuneDetails?.decree
        : controller.selectedProvinceDetails?.decree;

    final String? decreeUrl = selectedPlace != null
        ? controller.selectedCommuneDetails?.decreeUrl
        : controller.selectedProvinceDetails?.decreeUrl;

    final String? predecessors = selectedPlace != null
        ? controller.selectedCommuneDetails?.predecessors
        : controller.selectedProvinceDetails?.predecessors;

    final String? address = selectedPlace != null
        ? null
        : controller.selectedProvinceDetails?.address;

    final String? phone = selectedPlace != null
        ? null
        : controller.selectedProvinceDetails?.phone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: selectedPlace != null
                  ? 'Go back to Province'
                  : 'Go back to Search & Filter',
              onPressed: () {
                if (selectedPlace != null) {
                  controller.clearPlaceSelection();
                } else {
                  controller.clearSelection();
                }
              },
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          typeLabel.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 9,
                          ),
                        ),
                      ),
                      if (macroRegion != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            macroRegion.replaceAll('_', ' ').toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                            ),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            locationContext,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 16),

        if (controller.isLoadingDetails)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(strokeWidth: 3),
                  SizedBox(height: 12),
                  Text('Loading details from database...'),
                ],
              ),
            ),
          )
        else ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.square_foot_outlined,
                    label: 'Area',
                    value: area != null ? '${_formatDouble(area)} km²' : 'N/A',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    icon: Icons.people_outline,
                    label: 'Population',
                    value: population != null ? _formatNumber(population) : 'N/A',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    icon: Icons.density_medium_outlined,
                    label: 'Density',
                    value: density != null ? '${_formatDouble(density)}/km²' : 'N/A',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (capital != null && capital.isNotEmpty)
            _InfoRow(
              icon: Icons.location_city_outlined,
              label: selectedPlace != null ? 'Headquarters' : 'Capital',
              value: capital,
            ),

          if (address != null && address.isNotEmpty)
            _InfoRow(
              icon: Icons.home_outlined,
              label: 'Address',
              value: address,
            ),

          if (phone != null && phone.isNotEmpty)
            _InfoRow(
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: phone,
            ),

          if (decree != null && decree.isNotEmpty) ...[
            const SizedBox(height: 12),
            _InfoSection(
              title: 'Decree / Legal Basis',
              icon: Icons.gavel_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    decree,
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (decreeUrl != null && decreeUrl.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.copy_all, size: 16),
                      label: const Text('Copy Source Link'),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: decreeUrl));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Decree link copied to clipboard!'),
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

          if (predecessors != null && predecessors.isNotEmpty) ...[
            const SizedBox(height: 12),
            _InfoSection(
              title: 'Historical Background',
              icon: Icons.history_outlined,
              child: Text(
                predecessors,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
          
          if (selectedPlace == null && controller.selectedLowerLevelPlaces.isNotEmpty)
            _CommuneListSection(
              places: controller.selectedLowerLevelPlaces,
              onPlaceSelected: controller.selectLowerLevelPlace,
            ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.center_focus_strong_outlined),
              label: const Text('Center Location on Map'),
              onPressed: () {
                if (selectedPlace != null) {
                  controller.selectLowerLevelPlace(selectedPlace);
                } else if (selectedProvince != null) {
                  controller.selectProvinceAt(selectedProvince.labelCoordinate);
                }
              },
            ),
          ),
        ],
      ],
    );
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
              'Communes & Wards (${widget.places.length})',
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
            hintText: 'Search communes/wards...',
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            border: Border.all(color: colorScheme.outlineVariant.withAlpha(128)),
            borderRadius: BorderRadius.circular(8),
            color: colorScheme.surfaceContainerHighest.withAlpha(64),
          ),
          child: filteredPlaces.isEmpty
              ? const Center(
                  child: Text('No communes match your search.'),
                )
              : ListView.builder(
                  itemCount: filteredPlaces.length,
                  itemExtent: 44,
                  itemBuilder: (context, index) {
                    final place = filteredPlaces[index];
                    final levelName = place.level == 'ward' ? 'Phường' : 'Xã/Thị trấn';
                    return ListTile(
                      dense: true,
                      title: Text(
                        place.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
  if (value == null) return 'N/A';
  return value.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
}

String _formatDouble(double? value, {int decimalPlaces = 1}) {
  if (value == null) return 'N/A';
  return value.toStringAsFixed(decimalPlaces);
}
