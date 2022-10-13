import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BelowAppBar extends StatelessWidget {
  const BelowAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    print(user.name);
    return Container(
      decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
                text: 'Hello, ',
                style: TextStyle(color: Colors.black, fontSize: 22),
                children: [
                  TextSpan(
                      text: user.name,
                      style: TextStyle(color: Colors.black, fontSize: 22))
                ]),
          ),
        ],
      ),
    );
  }
}
