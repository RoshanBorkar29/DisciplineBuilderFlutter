import 'package:flutter/material.dart';
import 'package:flutter_discplinebuilder/common/userprofile.dart';
import 'package:flutter_discplinebuilder/services/leaderboardservice.dart';

class Leaderboard extends StatefulWidget {
  static const String routeName = '/leaderboard';
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  final LeaderboardService _lbService = LeaderboardService();
  List<Map<String, dynamic>> leaders = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
  }

  Future<void> _fetchLeaderboard() async {
    if (!mounted) return;
    setState(() {
      leaders = [];
      isLoading = true;
    });

    final fetchLeaders = await _lbService.fetchGlobalLeaderboard(context);

    if (mounted) {
      setState(() {
        leaders = fetchLeaders;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LEAGUE',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : leaders.isEmpty
                ? const Center(
                    child: Text(
                      'No leaderboard data available.',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: leaders.length,
                    itemBuilder: (context, index) {
                      final leader = leaders[index];
                      return UserTile(
                        rank: index + 1,
                        userName: leader['name'] ?? 'Unknown User',
                        points: leader['points'] ?? 0,
                        league: leader['league'] ?? 'N/A', // ✅ Added league
                      );
                    },
                  ),
      ),
    );
  }
}
