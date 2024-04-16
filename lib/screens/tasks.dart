import 'package:flutter/material.dart';
import 'package:task_management_go_online/services/task_management_db.dart';
import 'package:task_management_go_online/models/task_model.dart';
import 'package:task_management_go_online/widgets/custom_app_bar.dart';
import 'package:task_management_go_online/widgets/custom_nav_bar.dart';
import 'package:task_management_go_online/widgets/task_element.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({super.key});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  Future<List<Map>>? futureTasks;
  final tasksDB = TaskManagementDB();
  String activeFilterDate = 'ALL';

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  void fetchTasks() {
    setState(() {
      futureTasks = tasksDB.fetchAll();
      //futureTasks = tasksDB.fetchTodaysTasks();
      //futureTasks = tasksDB.fetchThisWeekTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Tasks',
        backOption: false,
      ),
      bottomNavigationBar: const CustomNavBar(),
      body: Column(
        children: [
          Container(
            height: 60,
            margin: const EdgeInsets.only(bottom: 12.0),
            color: const Color(0xFFE9E9F0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      futureTasks = tasksDB.fetchAll();
                      activeFilterDate = 'ALL';
                    });
                  },
                  color: activeFilterDate == 'ALL'
                      ? const Color(0xFF3787EB)
                      : null,
                  minWidth: (screenWidth - 85) / 3,
                  child: Text(
                    'ALL',
                    style: TextStyle(
                        color: activeFilterDate == 'ALL'
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      futureTasks = tasksDB.fetchTodaysTasks();
                      activeFilterDate = 'TODAY';
                    });
                  },
                  color: activeFilterDate == 'TODAY'
                      ? const Color(0xFF3787EB)
                      : null,
                  minWidth: (screenWidth - 85) / 3,
                  child: Text(
                    'TODAY',
                    style: TextStyle(
                        color: activeFilterDate == 'TODAY'
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      futureTasks = tasksDB.fetchThisWeekTasks();
                      activeFilterDate = 'THIS WEEK';
                    });
                  },
                  color: activeFilterDate == 'THIS WEEK'
                      ? const Color(0xFF3787EB)
                      : null,
                  minWidth: (screenWidth - 85) / 3,
                  child: Text(
                    'THIS WEEK',
                    style: TextStyle(
                        color: activeFilterDate == 'THIS WEEK'
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<TaskModel>>(
              future: futureTasks?.then((queryResultSet) {
                return queryResultSet
                    .map((map) => TaskModel(
                          id: map['id'] as int,
                          name: map['name'] as String,
                          description: map['description'] as String,
                          deadline: DateTime.parse(map['deadline'] as String),
                          createdAt:
                              DateTime.parse(map['created_at'] as String),
                          priority: map['priority'] as int,
                          status: map['status'] as String,
                        ))
                    .toList();
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final tasks = snapshot.data ?? [];
                  return tasks.isEmpty
                      ? Center(
                          child: Text(
                            'No tasks..',
                            style: TextStyle(
                              fontSize: screenWidth > 360 ? 19 : 13,
                              color: Colors.black,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return TaskElementWidget(
                              task: task,
                            );
                          },
                        );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
