import 'package:flutter/material.dart';
import 'package:task_management_go_online/services/notify_service.dart';
import 'package:task_management_go_online/services/task_management_db.dart';
import 'package:task_management_go_online/geo.dart';
import 'package:task_management_go_online/screens/geo_panel.dart';
import 'package:task_management_go_online/widgets/custom_app_bar.dart';
import 'package:task_management_go_online/widgets/custom_nav_bar.dart';
import 'package:task_management_go_online/widgets/home_chart.dart';
import 'package:task_management_go_online/widgets/style.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  Future<List<Map>>? futureTasks;
  final tasksDB = TaskManagementDB();
  final geo = Geo();
  double? latitude;
  double? longitude;
  String activeFilterDate = 'TODAY';

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  void fetchTasks() {
    setState(() {
      futureTasks = tasksDB.fetchTodaysTasks();
    });
  }

  int countDoneTasks(List<Map> tasks) {
    int count = 0;
    for (var task in tasks) {
      if (task['status'] == 'done') {
        count++;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Home',
        backOption: false,
      ),
      bottomNavigationBar: const CustomNavBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GeolocatorWidget(),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Statistics',
                    style: poppinsBold.copyWith(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                  FutureBuilder<List<Map>>(
                    future: futureTasks,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        final List<Map>? tasks = snapshot.data;
                        if (tasks == null || tasks.isEmpty) {
                          return const Center(
                              child:
                                  Text('There is no data to show statistics'));
                        } else {
                          return Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                PieChartSample1(
                                  allTasks: tasks.length,
                                  doneTasks: countDoneTasks(tasks),
                                ),
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(80),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${countDoneTasks(tasks)}/${tasks.length}',
                                      style: poppinsBold.copyWith(
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
