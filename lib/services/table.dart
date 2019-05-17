import 'dart:async';
import 'package:sqflite/sqflite.dart';

final String tableTodo = "todo";
final String columnId = "_id";
final String columnDate = "date";
final String columnLocate = "locate";

class Todo {
  int id;
  String date;
  List locate;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnDate: date,
      columnLocate: locate,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Todo();

  Todo.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    date = map[columnDate];
    locate = map[columnLocate];
  }
}

class DatabaseProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1, onCreate: (Database db, int version) async{
      await db.execute(
        '''create table $tableTodo (
          $columnId integer primary key autoincrement,
          $columnDate text not null,
          $columnLocate integer not null)
        '''
      );
    });
  }

  Future<Todo> insert(Todo todo) async {
        todo.id = await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  Future<Todo> getTodo(int id) async{
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnDate, columnLocate],
        where: '$columnId = ?',
        whereArgs: [id]);
    if(maps.length > 0){
      return new Todo.fromMap(maps.first);
    }
    return null;
  }

  Future close() async => db.close();
}