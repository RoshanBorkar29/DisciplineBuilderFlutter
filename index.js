const express = require("express");
const mongoose = require("mongoose");
const authRouter = require("./routes/auth");
const taskRouter = require("./routes/task");
const leaderRouter=require("./routes/leaderboard");
const app = express();

const DB = "mongodb+srv://roshanborkar511_db_user:frzEt58gTzYejYMO@cluster1.69janq4.mongodb.net/?retryWrites=true&w=majority&appName=Cluster1";

app.use(express.json());

// console.log("authRouter:", authRouter);
// console.log("taskRouter:", taskRouter);
app.use("/auth", authRouter);
app.use("/tasks", taskRouter);
app.use("/",leaderRouter);

mongoose
  .connect(DB)
  .then(() => console.log("✅ MongoDB Connected"))
  .catch((err) => console.error("❌ MongoDB Connection Error:", err));

const PORT = 3000;
app.listen(PORT, "0.0.0.0", () =>
  console.log("✅ Server connected at port " + PORT)
);