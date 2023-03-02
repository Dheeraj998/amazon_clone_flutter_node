const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/user");
const auth = require("../middlewares/auth");

const authRouter = express.Router();

//signup
authRouter.post("/api/signup", async (req, res) => {
  try {
    const { name, email, password } = req.body;
    console.log("hello");

    const existngUser = await User.findOne({ email });

    if (existngUser) {
      return res
        .status(400)
        .json({ msg: "User with same email already exists" });
    }
    // var salt = bcrypt.genSaltSync(10);
    // var hashedPassword = bcrypt.hashSync(password, salt);
    const hashedPassword = await bcrypt.hash(password, 8);
    let user = new User({
      name,
      email,
      password: hashedPassword,
    });
    user = await user.save();

    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//signin
authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;
    console.log(req.body);
    const user = await User.findOne({ email });
    console.log("#################", user);
    if (!user) {
      return res.status(400).json({ msg: "User with email doesnot exist!" });
    }
    const isMatch = bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.statusCode(400).json({ msg: "Incorrect Password !" });
    }

    const token = jwt.sign({ id: user._id }, "passwordKey");
    res.json({ token, ...user._doc });
  } catch (e) {
    res.statusCode(500).json({ error: e.message });
  }
});

//token isValid
authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);
    const user = User.findById(verified.id);
    if (!user) return res.json(false);
    res.json(true);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//get user data
authRouter.get("/", auth, async (req, res) => {
  const user = await User.findById(req.user);
  res.json({ ...user._doc, token: req.token });
});
module.exports = authRouter;
