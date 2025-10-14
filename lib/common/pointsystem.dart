import 'package:flutter/material.dart';

class PointSystemCard extends StatelessWidget {
  const PointSystemCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white12, // Dark background card color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const Text(
              'Dynamic Point System',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),

            // --- Point Gains (Rewards) Section ---
            const Text(
              '🚀 Rewards (Gains)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.greenAccent,
              ),
            ),
            const SizedBox(height: 10),
            _buildPointDetailRow(
              icon: Icons.add_circle,
              title: 'Task Completion',
              description: '+5 points for every completed task.',
              color: Colors.green.shade400,
            ),
            _buildPointDetailRow(
              icon: Icons.local_fire_department,
              title: 'Streak Momentum Bonus',
              description: '+ (Current Streak x 5) extra points when all daily tasks are complete.',
              color: Colors.orange.shade400,
            ),

            const Divider(color: Colors.white38, height: 30),

            // --- Streak Maintenance (Decay) Section ---
            const Text(
              '⚠️ Maintenance (Decay)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 10),
            _buildPointDetailRow(
              icon: Icons.remove_circle,
              title: 'Streak Break Penalty',
              description: '-20 points will be deducted from your total points if your streak is broken.',
              color: Colors.red.shade400,
            ),
            _buildPointDetailRow(
              icon: Icons.restart_alt,
              title: 'Streak Reset',
              description: 'Current Streak resets to 0 when daily task completion is missed.',
              color: Colors.blue.shade400,
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for consistent row display
  Widget _buildPointDetailRow({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
