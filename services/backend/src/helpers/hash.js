const bcrypt = require("bcrypt");

const saltRounds = 10;

const hashPassword = async (password) => {
  const passwordHash = await bcrypt.hash(password, saltRounds);
  return passwordHash;
};

const verifyPassword = async (password, passwordHash) => {
  try {
    await bcrypt.compare(password, passwordHash);
    return true;
  } catch {
    return false;
  }
};

module.exports = {
  hashPassword,
  verifyPassword,
};
