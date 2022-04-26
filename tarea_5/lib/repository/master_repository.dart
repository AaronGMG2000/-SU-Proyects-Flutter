import 'package:sqflite/sqflite.dart';
import 'package:tarea_2/repository/db_manager.dart';

abstract class MasterRepository {
  Future<dynamic> save(
      {required List<dynamic> data, required String table}) async {
    Database dbManager = await DbManager().db;
    Batch batch = dbManager.batch();
    for (final item in data) {
      batch.insert(table, item.toDatabase());
    }
    return batch.commit();
  }

  Future<dynamic> update({
    required dynamic data,
    required String table,
    required String where,
    required List<String> whereArgs,
  }) async {
    Database dbManager = await DbManager().db;
    Batch batch = dbManager.batch();
    batch.update(table, data.toDatabaseU(), where: where, whereArgs: whereArgs);
    return batch.commit();
  }

  Future<dynamic> delete({
    required String table,
    required String where,
    required List<String> whereArgs,
  }) async {
    Database dbManager = await DbManager().db;
    Batch batch = dbManager.batch();
    batch.delete(table, where: where, whereArgs: whereArgs);
    return batch.commit();
  }

  Future<void> deleteTable({required String tablName}) async {
    Database dbManager = await DbManager().db;
    dbManager.delete(tablName);
  }

  Future<List<Map<String, dynamic>>> getAll({required String table}) async {
    Database dbManager = await DbManager().db;
    return dbManager.query(table);
  }

  Future<List<Map<String, dynamic>>> selectWhere({
    required String table,
    required String where,
    required List<String> whereArgs,
  }) async {
    Database dbManager = await DbManager().db;
    return dbManager.query(table, where: where, whereArgs: whereArgs);
  }

  Future<void> editTable({
    required String tableName,
    required String parameter,
    required String type,
  }) async {
    await DbManager.shared.addParameterTable(tableName, parameter, type);
  }
}
