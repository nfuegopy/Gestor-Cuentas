import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';

class ResumenRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<double> calculateMonthlyBalance(
      int userId, int month, int year) async {
    final db = await _databaseHelper.database;

    try {
      // Sumar todos los ingresos del usuario para el mes y año especificados
      final List<Map<String, dynamic>> ingresosResult = await db.rawQuery(
        '''
        SELECT SUM(monto) as totalIngresos
        FROM Ingresos
        WHERE usuario_id = ? AND strftime('%m', fecha) = ? AND strftime('%Y', fecha) = ?
        ''',
        [userId, month.toString().padLeft(2, '0'), year.toString()],
      );
      print('Ingresos Result: $ingresosResult');

      // Sumar todos los gastos del usuario para el mes y año especificados
      final List<Map<String, dynamic>> gastosResult = await db.rawQuery(
        '''
        SELECT SUM(monto) as totalGastos
        FROM Gastos
        WHERE usuario_id = ? AND strftime('%m', fecha) = ? AND strftime('%Y', fecha) = ?
        ''',
        [userId, month.toString().padLeft(2, '0'), year.toString()],
      );
      print('Gastos Result: $gastosResult');

      // Calcular el balance
      double totalIngresos =
          (ingresosResult.first['totalIngresos'] as num?)?.toDouble() ?? 0.0;
      double totalGastos =
          (gastosResult.first['totalGastos'] as num?)?.toDouble() ?? 0.0;
      return totalIngresos - totalGastos;
    } catch (e) {
      print('Error en calculateMonthlyBalance: $e');
      return 0.0;
    }
  }

  Future<double> getTotalIngresos(int userId, int month, int year) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      '''
      SELECT SUM(monto) as totalIngresos
      FROM Ingresos
      WHERE usuario_id = ? AND strftime('%m', fecha) = ? AND strftime('%Y', fecha) = ?
      ''',
      [userId, month.toString().padLeft(2, '0'), year.toString()],
    );
    return (result.first['totalIngresos'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getTotalEgresos(int userId, int month, int year) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      '''
      SELECT SUM(monto) as totalEgresos
      FROM Gastos
      WHERE usuario_id = ? AND strftime('%m', fecha) = ? AND strftime('%Y', fecha) = ?
      ''',
      [userId, month.toString().padLeft(2, '0'), year.toString()],
    );
    return (result.first['totalEgresos'] as num?)?.toDouble() ?? 0.0;
  }

  Future<List<Map<String, dynamic>>> getMonthlyMovements(
      int userId, int month, int year) async {
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> ingresosResult = await db.rawQuery(
      '''
      SELECT 'Ingreso' as tipo, monto, fecha, notas
      FROM Ingresos
      WHERE usuario_id = ? AND strftime('%m', fecha) = ? AND strftime('%Y', fecha) = ?
      ''',
      [userId, month.toString().padLeft(2, '0'), year.toString()],
    );

    final List<Map<String, dynamic>> gastosResult = await db.rawQuery(
      '''
      SELECT 'Gasto' as tipo, monto, fecha, notas
      FROM Gastos
      WHERE usuario_id = ? AND strftime('%m', fecha) = ? AND strftime('%Y', fecha) = ?
      ''',
      [userId, month.toString().padLeft(2, '0'), year.toString()],
    );

    return [...ingresosResult, ...gastosResult];
  }
}
