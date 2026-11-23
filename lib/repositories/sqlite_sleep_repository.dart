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

  }
