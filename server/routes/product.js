const express = require("express");
const productRouter = express.Router();
const auth = require("../middlewares/auth");
const Product = require("../models/product");
// /api/products?category=Essentials req.query.category
// /api/products:category=Essentials req.query.category

productRouter.get("/api/products", auth, async (req, res) => {
  try {
    // console.log(req.query.category);
    const products = await Product.find({ category: req.query.category });
    res.json(products);
  } catch (error) {
    res.statusCode(500).json({ error: e.message });
  }
});
productRouter.get(
  "/api/products/search/:searchQuery",
  auth,
  async (req, res) => {
    try {
      console.log(req.params.searchQuery);
      const products = await Product.find({
        searchQuery: { $regex: req.params.searchQuery, $options: "i" },
      });
      console.log(products);
      res.json(products);
    } catch (error) {
      res.statusCode(500).json({ error: e.message });
    }
  }
);
productRouter.post('/api/products/rate-product',auth,(req,res)=>{
  // const {id,}
})

module.exports = productRouter;
