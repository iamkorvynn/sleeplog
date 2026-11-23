import 'package:intl/intl.dart';

class TimeFormatter {
  static String formatDuration(Duration duration, {bool short = false}) {
    final totalMinutes = duration.inMinutes;
    if (totalMinutes <= 0) return '0h 00m';
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (short) {
      if (hours == 0) return '${minutes}m';
      if (minutes == 0) return '${hours}h';
      return '${hours}h ${minutes}m';
    }

    if (hours == 0) return '${minutes}m';
    return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
  }

  static String formatDurationHours(double hours) {
    final totalMinutes = (hours * 60).round();
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }

  static String formatTime(DateTime dateTime, {required bool use24HourFormat}) {
    if (use24HourFormat) {
      return DateFormat('HH:mm').format(dateTime);
    }
    return DateFormat('h:mm a').format(dateTime);
  }

  static String formatTimeOfDay(int hour, int minute, {required bool use24HourFormat}) {
    final dt = DateTime(2026, 1, 1, hour, minute);
    return formatTime(dt, use24HourFormat: use24HourFormat);
  }

  static String formatDate(DateTime date, {bool includeWeekday = true, bool includeYear = false}) {
    if (includeYear) {
      if (includeWeekday) {
        return DateFormat('EEE, MMM d, yyyy').format(date);
      }
      return DateFormat('MMM d, yyyy').format(date);
    }
    if (includeWeekday) {
      return DateFormat('EEE, MMM d').format(date);
    }
    return DateFormat('MMM d').format(date);
  }

  static String formatRelativeNight(DateTime date, {DateTime? referenceDate}) {
    final now = referenceDate ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diffDays = today.difference(target).inDays;

    if (diffDays == 0) return 'Tonight';
    if (diffDays == 1) return 'Last night';
    if (diffDays == 2) return '2 nights ago';
    if (diffDays > 2 && diffDays <= 6) return '$diffDays nights ago';
    return formatDate(date, includeWeekday: true);
  }

  static String formatDebt(Duration debt) {
    final totalMinutes = debt.inMinutes;
    if (totalMinutes.abs() < 5) return 'On track';
    final isSurplus = totalMinutes < 0;
    final absMin = totalMinutes.abs();
    final h = absMin ~/ 60;
    final m = absMin % 60;
    final timeStr = h == 0 ? '${m}m' : (m == 0 ? '${h}h' : '${h}h ${m}m');
    return isSurplus ? '+$timeStr surplus' : '-$timeStr debt';
  }
}}
