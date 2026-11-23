import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:sleeplog/constants/app_constants.dart';
import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/repositories/sleep_repository.dart';

class SqliteSleepRepository implements SleepRepository {
  Database? _db;

  @override
  Future<void> initialize() async {
    if (_db != null) return;
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, AppConstants.dbName);

    _db = await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ${AppConstants.nightsTable} (
            id TEXT PRIMARY KEY,
            bedtime TEXT NOT NULL,
            wake_time TEXT NOT NULL,
            quality INTEGER NOT NULL,
            notes TEXT,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE INDEX idx_bedtime ON ${AppConstants.nightsTable} (bedtime DESC)
        ''');
      },
    );
  }

  Database get db {
    if (_db == null) {
      throw StateError('SqliteSleepRepository must be initialized before use');
    }
    return _db!;
  }

  @override
  Future<List<SleepNight>> getAllNights() async {
    final rows = await db.query(
      AppConstants.nightsTable,
      orderBy: 'bedtime DESC',
    );
    return rows.map((r) => SleepNight.fromMap(r)).toList();
  }

  @override
  Future<SleepNight?> getNightById(String id) async {
    final rows = await db.query(
      AppConstants.nightsTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return SleepNight.fromMap(rows.first);
  }

  @override
  Future<void> saveNight(SleepNight night) async {
    await db.insert(
      AppConstants.nightsTable,
      night.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateNight(SleepNight night) async {
    await db.update(
      AppConstants.nightsTable,
      night.toMap(),
      where: 'id = ?',
      whereArgs: [night.id],
    );
  }

  @override
  Future<void> deleteNight(String id) async {
    await db.delete(
      AppConstants.nightsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> deleteAllNights() async {
    await db.delete(AppConstants.nightsTable);
  }

  @override
  Future<void> importNights(List<SleepNight> nights) async {
    final batch = db.batch();
    for (final night in nights) {
      batch.insert(
        AppConstants.nightsTable,
        night.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
