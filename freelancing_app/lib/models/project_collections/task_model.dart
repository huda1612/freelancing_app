class TaskModel {
  final String id;
  //بدل الاسم
  // final int orderNumber;
  final String description;
  final bool isDone;

  TaskModel({
    required this.id,
    // required this.orderNumber,
    this.description = '',
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'orderNumber': orderNumber,
      'description': description,
      'isDone': isDone,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map, String docId) {
    return TaskModel(
      id: docId,
      // orderNumber: (map['orderNumber'] as num?)?.toInt() ??
      //     (map['order_number'] as num?)?.toInt() ??
      //     0,
      description: map['description'] ?? map['name'] ?? '',
      isDone: map['isDone'] ?? false,
    );
  }

  TaskModel copyWith({
    String? description,
    bool? isDone,
  }) {
    return TaskModel(
      id: id,
      // orderNumber: orderNumber,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }
}
