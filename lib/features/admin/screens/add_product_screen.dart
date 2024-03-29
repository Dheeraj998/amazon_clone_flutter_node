import 'dart:io';

import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/providers/admin_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/global_variables.dart';
import 'package:dotted_border/dotted_border.dart';

class AddProductSCreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductSCreen({Key? key}) : super(key: key);

  @override
  State<AddProductSCreen> createState() => _AddProductSCreenState();
}

class _AddProductSCreenState extends State<AddProductSCreen> {
  final productController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  AdminServices adminServices = AdminServices();
  final _addProductFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    productController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

  void selectedImages() async {
    print("heree");
    var res = await pickImages();

    Provider.of<AdminProvider>(context, listen: false).getImages(res);
  }

  void sellProduct() {
    final provider = Provider.of<AdminProvider>(context, listen: false);
    if (_addProductFormKey.currentState!.validate() &&
        provider.images.isNotEmpty) {
      adminServices.sellProduct(
          context: context,
          name: productController.text,
          description: descriptionController.text,
          price: double.parse(priceController.text),
          quantity: double.parse(quantityController.text),
          category: provider.category,
          images: provider.images);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("EEEEEEEEEEEEEEEEEE ");
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
            flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: GlobalVariables.appBarGradient)),
            title: const Text(
              'Add Product',
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
            )),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _addProductFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(children: [
                const SizedBox(height: 20),
                Consumer<AdminProvider>(builder: (context, provider, child) {
                  return Provider.of<AdminProvider>(context, listen: false)
                          .images
                          .isNotEmpty
                      ? Stack(
                          children: [
                            CarouselSlider(
                              items: provider.images.map((e) {
                                return Builder(
                                    builder: (BuildContext context) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.file(
                                              e,
                                              fit: BoxFit.cover,
                                              height: 200,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  20,
                                            ),
                                          ),
                                        ));
                              }).toList(),
                              options: CarouselOptions(
                                  viewportFraction: 1, height: 200),
                            ),
                            SizedBox(
                              height: 200,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orangeAccent
                                            .withOpacity(.5)),
                                    onPressed: () {
                                      selectedImages();
                                    },
                                    child: const Text("Change Images")),
                              ),
                            )
                          ],
                        )
                      : GestureDetector(
                          onTap: selectedImages,
                          child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(10),
                              dashPattern: const [10, 4],
                              strokeCap: StrokeCap.round,
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.folder_open, size: 40),
                                    const SizedBox(height: 15),
                                    Text(
                                      'Select Product Images',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade400),
                                    )
                                  ],
                                ),
                              )),
                        );
                }),
                const SizedBox(height: 30),
                CustomTextField(
                    controller: productController, hintText: 'Product Name'),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'Description',
                  maxLines: 7,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: priceController,
                  hintText: 'Price',
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: quantityController,
                  hintText: 'Quantity',
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                Consumer<AdminProvider>(builder: (context, provider, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: DropdownButton(
                      value: provider.category,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: provider.productCategories.map((String item) {
                        return DropdownMenuItem(value: item, child: Text(item));
                      }).toList(),
                      onChanged: (String? val) {
                        provider.updateCategory(val!);
                      },
                    ),
                  );
                }),
                CustomButton(text: 'Sell', onTap: sellProduct),
                const SizedBox(height: 40)
              ]),
            )),
      ),
    );
  }
}
