import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/task_model.dart';
import '../../logic/bloc/todo_bloc.dart';
import '../../logic/bloc/todo_event.dart';
import '../../core/constants/string_constants.dart';

/// TaskItems - Display Task Item
class TaskItem extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onEdit;

  const TaskItem({super.key, required this.task, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: _buildLeading(context),
        title: _buildTitle(),
        subtitle: _buildSubTitle(),
        trailing: _buildTrailing(context),
      ),
    );
  }

  Widget _buildLeading(BuildContext context) {
    return Transform.scale(
      scale: 1.2,
      child: Checkbox(
        value: task.isCompleted,
        onChanged: (bool? value) {
          if (value != null) {
            context.read<TodoBloc>().add(
                  UpdateTaskEvent(
                    task.copyWith(isCompleted: value, isSynced: task.isSynced),
                  ),
                );
          }
        },
        activeColor: Colors.green,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      task.title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        color: task.isCompleted ? Colors.grey : Colors.black,
      ),
    );
  }

  Widget _buildSubTitle() {
    return Row(
      children: [
        Icon(
          task.isSynced ? Icons.check_circle : Icons.sync,
          color: task.isSynced ? Colors.green : Colors.orange,
          size: 20,
        ),
        const SizedBox(width: 5),
        Text(
          task.isSynced ? StringConstants.synced : StringConstants.pendingSync,
          style: TextStyle(
            fontSize: 16,
            color: task.isSynced ? Colors.green : Colors.orange,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTrailing(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onEdit,
          child: Icon(
            Icons.edit,
            color: Colors.blue,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            context.read<TodoBloc>().add(DeleteTaskEvent(task.id));
          },
          child: Icon(
            Icons.delete,
            color: Colors.red,
            size: 20,
          ),
        ),
      ],
    );
  }
}
