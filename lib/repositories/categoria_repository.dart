import 'package:sqflite/sqflite.dart';
import '../models/categoria.dart';
import '../database/database_helper.dart';

class CategoriaRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Categoria>> retrieveCategoriasPorTipo(String tipo) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query('Categoria', where: 'tipo = ?', whereArgs: [tipo]);
    return List.generate(maps.length, (i) {
      return Categoria.fromMap(maps[i]);
    });
  }

  Future<List<Categoria>> retrieveCategorias() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Categoria');
    return List.generate(maps.length, (i) {
      return Categoria.fromMap(maps[i]);
    });
  }

  Future<void> addCategoria(Categoria categoria) async {
    final db = await _databaseHelper.database;
    try {
      await db.insert(
        'Categoria',
        categoria.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error al insertar categoría: $e');
    }
  }

  Future<void> updateCategoria(Categoria categoria) async {
    final db = await _databaseHelper.database;
    try {
      await db.update(
        'Categoria',
        categoria.toMap(),
        where: 'categoria_id = ?',
        whereArgs: [categoria.categoriaId],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error al actualizar categoría: $e');
    }
  }

  Future<void> deleteCategoria(int id) async {
    final db = await _databaseHelper.database;
    try {
      await db.delete(
        'Categoria',
        where: 'categoria_id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error al eliminar categoría: $e');
    }
  }
}
