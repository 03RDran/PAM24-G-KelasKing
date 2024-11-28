const { celebrate, Joi, Segments } = require("celebrate");
const asyncHandler = require("express-async-handler");
const { Router } = require("express");
const jwt = require("jsonwebtoken");

const { verifyPassword, hashPassword } = require("../helpers/hash");
const config = require("../config");
const db = require("../db");

const router = Router();

// Request JWT
router.post(
  "/login",
  celebrate({
    [Segments.BODY]: Joi.object().keys({
      email: Joi.string().email().required(),
      password: Joi.string().required(),
    }),
  }),
  asyncHandler(async (req, res) => {
    const { email, password } = req.body;

    try {
      // Fetch user details from the database
      const [rows] = await db.query(
        "SELECT id, name, email, password FROM users WHERE email = ?",
        [email]
      );

      if (rows.length === 0) {
        return res.status(401).json({ error: "Wrong username or password" });
      }

      const user = rows[0];

      // Verify the password
      const isPasswordValid = await verifyPassword(password, user.password);
      if (!isPasswordValid) {
        return res.status(401).json({ error: "Wrong username or password" });
      }

      // Generate JWT token
      const token = jwt.sign(
        {
          id: user.id,
          name: user.name,
          email: user.email,
        },
        config.SECRET_KEY,
        { expiresIn: "7d" }
      );

      res.status(200).json({ token });
    } catch (error) {
      console.error("Database error:", error);
      res.status(500).json({ error: "Internal Server Error" });
    }
  })
);

// Signup Route
router.post(
  "/signup",
  celebrate({
    [Segments.BODY]: Joi.object().keys({
      name: Joi.string().min(1).required(),
      email: Joi.string().email().required(),
      password: Joi.string().min(6).required(),
    }),
  }),
  asyncHandler(async (req, res) => {
    const { name, email, password } = req.body;

    try {
      // Check if the user already exists
      const [existingUser] = await db.query(
        "SELECT id FROM users WHERE email = ?",
        [email]
      );
      if (existingUser.length > 0) {
        return res
          .status(400)
          .json({ error: "User already exists with this email" });
      }

      // Hash the password
      const hashedPassword = await hashPassword(password);

      // Insert the new user into the database
      const [result] = await db.query(
        "INSERT INTO users (name, email, password) VALUES (?, ?, ?)",
        [name, email, hashedPassword]
      );

      // Generate a JWT token for the new user
      const token = jwt.sign(
        {
          id: result.insertId,
          name,
          email,
        },
        config.SECRET_KEY,
        { expiresIn: "7d" }
      );

      res.status(201).json({ token, message: "User registered successfully!" });
    } catch (error) {
      console.error("Database error:", error);
      res.status(500).json({ error: "Internal Server Error" });
    }
  })
);

module.exports = router;
