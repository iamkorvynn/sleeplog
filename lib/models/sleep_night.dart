class SleepNight {
  final String id;
  final DateTime bedtime;
  final DateTime wakeTime;
  final int quality; // 1 to 5
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  SleepNight({
    required this.id,
    required this.bedtime,
    required this.wakeTime,
    required this.quality,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? bedtime,
        updatedAt = updatedAt ?? wakeTime;

  Duration get duration => wakeTime.difference(bedtime);
  int get durationMinutes => duration.inMinutes;
  double get durationHours => duration.inMinutes / 60.0;
  bool isGoalMet(double targetHours) => durationHours >= targetHours;
  }
