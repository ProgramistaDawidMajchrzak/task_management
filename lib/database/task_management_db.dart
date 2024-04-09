import 'package:sqflite/sqflite.dart';
import 'package:task_management_go_online/database/database_service.dart';
import 'package:task_management_go_online/models/task_model.dart';

class TaskManagementDB {
  // Future<void> createTable(Database database) async {
  //   await database.execute("""CREATE TABLE IF NOT EXIST $tableName (
  //     "id" INTEGER NOT NULL,
  //     "title" TEXT NOT NULL,
  //   ))
  // }
  Future<void> createTable(Database database) async {
    await database.execute(
        'CREATE TABLE tasks (id INTEGER PRIMARY KEY, name TEXT, description TEXT, deadline TEXT, created_at TEXT, priority INTEGER, status TEXT)');
  }

  Future<int> create({required TaskModel task}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
        'INSERT INTO tasks(name, description, deadline, created_at, priority, status) VALUES(${task.name}, ${task.description}, ${task.deadline}, ${DateTime.now()}, ${task.priority}, ${task.status})');
  }

  // Future<List<TaskModel>> fetchAll() async {
  //   final database = await DatabaseService().database;
  //   final tasks = await database.rawQuery('SELECT * FROM tasks');
  //   return tasks.map((task) => TaskModel.from)
  // }
  Future<List<Map>> fetchAll() async {
    final database = await DatabaseService().database;
    List<Map> tasks = await database.rawQuery('SELECT * FROM tasks');
    return tasks;
  }

  Future<Map<String, Object?>> fetchById(int id) async {
    final database = await DatabaseService().database;
    final task = await database.rawQuery('SELECT * FROM tasks WHERE id = $id');
    return task.first;
  }

  Future<int> updateStatus({required int id, required String status}) async {
    final database = await DatabaseService().database;
    return await database.update('tasks', {'status': status},
        where: 'id = ?',
        conflictAlgorithm: ConflictAlgorithm.rollback,
        whereArgs: [id]);
  }

  Future<void> delete({required int id}) async {
    final database = await DatabaseService().database;
    await database.rawDelete('DELETE FROM tasks WHERE id = $id');
  }
}
