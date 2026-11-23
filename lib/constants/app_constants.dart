class AppConstants {
  static const String appName = 'SleepLog';
  static const double defaultGoalHours = 8.0;
  static const double minGoalHours = 4.0;
  static const double maxGoalHours = 14.0;
  static const int defaultTargetBedtimeHour = 23;
  static const int defaultTargetBedtimeMinute = 0;
  static const int defaultTargetWakeHour = 7;
  static const int defaultTargetWakeMinute = 0;
  static const int defaultReminderMinutes = 30;
  static const int defaultMorningSummaryHour = 8;
  static const int defaultMorningSummaryMinute = 0;
  static const String dbName = 'sleeplog.db';
  static const int dbVersion = 1;
  static const String nightsTable = 'sleep_nights';
  static const String preferencesTable = 'app_preferences';
  static const String notificationChannelId = 'sleeplog_reminders';
  static const String notificationChannelName = 'Sleep Reminders';
  static const String notificationChannelDescription = 'Bedtime reminders and morning sleep summary notifications';
  static const int bedtimeNotificationId = 1001;
  static const int morningNotificationId = 1002;
}
