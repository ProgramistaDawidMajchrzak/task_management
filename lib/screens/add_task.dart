import 'package:flutter/material.dart';
import 'package:task_management_go_online/models/task_model.dart';
import 'package:task_management_go_online/widgets/custom_app_bar.dart';
import 'package:task_management_go_online/widgets/custom_text_field.dart';
import 'package:task_management_go_online/widgets/style.dart';
import 'package:intl/intl.dart';

class AddTaskWidget extends StatefulWidget {
  final TaskModel? task;
  // final ValueChanged<String> onSubmit;
  const AddTaskWidget({super.key, this.task});

  @override
  State<AddTaskWidget> createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _deadlineController = TextEditingController();
  String selectedPriority = '';
  final formKey = GlobalKey<FormState>();

  bool nameError = false;

  DateTime? _selectedDate;

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
    _nameController = TextEditingController(text: widget.task?.name);
    _descriptionController =
        TextEditingController(text: widget.task?.description);
    // _deadlineController =
    //     TextEditingController(text: widget.task!.deadline);
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
      appBar: const CustomAppBar(
        title: 'Add Task',
        backOption: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 60,
          // /width: MediaQuery.of(context).size.width - 200,
          decoration: const BoxDecoration(
            color: Color(0xFF3787EB),
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
          ),
          child: Center(
            child: Text(
              'Add task',
              style: poppinsMedium.copyWith(
                  color: Colors.white, fontSize: screenWidth > 360 ? 17 : 12),
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
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true, // Zapobiega wprowadzaniu danych ręcznie
              ),
              const SizedBox(height: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12.0),
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
                        color: Colors.green,
                        minWidth: (screenWidth - 85) / 3,
                        child:
                            Text('Low', style: TextStyle(color: Colors.black)),
                      ),
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            selectedPriority = 'Medium';
                          });
                        },
                        color: Colors.yellow,
                        minWidth: (screenWidth - 85) / 3,
                        child: Text('Medium',
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
                        child:
                            Text('High', style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
