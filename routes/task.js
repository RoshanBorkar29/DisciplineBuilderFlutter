const express = require("express");
const User = require("../models/user");
const auth = require("../middlewares/auth");

const taskRouter = express.Router();

// Add a new task
taskRouter.post("/api/addTask", auth, async (req, res) => {
  try {
    const { title } = req.body;
    if (!title) {
      return res.status(400).json({ error: "Title is required" });
    }
    const user = await User.findById(req.userId);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const todayStr = new Date().toISOString().substring(0, 10);
    let day = user.dailySummary.find(
      (d) => d.date.toISOString().substring(0, 10) === todayStr
    );
    if (!day) {
      day = { date: new Date(), tasks: [], totalTasks: 0, tasksCompleted: 0, points: 0 };
      user.dailySummary.push(day);
    }

    const newTask = { title, isCompleted: false, createdAt: new Date() };
    day.tasks.push(newTask);
    day.totalTasks = day.tasks.length;

    await user.save();
    console.log(`Task added for user ${req.userId}: ${title}`);
    res.status(201).json({ message: "Task added successfully", task: newTask });
  } catch (e) {
    console.error("Error adding task:", e);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Get all tasks for the current day
taskRouter.get("/api/tasks", auth, async (req, res) => {
  try {
    const user = await User.findById(req.userId);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const todayStr = new Date().toISOString().substring(0, 10);
    const day = user.dailySummary.find(
      (d) => d.date.toISOString().substring(0, 10) === todayStr
    );
    const tasks = day ? day.tasks : [];

    console.log(`Fetched ${tasks.length} tasks for user ${req.userId}`);
    res.status(200).json(tasks);
  } catch (e) {
    console.error("Error fetching tasks:", e);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Toggle task completion
// Toggle task completion
// Toggle task completion
taskRouter.put("/api/tasks/toggle/:taskIndex", auth, async (req, res) => {
  try {
    const { taskIndex } = req.params;
    const user = await User.findById(req.userId);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const todayStr = new Date().toISOString().substring(0, 10);
    const day = user.dailySummary.find(
      (d) => d.date.toISOString().substring(0, 10) === todayStr
    );

    if (!day || !day.tasks[taskIndex]) {
      return res.status(400).json({ error: "Task not found" });
    }

    // Toggle task
    const task = day.tasks[taskIndex];
    task.isCompleted = !task.isCompleted;

    // Update day stats
    day.tasksCompleted = day.tasks.filter((t) => t.isCompleted).length;
    day.points = day.tasksCompleted * 5;

    // Update user total points (only ±5 for the toggled task)
    if (task.isCompleted) {
      user.points = (user.points || 0) + 5;
    } else {
      user.points = Math.max(0, (user.points || 0) - 5);
    }

    // ✅ Streak: increment only ONCE per day
    if (day.tasksCompleted === day.totalTasks && day.totalTasks > 0) {
      if (!day.streakCounted) {              // <-- check if streak already counted today
        user.streak = (user.streak || 0) + 1;
        day.streakCounted = true;            // mark streak awarded for this day
      }
    }

    await user.save();

    console.log(`Toggled task ${taskIndex} for user ${req.userId}`);
    res.status(200).json({
      message: "Task toggled successfully",
      task,
      user: { points: user.points, streak: user.streak }
    });
  } catch (e) {
    console.error("Error toggling task:", e);
    res.status(500).json({ error: "Internal server error" });
  }
});


// Delete a task
taskRouter.delete("/api/tasks/:taskIndex", auth, async (req, res) => {
  try {
    const { taskIndex } = req.params;
    const user = await User.findById(req.userId);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const todayStr = new Date().toISOString().substring(0, 10);
    const day = user.dailySummary.find(
      (d) => d.date.toISOString().substring(0, 10) === todayStr
    );
    if (!day || !day.tasks[taskIndex]) {
      return res.status(400).json({ error: "Task not found" });
    }

    day.tasks.splice(taskIndex, 1);
    day.totalTasks = day.tasks.length;
    day.tasksCompleted = day.tasks.filter((t) => t.isCompleted).length;
    day.points = day.tasksCompleted * 5;

    await user.save();
    console.log(`Deleted task ${taskIndex} for user ${req.userId}`);
    res.status(200).json({ message: "Task deleted successfully" });
  } catch (e) {
    console.error("Error deleting task:", e);
    res.status(500).json({ error: "Internal server error" });
  }
});

module.exports = taskRouter;