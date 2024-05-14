import 'package:sqflite/sqflite.dart';
import '../models/frecuencia.dart';
import '../database/database_helper.dart';

class FrecuenciaRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Frecuencia>> retrieveFrecuencias() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Frecuencia');
    return List.generate(maps.length, (i) => Frecuencia.fromMap(maps[i]));
  }

  Future<void> insertFrecuencia(Frecuencia frecuencia) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'Frecuencia',
      {'descripcion': frecuencia.descripcion},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateFrecuencia(Frecuencia frecuencia) async {
    final db = await _databaseHelper.database;
    await db.update(
      'Frecuencia',
      frecuencia.toMap(),
      where: 'frecuencia_id = ?',
      whereArgs: [frecuencia.frecuenciaId],
    );
  }

  Future<void> deleteFrecuencia(int id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'Frecuencia',
      where: 'frecuencia_id = ?',
      whereArgs: [id],
    );
  }

  Future<void> initFrecuencia() async {
    final db = await _databaseHelper.database;
    var exists = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM Frecuencia'));
    if (exists == 0) {
      var frecuencias = ['Diaria', 'Semanal', 'Mensual', 'Anual'];
      for (var desc in frecuencias) {
        await db.insert('Frecuencia', {'descripcion': desc});
      }
    }
  }
}
