class TaskModel {
  final String name;
  final String description;
  final DateTime deadline;
  final DateTime createdAt;
  final int priority;
  final String status;

  TaskModel(
      {required this.name,
      required this.description,
      required this.deadline,
      required this.createdAt,
      required this.priority,
      this.status = 'pending'});
}
