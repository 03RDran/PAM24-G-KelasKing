const jwt = require("jsonwebtoken");
const config = require("../config");

module.exports.authz = (obj, act) => {
  return async (req, res, next) => {
    if (
      !req.headers.authorization ||
      !req.headers.authorization.startsWith("Bearer ")
    ) {
      res.status(401).send("Unauthorized");
      return;
    }

    const token = req.headers.authorization.split(" ")[1];

    try {
      let payload = jwt.verify(token, config.SECRET_KEY);

      if (typeof payload === "string") throw new Error();
      res.locals.email = payload.email;
      res.locals.name = payload.name;
      res.locals.role = payload.role;
    } catch {
      res.status(401).send("Unauthorized");
      return;
    }

    let allowed = false;

    if (typeof act === "string") {
      allowed = await checkPermission(res.locals.role, obj, act);
    } else {
      for (const x of act) {
        if (await checkPermission(res.locals.role, obj, x)) {
          allowed = true;
          break;
        }
      }
    }

    if (!allowed) {
      res.status(401).send("Unauthorized");
      return;
    }

    next();
  };
};
