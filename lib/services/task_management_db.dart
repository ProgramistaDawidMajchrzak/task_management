import 'package:sqflite/sqflite.dart';
import 'package:task_management_go_online/services/database_service.dart';
import 'package:task_management_go_online/models/task_model.dart';

class TaskManagementDB {
  Future<void> createTable(Database database) async {
    await database.execute(
        'CREATE TABLE tasks (id INTEGER PRIMARY KEY, name TEXT, description TEXT, deadline TEXT, created_at TEXT, priority INTEGER, status TEXT)');
  }

  Future<int> create({required TaskModel task}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      'INSERT INTO tasks(name, description, deadline, created_at, priority, status) '
      'VALUES(?, ?, ?, ?, ?, ?)',
      [
        task.name,
        task.description,
        task.deadline?.toIso8601String(),
        DateTime.now().toIso8601String(),
        task.priority,
        task.status,
      ],
    );
  }

  Future<List<Map>> fetchAll() async {
    final database = await DatabaseService().database;
    List<Map> tasks =
        await database.rawQuery('SELECT * FROM tasks ORDER BY deadline ASC');
    return tasks;
  }

  Future<List<Map>> fetchTodaysTasks() async {
    final database = await DatabaseService().database;
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    String query = 'SELECT * FROM tasks WHERE DATE(deadline) = ?';
    List<Map<String, dynamic>> tasks =
        await database.rawQuery(query, [formattedDate]);
    return tasks;
  }

  Future<int> countTodaysPendingTasks() async {
    final database = await DatabaseService().database;
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    String query =
        'SELECT COUNT(*) AS count FROM tasks WHERE DATE(deadline) = ? AND status != ?';
    List<Map<String, dynamic>> result =
        await database.rawQuery(query, [formattedDate, 'done']);
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count;
  }

  Future<List<Map>> fetchThisWeekTasks() async {
    final database = await DatabaseService().database;
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    String formattedStartOfWeek =
        "${startOfWeek.year}-${startOfWeek.month.toString().padLeft(2, '0')}-${startOfWeek.day.toString().padLeft(2, '0')}";
    String formattedEndOfWeek =
        "${endOfWeek.year}-${endOfWeek.month.toString().padLeft(2, '0')}-${endOfWeek.day.toString().padLeft(2, '0')}";
    String query =
        'SELECT * FROM tasks WHERE deadline BETWEEN ? AND ? ORDER BY deadline ASC';
    List<Map<String, dynamic>> tasks = await database
        .rawQuery(query, [formattedStartOfWeek, formattedEndOfWeek]);

    return tasks;
  }

  Future<int> updateStatus({required int id, required String status}) async {
    final database = await DatabaseService().database;
    return await database.update('tasks', {'status': status},
        where: 'id = ?',
        conflictAlgorithm: ConflictAlgorithm.rollback,
        whereArgs: [id]);
  }

  Future<int> updateTask({required int id, required TaskModel task}) async {
    final database = await DatabaseService().database;
    return await database.update(
        'tasks',
        {
          'name': task.name,
          'description': task.description,
          'deadline': task.deadline?.toIso8601String(),
          'priority': task.priority
        },
        where: 'id = ?',
        conflictAlgorithm: ConflictAlgorithm.rollback,
        whereArgs: [id]);
  }

  Future<void> delete({required int id}) async {
    final database = await DatabaseService().database;
    await database.rawDelete('DELETE FROM tasks WHERE id = $id');
  }
}
