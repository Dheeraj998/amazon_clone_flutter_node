//IMPORT FROM PACKAGES
const express = require("express");
const mongoose = require("mongoose");
const adminRoute = require("./routes/admin");

//IMPORT FROM OTHER FILES
const authRouter = require("./routes/auth");
const productRouter = require("./routes/product");
const userRouter = require("./routes/user");
//INIT
const app = express();
const PORT = 3003;
const DB =
  "mongodb+srv://admin:admin@cluster0.up9kl6z.mongodb.net/?retryWrites=true&w=majority";

//MIDDLEWARE
app.use(express.json()); //used when  Cannot destructure property 'name' of 'req.body' as it is undefined.
app.use(authRouter);
app.use(adminRoute);
app.use(productRouter);
app.use(userRouter);
//Connections
mongoose
  .connect(DB)
  .then(() => {
    console.log("connected successflully");
  })
  .catch((e) => {
    console.log(e);
  });
app.listen(PORT, "0.0.0.0", () => {
  console.log(`connected at port ${PORT}`);
});
