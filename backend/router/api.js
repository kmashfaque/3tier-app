const express = require("express");
const router = express.Router();

// Health check (for frontend + CI/CD testing)
router.get("/health", (req, res) => {
    res.json({
        status: "OK",
        message: "Backend is running",
        timestamp: new Date()
    });
});

// Example API
router.get("/data", (req, res) => {
    res.json({
        app: "3-tier backend",
        version: "1.0.0"
    });
});

module.exports = router;