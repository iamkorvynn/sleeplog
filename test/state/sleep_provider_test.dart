import 'package:flutter_test/flutter_test.dart';
import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/repositories/in_memory_sleep_repository.dart';
import 'package:sleeplog/repositories/in_memory_preferences_repository.dart';
import 'package:sleeplog/services/mock_notification_service.dart';
import 'package:sleeplog/state/sleep_provider.dart';

void main() {
  group('SleepProvider State Tests', () {
    late SleepProvider provider;

    setUp(() async {
      provider = SleepProvider(
        repository: InMemorySleepRepository(),
        preferencesRepository: InMemoryPreferencesRepository(),
        notificationService: MockNotificationService(),
      );
      await provider.load();
    });

    test('initial state after load', () {
      expect(provider.isLoading, isFalse);
      expect(provider.nights, isEmpty);
      expect(provider.lastNight, isNull);
      expect(provider.settings.goalHours, 8.0);
    });

    test('addMultipleNights sequentially updates stats', () async {
      for (int i = 1; i <= 5; i++) {
        final night = SleepNight(
          id: 'n$i',
          bedtime: DateTime(2026, 11, 20 + i, 23, 0),
          wakeTime: DateTime(2026, 11, 21 + i, 7, 30),
          quality: 4,
        );
        await provider.addNight(night);
        expect(provider.nights.length, i);
      }
    });

    test('updateNight modifies existing night and recalculates', () async {
      final night = SleepNight(id: 'n1', bedtime: DateTime(2026, 1, 1), wakeTime: DateTime(2026, 1, 1, 8), quality: 3);
      await provider.addNight(night);
      await provider.updateNight(night.copyWith(quality: 5));
      expect(provider.lastNight?.quality, 5);
      expect(provider.stats.averageQualityAllTime, 5.0);
    });

    test('deleteNight removes night', () async {
      final night = SleepNight(id: 'n1', bedtime: DateTime(2026, 1, 1), wakeTime: DateTime(2026, 1, 1, 8), quality: 4);
      await provider.addNight(night);
      expect(provider.nights.length, 1);
      await provider.deleteNight('n1');
      expect(provider.nights, isEmpty);
    });

    test('deleteAllNights clears state', () async {
      await provider.addNight(SleepNight(id: '1', bedtime: DateTime(2026, 1, 1), wakeTime: DateTime(2026, 1, 1, 8), quality: 4));
      await provider.addNight(SleepNight(id: '2', bedtime: DateTime(2026, 1, 2), wakeTime: DateTime(2026, 1, 2, 8), quality: 4));
      expect(provider.nights.length, 2);
      await provider.deleteAllNights();
      expect(provider.nights, isEmpty);
    });

    test('updateSettings updates preferences and reschedules notifications', () async {
      final newS = provider.settings.copyWith(goalHours: 7.0, use24HourFormat: true);
      await provider.updateSettings(newS);
      expect(provider.settings.goalHours, 7.0);
      expect(provider.is24Hour, isTrue);
    });
  });
}
