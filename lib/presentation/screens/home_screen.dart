import 'package:collabtools_assignment/core/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/task_model.dart';
import '../../logic/bloc/todo_bloc.dart';
import '../../logic/bloc/todo_event.dart';
import '../../logic/bloc/todo_state.dart';
import '../../logic/network/bloc/network_bloc.dart';
import '../../logic/network/bloc/network_state.dart';
import '../widgets/task_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is TodoAdded) {
            _showSnackBar(context, StringConstants.taskAdded);
          }
          if (state is TodoUpdated) {
            _showSnackBar(context, StringConstants.taskUpdated);
          }
          if (state is TodoDeleted) {
            _showSnackBar(context, StringConstants.taskDeleted);
          }
          if (state is TodoCompleted) {
            _showSnackBar(context, StringConstants.taskCompleted);
          }
          if (state is TodoUnselected) {
            _showSnackBar(context, StringConstants.taskMarkedAsIncomplete);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _networkStatusIndicator(context),
              Expanded(
                child: state is TodoLoading
                    ? _loadingIndicator()
                    : state is TodoLoaded
                        ? state.tasks.isEmpty
                            ? _noTasksMessage()
                            : _taskList(state.tasks, context)
                        : _loadingIndicator(),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButtons(context),
      backgroundColor: Colors.grey[100],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        StringConstants.appName,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      backgroundColor: Colors.blueAccent,
      elevation: 10,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _loadingIndicator() {
    return Center(child: CircularProgressIndicator(color: Colors.blueAccent));
  }

  Widget _noTasksMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 50, color: Colors.grey),
          const SizedBox(height: 10),
          Text(
            StringConstants.noTaskPleaseAddSome,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _taskList(List<TaskModel> tasks, BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      padding: EdgeInsets.only(top: 8),
      itemBuilder: (context, index) {
        return TaskItem(
          task: tasks[index],
          onEdit: () => _showTaskDialog(context, task: tasks[index]),
        );
      },
    );
  }

  Column _buildFloatingActionButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'add',
          onPressed: () => _showTaskDialog(context),
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        const SizedBox(height: 12),
        FloatingActionButton(
          heroTag: 'sync',
          onPressed: () {
            context.read<TodoBloc>().add(SyncTasksEvent());
          },
          backgroundColor: Colors.greenAccent,
          child: const Icon(Icons.sync, color: Colors.white),
        ),
      ],
    );
  }

  void _showTaskDialog(BuildContext context, {TaskModel? task}) {
    final TextEditingController taskController = TextEditingController();
    if (task != null) {
      taskController.text = task.title;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            task == null ? StringConstants.addTask : StringConstants.editTask,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: taskController,
            decoration: InputDecoration(
              hintText: StringConstants.enterTaskTitle,
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => taskController.clear(),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
            ),
          ),
          actions: _buildDialogActions(context, taskController, task),
        );
      },
    );
  }

  List<Widget> _buildDialogActions(
    BuildContext context,
    TextEditingController taskController,
    TaskModel? task,
  ) {
    return [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text(
          StringConstants.cancel,
          style: TextStyle(color: Colors.grey),
        ),
      ),
      TextButton(
        onPressed: () {
          final taskTitle = taskController.text.trim();
          if (taskTitle.isNotEmpty) {
            Navigator.pop(context);
            final updatedTask = task?.copyWith(title: taskTitle, isSynced: false) ??
                TaskModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: taskTitle,
                  isCompleted: false,
                  isSynced: false,
                );

            if (task == null) {
              context.read<TodoBloc>().add(AddTaskEvent(updatedTask));
            } else {
              context.read<TodoBloc>().add(UpdateTaskEvent(updatedTask));
            }
          }
        },
        child: const Text(
          StringConstants.save,
          style: TextStyle(color: Colors.blueAccent),
        ),
      ),
    ];
  }

  Widget _networkStatusIndicator(BuildContext context) {
    return SizedBox(
      height: 30,
      width: double.infinity,
      child: BlocBuilder<NetworkStatusBloc, NetworkStatusState>(
        builder: (context, state) {
          return Container(
            alignment: Alignment.center,
            color: state is NetworkOnline ? Colors.green : Colors.red,
            child: Text(
              state is NetworkOnline ? StringConstants.online : StringConstants.offLine,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
