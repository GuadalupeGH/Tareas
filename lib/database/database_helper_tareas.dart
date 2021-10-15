import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tareas/models/tareas_model.dart';

class DatabaseHelperTareas {
  static final _nombreBD = "TAREASBD";
  static final _versionBD = 1;
  static final _nombreTBL = "TBLTareas";

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    Directory carpeta = await getApplicationDocumentsDirectory();
    String rutaDB = join(carpeta.path, _nombreBD);
    return openDatabase(rutaDB, version: _versionBD, onCreate: _crearTabla);
  }

  Future<void> _crearTabla(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $_nombreTBL (idTarea INTEGER PRIMARY KEY, nomTarea VARCHAR(100), dscTarea VARCHAR(500), fechaEntrega VARCHAR(100), entregada INT(1))");
  }

  Future<int> insert(Map<String, dynamic> row) async {
    var conexion = await database;
    return conexion!.insert(_nombreTBL, row);
  }

  Future<int> update(Map<String, dynamic> row) async {
    var conexion = await database;
    return conexion!.update(_nombreTBL, row,
        where: 'idTarea = ?', whereArgs: [row['idTarea']]);
  }

  Future<int> delete(Map<String, dynamic> row) async {
    var conexion = await database;
    return conexion!
        .delete(_nombreTBL, where: 'idTarea = ?', whereArgs: [row['idTarea']]);
  }

  Future<int> numCompletadas() async {
    var conexion = await database;
    var resultado = await conexion!.query(_nombreTBL, where: 'entregada = 1');
    return resultado.length;
  }

  Future<int> numPendientes() async {
    var conexion = await database;
    var resultado = await conexion!.query(_nombreTBL, where: 'entregada = 0');
    return resultado.length;
  }

  Future<int> numVencidas() async {
    var conexion = await database;
    var result = await conexion!.rawQuery(
        "SELECT (strftime('%s','now') - strftime('%s',t.fechaEntrega)) as tiempo from TBLTareas t where tiempo>0 and t.entregada==0");
    return result.length;
  }

  Future<List<TareasModel>> getTareasPendientes() async {
    var conexion = await database;
    var result = await conexion!.query(_nombreTBL, where: 'entregada = 0');
    return result.map((tareaMap) => TareasModel.fromMap(tareaMap)).toList();
  }

  Future<List<TareasModel>> getTareasTerminadas() async {
    var conexion = await database;
    var result = await conexion!.query(_nombreTBL, where: 'entregada = 1');
    return result.map((tareaMap) => TareasModel.fromMap(tareaMap)).toList();
  }

  Future<TareasModel> getTarea(int idTarea) async {
    var conexion = await database;
    var result = await conexion!
        .query(_nombreTBL, where: 'idTarea = ?', whereArgs: [idTarea]);
    return TareasModel.fromMap(result.first);
  }
}
