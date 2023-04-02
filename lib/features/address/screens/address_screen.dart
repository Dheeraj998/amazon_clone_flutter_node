import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/address/services/addresss_services.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
// import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AdddressScreen extends StatefulWidget {
  static const routeName = '/address-screen';
  final String totalSum;
  const AdddressScreen({Key? key, required this.totalSum}) : super(key: key);

  @override
  State<AdddressScreen> createState() => _AdddressScreenState();
}

class _AdddressScreenState extends State<AdddressScreen> {
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();
  // List<PaymentItem> paymentItems = [];
  String addressTobeUsed = '';
  AddressServices addressServices = AddressServices();
  @override
  void initState() {
    super.initState();
    // paymentItems.add(PaymentItem(
    //     amount: widget.totalSum,
    //     label: 'Total Amount ',
    //     status: PaymentItemStatus.final_price));
  }

  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
  }

  void onApplepayResult(re) {}
  void onGooglePaymentResult(res) {
    print("hh");
  }

  void payPressed(String addressFromProvider) {
    print(addressFromProvider);
    addressTobeUsed = '';
    bool isForm = flatBuildingController.text.isNotEmpty;

    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressTobeUsed = flatBuildingController.text;
        addressServices.saveUserAddress(context, addressTobeUsed);
      } else {
        throw Exception("please enter all values");
      }
    } else if (addressFromProvider.isNotEmpty) {
      print(" gsgsgsgs ${addressFromProvider}");
      addressTobeUsed = addressFromProvider;
    } else {
      showSnackBar(context, "ERROR");
    }
    addressServices.orderFromCart(
        context, addressTobeUsed, double.parse(widget.totalSum));
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;
    // address = 'fale shhsshhs shhshs';
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: GlobalVariables.appBarGradient)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12)),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(address),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('OR')
                  ],
                ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _addressFormKey,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: GlobalVariables.backgroundColor,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: flatBuildingController,
                        hintText: " Flat ,House no, building",
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 10),
                      // CustomTextField(
                      //   controller: areaController,
                      //   hintText: " Area, Street",
                      //   textInputAction: TextInputAction.next,
                      // ),
                      // const SizedBox(height: 10),
                      // CustomTextField(
                      //   controller: pincodeController,
                      //   hintText: "Pinode",
                      //   textInputAction: TextInputAction.done,
                      // ),
                      // CustomTextField(
                      //   controller: cityController,
                      //   hintText: "Town , city",
                      //   textInputAction: TextInputAction.done,
                      // ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              // ApplePayButton(
              //     onPaymentResult: onApplepayResult,
              //     paymentItems: paymentItems,
              //     paymentConfigurationAsset: 'applepay.json'),
              // GooglePayButton(
              //     onPressed: () => payPressed(address),
              //     onPaymentResult: onGooglePaymentResult,
              //     paymentConfigurationAsset: 'gpay.json',
              //     paymentItems: paymentItems)

              CustomButton(
                  text: "Pay",
                  onTap: () {
                    payPressed(address);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
