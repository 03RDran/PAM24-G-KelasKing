const express = require("express");
const db = require("../db");

const router = express.Router();

// Get all lamps
router.get("/", async (req, res) => {
  try {
    const [lamps] = await db.query("SELECT * FROM lamps");
    res.json(lamps);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Create a new lamp
router.post("/", async (req, res) => {
  const { id_product, location, installation_date, status, owner_id } =
    req.body;
  try {
    const [result] = await db.query(
      "INSERT INTO lamps (id_product, location, installation_date, status, owner_id) VALUES (?, ?, ?, ?, ?)",
      [id_product, location, installation_date, status, owner_id]
    );
    res.status(201).json({
      id: result.insertId,
      id_product,
      location,
      installation_date,
      status,
      owner_id,
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Additional routes for lamps...
module.exports = router;
