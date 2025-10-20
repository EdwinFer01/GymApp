import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../constants/table_names.dart';

class AppDatabase {
  AppDatabase._();

  static const _dbName = 'my_gym_app.db';
  static const _dbVersion = 3;

  static final AppDatabase instance = AppDatabase._();

  sqflite.Database? _database;
  static bool _isFactoryInitialized = false;

  Future<sqflite.Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _openDatabase();
    return _database!;
  }

  Future<void> _ensureDatabaseFactoryInitialized() async {
    if (_isFactoryInitialized) return;

    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      sqflite.databaseFactory = databaseFactoryFfi;
    }

    _isFactoryInitialized = true;
  }

  Future<sqflite.Database> _openDatabase() async {
    await _ensureDatabaseFactoryInitialized();

    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = p.join(directory.path, _dbName);

    return sqflite.openDatabase(
      path,
      version: _dbVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await _createSchema(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            ALTER TABLE ${TableNames.progressRecords}
            ADD COLUMN exercise_name TEXT
          ''');
          await db.execute('''
            ALTER TABLE ${TableNames.progressRecords}
            ADD COLUMN exercise_weight REAL
          ''');
          await db.execute('''
            ALTER TABLE ${TableNames.progressRecords}
            ADD COLUMN exercise_reps INTEGER
          ''');
        }
        if (oldVersion < 3) {
          await db.execute('''
            ALTER TABLE ${TableNames.users}
            ADD COLUMN photo_url TEXT
          ''');
        }
      },
    );
  }

  Future<void> _createSchema(sqflite.Database db) async {
    await db.transaction((txn) async {
      await txn.execute('''
        CREATE TABLE ${TableNames.users} (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT NOT NULL UNIQUE,
          password_hash TEXT NOT NULL,
          display_name TEXT NOT NULL,
          role TEXT NOT NULL,
          photo_url TEXT,
          created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
      ''');

      await txn.execute('''
        CREATE TABLE ${TableNames.clients} (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          first_name TEXT NOT NULL,
          last_name TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE,
          phone TEXT,
          birth_date TEXT,
          gender TEXT NOT NULL,
          height_cm REAL,
          weight_kg REAL,
          created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (user_id) REFERENCES ${TableNames.users}(id) ON DELETE SET NULL
        )
      ''');

      await txn.execute('''
        CREATE TABLE ${TableNames.memberships} (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          client_id INTEGER NOT NULL,
          plan_name TEXT NOT NULL,
          status TEXT NOT NULL,
          price REAL NOT NULL,
          start_date TEXT NOT NULL,
          end_date TEXT NOT NULL,
          billing_cycle_days INTEGER,
          notes TEXT,
          created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (client_id) REFERENCES ${TableNames.clients}(id) ON DELETE CASCADE
        )
      ''');

      await txn.execute('''
        CREATE TABLE ${TableNames.payments} (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          membership_id INTEGER NOT NULL,
          amount REAL NOT NULL,
          status TEXT NOT NULL,
          method TEXT NOT NULL,
          paid_at TEXT NOT NULL,
          reference TEXT,
          notes TEXT,
          created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (membership_id) REFERENCES ${TableNames.memberships}(id) ON DELETE CASCADE
        )
      ''');

      await txn.execute('''
        CREATE TABLE ${TableNames.products} (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          description TEXT,
          price REAL NOT NULL,
          stock INTEGER NOT NULL DEFAULT 0,
          sku TEXT,
          category TEXT,
          image_url TEXT,
          created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
      ''');

      await txn.execute('''
        CREATE TABLE ${TableNames.trainingSessions} (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          client_id INTEGER NOT NULL,
          title TEXT NOT NULL,
          type TEXT NOT NULL,
          scheduled_at TEXT NOT NULL,
          duration_minutes INTEGER,
          notes TEXT,
          created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (client_id) REFERENCES ${TableNames.clients}(id) ON DELETE CASCADE
        )
      ''');

      await txn.execute('''
        CREATE TABLE ${TableNames.workoutSets} (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          session_id INTEGER NOT NULL,
          exercise_name TEXT NOT NULL,
          set_number INTEGER NOT NULL,
          repetitions INTEGER NOT NULL,
          weight REAL,
          rest_seconds INTEGER,
          combination TEXT NOT NULL,
          notes TEXT,
          created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (session_id) REFERENCES ${TableNames.trainingSessions}(id) ON DELETE CASCADE
        )
      ''');

      await txn.execute('''
        CREATE TABLE ${TableNames.progressRecords} (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          client_id INTEGER NOT NULL,
          recorded_at TEXT NOT NULL,
          weight_kg REAL,
          body_fat_percentage REAL,
          chest_cm REAL,
          waist_cm REAL,
          hip_cm REAL,
          arm_cm REAL,
          thigh_cm REAL,
          exercise_name TEXT,
          exercise_weight REAL,
          exercise_reps INTEGER,
          notes TEXT,
          created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (client_id) REFERENCES ${TableNames.clients}(id) ON DELETE CASCADE
        )
      ''');
    });
  }

  Future<void> close() async {
    final db = _database;
    if (db == null) return;
    await db.close();
    _database = null;
  }
}
