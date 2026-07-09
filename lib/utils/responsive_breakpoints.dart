import 'package:flutter/widgets.dart';

/// Centralized responsive breakpoints for consistent cross-platform layouts.
///
/// Replaces scattered hardcoded values (980, 700, 600) with semantic names.
/// All screens should use these breakpoints for layout decisions.
class ResponsiveBreakpoints {
  const ResponsiveBreakpoints._();

  /// Compact layout (phones in portrait).
  /// < 600px width.
  static const double compact = 600;

  /// Medium layout (tablets, large phones in landscape, small desktops).
  /// 600-900px width.
  static const double medium = 900;

  /// Expanded layout (desktops, large tablets in landscape).
  /// > 900px width.
  static const double expanded = 900;

  /// Minimum touch target size per Material Design guidelines.
  /// All interactive elements on touch devices should be at least 48x48.
  static const double minTouchTarget = 48;

  /// Width threshold for showing side panels vs bottom sheets.
  /// Below this, use bottom sheet; above, use side panel.
  static const double sidePanelThreshold = 900;

  /// Width threshold for compact navigation (bottom nav vs top tabs).
  /// Below this, use bottom navigation; above, use top app bar tabs.
  static const double compactNavigationThreshold = 700;

  /// Width for side panels on expanded layouts.
  static const double sidePanelWidth = 360;

  /// Width for campaign panel on expanded layouts.
  static const double campaignPanelWidth = 400;
}

/// Extension methods for responsive layout decisions.
extension ResponsiveContext on BuildContext {
  /// Returns true if the screen width is compact (phone).
  bool get isCompact =>
      MediaQuery.of(this).size.width < ResponsiveBreakpoints.compact;

  /// Returns true if the screen width is medium (tablet/small desktop).
  bool get isMedium {
    final width = MediaQuery.of(this).size.width;
    return width >= ResponsiveBreakpoints.compact &&
        width < ResponsiveBreakpoints.medium;
  }

  /// Returns true if the screen width is expanded (desktop).
  bool get isExpanded =>
      MediaQuery.of(this).size.width >= ResponsiveBreakpoints.expanded;

  /// Returns true if layout should use side panels (vs bottom sheets).
  bool get useSidePanels =>
      MediaQuery.of(this).size.width >= ResponsiveBreakpoints.sidePanelThreshold;

  /// Returns true if layout should use compact navigation (bottom nav).
  bool get useCompactNavigation =>
      MediaQuery.of(this).size.width <
      ResponsiveBreakpoints.compactNavigationThreshold;

  /// Screen width in logical pixels.
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Screen height in logical pixels.
  double get screenHeight => MediaQuery.of(this).size.height;
}

/// Layout type based on screen width.
enum LayoutType {
  /// Phone layout (< 600px).
  compact,

  /// Tablet/small desktop layout (600-900px).
  medium,

  /// Desktop layout (> 900px).
  expanded;

  /// Returns the layout type for the given width.
  static LayoutType fromWidth(double width) {
    if (width < ResponsiveBreakpoints.compact) return LayoutType.compact;
    if (width < ResponsiveBreakpoints.medium) return LayoutType.medium;
    return LayoutType.expanded;
  }

  /// Returns the layout type for the given context.
  static LayoutType of(BuildContext context) {
    return fromWidth(MediaQuery.of(context).size.width);
  }
}
