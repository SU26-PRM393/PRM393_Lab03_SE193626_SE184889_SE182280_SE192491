import 'dart:io';

String? getEnvValue(String key) {
  try {
    final file = File('.env');
    if (file.existsSync()) {
      final lines = file.readAsLinesSync();
      for (var line in lines) {
        line = line.trim();
        if (line.startsWith('#') || !line.contains('=')) continue;
        final parts = line.split('=');
        final currentKey = parts[0].trim();
        if (currentKey == key) {
          final value = parts.sublist(1).join('=').trim();
          if ((value.startsWith("'") && value.endsWith("'")) ||
              (value.startsWith('"') && value.endsWith('"'))) {
            return value.substring(1, value.length - 1);
          }
          return value;
        }
      }
    }
  } catch (_) {
    // ignore
  }
  return null;
}
