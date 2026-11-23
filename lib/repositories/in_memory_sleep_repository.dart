import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/repositories/sleep_repository.dart';

class InMemorySleepRepository implements SleepRepository {
  final Map<String, SleepNight> _storage = {};

  @override
  Future<void> initialize() async {}

  }
