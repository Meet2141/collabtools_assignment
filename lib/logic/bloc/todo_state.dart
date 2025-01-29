import 'package:equatable/equatable.dart';
import '../../data/models/task_model.dart';

abstract class TodoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<TaskModel> tasks;

  TodoLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TodoError extends TodoState {
  final String message;

  TodoError(this.message);

  @override
  List<Object?> get props => [message];
}

class TodoAdded extends TodoState {
  final TaskModel task;

  TodoAdded(this.task);

  @override
  List<Object?> get props => [task];
}

class TodoUpdated extends TodoState {
  final TaskModel task;

  TodoUpdated(this.task);

  @override
  List<Object?> get props => [task];
}

class TodoDeleted extends TodoState {
  final String taskId;

  TodoDeleted(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class TodoCompleted extends TodoState {
  final TaskModel task;

  TodoCompleted(this.task);

  @override
  List<Object?> get props => [task];
}

class TodoUnselected extends TodoState {
  final TaskModel task;

  TodoUnselected(this.task);

  @override
  List<Object?> get props => [task];
}
