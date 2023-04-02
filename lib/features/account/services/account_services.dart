import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AccountServices {
  Future<List<Order>> getAllOrders({required BuildContext context}) async {
    List<Order> orderList = [];
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final http.Response response = await http.get(
        Uri.parse('$uri/api/get-orders'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
          'x-auth-token': userProvider.user.token
        },
      );
      print(response.body);

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            orderList = orderFromJson(response.body);
            print(orderList);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
      print(" erroorrrrrrrr ###### ${e.toString()}");
    }
    return orderList;
  }
}
