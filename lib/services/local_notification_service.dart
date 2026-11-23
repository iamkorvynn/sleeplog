import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sleeplog/constants/app_constants.dart';
import 'package:sleeplog/models/sleep_settings.dart';
import 'package:sleeplog/services/notification_service.dart';

class LocalNotificationService implements NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(initSettings);
    _initialized = true;
  }

  @override
  Future<bool> requestPermissions() async {
    final androidImpl = _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      final granted = await androidImpl.requestNotificationsPermission();
      return granted ?? false;
    }
    return true;
  }

  @override
  Future<void> scheduleBedtimeReminder(SleepSettings settings) async {
    await cancelBedtimeReminder();
    if (!settings.bedtimeReminderEnabled) return;

    int totalMinutes = settings.targetBedtimeHour * 60 + settings.targetBedtimeMinute - settings.bedtimeReminderMinutesBefore;
    if (totalMinutes < 0) totalMinutes += 1440;

    const androidDetails = AndroidNotificationDetails(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      channelDescription: AppConstants.notificationChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    try {
      // Local notification display
      await _notificationsPlugin.periodicallyShow(
        AppConstants.bedtimeNotificationId,
        'Time to wind down',
        'Bedtime is in ${settings.bedtimeReminderMinutesBefore} minutes. Dim lights and prepare for rest.',
        RepeatInterval.daily,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (_) {
      // Gracefully ignore if scheduled notification platform failure occurs in emulator or headless
    }
  }

  }
