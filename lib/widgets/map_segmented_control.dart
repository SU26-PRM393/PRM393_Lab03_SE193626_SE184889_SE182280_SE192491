import 'package:flutter/material.dart';

class MapSegmentedControl<T> extends StatelessWidget {
  const MapSegmentedControl({
    super.key,
    required this.value,
    required this.onChanged,
    required this.segments,
  });

  final T value;
  final ValueChanged<T> onChanged;
  final List<MapSegmentedOption<T>> segments;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: segments.asMap().entries.map((entry) {
            final idx = entry.key;
            final opt = entry.value;
            final isSelected = opt.value == value;

            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(opt.value),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFCCFBF1) : Colors.transparent,
                    border: idx > 0
                        ? Border(left: BorderSide(color: Colors.grey.shade300, width: 1.0))
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        opt.icon,
                        size: 16,
                        color: isSelected ? const Color(0xFF0F766E) : Colors.grey.shade700,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          opt.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: isSelected ? const Color(0xFF0F766E) : Colors.grey.shade700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class MapSegmentedOption<T> {
  const MapSegmentedOption({
    required this.value,
    required this.icon,
    required this.label,
  });

  final T value;
  final IconData icon;
  final String label;
}
