import 'package:flutter_test/flutter_test.dart';
import 'package:sleeplog/models/sleep_settings.dart';
import 'package:sleeplog/repositories/in_memory_preferences_repository.dart';

void main() {
  group('PreferencesRepository Tests', () {
    late InMemoryPreferencesRepository repo;

    setUp(() {
      repo = InMemoryPreferencesRepository();
    });

    test('returns default settings', () async {
      final s = await repo.getSettings();
      expect(s.goalHours, 8.0);
    });

    for (double g = 5.0; g <= 10.0; g += 1.0) {
      test('saveSettings with goal $g', () async {
        await repo.saveSettings(SleepSettings(goalHours: g));
        final s = await repo.getSettings();
        expect(s.goalHours, g);
      });
    }

    test('clearSettings resets back to defaults', () async {
      await repo.saveSettings(const SleepSettings(goalHours: 6.0));
      await repo.clearSettings();
      expect((await repo.getSettings()).goalHours, 8.0);
    });
  });
}  });
}
