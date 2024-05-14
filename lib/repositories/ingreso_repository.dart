import 'package:sqflite/sqflite.dart';
import '../models/ingreso.dart';
import '../database/database_helper.dart';

class IngresoRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Map<String, dynamic>>> retrieveIngresos() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Ingresos');
    return maps;
  }

  Future<void> addIngreso(Map<String, dynamic> ingresoData) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'Ingresos',
      ingresoData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateIngreso(Ingreso ingreso) async {
    final db = await _databaseHelper.database;
    await db.update(
      'Ingresos',
      ingreso.toMap(),
      where: 'ingreso_id = ?',
      whereArgs: [ingreso.ingresoId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteIngreso(int id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'Ingresos',
      where: 'ingreso_id = ?',
      whereArgs: [id],
    );
  }
}
