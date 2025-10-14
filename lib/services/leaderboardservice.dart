import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_discplinebuilder/common/GlobalVariables.dart'; // For '$uri'
import 'package:flutter_discplinebuilder/common/errorhandling.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Fetches a list of all users sorted by points and streak
  Future<List<Map<String, dynamic>>> fetchGlobalLeaderboard(BuildContext context) async {
    List<Map<String, dynamic>> leaderboardList = [];
    try {
      // 1. Get the auth token
      final token = await _getToken();
      if (token == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Authentication required to view leaderboard.')),
          );
        }
        return [];
      }

      // 2. Make the HTTP GET request to the global leaderboard endpoint
      http.Response response = await http.get(
        Uri.parse('$uri/api/leaderboard/global'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      
      // Check if widget is still in the tree before using context
      if (!context.mounted) return [];

      // 3. Handle the HTTP response (including success 200 and errors like 500)
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          final decoded = jsonDecode(response.body);
          
          // Populate the list from the JSON response
          for (int i = 0; i < decoded.length; i++) {
            // Each item is a user object (name, points, streak, league)
            leaderboardList.add(decoded[i] as Map<String, dynamic>);
          }
        },
      );

    } catch (e) {
      // Handles network errors (e.g., connection refused, timeout)
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load leaderboard due to connection error: ${e.toString()}')),
        );
      }
    }
    // Return the list (will be empty if an error occurred)
    return leaderboardList;
  }
}
