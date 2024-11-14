const express = require("express");
const mysql = require("mysql2");
const port = 3500;

const app = express();
app.use(express.json());

// Konfigurasi database
const connection = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "serverlampu",
});

app.get("/daftarlampu", (req, res) => {
  const sql = "SELECT * FROM lamps";
  connection.query(sql, (err, result) => {
    if (err) {
      return res.status(500).json({ message: "Database sedang turu" });
    }

    return res.status(200).json(result);
  });
});

app.post("/tambahlampu", (req, res) => {
  const { id_product, location, installation_date, status } = req.body;

  const sql =
    "INSERT INTO lamps (id_product, location, installation_date, status) VALUES (?, ?, ?, ?)";
  connection.query(
    sql,
    [id_product, location, installation_date, status],
    (err, result) => {
      if (err) {
        return res.status(500).json({ message: "Database sedang turu" });
      }

      return res.status(200).json({ message: "Berhasil tersimpan" });
    }
  );
});

app.get("/carilampu", (req, res) => {
  const { id_product, location, installation_date, status } = req.query;
  let sql = "SELECT * FROM lamps WHERE 1=1";
  const params = [];

  if (id_product) {
    sql += " AND id_product = ?";
    params.push(id_product);
  }
  if (location) {
    sql += " AND location LIKE ?";
    params.push(`%${location}%`);
  }
  if (installation_date) {
    sql += " AND installation_date = ?";
    params.push(installation_date);
  }
  if (status) {
    sql += " AND status = ?";
    params.push(status);
  }

  connection.query(sql, params, (err, result) => {
    if (err) {
      return res.status(500).json({ message: "Database sedang turu" });
    }

    return res.status(200).json(result);
  });
});

app.listen(port, () => {
  console.log(`Backend Berjalan di http://db:${port}`);
});
