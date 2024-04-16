import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management_go_online/models/task_model.dart';
import 'package:task_management_go_online/widgets/custom_app_bar.dart';
import 'package:task_management_go_online/widgets/custom_task_bar.dart';
import 'package:task_management_go_online/widgets/style.dart';

class TaskViewWidget extends StatefulWidget {
  final TaskModel task;
  const TaskViewWidget({super.key, required this.task});

  @override
  State<TaskViewWidget> createState() => _TaskViewWidgetState();
}

class _TaskViewWidgetState extends State<TaskViewWidget> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String formattedDeadlineDate =
        DateFormat('dd MMM yyyy').format(widget.task.deadline!);
    String formattedCreatedDate =
        DateFormat('dd MMM yyyy HH:ss').format(widget.task.createdAt);
    return Scaffold(
      appBar: CustomAppBar(
        title: '${widget.task.name} (${widget.task.status})',
        backOption: true,
        rightIcon: Container(
          width: 50,
          height: 50,
          margin: const EdgeInsets.only(right: 10.0, top: 5.0, bottom: 5.0),
          decoration: const BoxDecoration(
            color: Color(0xFFE9E9F0),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/edit-task',
                  arguments: [widget.task]);
            },
          ),
        ),
      ),
      bottomNavigationBar: CustomTaskBar(
          taskId: widget.task.id!, activeStatus: widget.task.status),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: (screenWidth - 72) / 2,
                    height: 80.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEBF3FC),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: Color(0xFF3787EB),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Due Date',
                              style: poppinsSemiBold.copyWith(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              formattedDeadlineDate,
                              style: poppinsBold.copyWith(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: (screenWidth - 72) / 2,
                    height: 80.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEBF3FC),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(
                          Icons.light_mode,
                          color: Color(0xFF3787EB),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Priority',
                              style: poppinsSemiBold.copyWith(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              widget.task.priority == 1
                                  ? 'Low'
                                  : (widget.task.priority == 2
                                      ? 'Medium'
                                      : 'High'),
                              style: poppinsBold.copyWith(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                'Description',
                style: poppinsBold.copyWith(
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                widget.task.description,
                style: poppinsSemiBold.copyWith(
                  color: const Color(0xFFBBBBBB),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Created At',
                style: poppinsBold.copyWith(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              Text(
                formattedCreatedDate,
                style: poppinsSemiBold.copyWith(
                  color: const Color(0xFFBBBBBB),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
