class TaskModel {
  final String id;
  final String name;
  final String description;
  final bool isDone;

  TaskModel({
    required this.id,
    required this.name,
    this.description = '',
    this.isDone = false,
  });

  // 🔹 تحويل من Object إلى Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'isDone': isDone,
    };
  }

  // 🔹 تحويل من Map إلى Object
  factory TaskModel.fromMap(Map<String, dynamic> map, String docId) {
    return TaskModel(
      id: docId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      isDone: map['isDone'] ?? false,
    );
  }
}
