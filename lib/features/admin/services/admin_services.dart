import 'dart:convert';
import 'dart:io';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/account/widgets/orders.dart';
import 'package:amazon_clone/features/admin/models/sales.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:amazon_clone/providers/admin_provider.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AdminServices {
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final cloudinary = CloudinaryPublic('du0boc2nl', 'hsugex3n');
      List<String> imageUrls = [];
      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imageUrls.add(res.secureUrl);
      }
      Product product = Product(
          name: name,
          description: description,
          quantity: quantity,
          images: imageUrls,
          category: category,
          price: price);

      http.Response res = await http.post(Uri.parse('$uri/admin/add-product'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          },
          body: product.toJson());
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Product Added SUccessFully');
            Navigator.pop(context);
            fetchAllProduct(context);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //get all product
  void fetchAllProduct(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    List<Product> productList = [];
    try {
      http.Response resp = await http.get(
        Uri.parse('$uri/admin/get-products'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token
        },
      );

      httpErrorHandle(
          response: resp,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(resp.body).length; i++) {
              productList.add(
                Product.fromJson(
                  jsonEncode(
                    jsonDecode(resp.body)[i],
                  ),
                ),
              );
            }
          });
      print(productList);
    } catch (e) {
      showSnackBar(context, e.toString());
      debugPrint(e.toString());
    }
    // return productList;
    adminProvider.getAllProducts(productList);
  }

  //delete product
  void deleteProduct(
      {required BuildContext context,
      required Product product,
      required VoidCallback onSuccess}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response response =
          await http.post(Uri.parse('$uri/admin/delete-product'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.user.token
              },
              body: jsonEncode({'id': product.id}));
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //get all orders
  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    List<Order> ordersList = [];
    try {
      http.Response resp = await http.get(
        Uri.parse('$uri/admin/get-orders'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token
        },
      );

      print(resp.body);
      httpErrorHandle(
          response: resp,
          context: context,
          onSuccess: () {
            ordersList = orderFromJson(resp.body);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
      debugPrint(e.toString());
    }
    return ordersList;
  }

  //change status
  void changeStatus(
      {required BuildContext context,
      required int status,
      required Order order,
      required VoidCallback onSuccess}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response response =
          await http.post(Uri.parse('$uri/admin/change-order-status'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.user.token
              },
              body: jsonEncode({'id': order.id, "status": status}));
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<Map<String, dynamic>> getAnalytics(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    List<Sales> sales = [];
    int totalEarning = 0;
    try {
      http.Response resp = await http.get(
        Uri.parse('$uri/admin/analytics'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token
        },
      );

      print(resp.body);
      httpErrorHandle(
          response: resp,
          context: context,
          onSuccess: () {
            var response = jsonDecode(resp.body);
            totalEarning = response['totalEarnings'];
            sales = [
              Sales(label: "Mobiles", earning: response['mobileEarnings']),
              Sales(
                  label: "Essentials", earning: response['essentialEarnings']),
              Sales(
                  label: "Appliances", earning: response['applianceEarnings']),
              Sales(label: "Books", earning: response['booksEarnings']),
              Sales(label: "Fashion", earning: response['fashionEarnings']),
            ];
          });
    } catch (e) {
      showSnackBar(context, e.toString());
      debugPrint(e.toString());
    }
    return {'sales': sales, 'totalEarnings': totalEarning};
  }
}
