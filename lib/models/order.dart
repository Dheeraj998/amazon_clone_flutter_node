// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

List<Order> orderFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
  Order({
    this.id,
    this.products,
    this.totalPrice,
    this.address,
    this.userId,
    this.orderedAt,
    this.status,
    this.v,
  });

  String? id;
  List<ProductElement>? products;
  int? totalPrice;
  String? address;
  String? userId;
  int? orderedAt;
  int? status;
  int? v;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["_id"],
        products: json["products"] == null
            ? []
            : List<ProductElement>.from(
                json["products"]!.map((x) => ProductElement.fromJson(x))),
        totalPrice: json["totalPrice"],
        address: json["address"],
        userId: json["userId"],
        orderedAt: json["orderedAt"],
        status: json["status"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
        "totalPrice": totalPrice,
        "address": address,
        "userId": userId,
        "orderedAt": orderedAt,
        "status": status,
        "__v": v,
      };
}

class ProductElement {
  ProductElement({
    this.product,
    this.quantity,
    this.id,
  });

  ProductProduct? product;
  int? quantity;
  String? id;

  factory ProductElement.fromJson(Map<String, dynamic> json) => ProductElement(
        product: json["product"] == null
            ? null
            : ProductProduct.fromJson(json["product"]),
        quantity: json["quantity"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "product": product?.toJson(),
        "quantity": quantity,
        "_id": id,
      };
}

class ProductProduct {
  ProductProduct({
    this.name,
    this.description,
    this.images,
    this.quantity,
    this.price,
    this.category,
    this.ratings,
    this.id,
    this.v,
  });

  String? name;
  String? description;
  List<String>? images;
  int? quantity;
  int? price;
  String? category;
  List<Rating>? ratings;
  String? id;
  int? v;

  factory ProductProduct.fromJson(Map<String, dynamic> json) => ProductProduct(
        name: json["name"],
        description: json["description"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        quantity: json["quantity"],
        price: json["price"],
        category: json["category"],
        ratings: json["ratings"] == null
            ? []
            : List<Rating>.from(
                json["ratings"]!.map((x) => Rating.fromJson(x))),
        id: json["_id"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "quantity": quantity,
        "price": price,
        "category": category,
        "ratings": ratings == null
            ? []
            : List<dynamic>.from(ratings!.map((x) => x.toJson())),
        "_id": id,
        "__v": v,
      };
}

class Rating {
  Rating({
    this.userId,
    this.rating,
    this.id,
  });

  String? userId;
  int? rating;
  String? id;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        userId: json["userId"],
        rating: json["rating"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "rating": rating,
        "_id": id,
      };
}
