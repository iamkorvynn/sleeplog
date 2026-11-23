import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:sleeplog/constants/app_constants.dart';
import 'package:sleeplog/models/sleep_settings.dart';
import 'package:sleeplog/repositories/preferences_repository.dart';

class SqlitePreferencesRepository implements PreferencesRepository {
  Database? _db;

  Future<void> initialize() async {
    if (_db != null) return;
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'sleeplog_prefs.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ${AppConstants.preferencesTable} (
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL
          )
        ''');
      },
    );
  }

  @override
  Future<SleepSettings> getSettings() async {
    await initialize();
    final rows = await _db!.query(
      AppConstants.preferencesTable,
      where: 'key = ?',
      whereArgs: ['user_settings'],
    );
    if (rows.isEmpty) {
      return const SleepSettings.defaults();
    }
    final raw = rows.first['value'] as String;
    return SleepSettings.fromJson(Map<String, dynamic>.from(Map.castFrom(
      Uri.splitQueryString(raw),
    )));
  }

  @override
  Future<void> saveSettings(SleepSettings settings) async {
    await initialize();
    final map = settings.toMap();
    final queryString = Uri(queryParameters: map.map((k, v) => MapEntry(k, v.toString()))).query;
    await _db!.insert(
      AppConstants.preferencesTable,
      {'key': 'user_settings', 'value': queryString},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> clearSettings() async {
    await initialize();
    await _db!.delete(
      AppConstants.preferencesTable,
      where: 'key = ?',
      whereArgs: ['user_settings'],
    );
  }
}}
