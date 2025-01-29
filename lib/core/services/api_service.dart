import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../data/models/task_model.dart';

class ApiService {
  static const String baseUrl = "https://jsonplaceholder.typicode.com/todos";
  static final http.Client _client = http.Client();

  // Generic GET request handler
  static Future<List<TaskModel>> performGetRequest(String url) async {
    try {
      final response = await _client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((task) => TaskModel.fromJson(task)).toList();
      } else {
        throw Exception("Failed to load tasks with status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error occurred while fetching tasks: $e");
      throw Exception("Error occurred while fetching tasks: $e");
    }
  }

  // Generic POST request handler
  static Future<http.Response?> performPostRequest(String url, Map<String, dynamic> body) async {
    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception("Failed to sync task. Status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error occurred during POST request: $e");
      return null;
    }
  }
}
