import 'package:amazon_clone/features/account/widgets/account_button.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:flutter/material.dart';

class TopButton extends StatefulWidget {
  const TopButton({Key? key}) : super(key: key);

  @override
  State<TopButton> createState() => _TopButtonState();
}

class _TopButtonState extends State<TopButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(text: "Your Orders", onPress: () {}),
            AccountButton(text: "Turn Seller", onPress: () {})
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            AccountButton(
                text: "Log Out",
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AuthScreen(),
                  ));
                }),
            AccountButton(text: "Your Wish List", onPress: () {})
          ],
        ),
      ],
    );
  }
}
