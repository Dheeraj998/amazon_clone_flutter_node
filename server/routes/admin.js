const express = require("express");
const admin = require("../middlewares/admin");
const Product = require("../models/product");

const adminRoute = express.Router();

//Add product
adminRoute.post("/admin/add-product", admin, async (req, res) => {
  try {
    const { name, description, images, quantity, price, category } = req.body;
    let product = new Product({
      name,
      description,
      images,
      quantity,
      price,
      category,
    });
    product = await product.save();
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//get all product
adminRoute.get("/admin/get-products", admin, async (req, res) => {
  try {
    const products = await Product.find({});
    res.status(200).json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
//delete the product
adminRoute.post("/admin/delete-product", admin, async (req, res) => {
  try {
    const { id } = req.body;
    const product = await Product.findByIdAndDelete(id);
    // product = await product.save();
    res.json(product);
  } catch (e) {}
});
module.exports = adminRoute;
