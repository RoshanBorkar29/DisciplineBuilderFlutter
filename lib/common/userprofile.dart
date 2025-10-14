import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final int rank;
  final String userName;
  final int points;
  final String league;

  const UserTile({
    super.key,
    required this.rank,
    required this.userName,
    required this.points,
    required this.league,
  });

  // Function to get background color based on rank
  Color _getBackgroundColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber.shade400.withOpacity(0.9); // Gold for 1st
      case 2:
        return Colors.grey.shade400.withOpacity(0.9); // Silver for 2nd
      case 3:
        return Colors.brown.shade400.withOpacity(0.9); // Bronze for 3rd
      default:
        return Colors.deepPurple.shade400.withOpacity(0.8); // Default purple
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      color: _getBackgroundColor(rank), // ✅ dynamic background
      child: ListTile(
        leading: _buildRankIcon(),
        title: Text(
          "#$rank  $userName",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Text(
          "$points pts",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Function for rank icons
  Widget _buildRankIcon() {
    switch (rank) {
      case 1:
        return const Icon(Icons.emoji_events, color: Colors.yellow, size: 28);
      case 2:
        return const Icon(Icons.emoji_events, color: Colors.grey, size: 28);
      case 3:
        return const Icon(Icons.emoji_events, color: Colors.brown, size: 28);
      default:
        return const Icon(Icons.emoji_events, color: Colors.white, size: 28);
    }
  }
}
