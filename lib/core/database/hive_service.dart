import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/task_model.dart';

class HiveService {
  static late Box<TaskModel> taskBox;

  static Future<void> initHive() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(TaskModelAdapter());
    taskBox = await Hive.openBox<TaskModel>('tasks');
  }

  static List<TaskModel> getTasks() {
    return taskBox.values.toList();
  }

  static Future<void> addTask(TaskModel task) async {
    await taskBox.put(task.id, task);
  }

  static Future<void> deleteTask(String id) async {
    await taskBox.delete(id);
  }

  static Future<void> updateTask(TaskModel task) async {
    await taskBox.put(task.id, task);
  }
}
