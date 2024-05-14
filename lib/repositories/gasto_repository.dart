import 'package:sqflite/sqflite.dart';
import '../models/gasto.dart';
import '../database/database_helper.dart';

class GastoRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Map<String, dynamic>>> retrieveGastos() async {
    final db = await _databaseHelper.database;
    return await db.query('Gastos');
  }

  Future<void> addGasto(Map<String, dynamic> gastoData) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'Gastos',
      gastoData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateGasto(Map<String, dynamic> gastoData) async {
    final db = await _databaseHelper.database;
    int gastoId = gastoData['gasto_id'];
    await db.update(
      'Gastos',
      gastoData,
      where: 'gasto_id = ?',
      whereArgs: [gastoId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteGasto(int id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'Gastos',
      where: 'gasto_id = ?',
      whereArgs: [id],
    );
  }
}
