import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import 'api_service.dart';
import '../database/hive_service.dart';

class TodoService {
  // Fetch tasks from the API
  static Future<List<TaskModel>> fetchTasks() async {
    try {
      return await ApiService.performGetRequest(ApiService.baseUrl);
    } catch (e) {
      debugPrint("Error occurred while fetching tasks: $e");
      throw Exception("Error occurred while fetching tasks");
    }
  }

  // Sync a task with the server
  static Future<void> syncTask(TaskModel task) async {
    try {
      final response = await ApiService.performPostRequest(ApiService.baseUrl, task.toJson());
      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        task.isSynced = true;
        await HiveService.updateTask(task);
      } else {
        debugPrint("Failed to sync task with status code: ${response?.statusCode}");
      }
    } catch (e) {
      debugPrint("Error syncing task: $e");
      throw Exception("Error syncing task: $e");
    }
  }
}
