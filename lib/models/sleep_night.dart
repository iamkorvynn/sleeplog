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
  String get dateKey => '${bedtime.year}-${bedtime.month.toString().padLeft(2, '0')}-${bedtime.day.toString().padLeft(2, '0')}';
  int get bedtimeMinuteOfDay => bedtime.hour * 60 + bedtime.minute;
  int get wakeMinuteOfDay => wakeTime.hour * 60 + wakeTime.minute;

  List<String> validate() {
    final errors = <String>[];
    if (wakeTime.isBefore(bedtime) || wakeTime == bedtime) {
      errors.add('Wake time must be after bedtime');
    }
    if (duration.inMinutes < 15) {
      errors.add('Sleep duration must be at least 15 minutes');
    }
    if (duration.inHours > 24) {
      errors.add('Sleep duration cannot exceed 24 hours');
    }
    if (quality < 1 || quality > 5) {
      errors.add('Quality rating must be between 1 and 5');
    }
    return errors;
  }

  SleepNight copyWith({
    String? id,
    DateTime? bedtime,
    DateTime? wakeTime,
    int? quality,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SleepNight(
      id: id ?? this.id,
      bedtime: bedtime ?? this.bedtime,
      wakeTime: wakeTime ?? this.wakeTime,
      quality: quality ?? this.quality,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bedtime': bedtime.toIso8601String(),
      'wake_time': wakeTime.toIso8601String(),
      'quality': quality,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory SleepNight.fromMap(Map<String, dynamic> map) {
    return SleepNight(
      id: map['id'] as String,
      bedtime: DateTime.parse(map['bedtime'] as String),
      wakeTime: DateTime.parse(map['wake_time'] as String),
      quality: (map['quality'] as num).toInt(),
      notes: map['notes'] as String?,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at'] as String) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => toMap();
  factory SleepNight.fromJson(Map<String, dynamic> json) => SleepNight.fromMap(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SleepNight &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          bedtime == other.bedtime &&
          wakeTime == other.wakeTime &&
          quality == other.quality &&
          notes == other.notes;

  @override
  int get hashCode => Object.hash(id, bedtime, wakeTime, quality, notes);

  }
