import 'package:flutter_test/flutter_test.dart';
import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/repositories/in_memory_sleep_repository.dart';

void main() {
  group('InMemorySleepRepository Tests', () {
    late InMemorySleepRepository repo;

    setUp(() async {
      repo = InMemorySleepRepository();
      await repo.initialize();
    });

    test('starts empty', () async {
      expect(await repo.getAllNights(), isEmpty);
    });

    for (int i = 1; i <= 10; i++) {
      test('saveNight and getAllNights for $i nights', () async {
        final night = SleepNight(
          id: 'night_$i',
          bedtime: DateTime(2026, 1, i, 23, 0),
          wakeTime: DateTime(2026, 1, i + 1, 7, 0),
          quality: 4,
        );
        await repo.saveNight(night);
        final retrieved = await repo.getNightById('night_$i');
        expect(retrieved, equals(night));
      });
    }

    test('updateNight updates existing night', () async {
      final night = SleepNight(id: 'n1', bedtime: DateTime(2026, 1, 1), wakeTime: DateTime(2026, 1, 1, 8), quality: 3);
      await repo.saveNight(night);
      await repo.updateNight(night.copyWith(quality: 5));
      final updated = await repo.getNightById('n1');
      expect(updated?.quality, 5);
    });

    test('deleteNight and deleteAllNights', () async {
      await repo.saveNight(SleepNight(id: '1', bedtime: DateTime(2026, 1, 1), wakeTime: DateTime(2026, 1, 1, 8), quality: 4));
      await repo.saveNight(SleepNight(id: '2', bedtime: DateTime(2026, 1, 2), wakeTime: DateTime(2026, 1, 2, 8), quality: 4));
      expect((await repo.getAllNights()).length, 2);

      await repo.deleteNight('1');
      expect((await repo.getAllNights()).length, 1);

      await repo.deleteAllNights();
      expect(await repo.getAllNights(), isEmpty);
    });
  });
}
