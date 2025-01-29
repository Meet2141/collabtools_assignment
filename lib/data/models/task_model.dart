import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  bool isSynced;

  TaskModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.isSynced = false,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    bool? isSynced,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  // fromJson method for decoding the API response
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'].toString(),  // assuming id is an integer from API
      title: json['title'],
      isCompleted: json['completed'],
      isSynced: false,  // You can set this to false for newly fetched tasks
    );
  }

  // toJson method for encoding the object to send in requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': isCompleted,
    };
  }
}
