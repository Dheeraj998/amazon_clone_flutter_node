import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;
  static const routeName = '/order-detail';
  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int currentStep = 0;
  final AdminServices adminServices = AdminServices();
  @override
  void initState() {
    // TODO: implement initStatcue
    currentStep = widget.order.status ?? 0;
  }

  void changeOrderStatus(int status) {
    adminServices.changeStatus(
        context: context,
        status: status + 1,
        order: widget.order,
        onSuccess: () {
          setState(() {
            currentStep += 1;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: GlobalVariables.appBarGradient)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: (e) {},
                      decoration: InputDecoration(
                          prefixIcon: InkWell(
                              onTap: () {},
                              child: const Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                  size: 23,
                                ),
                              )),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(top: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: const BorderSide(
                                color: Colors.black38, width: 1),
                          ),
                          hintText: 'Search Amazon.in',
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17)),
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                color: Colors.transparent,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(
                  Icons.mic,
                  color: Colors.black,
                  size: 25,
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              'View Order Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black12)),
              child: Column(
                children: [
                  Text(
                      "Order Date: ${DateFormat().format(DateTime.fromMicrosecondsSinceEpoch(widget.order.orderedAt!))}"),
                  SizedBox(height: 10),
                  Text("Order ID: ${widget.order.id}"),
                  SizedBox(height: 10),
                  Text("Order Total: ${widget.order.totalPrice}"),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text('Purchase Details'),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: widget.order.products?.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Image.network(
                      widget.order.products![index].product!.images![0],
                      height: 150,
                      width: 110,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.order.products?[index].product?.name ??
                              ""),
                          SizedBox(
                            height: 10,
                          ),
                          Text(widget.order.products?[index].quantity
                                  .toString() ??
                              ""),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
            SizedBox(height: 10),
            Text('Tracking'),
            SizedBox(height: 10),
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black12)),
              child: Stepper(
                  currentStep: currentStep,
                  controlsBuilder: (context, details) {
                    if (user.type == 'admin') {
                      return CustomButton(
                          text: "Done",
                          onTap: () => changeOrderStatus(details.currentStep));
                    }
                    return SizedBox();
                  },
                  physics: ClampingScrollPhysics(),
                  steps: [
                    Step(
                        isActive: currentStep >= 0,
                        state: currentStep > 0
                            ? StepState.complete
                            : StepState.indexed,
                        title: Text("Pending"),
                        content: Text("your order is yet to bet delivered")),
                    Step(
                        isActive: currentStep > 1,
                        state: currentStep > 1
                            ? StepState.complete
                            : StepState.indexed,
                        title: Text("Completed"),
                        content: Text("your order is completed")),
                    Step(
                        isActive: currentStep > 2,
                        state: currentStep > 2
                            ? StepState.complete
                            : StepState.indexed,
                        title: Text("Recieved"),
                        content: Text("your order is recieved")),
                    Step(
                        isActive: currentStep >= 3,
                        state: currentStep >= 3
                            ? StepState.complete
                            : StepState.indexed,
                        title: Text("Delivered"),
                        content: Text("your order is delivered")),
                  ]),
            )
          ],
        ),
      )),
    );
  }
}
