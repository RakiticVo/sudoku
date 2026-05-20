import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SudokuDatabase {
  static final SudokuDatabase instance = SudokuDatabase._init();
  static Database? _database;

  SudokuDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sudoku_newspaper.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Tracks campaign mode levels
    await db.execute('''
      CREATE TABLE campaign_progress (
        volume_id TEXT NOT NULL,
        level_index INTEGER NOT NULL,
        is_completed INTEGER DEFAULT 0,
        best_time_seconds INTEGER,
        unlocked_at_timestamp INTEGER,
        PRIMARY KEY (volume_id, level_index)
      )
    ''');

    // 2. Stores selective replay history (JSON action logs)
    await db.execute('''
      CREATE TABLE press_archives (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        date_timestamp INTEGER NOT NULL,
        solve_duration_seconds INTEGER NOT NULL,
        log_payload TEXT NOT NULL
      )
    ''');

    // 3. Tracks Daily Challenge dates completed
    await db.execute('''
      CREATE TABLE daily_calendar (
        challenge_date TEXT PRIMARY KEY,
        difficulty TEXT NOT NULL,
        solve_time_seconds INTEGER NOT NULL,
        reward_earned INTEGER NOT NULL
      )
    ''');
  }

  // --- Campaign Progress Helpers ---
  Future<void> saveCampaignProgress({
    required String volumeId,
    required int levelIndex,
    required bool isCompleted,
    int? bestTimeSeconds,
  }) async {
    final db = await instance.database;
    await db.insert(
      'campaign_progress',
      {
        'volume_id': volumeId,
        'level_index': levelIndex,
        'is_completed': isCompleted ? 1 : 0,
        'best_time_seconds': bestTimeSeconds,
        'unlocked_at_timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getVolumeProgress(String volumeId) async {
    final db = await instance.database;
    return await db.query(
      'campaign_progress',
      where: 'volume_id = ?',
      whereArgs: [volumeId],
    );
  }

  Future<int> getCompletedCount(String volumeId) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM campaign_progress WHERE volume_id = ? AND is_completed = 1',
      [volumeId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // --- Press Archives (Selective Replay) Helpers ---
  Future<void> saveReplay({
    required String id,
    required String title,
    required String difficulty,
    required int solveDurationSeconds,
    required List<Map<String, dynamic>> moves,
  }) async {
    final db = await instance.database;
    await db.insert(
      'press_archives',
      {
        'id': id,
        'title': title,
        'difficulty': difficulty,
        'date_timestamp': DateTime.now().millisecondsSinceEpoch,
        'solve_duration_seconds': solveDurationSeconds,
        'log_payload': jsonEncode(moves),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllReplays() async {
    final db = await instance.database;
    return await db.query('press_archives', orderBy: 'date_timestamp DESC');
  }

  Future<Map<String, dynamic>?> getReplay(String id) async {
    final db = await instance.database;
    final result = await db.query(
      'press_archives',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> deleteReplay(String id) async {
    final db = await instance.database;
    await db.delete(
      'press_archives',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> purgeAllReplays() async {
    final db = await instance.database;
    await db.delete('press_archives');
  }

  // --- Daily Calendar Helpers ---
  Future<void> saveDailyChallenge({
    required String date,
    required String difficulty,
    required int solveTimeSeconds,
    required int rewardEarned,
  }) async {
    final db = await instance.database;
    await db.insert(
      'daily_calendar',
      {
        'challenge_date': date,
        'difficulty': difficulty,
        'solve_time_seconds': solveTimeSeconds,
        'reward_earned': rewardEarned,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getDailyChallenges() async {
    final db = await instance.database;
    return await db.query('daily_calendar', orderBy: 'challenge_date DESC');
  }

  Future<bool> hasCompletedDaily(String date) async {
    final db = await instance.database;
    final result = await db.query(
      'daily_calendar',
      where: 'challenge_date = ?',
      whereArgs: [date],
    );
    return result.isNotEmpty;
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}
