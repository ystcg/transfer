import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/user.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'unfold.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            passwordHash TEXT NOT NULL,
            createdAt TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE bookmarks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER NOT NULL,
            tipId TEXT NOT NULL,
            UNIQUE(userId, tipId),
            FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // User operations
  Future<AppUser?> createUser(
    String name,
    String email,
    String password,
  ) async {
    final db = await database;
    try {
      final id = await db.insert('users', {
        'name': name,
        'email': email.toLowerCase().trim(),
        'passwordHash': hashPassword(password),
        'createdAt': DateTime.now().toIso8601String(),
      });
      return await getUserById(id);
    } catch (e) {
      return null; // Email already exists
    }
  }

  Future<AppUser?> getUserByEmail(String email) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.toLowerCase().trim()],
    );
    if (results.isEmpty) return null;
    return AppUser.fromMap(results.first);
  }

  Future<AppUser?> getUserById(int id) async {
    final db = await database;
    final results = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (results.isEmpty) return null;
    return AppUser.fromMap(results.first);
  }

  Future<bool> validatePassword(String email, String password) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'email = ? AND passwordHash = ?',
      whereArgs: [email.toLowerCase().trim(), hashPassword(password)],
    );
    return results.isNotEmpty;
  }

  // Bookmark operations
  Future<void> addBookmark(int userId, String tipId) async {
    final db = await database;
    await db.insert('bookmarks', {
      'userId': userId,
      'tipId': tipId,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> removeBookmark(int userId, String tipId) async {
    final db = await database;
    await db.delete(
      'bookmarks',
      where: 'userId = ? AND tipId = ?',
      whereArgs: [userId, tipId],
    );
  }

  Future<List<String>> getBookmarks(int userId) async {
    final db = await database;
    final results = await db.query(
      'bookmarks',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return results.map((r) => r['tipId'] as String).toList();
  }

  Future<bool> isBookmarked(int userId, String tipId) async {
    final db = await database;
    final results = await db.query(
      'bookmarks',
      where: 'userId = ? AND tipId = ?',
      whereArgs: [userId, tipId],
    );
    return results.isNotEmpty;
  }

  // Admin operations
  Future<int> getTotalBookmarkCount() async {
    final db = await database;
    final results = await db.rawQuery('SELECT COUNT(*) as count FROM bookmarks');
    if (results.isEmpty) return 0;
    return (results.first['count'] as int?) ?? 0;
  }

  Future<void> deleteUser(int userId) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [userId]);
  }

  Future<void> clearAllBookmarks() async {
    final db = await database;
    await db.delete('bookmarks');
  }

  Future<void> clearAllUsers() async {
    final db = await database;
    await db.delete('users');
  }

  Future<List<AppUser>> getAllUsers() async {
    final db = await database;
    final results = await db.query('users', orderBy: 'createdAt DESC');
    return results.map((r) => AppUser.fromMap(r)).toList();
  }
}
