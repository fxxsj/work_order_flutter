class TaskDepartmentOption {
  const TaskDepartmentOption({
    required this.id,
    required this.name,
    this.processIds = const [],
  });

  final int id;
  final String name;
  final List<int> processIds;
}
