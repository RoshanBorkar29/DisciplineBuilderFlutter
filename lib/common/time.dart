import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeScreen extends StatelessWidget {
  final int points; // 👈 add this

  const TimeScreen({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                today,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 4),
              const Text(
                "Today's Progress",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),

          // Points
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 5),
              Text(
                "$points pts",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
