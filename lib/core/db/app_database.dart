

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  // Expose the raw sqflite Database object
  final Database db;

  AppDatabase._(this.db);

  /// The asynchronous factory method that opens the database connection
  static Future<AppDatabase> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'my_app_database.db');

    final database = await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        // Define your tables here
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


        /*
          final int id;
          final String email;
          final UserModelEntity? user;
          final String title;
          final String message;
          final String imageUrl;
          final String topic;
          final String date;
         */
        await db.execute('''
          CREATE TABLE notification (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            notification_id INTEGER NOT NULL UNIQUE,
            email TEXT NOT NULL,
            user TEXT NOT NULL,
            title TEXT NOT NULL,
            message TEXT NOT NULL,
            imageUrl TEXT NOT NULL,
            topic TEXT NOT NULL,
            date TEXT NOT NULL,
            status TEXT NOT NULL DEFAULT 'U'
          )
        ''');
        await db.execute(
          'CREATE INDEX idx_notification_id ON notification(notification_id)',
        );
        await db.execute(
          'CREATE INDEX idx_notification_email ON notification(email)',
        );
        await db.execute(
          'CREATE INDEX idx_notification_topic ON notification(topic)',
        );

      },
    );

    return AppDatabase._(database);
  }
}
