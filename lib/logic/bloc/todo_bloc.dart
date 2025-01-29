import 'package:collabtools_assignment/core/services/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/database/hive_service.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<SyncTasksEvent>(_onSyncTasks);
  }

  Future<void> _loadAndEmitTasks(Emitter<TodoState> emit) async {
    try {
      final tasks = HiveService.getTasks();
      emit(TodoLoaded(tasks));
    } catch (e) {
      emit(TodoError("Failed to load tasks: ${e.toString()}"));
    }
  }

  void _onLoadTasks(LoadTasksEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    await _loadAndEmitTasks(emit);
  }

  void _onAddTask(AddTaskEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      await HiveService.addTask(event.task);
      emit(TodoAdded(event.task)); // Emit task added state
      await _loadAndEmitTasks(emit);
    } catch (e) {
      emit(TodoError("Failed to add task: ${e.toString()}"));
    }
  }

  void _onUpdateTask(UpdateTaskEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      await HiveService.updateTask(event.task);
      emit(TodoUpdated(event.task)); // Emit task updated state
      await _loadAndEmitTasks(emit);
    } catch (e) {
      emit(TodoError("Failed to update task: ${e.toString()}"));
    }
  }

  void _onDeleteTask(DeleteTaskEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      await HiveService.deleteTask(event.taskId);
      emit(TodoDeleted(event.taskId)); // Emit task deleted state
      await _loadAndEmitTasks(emit);
    } catch (e) {
      emit(TodoError("Failed to delete task: ${e.toString()}"));
    }
  }

  void _onSyncTasks(SyncTasksEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final tasks = HiveService.getTasks();
      for (var task in tasks) {
        if (!task.isSynced) {
          try {
            await TodoService.syncTask(task);
            task.isSynced = true;
            await HiveService.updateTask(task);
          } catch (e) {
            debugPrint("Error syncing task: ${e.toString()}");
          }
        }
      }
      await _loadAndEmitTasks(emit);
    } catch (e) {
      emit(TodoError("Failed to sync tasks: ${e.toString()}"));
    }
  }
}
