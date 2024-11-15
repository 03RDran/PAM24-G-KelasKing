const express = require("express");
const db = require("../db");

const router = express.Router();

// Get all sensor data
router.get("/", async (req, res) => {
  try {
    const [sensorData] = await db.query("SELECT * FROM sensor_data");
    res.json(sensorData);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Create new sensor data
router.post("/", async (req, res) => {
  const { lamp_id, sensor_key, sensor_value } = req.body;
  try {
    const [result] = await db.query(
      "INSERT INTO sensor_data (lamp_id, sensor_key, sensor_value) VALUES (?, ?, ?)",
      [lamp_id, sensor_key, sensor_value]
    );
    res
      .status(201)
      .json({ id: result.insertId, lamp_id, sensor_key, sensor_value });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get sensor data by lamp ID
router.get("/lamp/:lamp_id", async (req, res) => {
  try {
    const [sensorData] = await db.query(
      "SELECT * FROM sensor_data WHERE lamp_id = ?",
      [req.params.lamp_id]
    );
    res.json(sensorData);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Delete sensor data by ID
router.delete("/:id", async (req, res) => {
  try {
    await db.query("DELETE FROM sensor_data WHERE id = ?", [req.params.id]);
    res.json({ message: "Sensor data deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
