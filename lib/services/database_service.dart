import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:recorder_app/exports.dart';

class DatabaseService {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'recordings.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE recordings(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            filePath TEXT,
            timestamp TEXT,
            duration INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertRecording(Recording rec) async {
    final db = await database;
    await db.insert(
      'recordings',
      rec.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Recording>> getRecordings() async {
    final db = await database;
    final res = await db.query('recordings', orderBy: 'id DESC');
    return res.map((e) => Recording.fromMap(e)).toList();
  }

 


  Future<void> deleteRecording(int id) async {
    final db = await database;
    await db.delete(
      'recordings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


}
