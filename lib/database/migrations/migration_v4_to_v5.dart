import 'package:sqflite/sqflite.dart';

Future<void> migrateV4toV5(Database db) async {
  await db.execute('DROP TABLE IF EXISTS Gastos');
  await db.execute('''
    CREATE TABLE Gastos (
      gasto_id INTEGER PRIMARY KEY AUTOINCREMENT,
      usuario_id INTEGER,
      categoria_id INTEGER NOT NULL,
      frecuencia_id INTEGER NOT NULL,
      fecha DATE,
      periodo YEAR,
      monto DECIMAL(10, 2),
      notas TEXT,
      FOREIGN KEY(categoria_id) REFERENCES Categoria(categoria_id),
      FOREIGN KEY(frecuencia_id) REFERENCES Frecuencia(frecuencia_id),
      FOREIGN KEY(usuario_id) REFERENCES Usuario(usuario_id)
    );
  ''');
}
