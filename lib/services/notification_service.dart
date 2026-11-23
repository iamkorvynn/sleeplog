import 'package:sleeplog/models/sleep_settings.dart';

abstract class NotificationService {
  Future<void> initialize();
  Future<bool> requestPermissions();
  Future<void> scheduleBedtimeReminder(SleepSettings settings);
  Future<void> scheduleMorningSummary(SleepSettings settings);
  Future<void> cancelBedtimeReminder();
  Future<void> cancelMorningSummary();
  Future<void> cancelAll();
}
