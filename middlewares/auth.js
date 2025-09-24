const jwt = require("jsonwebtoken");

function auth(req, res, next) {
  try {
    const authHeader = req.header("Authorization");
    const token = authHeader && authHeader.startsWith("Bearer ") ? authHeader.substring(7) : authHeader;
    if (!token) return res.status(401).json({ msg: "No auth token, access denied" });

    const verified = jwt.verify(token, "passwordKey"); // same secret as in signin
    if (!verified) return res.status(401).json({ msg: "Token verification failed" });

    req.userId = verified.id; // attach userId to request
    next(); // ✅ continue to the next handler
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

module.exports = auth;
