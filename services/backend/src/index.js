const bodyParser = require("body-parser");
const express = require("express");

const userRoutes = require("./controllers/users");
const lampRoutes = require("./controllers/lamps");
const settingRoutes = require("./controllers/settings");
const sensorDataRoutes = require("./controllers/sensorData");

const app = express();

app.use(bodyParser.json());

app.use("/users", userRoutes);
app.use("/lamps", lampRoutes);
app.use("/settings", settingRoutes);
app.use("/sensor-data", sensorDataRoutes);

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
