import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management_go_online/models/task_model.dart';
import 'package:task_management_go_online/widgets/style.dart';

class TaskElementWidget extends StatelessWidget {
  final TaskModel task;
  const TaskElementWidget({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(task.deadline!);
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.name,
                  style: poppinsSemiBold.copyWith(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Due: $formattedDate',
                  style: poppinsRegular.copyWith(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          Container(
            margin: const EdgeInsets.only(top: 14.0),
            decoration: BoxDecoration(
              color: task.status == 'planned'
                  ? Colors.blue
                  : (task.status == 'executing' ? Colors.purple : Colors.green),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
              child: Text(
                task.status,
                style: poppinsBold.copyWith(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          Container(
            width: 60,
            height: 50,
            margin: const EdgeInsets.only(right: 10.0),
            decoration: BoxDecoration(
              color: const Color(0xFFE9E9F0),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border(
                right: BorderSide(
                  color: task.priority == 1
                      ? Colors.yellow
                      : (task.priority == 2 ? Colors.orange : Colors.red),
                  width: 10.0,
                ),
              ),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/task_view', arguments: [task]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
