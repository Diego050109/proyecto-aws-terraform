const express = require("express");
const { Pool } = require("pg");
const os = require("os");

const app = express();

const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

app.get("/", async (req, res) => {
  try {
    // Query REAL a Postgres
    const result = await pool.query("SELECT 1");

    res.json({
      message: "Backend funcionando con Postgres 🚀",
      db_status: "connected",
      db_response: result.rows[0]["?column?"] || 1,
      host: os.hostname()
    });
  } catch (error) {
    res.status(500).json({
      message: "Error conectando a la base de datos ❌",
      error: error.message
    });
  }
});

app.listen(80, () => {
  console.log("Backend escuchando en puerto 80");
});
