import 'package:sleeplog/models/sleep_night.dart';

class SleepStats {
  final int totalNights;
  final Duration averageDuration7Days;
  final Duration averageDuration30Days;
  final Duration averageDurationAllTime;
  final SleepNight? longestNight;
  final SleepNight? shortestNight;
  final double bedtimeConsistencyScore; // 0.0 - 100.0%
  final double bedtimeConsistencyStdDevMinutes;
  final int currentGoalStreak;
  final int bestGoalStreak;
  final Duration sleepDebt7Days; // positive = debt, negative = surplus
  final double averageQuality7Days;
  final double averageQuality30Days;
  final double averageQualityAllTime;
  final Map<int, int> qualityDistribution; // 1..5 -> count
  final int nightsGoalMetCount;
  final int nightsGoalMissedCount;
  final double goalMetPercentage;

  const SleepStats({
    required this.totalNights,
    required this.averageDuration7Days,
    required this.averageDuration30Days,
    required this.averageDurationAllTime,
    this.longestNight,
    this.shortestNight,
    required this.bedtimeConsistencyScore,
    required this.bedtimeConsistencyStdDevMinutes,
    required this.currentGoalStreak,
    required this.bestGoalStreak,
    required this.sleepDebt7Days,
    required this.averageQuality7Days,
    required this.averageQuality30Days,
    required this.averageQualityAllTime,
    required this.qualityDistribution,
    required this.nightsGoalMetCount,
    required this.nightsGoalMissedCount,
    required this.goalMetPercentage,
  });

  const SleepStats.empty()
      : totalNights = 0,
        averageDuration7Days = Duration.zero,
        averageDuration30Days = Duration.zero,
        averageDurationAllTime = Duration.zero,
        longestNight = null,
        shortestNight = null,
        bedtimeConsistencyScore = 100.0,
        bedtimeConsistencyStdDevMinutes = 0.0,
        currentGoalStreak = 0,
        bestGoalStreak = 0,
        sleepDebt7Days = Duration.zero,
        averageQuality7Days = 0.0,
        averageQuality30Days = 0.0,
        averageQualityAllTime = 0.0,
        qualityDistribution = const {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
        nightsGoalMetCount = 0,
        nightsGoalMissedCount = 0,
        goalMetPercentage = 0.0;

  SleepStats copyWith({
    int? totalNights,
    Duration? averageDuration7Days,
    Duration? averageDuration30Days,
    Duration? averageDurationAllTime,
    SleepNight? longestNight,
    SleepNight? shortestNight,
    double? bedtimeConsistencyScore,
    double? bedtimeConsistencyStdDevMinutes,
    int? currentGoalStreak,
    int? bestGoalStreak,
    Duration? sleepDebt7Days,
    double? averageQuality7Days,
    double? averageQuality30Days,
    double? averageQualityAllTime,
    Map<int, int>? qualityDistribution,
    int? nightsGoalMetCount,
    int? nightsGoalMissedCount,
    double? goalMetPercentage,
  }) {
    return SleepStats(
      totalNights: totalNights ?? this.totalNights,
      averageDuration7Days: averageDuration7Days ?? this.averageDuration7Days,
      averageDuration30Days: averageDuration30Days ?? this.averageDuration30Days,
      averageDurationAllTime: averageDurationAllTime ?? this.averageDurationAllTime,
      longestNight: longestNight ?? this.longestNight,
      shortestNight: shortestNight ?? this.shortestNight,
      bedtimeConsistencyScore: bedtimeConsistencyScore ?? this.bedtimeConsistencyScore,
      bedtimeConsistencyStdDevMinutes: bedtimeConsistencyStdDevMinutes ?? this.bedtimeConsistencyStdDevMinutes,
      currentGoalStreak: currentGoalStreak ?? this.currentGoalStreak,
      bestGoalStreak: bestGoalStreak ?? this.bestGoalStreak,
      sleepDebt7Days: sleepDebt7Days ?? this.sleepDebt7Days,
      averageQuality7Days: averageQuality7Days ?? this.averageQuality7Days,
      averageQuality30Days: averageQuality30Days ?? this.averageQuality30Days,
      averageQualityAllTime: averageQualityAllTime ?? this.averageQualityAllTime,
      qualityDistribution: qualityDistribution ?? this.qualityDistribution,
      nightsGoalMetCount: nightsGoalMetCount ?? this.nightsGoalMetCount,
      nightsGoalMissedCount: nightsGoalMissedCount ?? this.nightsGoalMissedCount,
      goalMetPercentage: goalMetPercentage ?? this.goalMetPercentage,
    );
  }
}}
