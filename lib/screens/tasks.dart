import 'package:flutter/material.dart';
import 'package:task_management_go_online/database/task_management_db.dart';
import 'package:task_management_go_online/widgets/custom_app_bar.dart';
import 'package:task_management_go_online/widgets/custom_nav_bar.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({super.key});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  Future<List<Map>>? futureTasks;
  final tasksDB = TaskManagementDB();

  @override
  void initState() {
    super.initState();

    fetchTasks();
  }

  void fetchTasks() {
    setState(() {
      futureTasks = tasksDB.fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Tasks',
        backOption: false,
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}
