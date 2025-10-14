import 'package:flutter/material.dart';

class Leaguehierarchy extends StatelessWidget {
  final String currentLeague; // ✅ received from Status.dart

  const Leaguehierarchy({super.key, required this.currentLeague});

  final List<Map<String, dynamic>> leagues = const [
    {'name': 'Bronze', 'points': 100, 'color1': 0xFFCD7F32, 'color2': 0xFFB87333},
    {'name': 'Silver', 'points': 300, 'color1': 0xFFC0C0C0, 'color2': 0xFFAFAFAF},
    {'name': 'Gold', 'points': 600, 'color1': 0xFFFFD700, 'color2': 0xFFDAA520},
    {'name': 'Platinum', 'points': 1000, 'color1': 0xFFE5E4E2, 'color2': 0xFFB3B3B3},
    {'name': 'Diamond', 'points': 1500, 'color1': 0xFF40E0D0, 'color2': 0xFF00CED1},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        children: leagues.map((league) {
          final bool isCurrent = league['name'] == currentLeague;
          return Column(
            children: [
              if (isCurrent)
                const Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    "YOU ARE HERE 👇",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              _leagueCard(
                league['name'],
                league['points'],
                league['color1'],
                league['color2'],
                isCurrent,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _leagueCard(String name, int points, int color1, int color2, bool isCurrent) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isCurrent
            ? const BorderSide(color: Colors.yellowAccent, width: 3)
            : BorderSide.none,
      ),
      elevation: isCurrent ? 10 : 5,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(color1), Color(color2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(Icons.shield, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              "$points pts",
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
