const express = require("express");
const productRouter = express.Router();
const auth = require("../middlewares/auth");
const { Product } = require("../models/product");
// /api/products?category=Essentials req.query.category
// /api/products:category=Essentials req.query.category

productRouter.get("/api/products", auth, async (req, res) => {
  try {
    // console.log(req.query.category);
    const products = await Product.find({ category: req.query.category });
    res.json(products);
  } catch (error) {
    res.status(500).json({ error: error.message });
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
productRouter.post("/api/products/rate-product", auth, async (req, res) => {
  try {
    const { id, rating } = req.body;

    let product = await Product.findById(id);

    for (let i = 0; i < product.ratings.length; i++) {
      if (product.ratings[i].userId === req.user) {
        product.ratings.splice(i, 1);
        break;
      }
    }
    const ratingSchema = {
      userId: req.user,
      rating,
    };

    product.ratings.push(ratingSchema);
    product = await product.save();
    res.status(200).json(product);
  } catch (error) {
    res.statusCode(500).json({ error: error.message });
  }
});

productRouter.get("/api/deal-of-day", auth, async (req, res) => {
  try {
    let products = await Product.find({});

    products = products.sort((a, b) => {
      let aSum = 0;
      let bSum = 0;

      for (let i = 0; i < a.ratings.length; i++) {
        aSum += a.ratings[i].rating;
      }
      for (let i = 0; i < b.ratings.length; i++) {
        bSum += b.ratings[i].rating;
      }
      return aSum < bSum ? 1 : -1;
    });

    res.status(200).json(products[0]);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: error.message });
  }
});

module.exports = productRouter;
