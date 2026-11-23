import 'package:material_ui/material_ui.dart';

class SleepSettings {
  final double goalHours;
  final bool bedtimeReminderEnabled;
  final int bedtimeReminderMinutesBefore;
  final int targetBedtimeHour;
  final int targetBedtimeMinute;
  final bool morningSummaryEnabled;
  final int morningSummaryHour;
  final int morningSummaryMinute;
  final bool use24HourFormat;
  final String themeMode; // 'dark', 'light', 'system'

  const SleepSettings({
    this.goalHours = 8.0,
    this.bedtimeReminderEnabled = true,
    this.bedtimeReminderMinutesBefore = 30,
    this.targetBedtimeHour = 23,
    this.targetBedtimeMinute = 0,
    this.morningSummaryEnabled = true,
    this.morningSummaryHour = 8,
    this.morningSummaryMinute = 0,
    this.use24HourFormat = false,
    this.themeMode = 'dark',
  });

  const SleepSettings.defaults() : this();

  TimeOfDay get targetBedtime => TimeOfDay(hour: targetBedtimeHour, minute: targetBedtimeMinute);
  TimeOfDay get morningSummaryTime => TimeOfDay(hour: morningSummaryHour, minute: morningSummaryMinute);

  }
