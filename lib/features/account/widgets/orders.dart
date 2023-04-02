import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/account/services/account_services.dart';
import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:amazon_clone/features/order%20details/screens/order_detail_screen.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List list = [
    'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bGFwdG9wfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60',
    'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bGFwdG9wfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60',
    'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bGFwdG9wfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60'
  ];
  List<Order>? myOrders;

  @override
  void initState() {
    super.initState();
    getMyProducts();
  }

  getMyProducts() async {
    AccountServices accountServices = AccountServices();
    myOrders = await accountServices.getAllOrders(context: context);
    // print(myOrders![0].products?[0].product?.category);
    print(myOrders?.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 15),
              child: const Text(
                'Your Orders',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 15),
              child: Text(
                'See all',
                style: TextStyle(color: GlobalVariables.selectedNavBarColor),
              ),
            )
          ],
        ),
        //display orders
        Container(
            height: 170,
            padding: const EdgeInsets.only(left: 10, top: 20, right: 0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: myOrders?.length,
              itemBuilder: (context, index) {
                // print(myOrders?[index].products?[0].product?.images?[0] ?? "");
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(OrderDetailScreen.routeName,
                        arguments: myOrders?[index]);
                  },
                  child: SingleProduct(
                    img:
                        myOrders?[index].products?[0].product?.images?[0] ?? "",
                  ),
                );
              },
            )
            //mapping each product
            // ListView(
            //   scrollDirection: Axis.horizontal,
            //   shrinkWrap: true,
            //   physics: const ClampingScrollPhysics(),
            //   children: [
            //     for (int i = 0; i < (myOrders?.length ?? 0); i++) ...[
            //       ListView.builder(
            //         scrollDirection: Axis.horizontal,
            //         itemCount: myOrders?[i].products?.length,
            //         shrinkWrap: true,
            //         physics: const NeverScrollableScrollPhysics(),
            //         itemBuilder: (context, index) {
            //           print(
            //               " $i $index Data :: ${myOrders?[i].products?[0].product?.images?[0]}");
            //           return InkWell(
            //             onTap: () {
            //               Navigator.of(context).pushNamed(
            //                   OrderDetailScreen.routeName,
            //                   arguments: myOrders?[i]);
            //             },
            //             child: SingleProduct(
            //               img:
            //                   myOrders?[i].products?[0].product?.images?[0] ?? "",
            //             ),
            //           );
            //         },
            //       ),
            //     ]
            //   ],
            // ),
            )
      ],
    );
  }
}
