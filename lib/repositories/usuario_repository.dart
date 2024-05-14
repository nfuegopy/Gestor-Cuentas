import 'package:sqflite/sqflite.dart';
import '../models/usuario.dart';
import '../database/database_helper.dart';

class UsuarioRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> addUser(String nombre, String? correo) async {
    final db = await _databaseHelper.database;
    try {
      await db.insert(
        'Usuario',
        {
          'nombre': nombre,
          'correo': correo,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error al insertar usuario: $e');
    }
  }

  Future<List<Usuario>> getUsers() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> results = await db.query('Usuario');
    return results.map((map) => Usuario.fromMap(map)).toList();
  }

  Future<void> updateUser(int id, String nombre, String? correo) async {
    final db = await _databaseHelper.database;
    try {
      await db.update(
        'Usuario',
        {'nombre': nombre, 'correo': correo},
        where: 'usuario_id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error al actualizar usuario: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    final db = await _databaseHelper.database;
    try {
      await db.delete(
        'Usuario',
        where: 'usuario_id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error al eliminar usuario: $e');
    }
  }
}
