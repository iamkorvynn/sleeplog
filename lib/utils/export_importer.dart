import 'dart:convert';
import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/models/sleep_settings.dart';

class ImportResult {
  final List<SleepNight> nights;
  final SleepSettings? settings;
  final int count;

  ImportResult({
    required this.nights,
    this.settings,
    required this.count,
  });
}

class ExportImporter {
  static String exportToJson(List<SleepNight> nights, SleepSettings settings) {
    final data = {
      'app': 'SleepLog',
      'version': 1,
      'exported_at': DateTime.now().toIso8601String(),
      'settings': settings.toMap(),
      'nights': nights.map((n) => n.toMap()).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  static ImportResult importFromJson(String jsonString) {
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Invalid JSON format: root must be an object');
      }

      SleepSettings? settings;
      if (decoded['settings'] != null && decoded['settings'] is Map) {
        settings = SleepSettings.fromMap(Map<String, dynamic>.from(decoded['settings'] as Map));
      }

      final nightsList = <SleepNight>[];
      if (decoded['nights'] != null && decoded['nights'] is List) {
        for (final item in decoded['nights'] as List) {
          if (item is Map) {
            nightsList.add(SleepNight.fromMap(Map<String, dynamic>.from(item)));
          }
        }
      }

      return ImportResult(nights: nightsList, settings: settings, count: nightsList.length);
    } catch (e) {
      throw FormatException('Failed to import JSON data: $e');
    }
  }

  }
