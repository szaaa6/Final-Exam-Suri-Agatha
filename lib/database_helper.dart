import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'enrollment.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE subjects (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            name TEXT,
            credits INTEGER,
            FOREIGN KEY (userId) REFERENCES users (id)
          )
        ''');
      },
    );
  }

  Future<void> insertUser(String name, String email, String password) async {
    final db = await database;
    await db.insert('users', {'name': name, 'email': email, 'password': password});
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> saveSubjects(int userId, List<Map<String, dynamic>> subjects) async {
    final db = await database;

    // Hapus subjek lama sebelum menyimpan yang baru
    await db.delete('subjects', where: 'userId = ?', whereArgs: [userId]);

    // Menyimpan subjek baru
    for (var subject in subjects) {
      await db.insert('subjects', {
        'userId': userId,
        'name': subject['name'],
        'credits': subject['credits'],
      });
    }
  }

  Future<List<Map<String, dynamic>>> getSubjectsByUserId(int userId) async {
    final db = await database;
    return await db.query('subjects', where: 'userId = ?', whereArgs: [userId]);
  }
}
