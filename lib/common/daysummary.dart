class DaySummary {
  final String date; // e.g. "2025-09-15"
  int completedTasks;
  int totalTasks;
  int points;

  DaySummary({
    required this.date,
    required this.completedTasks,
    required this.totalTasks,
    required this.points,
  });
}
