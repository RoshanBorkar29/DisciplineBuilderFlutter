const express = require('express');
const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  },

  email: {
    type: String,
    required: true,
    trim: true,
    validate: {
      validator: (value) => {
        const re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return value.match(re);
      },
      message: "Please enter a valid email address",
    },
  },

  password: {
    type: String,
    required: true,
  },

  // Tracking daily activity with tasks
dailySummary: [
  {
    date: Date,
    tasks: [
      {
        title: String,
        isCompleted: Boolean,
        createdAt: Date
      }
    ],
    totalTasks: Number,
    tasksCompleted: Number,
    points: Number,
  }
],


  // ✅ For ranking / leaderboard
  streak: {
    type: Number,
    default: 0, // consecutive days
  },

  points: {
    type: Number,
    default: 0, // total XP-like points
  },

  league: {
    type: String,
    enum: ["Bronze", "Silver", "Gold", "Platinum"],
    default: "Bronze",
  },
});

const User = mongoose.model("User", userSchema);
module.exports = User;
