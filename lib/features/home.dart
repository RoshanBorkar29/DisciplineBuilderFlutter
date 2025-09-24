//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_discplinebuilder/common/daysummary.dart';
import 'package:flutter_discplinebuilder/common/drawer.dart';
import 'package:flutter_discplinebuilder/common/task.dart';
import 'package:flutter_discplinebuilder/common/time.dart';
import 'package:flutter_discplinebuilder/services/taskService.dart';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  static const String routeName = '/home';
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Task> tasks = [];
  final TextEditingController taskController = TextEditingController();
  Map<String, DaySummary> dailySummaries = {};
  String today = DateTime.now().toIso8601String().substring(0, 10);
  final TaskService _taskService = TaskService();

  final GlobalKey _streakKey = GlobalKey();
  int streakCount = 0;
  late ConfettiController _confettiController;
  bool _showStreakAnimation = false;
  String? lastStreakDate;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _loadTasks();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    taskController.dispose();
    super.dispose();
  }

  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> _loadTasks() async {
    try {
      final userId = await getUserId();
      if (userId == null) {
        print('No userId found');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to view tasks')),
        );
        return;
      }
      final fetchedTasks = await _taskService.getTasks(userId,context);
      setState(() {
        tasks.clear();
        tasks.addAll(fetchedTasks);
      });
    } catch (e) {
      print('Error loading tasks: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load tasks: $e')),
      );
    }
  }

  void showAddTask() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Add your task',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(
              hintText: 'Enter your Task',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (taskController.text.trim().isNotEmpty) {
                  try {
                    final userId = await getUserId();
                    print('User ID: $userId');
                    if (userId == null) {
                      print('No userId found');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please log in to add tasks')),
                      );
                      Navigator.pop(context);
                      return;
                    }
                    print('Adding task: ${taskController.text.trim()}');
                    await _taskService.addTask(userId, taskController.text.trim(), context);
                    print('Task added to backend');
                    taskController.clear();
                    Navigator.pop(context);
                    await _loadTasks(); // Refresh tasks from backend
                  } catch (e) {
                    print('Error adding task: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add task: $e')),
                    );
                  }
                } else {
                  print('Task title is empty');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task title cannot be empty')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void toggleTaskCompletion(int index) async {
    try {
      final userId = await getUserId();
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to toggle tasks')),
        );
        return;
      }
      await _taskService.toggleTask(userId, index, context);
      setState(() {
        tasks[index].isCompleted = !tasks[index].isCompleted;
        int completed = tasks.where((t) => t.isCompleted).length;
        int totalTasks = tasks.length;
        int points = completed * 5;
        dailySummaries[today] = DaySummary(
          date: today,
          completedTasks: completed,
          totalTasks: totalTasks,
          points: points,
        );
        if (completed == totalTasks && totalTasks > 0) {
          _askCompletionConfirmation();
        }
      });
    } catch (e) {
      print('Error toggling task: $e');
    }
  }

  void deleteTask(int index) async {
    try {
      final userId = await getUserId();
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to delete tasks')),
        );
        return;
      }
      await _taskService.deleteTask(userId, index, context);
      setState(() {
        tasks.removeAt(index);
        dailySummaries[today]?.points = 0;
      });
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  void _askCompletionConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Great Job!"),
          content: const Text("Did you complete all your today's tasks?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Not yet"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _triggerStreakCelebration();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void _triggerStreakCelebration() {
    setState(() {
      if (lastStreakDate == today) return;
      streakCount++;
      lastStreakDate = today;
      _showStreakAnimation = true;
    });
    _confettiController.play();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showStreakAnimation = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Tasks in UI: ${tasks.map((t) => t.title).toList()}');
    int todayPoints = dailySummaries[today]?.points ?? 0;
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text(
          'Add your task',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              key: _streakKey,
              children: [
                const Icon(Icons.local_fire_department, color: Colors.orangeAccent),
                const SizedBox(width: 5),
                Text(
                  'Streak: $streakCount',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          )
        ],
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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Column(
              children: [
                TimeScreen(points: todayPoints),
                const SizedBox(height: 10),
                Expanded(
                  child: tasks.isEmpty
                      ? const Center(
                          child: Text('No tasks yet. Add one!', style: TextStyle(color: Colors.white)))
                      : ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.deepPurple, Colors.purpleAccent],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                ),
                                child: ListTile(
                                  leading: Checkbox(
                                    value: task.isCompleted,
                                    onChanged: (_) => toggleTaskCompletion(index),
                                    checkColor: Colors.white,
                                    activeColor: Colors.green,
                                  ),
                                  title: Text(
                                    task.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.white),
                                    onPressed: () => deleteTask(index),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple],
            ),
          ),
          if (_showStreakAnimation)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "assets/animations/fire.json",
                    width: 150,
                    height: 150,
                    repeat: false,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Streak: $streakCount',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddTask,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}