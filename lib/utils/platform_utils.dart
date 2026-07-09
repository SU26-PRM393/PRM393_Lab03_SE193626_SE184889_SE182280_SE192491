import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// Platform detection utilities for cross-platform UI consistency.
///
/// Centralizes platform checks to ensure Windows and mobile have
/// consistent behavior and appropriate interaction patterns.
class PlatformUtils {
  const PlatformUtils._();

  /// True on Windows, macOS, or Linux.
  static bool get isDesktop {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  /// True on Android or iOS.
  static bool get isMobileDevice {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  /// True on Android.
  static bool get isAndroid {
    if (kIsWeb) return false;
    return Platform.isAndroid;
  }

  /// True on iOS.
  static bool get isIOS {
    if (kIsWeb) return false;
    return Platform.isIOS;
  }

  /// True on Windows.
  static bool get isWindows {
    if (kIsWeb) return false;
    return Platform.isWindows;
  }

  /// True if running in a web browser.
  static bool get isWeb => kIsWeb;

  /// True if the device primarily uses touch interaction.
  ///
  /// On mobile devices, touch is primary. On desktop, mouse/trackpad is primary.
  /// This affects:
  /// - Province hover vs long-press for preview
  /// - Touch target sizing (48px minimum on touch devices)
  /// - Tooltip behavior
  static bool get usesTouchInteraction => isMobileDevice;

  /// True if the device supports mouse hover.
  ///
  /// Desktop platforms support hover; mobile platforms do not.
  /// Used to determine whether to show hover feedback or require
  /// long-press for similar functionality.
  static bool get supportsHover => isDesktop || isWeb;

  /// Returns an appropriate gesture label based on platform.
  ///
  /// Example: "Hover" on desktop, "Long press" on mobile.
  static String get hoverOrLongPressLabel =>
      supportsHover ? 'Di chuột qua' : 'Nhấn giữ';

  /// Returns an appropriate tap label based on platform.
  ///
  /// Example: "Click" on desktop, "Tap" on mobile.
  static String get clickOrTapLabel => supportsHover ? 'Nhấp chuột' : 'Chạm';
}
