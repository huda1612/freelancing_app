import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String? id;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  // final String? projectId;
  final bool isRead;
  final Timestamp? createdAt;

  NotificationModel({
    this.id,
    required this.title,
    required this.body,
    this.data,
    // this.projectId,
    this.isRead = false,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'data': data,
      // 'projectId': projectId,
      'isRead': isRead,
      'createdAt': createdAt ?? Timestamp.now(),
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map, String docId) {
    return NotificationModel(
      id: docId,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      data: map['data'] ?? {},
      // projectId: map['projectId'],
      isRead: map['isRead'] ?? false,
      createdAt:
          map['createdAt'] is Timestamp ? map['createdAt'] as Timestamp : null,
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    String? projectId,
    bool? isRead,
    Timestamp? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      // projectId: projectId ?? this.projectId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
