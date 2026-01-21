const express = require("express");
const { Pool } = require("pg");

const app = express();
const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: 5432,
});

app.get("/", async (req, res) => {
  const result = await pool.query("SELECT * FROM users;");
  res.json(result.rows);
});

app.listen(3000, () => console.log("Backend running on port 3000"));
