import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/product.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  // List<Product>? products;
  final AdminServices adminServices = AdminServices();
  @override
  void initState() {
    super.initState();
    fetchAppProducts();
  }

  fetchAppProducts() async {
    adminServices.fetchAllProduct(context);
    // setState(() {});
  }

  void deleteProducts(Product product, int index) {
    adminServices.deleteProduct(
        context: context,
        product: product,
        onSuccess: () {
          // products!.removeAt(index);
          context.read<AdminProvider>().deleteProduct(index);
          showSnackBar(context, "Product deleted Successfully");

          // setState(() {});
        });
  }

  void navigateTooAddProduct() {
    Provider.of<AdminProvider>(context, listen: false).getImages([]);
    Navigator.pushNamed(context, AddProductSCreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<AdminProvider>(context).productList == null
        ? const Loader()
        : Scaffold(
            body: Consumer<AdminProvider>(builder: (context, provider, _) {
              List<Product>? products = provider.productList;
              return products != null && products.isEmpty
                  ? Center(
                      child: Text("empty List"),
                    )
                  : Column(
                      children: [
                        SizedBox(height: 10),
                        Expanded(
                          child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: products?.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemBuilder: (context, index) {
                                final productData = products![index];
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 130,
                                      child: SingleProduct(
                                          img: productData.images[0]),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Text(
                                          productData.name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        )),
                                        IconButton(
                                            onPressed: () {
                                              deleteProducts(
                                                  productData, index);
                                            },
                                            icon: const Icon(
                                                Icons.delete_outline))
                                      ],
                                    )
                                  ],
                                );
                              }),
                        )
                      ],
                    );
            }),
            floatingActionButton: FloatingActionButton(
              child: const Icon(
                Icons.add,
              ),
              onPressed: navigateTooAddProduct,
              tooltip: 'Add a Product',
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
