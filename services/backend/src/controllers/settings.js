const express = require("express");
const router = express.Router();
const db = require("../db");

// Get all settings
router.get("/", async (req, res) => {
  try {
    const [settings] = await db.query("SELECT * FROM settings");
    res.json(settings);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Create a new setting
router.post("/", async (req, res) => {
  const { user_id, setting_key, setting_value } = req.body;
  try {
    const [result] = await db.query(
      "INSERT INTO settings (user_id, setting_key, setting_value) VALUES (?, ?, ?)",
      [user_id, setting_key, setting_value]
    );
    res
      .status(201)
      .json({ id: result.insertId, user_id, setting_key, setting_value });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get settings by user ID
router.get("/user/:user_id", async (req, res) => {
  try {
    const [settings] = await db.query(
      "SELECT * FROM settings WHERE user_id = ?",
      [req.params.user_id]
    );
    res.json(settings);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Update a setting
router.put("/:id", async (req, res) => {
  const { setting_key, setting_value } = req.body;
  try {
    await db.query(
      "UPDATE settings SET setting_key = ?, setting_value = ? WHERE id = ?",
      [setting_key, setting_value, req.params.id]
    );
    res.json({ message: "Setting updated successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Delete a setting
router.delete("/:id", async (req, res) => {
  try {
    await db.query("DELETE FROM settings WHERE id = ?", [req.params.id]);
    res.json({ message: "Setting deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
