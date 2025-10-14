const express=require("express");

const User=require("../models/user");
const auth = require("../middlewares/auth"); 

const leaderRouter=express.Router();

// 💡 FIX: Added the necessary leading slash (/) to the route path 
// and ensured consistent lowercase naming.
leaderRouter.get("/api/leaderboard/global", auth, async (req, res) => {
    try {
        // Fetch all users, sorted primarily by points, then by streak (tie-breaker)
        const leaderboard = await User.find({})
            .sort({ points: -1, streak: -1 })
            .select('name points streak league -_id')
            .limit(50); // Limit to top 50 users

        console.log(`Fetched leaderboard with ${leaderboard.length} users.`);
        res.status(200).json(leaderboard);
    }
    catch (e) {
        console.error("Error fetching leaderboard:", e); // Log the detailed error
        res.status(500).json({ error: "Internal server error while fetching leaderboard" });
    }
});

module.exports = leaderRouter;
