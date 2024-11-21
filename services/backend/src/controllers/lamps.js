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

// Get a single lamp by ID
router.get("/:id", async (req, res) => {
  const { id } = req.params;
  try {
    const [lamp] = await db.query("SELECT * FROM lamps WHERE id = ?", [id]);
    if (lamp.length === 0) {
      return res.status(404).json({ error: "Lamp not found" });
    }
    res.json(lamp[0]);
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

// Update a lamp by ID
router.put("/:id", async (req, res) => {
  const { id } = req.params;
  const { id_product, location, installation_date, status, owner_id } =
    req.body;
  try {
    const [result] = await db.query(
      "UPDATE lamps SET id_product = ?, location = ?, installation_date = ?, status = ?, owner_id = ? WHERE id = ?",
      [id_product, location, installation_date, status, owner_id, id]
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: "Lamp not found" });
    }
    res.json({
      id,
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

// Delete a lamp by ID
router.delete("/:id", async (req, res) => {
  const { id } = req.params;
  try {
    const [result] = await db.query("DELETE FROM lamps WHERE id = ?", [id]);
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: "Lamp not found" });
    }
    res.status(204).send(); // No content
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
