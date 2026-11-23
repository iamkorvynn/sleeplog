import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/repositories/sleep_repository.dart';

class InMemorySleepRepository implements SleepRepository {
  final Map<String, SleepNight> _storage = {};

  @override
  Future<void> initialize() async {}

  @override
  Future<List<SleepNight>> getAllNights() async {
    final list = _storage.values.toList();
    list.sort((a, b) => b.bedtime.compareTo(a.bedtime));
    return list;
  }

  @override
  Future<SleepNight?> getNightById(String id) async {
    return _storage[id];
  }

  @override
  Future<void> saveNight(SleepNight night) async {
    _storage[night.id] = night;
  }

  @override
  Future<void> updateNight(SleepNight night) async {
    _storage[night.id] = night;
  }

  @override
  Future<void> deleteNight(String id) async {
    _storage.remove(id);
  }

  @override
  Future<void> deleteAllNights() async {
    _storage.clear();
  }

  @override
  Future<void> importNights(List<SleepNight> nights) async {
    for (final n in nights) {
      _storage[n.id] = n;
    }
  }
}}
