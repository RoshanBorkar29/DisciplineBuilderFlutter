import 'package:flutter/material.dart';
import 'package:flutter_discplinebuilder/features/profilescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  
  Future<Map<String, String>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('userName') ?? 'User Name';
    final email = prefs.getString('userEmail') ?? 'user@email.com';
    return {'name': name, 'email': email};
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blueGrey[900],
      child: FutureBuilder(
        future: getUserInfo(),
        builder: (context, snapshot) {
          final name = snapshot.data?['name'] ?? 'User Name';
          final email = snapshot.data?['email'] ?? 'user@email.com';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drawer Header with profile
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                accountName:  Text(
                  name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                accountEmail:  Text(
                  email,
                  style: TextStyle(fontSize: 14),
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
                ),
              ),
          
              // Profile
              ListTile(
                leading: const Icon(Icons.person, size: 22, color: Colors.white),
                title: const Text(
                  'PROFILE',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, ProfileScreen.routeName);
                },
              ),
          
              // Status / League
              ListTile(
                leading: const Icon(Icons.bar_chart, size: 22, color: Colors.white),
                title: const Text(
                  'STATUS / LEAGUE',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Status screen
                },
              ),
          
              // Leaderboard
              ListTile(
                leading: const Icon(Icons.leaderboard, size: 22, color: Colors.white),
                title: const Text(
                  'LEADERBOARD',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to Leaderboard screen
                },
              ),
          
              const Spacer(),
          
              // Logout at bottom
              ListTile(
                leading: const Icon(Icons.logout, size: 22, color: Colors.redAccent),
                title: const Text(
                  'LOGOUT',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle logout logic
                },
              ),
          
              const SizedBox(height: 12),
            ],
          );
        }
      ),
    );
  }
}
