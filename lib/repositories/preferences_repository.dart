import 'package:sleeplog/models/sleep_settings.dart';

abstract class PreferencesRepository {
  Future<SleepSettings> getSettings();
  Future<void> saveSettings(SleepSettings settings);
  Future<void> clearSettings();
}
