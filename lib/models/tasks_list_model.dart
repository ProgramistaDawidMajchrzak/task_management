import 'package:task_management_go_online/models/task_model.dart';

class TasksModel {
  List<TaskModel> tasks = [];

  void addTask(TaskModel task) {
    tasks.add(task);
  }

  void removeTask(TaskModel task) {
    tasks.remove(task);
  }

  void updateTask(TaskModel oldTask, TaskModel newTask) {
    final index = tasks.indexOf(oldTask);
    if (index != -1) {
      tasks[index] = newTask;
    }
  }

  List<TaskModel> getTasks() {
    return tasks;
  }
}
