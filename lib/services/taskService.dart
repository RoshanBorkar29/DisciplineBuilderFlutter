import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_discplinebuilder/common/GlobalVariables.dart';
import 'package:flutter_discplinebuilder/common/errorhandling.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_discplinebuilder/common/task.dart';

class TaskService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> addTask(String userId, String title, BuildContext context) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found. Please log in.');
      }
      final response = await http.post(
        Uri.parse("$uri/tasks/api/addTask"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': title,
        }),
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          print("Task added successfully: ${response.body}");
          final data = jsonDecode(response.body);
          return data['task'];
        },
      );
    } catch (e) {
      print('Error adding task: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add task: $e')),
      );
      rethrow;
    }
  }

 // ...existing code...
  Future<List<Task>> getTasks(String userId, BuildContext context) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found. Please log in.');
      }
      final response = await http.get(
        Uri.parse('$uri/tasks/api/tasks'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      // Capture and return the result from httpErrorHandle
      final tasks = httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          final List<dynamic> data = jsonDecode(response.body);
          return data.map((json) => Task.fromJson(json)).toList();
        },
      );
      return tasks;
    } catch (e) {
      print('Error fetching tasks: $e');
      rethrow;
    }
  }
// ...existing code...

  Future<void> toggleTask(String userId, int taskIndex, BuildContext context) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found. Please log in.');
      }
      final response = await http.put(
        Uri.parse("$uri/tasks/api/tasks/toggle/$taskIndex"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'taskIndex': taskIndex,
        }),
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          print("Task toggled successfully");
        },
      );
    } catch (e) {
      print('Error toggling task: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to toggle task: $e')),
      );
      rethrow;
    }
  }

  Future<void> deleteTask(String userId, int taskIndex, BuildContext context) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found. Please log in.');
      }
      final response = await http.delete(
        Uri.parse("$uri/tasks/api/tasks/$taskIndex"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          print("Task deleted successfully");
        },
      );
    } catch (e) {
      print('Error deleting task: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete task: $e')),
      );
      rethrow;
    }
  }
}