import 'package:flutter_test/flutter_test.dart';
import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/models/sleep_settings.dart';
import 'package:sleeplog/utils/export_importer.dart';

void main() {
  group('ExportImporter Tests', () {
    final bedtime = DateTime(2026, 11, 22, 23, 0);
    final wakeTime = DateTime(2026, 11, 23, 7, 0);
    final nights = [
      SleepNight(id: 'n1', bedtime: bedtime, wakeTime: wakeTime, quality: 5, notes: 'Note 1'),
      SleepNight(id: 'n2', bedtime: bedtime.subtract(const Duration(days: 1)), wakeTime: wakeTime.subtract(const Duration(days: 1)), quality: 4),
    ];
    const settings = SleepSettings(goalHours: 7.5, use24HourFormat: true);

    test('exportToJson includes expected keys', () {
      final json = ExportImporter.exportToJson(nights, settings);
      expect(json, contains('"app": "SleepLog"'));
      expect(json, contains('"version": 1'));
      expect(json, contains('"goal_hours": 7.5'));
      expect(json, contains('"n1"'));
    });

    test('importFromJson restores nights and settings', () {
      final json = ExportImporter.exportToJson(nights, settings);
      final res = ExportImporter.importFromJson(json);
      expect(res.count, 2);
      expect(res.nights.length, 2);
      expect(res.settings?.goalHours, 7.5);
      expect(res.nights.first.id, 'n1');
    });

    test('importFromJson throws FormatException on invalid json', () {
      expect(() => ExportImporter.importFromJson('not json'), throwsFormatException);
      expect(() => ExportImporter.importFromJson('123'), throwsFormatException);
    });

    test('exportToCsv and importFromCsv roundtrip', () {
      final csv = ExportImporter.exportToCsv(nights, 8.0);
      expect(csv, contains('id,bedtime,wake_time'));
      expect(csv, contains('"n1"'));

      final res = ExportImporter.importFromCsv(csv);
      expect(res.count, 2);
      expect(res.nights.first.id, 'n1');
    });

    test('importFromCsv handles empty string', () {
      final res = ExportImporter.importFromCsv('');
      expect(res.count, 0);
      expect(res.nights, isEmpty);
    });
  });
}  });
}
