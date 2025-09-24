import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  static const  String routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'User Name';
  String userEmail = 'user@email.com';
  int points = 0;
  int currentStreak = 0;
  int maxStreak = 0;
  String league = 'Bronze';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'User Name';
      userEmail = prefs.getString('userEmail') ?? 'user@email.com';
      points = prefs.getInt('points') ?? 0;
      currentStreak = prefs.getInt('currentStreak') ?? 0;
      maxStreak = prefs.getInt('maxStreak') ?? 0;
      league = prefs.getString('league') ?? 'Bronze';
    });
  }

  // void _logout() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();
  //   if (mounted) {
  //     Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double progress = (points % 100) / 100; // Example: 100 points per league

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
        bottom: BorderSide(color: Colors.white24, width: 2), // 👈 border
      ),
          ),
        ),
          elevation: 0, 
      ),
      body: Stack(
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
                    style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
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
                      _statCard('Current Streak', currentStreak.toString(), Icons.local_fire_department),
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
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: const [
                            Icon(Icons.format_quote, color: Colors.white70, size: 32),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '"Discipline is the bridge between goals and accomplishment."',
                                style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic, fontSize: 16),
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
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Card(
      color: Colors.white10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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