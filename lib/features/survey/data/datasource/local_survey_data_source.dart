import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../model/survey_record_model.dart';

class LocalSurveyDataSource {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final dbPath = await getDatabasesPath();
    _database = await openDatabase(
      path.join(dbPath, 'health_survey.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE survey_records (
            id TEXT PRIMARY KEY,
            answers_json TEXT NOT NULL,
            status TEXT NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            synced_at TEXT,
            last_error TEXT
          )
        ''');
        await db.execute(
          'CREATE INDEX idx_survey_status ON survey_records(status)',
        );
        await db.execute(
          'CREATE INDEX idx_survey_updated ON survey_records(updated_at)',
        );
      },
    );
    return _database!;
  }

  Future<SurveyRecordModel?> loadLatest() async {
    final db = await database;
    final rows = await db.query(
      'survey_records',
      orderBy: 'updated_at DESC',
      limit: 1,
    );
    return rows.isEmpty ? null : SurveyRecordModel.fromMap(rows.first);
  }

  Future<List<SurveyRecordModel>> loadPending() async {
    final db = await database;
    final rows = await db.query(
      'survey_records',
      where: 'status IN (?, ?)',
      whereArgs: ['pending', 'failed'],
      orderBy: 'updated_at ASC',
    );
    return rows.map(SurveyRecordModel.fromMap).toList();
  }

  Future<void> upsert(SurveyRecordModel record) async {
    final db = await database;
    await db.insert(
      'survey_records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
