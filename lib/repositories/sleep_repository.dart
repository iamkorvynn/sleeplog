import 'package:sleeplog/models/sleep_night.dart';

abstract class SleepRepository {
  Future<void> initialize();
  Future<List<SleepNight>> getAllNights();
  Future<SleepNight?> getNightById(String id);
  Future<void> saveNight(SleepNight night);
  Future<void> updateNight(SleepNight night);
  Future<void> deleteNight(String id);
  Future<void> deleteAllNights();
  Future<void> importNights(List<SleepNight> nights);
}
