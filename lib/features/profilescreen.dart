import 'package:flutter/material.dart';
// import 'package:flutter_discplinebuilder/common/drawer.dart';
import 'package:flutter_discplinebuilder/services/authService.dart';
// import 'package:flutter_discplinebuilder/services/taskService.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService= AuthService();
  String userName = 'Loading...';
  String userEmail = '';
  int points = 0;
  int currentStreak = 0;
  int maxStreak = 0;
  String league = 'Bronze';
  bool loading = true;
  String? error;
  int maxStreakStored=0;


@override
void initState() {
  super.initState();
  _loadProfile();
}

Future<void> _loadProfile() async {
  final data = await _authService.fetchUserProfile(context);
  if (data != null) {
    setState(() {
      

  if(currentStreak>maxStreak){
    maxStreakStored=currentStreak;
  }
      userName = data['name'] ?? 'Unknown';
      userEmail = data['email'] ?? '';
      points = data['points'] ?? 0;
      currentStreak = data['streak'] ?? 0;
      maxStreak = maxStreakStored;
      league = data['league'] ?? 'Bronze';
      loading = false;
    });
  } else {
    setState(() => loading = false);
  }
}

  

  @override
  Widget build(BuildContext context) {
    double progress = (points % 100) / 100;

    return Scaffold(
      
      appBar: AppBar(
        title: const Text('Profile'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border(
              bottom: BorderSide(color: Colors.white24, width: 2),
            ),
          ),
        ),
        elevation: 0,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
              : _buildProfileContent(progress),
    );
  }

  Widget _buildProfileContent(double progress) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 60, color: Colors.deepPurple),
                ),
                const SizedBox(height: 20),
                Text(
                  userName,
                  style: const TextStyle(
                      fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  userEmail,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statCard('Points', points.toString(), Icons.star),
                    _statCard('Current Streak', currentStreak.toString(),
                        Icons.local_fire_department),
                    _statCard('Max Streak', maxStreak.toString(), Icons.emoji_events),
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'League: $league',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          Icon(Icons.military_tech, color: Colors.amber[300]),
                        ],
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white24,
                        color: Colors.amber,
                        minHeight: 8,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Progress to next league: ${(progress * 100).toInt()}%',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Card(
                    color: Colors.white10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.format_quote,
                              color: Colors.white70, size: 32),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '"Discipline is the bridge between goals and accomplishment."',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Card(
      color: Colors.white10,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 100,
        height: 110,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.amber[200], size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
