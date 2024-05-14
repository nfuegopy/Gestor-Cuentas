import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initializeDB();
    return _database!;
  }

  Future<Database> initializeDB() async {
    String path = join(await getDatabasesPath(), 'gestion_gastos.db');
    return await openDatabase(
      path,
      version: 5,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Categoria (
            categoria_id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            tipo TEXT NOT NULL
          );
        ''');
        await db.execute('''
          CREATE TABLE Frecuencia (
            frecuencia_id INTEGER PRIMARY KEY AUTOINCREMENT,
            descripcion TEXT NOT NULL
          );
        ''');
        await db.execute('''
          CREATE TABLE Usuario (
            usuario_id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            correo TEXT
          );
        ''');
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
        await db.execute('''
          CREATE TABLE Ingresos (
            ingreso_id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuario_id INTEGER,
            categoria_id INTEGER NOT NULL,
            fecha DATE,
            monto DECIMAL(10, 2),
            notas TEXT,
            FOREIGN KEY(categoria_id) REFERENCES Categoria(categoria_id),
            FOREIGN KEY(usuario_id) REFERENCES Usuario(usuario_id)
          );
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          if (oldVersion == 5) {
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
        }
      },
    );
  }
}
