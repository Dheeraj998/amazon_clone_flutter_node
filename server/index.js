//IMPORT FROM PACKAGES
const express = require("express");
const mongoose = require("mongoose");

//IMPORT FROM OTHER FILES
const authRouter = require("./routes/auth");
//INIT
const app = express();
const PORT = 3000;
const DB =
  "mongodb+srv://admin:admin@cluster0.up9kl6z.mongodb.net/?retryWrites=true&w=majority";

//MIDDLEWARE
app.use(express.json()); //used when  Cannot destructure property 'name' of 'req.body' as it is undefined.
app.use(authRouter);

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
