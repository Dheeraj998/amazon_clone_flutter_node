import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../constants/global_variables.dart';

class AddressServices {
  void saveUserAddress(BuildContext context, String addressTobeUsed) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final http.Response response =
          await http.post(Uri.parse('$uri/api/save-user-address'),
              headers: <String, String>{
                'Content-Type': 'application/json;charset=UTF-8',
                'x-auth-token': userProvider.user.token
              },
              body: jsonEncode({'address': addressTobeUsed}));

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            User user = userProvider.user
                .copyWith(address: jsonDecode(response.body)['address']);

            userProvider.setUserFromModel(user);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void orderFromCart(
      BuildContext context, String address, double totalSum) async {
    print("odrererere apii $address");
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final http.Response response = await http.post(
          Uri.parse('$uri/api/order'),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8',
            'x-auth-token': userProvider.user.token
          },
          body: jsonEncode({
            'cart': userProvider.user.cart,
            'address': address,
            'totalPrice': totalSum
          }));

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Your order has been placed");
            User user = userProvider.user.copyWith(cart: []);

            userProvider.setUserFromModel(user);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
