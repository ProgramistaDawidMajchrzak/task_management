import 'package:flutter/material.dart';
import 'package:task_management_go_online/services/notify_service.dart';
import 'package:task_management_go_online/services/task_management_db.dart';
import 'package:task_management_go_online/widgets/style.dart';

class CustomTaskBar extends StatefulWidget {
  final int taskId;
  final String activeStatus;
  // ignore: prefer_typing_uninitialized_variables
  const CustomTaskBar(
      {super.key, required this.taskId, required this.activeStatus});

  @override
  State<CustomTaskBar> createState() => CustomTaskBarWidgetState();
}

class CustomTaskBarWidgetState extends State<CustomTaskBar> {
  TaskManagementDB db = TaskManagementDB();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        // /width: MediaQuery.of(context).size.width - 200,
        decoration: const BoxDecoration(
          color: Color(0xFFE9E9F0),
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (widget.activeStatus != 'planned') ...[
                InkWell(
                  onTap: () async {
                    await db.updateStatus(id: widget.taskId, status: 'planned');
                    Navigator.pushNamed(context, '/tasks-list');
                    LocalNotifications.scheduledNotification(
                        hour: 10, minutes: 30);
                  },
                  child: _buildStatusButton('Planned', Icons.note_add_outlined,
                      const Color(0xFF3787EB)),
                ),
              ],
              if (widget.activeStatus != 'executing') ...[
                InkWell(
                  onTap: () async {
                    await db.updateStatus(
                        id: widget.taskId, status: 'executing');
                    Navigator.pushNamed(context, '/tasks-list');
                    LocalNotifications.scheduledNotification(
                        hour: 10, minutes: 30);
                  },
                  child: _buildStatusButton(
                      'Executing', Icons.settings_outlined, Colors.purple),
                ),
              ],
              if (widget.activeStatus != 'done') ...[
                InkWell(
                  onTap: () async {
                    await db.updateStatus(id: widget.taskId, status: 'done');
                    Navigator.pushNamed(context, '/tasks-list');
                    LocalNotifications.scheduledNotification(
                        hour: 10, minutes: 30);
                  },
                  child: _buildStatusButton(
                      'Done', Icons.done_outlined, Colors.green),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusButton(String name, IconData icon, Color color) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 50,
      width: (screenWidth - 120) / 2,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 5),
          Text(
            name,
            style: poppinsExtraBold.copyWith(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
