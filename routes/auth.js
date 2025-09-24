const express = require("express");
const User = require("../models/user");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const auth = require("../middlewares/auth"); // auth middleware

const authRouter = express.Router();

// ==================== SIGNUP ====================
authRouter.post("/api/signup", async (req, res) => {
  try {
    const { name, email, password } = req.body;

    // Check if user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) 
      return res.status(400).json({ msg: "User with same email already exists" });

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 8);

    // Create user
    const user = new User({ name, email, password: hashedPassword });
    await user.save();

    // Return clean response
    res.json({ 
      msg: "Account created successfully",
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        streak: user.streak || 0,
        points: user.points || 0,
        league: user.league || "Bronze",
      }
    });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: "Internal server error" });
  }
});

// ==================== SIGNIN ====================
authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    // Check if user exists
    const user = await User.findOne({ email });
    if (!user) 
      return res.status(400).json({ msg: "User with this email does not exist!" });

    // Compare password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) 
      return res.status(400).json({ msg: "Incorrect password." });

    // Generate JWT token
    const token = jwt.sign({ id: user._id }, "passwordKey", { expiresIn: "7d" });

    // Send token + clean user data
    res.json({
      token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        streak: user.streak || 0,
        points: user.points || 0,
        league: user.league || "Bronze",
      }
    });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: "Internal server error" });
  }
});

// ==================== GET CURRENT USER ====================
// Protected route example
authRouter.get("/api/current", auth, async (req, res) => {
  try {
    const user = await User.findById(req.userId);
    if (!user) return res.status(404).json({ msg: "User not found" });

    res.json({
      id: user._id,
      name: user.name,
      email: user.email,
      streak: user.streak || 0,
      points: user.points || 0,
      league: user.league || "Bronze",
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
  }
});

module.exports = authRouter;
