import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/constants/table_names.dart';
import '../../../../core/database/app_database.dart';
import '../models/auth_user_model.dart';

class AuthLocalDataSource {
  AuthLocalDataSource({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<Database> get _db async => _database.database;

  Future<AuthUserModel?> login({
    required String email,
    required String password,
  }) async {
    final db = await _db;
    final result = await db.query(
      TableNames.users,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    final user = AuthUserModel.fromMap(result.first);
    final passwordHash = _hashPassword(password);
    if (user.passwordHash != passwordHash) {
      return null;
    }
    return user;
  }

  Future<int> registerUser({
    required String email,
    required String password,
    required String displayName,
    required String role,
    String? photoUrl,
  }) async {
    final db = await _db;
    final now = DateTime.now().toIso8601String();
    return db.insert(TableNames.users, <String, Object?>{
      'email': email.toLowerCase(),
      'password_hash': _hashPassword(password),
      'display_name': displayName,
      'role': role,
      'photo_url': photoUrl,
      'created_at': now,
      'updated_at': now,
    }, conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<bool> emailExists(String email) async {
    final db = await _db;
    final result = await db.query(
      TableNames.users,
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<AuthUserModel?> getUserById(int id) async {
    final db = await _db;
    final result = await db.query(
      TableNames.users,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) {
      return null;
    }
    return AuthUserModel.fromMap(result.first);
  }

  Future<void> updatePassword({
    required int userId,
    required String newPassword,
  }) async {
    final db = await _db;
    await db.update(
      TableNames.users,
      <String, Object?>{
        'password_hash': _hashPassword(newPassword),
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }
}
