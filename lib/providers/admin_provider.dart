import 'dart:io';

import 'package:amazon_clone/models/product.dart';
import 'package:flutter/cupertino.dart';

class AdminProvider extends ChangeNotifier {
  List<File> _images = [];
  String _category = 'Mobiles';
  List<Product>? _productList;

  final List<String> _productCategoies = [
    'Mobiles',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion',
  ];
  List<File> get images => _images;
  List<String> get productCategories => _productCategoies;
  String get category => _category;
  List<Product>? get productList => _productList;
  void getImages(List<File> images) {
    _images = images;
    notifyListeners();
  }

  void updateCategory(String category) {
    _category = category;
    notifyListeners();
  }

  void getAllProducts(List<Product> productList) {
    _productList = productList;
    notifyListeners();
  }

  void deleteProduct(int id) {
    _productList?.removeAt(id);
    notifyListeners();
  }
}
