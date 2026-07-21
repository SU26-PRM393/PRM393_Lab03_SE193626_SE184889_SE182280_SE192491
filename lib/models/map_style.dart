/// Map display styles available to the user.
///
/// Each style corresponds to a distinct tile source with its own
/// URL template and attribution string.
enum MapStyle {
  light,
  dark,
  satellite;

  String get displayName => switch (this) {
        MapStyle.light => 'Sáng',
        MapStyle.dark => 'Tối',
        MapStyle.satellite => 'Vệ tinh',
      };
}
