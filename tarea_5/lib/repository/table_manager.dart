import 'package:sqflite/sqflite.dart';

class TableManager {
  TableManager._privateConstuctor();
  static final TableManager shared = TableManager._privateConstuctor();

  Future<void> cliente(Database db) async {
    const String table = """CREATE TABLE cliente (
          dniCl INTEGER PRIMARY KEY, 
          nombreCl TEXT NOT NULL, 
          apellido1 TEXT NOT NULL, 
          apellido2 TEXT, 
          claseVia TEXT NOT NULL, 
          nombreVia TEXT NOT NULL, 
          numeroVia TEXT NOT NULL, 
          codPostal TEXT NOT NULL, 
          observaciones TEXT, 
          ciudad TEXT NOT NULL, 
          telefono TEXT NOT NULL
          )""";
    await db.execute(table);
  }

  Future<void> seguro(Database db) async {
    const String table = """CREATE TABLE seguro (
          numeroPoliza INTEGER PRIMARY KEY, 
          dniCl INTEGER NOT NULL, 
          ramo TEXT NOT NULL, 
          fechaInicio DateTime NOT NULL, 
          fechaVencimiento DateTime NOT NULL, 
          condicionesParticulares TEXT NOT NULL, 
          observaciones TEXT, 
          FOREIGN KEY(dniCl) REFERENCES cliente(dniCl)
          )""";
    await db.execute(table);
  }

  Future<void> perito(Database db) async {
    const String table = """CREATE TABLE perito (
          dniPerito INTEGER PRIMARY KEY, 
          nombrePerito TEXT NOT NULL, 
          apellidoPerito1 TEXT NOT NULL, 
          apellidoPerito2 TEXT, 
          telefonoContacto TEXT NOT NULL, 
          telefonoOficina TEXT NOT NULL, 
          claseVia TEXT NOT NULL, 
          nombreVia TEXT NOT NULL, 
          numeroVia TEXT NOT NULL, 
          codPostal TEXT NOT NULL, 
          ciudad TEXT
          )""";
    await db.execute(table);
  }

  Future<void> siniestro(Database db) async {
    const String table = """CREATE TABLE siniestro (
          idSiniestro INTEGER PRIMARY KEY, 
          numeroPoliza INTEGER, 
          fechaSiniestro DateTime, 
          causas TEXT, 
          aceptado TEXT, 
          indermizacion TEXT, 
          dniPerito INTEGER, 
          FOREIGN KEY(numeroPoliza) REFERENCES seguro(numeroPoliza),
          FOREIGN KEY(dniPerito) REFERENCES perito(dniPerito)
          )""";
    await db.execute(table);
  }

  Future<void> login(Database db) async {
    const String table = """CREATE TABLE login (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          password TEXT, 
          username TEXT,
          email TEXT, 
          name TEXT
          )""";
    await db.execute(table);
  }

  Future<void> createTable(Database? db, String tableName) async {
    String table = """CREATE TABLE $tableName (
      id Integer PRIMARY KEY AUTOINCREMENT,
      name TEXT
    )""";
    if (db != null) {
      await db.execute(table);
      Batch batch = db.batch();
      batch.insert(tableName, {'name': 'test'});
      batch.commit();
    }
  }

  Future<void> addParameterTable(
      Database? db, String tableName, String parameter, String type) async {
    String table = "ALTER TABLE $tableName ADD COLUMN $parameter $type";
    if (db != null) {
      await db.execute(table);
    }
  }
}
