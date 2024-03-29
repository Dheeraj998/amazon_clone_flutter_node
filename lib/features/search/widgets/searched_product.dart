import 'package:amazon_clone/common/widgets/stars.dart';
import 'package:flutter/material.dart';

import 'package:amazon_clone/models/product.dart';

class SearchedProduct extends StatelessWidget {
  final Product product;
  const SearchedProduct({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalRating = 0;
    double avgRating = 0;
    for (int i = 0; i < product.ratings!.length; i++) {
      totalRating += product.ratings![i].rating;
    }
    if (totalRating != 0) {
      avgRating = totalRating / product.ratings!.length;
    }
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                product.images[0],
                fit: BoxFit.cover,
                height: 135,
                width: 135,
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 235,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        product.name,
                        style: const TextStyle(fontSize: 16),
                        maxLines: 2,
                      ),
                    ),
                    Container(
                        width: 235,
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Stars(rating: avgRating)),
                    Container(
                      width: 235,
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Text(
                        '\$${product.price}',
                        style: const TextStyle(fontSize: 20),
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      width: 235,
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: Text(
                        'Eligible For Free Shipping',
                      ),
                    ),
                    Container(
                      width: 235,
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: Text(
                        'In Stock',
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
