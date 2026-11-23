import 'package:sleeplog/models/sleep_settings.dart';
import 'package:sleeplog/services/notification_service.dart';

class ScheduledNotificationItem {
  final int id;
  final String title;
  final String body;
  final int hour;
  final int minute;

  ScheduledNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.hour,
    required this.minute,
  });
}

class MockNotificationService implements NotificationService {
  final List<ScheduledNotificationItem> scheduledItems = [];
  bool permissionsGranted = true;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermissions() async => permissionsGranted;

  @override
  Future<void> scheduleBedtimeReminder(SleepSettings settings) async {
    cancelBedtimeReminder();
    if (!settings.bedtimeReminderEnabled) return;

    int totalMinutes = settings.targetBedtimeHour * 60 + settings.targetBedtimeMinute - settings.bedtimeReminderMinutesBefore;
    if (totalMinutes < 0) totalMinutes += 1440;
    final hour = totalMinutes ~/ 60;
    final minute = totalMinutes % 60;

    scheduledItems.add(ScheduledNotificationItem(
      id: 1001,
      title: 'Time to wind down',
      body: 'Your bedtime is in ${settings.bedtimeReminderMinutesBefore} minutes. Get ready for restful sleep.',
      hour: hour,
      minute: minute,
    ));
  }

  @override
  Future<void> scheduleMorningSummary(SleepSettings settings) async {
    cancelMorningSummary();
    if (!settings.morningSummaryEnabled) return;

    scheduledItems.add(ScheduledNotificationItem(
      id: 1002,
      title: 'Good morning!',
      body: 'How did you sleep last night? Tap to log your sleep.',
      hour: settings.morningSummaryHour,
      minute: settings.morningSummaryMinute,
    ));
  }

  @override
  Future<void> cancelBedtimeReminder() async {
    scheduledItems.removeWhere((i) => i.id == 1001);
  }

  @override
  Future<void> cancelMorningSummary() async {
    scheduledItems.removeWhere((i) => i.id == 1002);
  }

  @override
  Future<void> cancelAll() async {
    scheduledItems.clear();
  }
}
