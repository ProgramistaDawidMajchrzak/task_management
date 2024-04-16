import 'package:flutter/material.dart';
import 'package:task_management_go_online/services/notify_service.dart';
import 'package:task_management_go_online/services/task_management_db.dart';
import 'package:task_management_go_online/models/task_model.dart';
import 'package:task_management_go_online/widgets/custom_app_bar.dart';
import 'package:task_management_go_online/widgets/custom_text_field.dart';
import 'package:task_management_go_online/widgets/style.dart';
import 'package:intl/intl.dart';

class AddTaskWidget extends StatefulWidget {
  final TaskModel? task;
  const AddTaskWidget({super.key, this.task});

  @override
  State<AddTaskWidget> createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _deadlineController = TextEditingController();
  String selectedPriority = '';
  TaskManagementDB db = TaskManagementDB();

  bool nameError = false;
  bool descError = false;
  bool dateError = false;
  bool priotityError = false;

  DateTime? _selectedDate;

  bool validate() {
    if (_nameController.text.isEmpty) {
      setState(() {
        nameError = true;
      });
      return true;
    } else if (_descriptionController.text.isEmpty) {
      setState(() {
        descError = true;
      });
      return true;
    } else if (_deadlineController.text.isEmpty) {
      setState(() {
        dateError = true;
      });
      return true;
    } else if (selectedPriority.isEmpty) {
      setState(() {
        priotityError = true;
      });
      return true;
    }
    return false;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _deadlineController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _deadlineController = TextEditingController(
      text: widget.task?.deadline != null
          ? widget.task!.deadline!.toString().substring(0, 10)
          : '',
    );
    selectedPriority = widget.task?.priority == null
        ? ''
        : (widget.task?.priority == 1
            ? 'Low'
            : (widget.task?.priority == 2 ? 'Medium' : 'High'));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isEditing = widget.task != null;
    return Scaffold(
      appBar: CustomAppBar(
        title: isEditing ? 'Edit Task' : 'Add Task',
        backOption: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: InkWell(
          onTap: () async {
            if (validate()) {
              return;
            }
            int priority;
            switch (selectedPriority) {
              case 'Low':
                priority = 1;
                break;
              case 'Medium':
                priority = 2;
                break;
              default:
                priority = 3;
            }
            DateTime? deadline = DateTime.tryParse(_deadlineController.text);
            if (isEditing) {
              await db.updateTask(
                  id: widget.task!.id!,
                  task: TaskModel(
                      name: _nameController.text,
                      description: _descriptionController.text,
                      deadline: deadline, //tutaj error
                      createdAt: DateTime.now(),
                      priority: priority));
            } else {
              await db.create(
                  task: TaskModel(
                      name: _nameController.text,
                      description: _descriptionController.text,
                      deadline: deadline,
                      createdAt: DateTime.now(),
                      priority: priority));
            }
            Navigator.pushNamed(context, '/tasks-list');
            LocalNotifications.scheduledNotification(hour: 10, minutes: 30);
          },
          child: Container(
            height: 60,
            // /width: MediaQuery.of(context).size.width - 200,
            decoration: const BoxDecoration(
              color: Color(0xFF3787EB),
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
            ),
            child: Center(
              child: Text(
                isEditing ? 'Edit task' : 'Add task',
                style: poppinsMedium.copyWith(
                    color: Colors.white, fontSize: screenWidth > 360 ? 17 : 12),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                hintText: 'Task name',
                isError: nameError,
              ),
              const SizedBox(height: 12.0),
              CustomTextField(
                isError: descError,
                controller: _descriptionController,
                hintText: 'Description',
                isMultiline: true,
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _deadlineController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Due Date',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 26.0,
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: !dateError
                        ? const BorderSide(color: Colors.black, width: 1.0)
                        : const BorderSide(color: Colors.red, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: !dateError
                        ? const BorderSide(color: Colors.black, width: 1.0)
                        : const BorderSide(color: Colors.red, width: 2.0),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 12.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: priotityError ? Colors.red : Colors.transparent,
                    width: 2.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        'Priority: $selectedPriority',
                        style: poppinsMedium.copyWith(
                            color: Colors.black, fontSize: 15),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            setState(() {
                              selectedPriority = 'Low';
                            });
                          },
                          color: Colors.yellow,
                          minWidth: (screenWidth - 85) / 3,
                          child: const Text('Low',
                              style: TextStyle(color: Colors.black)),
                        ),
                        MaterialButton(
                          onPressed: () {
                            setState(() {
                              selectedPriority = 'Medium';
                            });
                          },
                          color: Colors.orange,
                          minWidth: (screenWidth - 85) / 3,
                          child: const Text('Medium',
                              style: TextStyle(color: Colors.black)),
                        ),
                        MaterialButton(
                          onPressed: () {
                            setState(() {
                              selectedPriority = 'High';
                            });
                          },
                          color: Colors.red,
                          minWidth: (screenWidth - 85) / 3,
                          child: const Text('High',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
