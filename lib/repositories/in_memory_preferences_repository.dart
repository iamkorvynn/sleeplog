import 'package:sleeplog/models/sleep_settings.dart';
import 'package:sleeplog/repositories/preferences_repository.dart';

class InMemoryPreferencesRepository implements PreferencesRepository {
  SleepSettings _settings;

  InMemoryPreferencesRepository([SleepSettings? initial])
      : _settings = initial ?? const SleepSettings.defaults();

  @override
  Future<SleepSettings> getSettings() async => _settings;

  @override
  Future<void> saveSettings(SleepSettings settings) async {
    _settings = settings;
  }

  @override
  Future<void> clearSettings() async {
    _settings = const SleepSettings.defaults();
  }
}
