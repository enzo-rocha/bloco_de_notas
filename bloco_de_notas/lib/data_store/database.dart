import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  /// Constructor
  DatabaseHelper();

  static const tableName = "note";

  static const createTableSql = '''
  CREATE TABLE $tableName (
    id          INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title       TEXT NOT NULL,
    description TEXT NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
  );
  ''';

  Future<void> createTable(Database db) async {
    await db.execute(createTableSql);
  }

  Future<Database?> database() async {
    const database = "notes.db";
    return openDatabase(
      database,
      version: 1,
      onCreate: (Database db, int version) async {
        await createTable(db);
      },
    );
  }

  Future<int?> insert(String title, String? description) async {
    final db = await database();

    final data = {
      'title': title,
      'description': description,
    };

    final id = await db?.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  Future<List<Map<String, Object?>>?> requestNotes() async {
    final db = await database();

    return await db?.query(
      tableName,
      orderBy: "created_at DESC",
    );
  }

  Future<Future<List<Map<String, Object?>>>?> requestOneNote(int id) async {
    final db = await database();

    return db?.query(
      tableName,
      orderBy: "id = ?",
      whereArgs: [id],
      limit: 1,
    );
  }

  Future<int?> update(int id, String title, String? description) async {
    final db = await database();

    final data = {
      'title': title,
      'description': description,
      'created_at': DateTime.now().toString(),
    };

    final result = await db?.update(
      tableName,
      data,
      where: "id = ?",
      whereArgs: [id],
    );

    return result;
  }

  Future<void> delete(int id) async {
    final db = await database();

    await db?.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}