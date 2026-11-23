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

  SleepSettings copyWith({
    double? goalHours,
    bool? bedtimeReminderEnabled,
    int? bedtimeReminderMinutesBefore,
    int? targetBedtimeHour,
    int? targetBedtimeMinute,
    bool? morningSummaryEnabled,
    int? morningSummaryHour,
    int? morningSummaryMinute,
    bool? use24HourFormat,
    String? themeMode,
  }) {
    return SleepSettings(
      goalHours: goalHours ?? this.goalHours,
      bedtimeReminderEnabled: bedtimeReminderEnabled ?? this.bedtimeReminderEnabled,
      bedtimeReminderMinutesBefore: bedtimeReminderMinutesBefore ?? this.bedtimeReminderMinutesBefore,
      targetBedtimeHour: targetBedtimeHour ?? this.targetBedtimeHour,
      targetBedtimeMinute: targetBedtimeMinute ?? this.targetBedtimeMinute,
      morningSummaryEnabled: morningSummaryEnabled ?? this.morningSummaryEnabled,
      morningSummaryHour: morningSummaryHour ?? this.morningSummaryHour,
      morningSummaryMinute: morningSummaryMinute ?? this.morningSummaryMinute,
      use24HourFormat: use24HourFormat ?? this.use24HourFormat,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'goal_hours': goalHours,
      'bedtime_reminder_enabled': bedtimeReminderEnabled ? 1 : 0,
      'bedtime_reminder_minutes_before': bedtimeReminderMinutesBefore,
      'target_bedtime_hour': targetBedtimeHour,
      'target_bedtime_minute': targetBedtimeMinute,
      'morning_summary_enabled': morningSummaryEnabled ? 1 : 0,
      'morning_summary_hour': morningSummaryHour,
      'morning_summary_minute': morningSummaryMinute,
      'use_24_hour_format': use24HourFormat ? 1 : 0,
      'theme_mode': themeMode,
    };
  }

  factory SleepSettings.fromMap(Map<String, dynamic> map) {
    return SleepSettings(
      goalHours: (map['goal_hours'] as num?)?.toDouble() ?? 8.0,
      bedtimeReminderEnabled: map['bedtime_reminder_enabled'] == 1 || map['bedtime_reminder_enabled'] == true,
      bedtimeReminderMinutesBefore: (map['bedtime_reminder_minutes_before'] as num?)?.toInt() ?? 30,
      targetBedtimeHour: (map['target_bedtime_hour'] as num?)?.toInt() ?? 23,
      targetBedtimeMinute: (map['target_bedtime_minute'] as num?)?.toInt() ?? 0,
      morningSummaryEnabled: map['morning_summary_enabled'] == 1 || map['morning_summary_enabled'] == true,
      morningSummaryHour: (map['morning_summary_hour'] as num?)?.toInt() ?? 8,
      morningSummaryMinute: (map['morning_summary_minute'] as num?)?.toInt() ?? 0,
      use24HourFormat: map['use_24_hour_format'] == 1 || map['use_24_hour_format'] == true,
      themeMode: (map['theme_mode'] as String?) ?? 'dark',
    );
  }

  Map<String, dynamic> toJson() => toMap();
  factory SleepSettings.fromJson(Map<String, dynamic> json) => SleepSettings.fromMap(json);

  }
