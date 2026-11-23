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

  static String exportToCsv(List<SleepNight> nights, double goalHours) {
    final buffer = StringBuffer();
    buffer.writeln('id,bedtime,wake_time,duration_minutes,quality,goal_met,notes');
    for (final n in nights) {
      final safeNotes = (n.notes ?? '').replaceAll('"', '""');
      final goalMet = n.isGoalMet(goalHours) ? '1' : '0';
      buffer.writeln(
        '"${n.id}","${n.bedtime.toIso8601String()}","${n.wakeTime.toIso8601String()}",${n.durationMinutes},${n.quality},$goalMet,"$safeNotes"',
      );
    }
    return buffer.toString();
  }

  static ImportResult importFromCsv(String csvString) {
    try {
      final lines = const LineSplitter().convert(csvString).where((l) => l.trim().isNotEmpty).toList();
      if (lines.isEmpty) return ImportResult(nights: const [], count: 0);

      final nights = <SleepNight>[];
      final startIndex = lines.first.toLowerCase().contains('bedtime') ? 1 : 0;

      for (int i = startIndex; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        // Parse CSV columns
        final parts = _parseCsvLine(line);
        if (parts.length >= 5) {
          final id = parts[0].isNotEmpty ? parts[0] : DateTime.now().microsecondsSinceEpoch.toString();
          final bedtime = DateTime.parse(parts[1]);
          final wakeTime = DateTime.parse(parts[2]);
          final quality = int.tryParse(parts[4]) ?? 3;
          final notes = parts.length >= 7 && parts[6].isNotEmpty ? parts[6] : null;

          nights.add(SleepNight(
            id: id,
            bedtime: bedtime,
            wakeTime: wakeTime,
            quality: quality.clamp(1, 5),
            notes: notes,
          ));
        }
      }

      return ImportResult(nights: nights, count: nights.length);
    } catch (e) {
      throw FormatException('Failed to import CSV data: $e');
    }
  }

  static List<String> _parseCsvLine(String line) {
    final result = <String>[];
    final buffer = StringBuffer();
    bool insideQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];
      if (char == '"') {
        if (insideQuotes && i + 1 < line.length && line[i + 1] == '"') {
          buffer.write('"');
          i++;
        } else {
          insideQuotes = !insideQuotes;
        }
      } else if (char == ',' && !insideQuotes) {
        result.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }
    result.add(buffer.toString());
    return result;
  }
}
