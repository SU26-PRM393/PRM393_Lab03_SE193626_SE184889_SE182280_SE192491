import 'dart:io';

String? _stripWrappedQuotes(String value) {
  if ((value.startsWith("'") && value.endsWith("'")) ||
      (value.startsWith('"') && value.endsWith('"'))) {
    return value.substring(1, value.length - 1);
  }
  return value;
}

String? _parseEnvLine(String line, String key) {
  final trimmedLine = line.trim();
  if (trimmedLine.startsWith('#') || !trimmedLine.contains('=')) {
    return null;
  }

  final parts = trimmedLine.split('=');
  if (parts.first.trim() != key) {
    return null;
  }

  return _stripWrappedQuotes(parts.sublist(1).join('=').trim());
}

String? getEnvValue(String key) {
  try {
    final file = File('.env');
    if (!file.existsSync()) {
      return null;
    }

    final lines = file.readAsLinesSync();
    for (final line in lines) {
      final value = _parseEnvLine(line, key);
      if (value != null) {
        return value;
      }
    }
  } catch (_) {
    // ignore
  }
  return null;
}
