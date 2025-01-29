import 'package:equatable/equatable.dart';
import '../../data/models/task_model.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTasksEvent extends TodoEvent {}

class AddTaskEvent extends TodoEvent {
  final TaskModel task;

  AddTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TodoEvent {
  final TaskModel task;

  UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TodoEvent {
  final String taskId;

  DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class SyncTasksEvent extends TodoEvent {}
