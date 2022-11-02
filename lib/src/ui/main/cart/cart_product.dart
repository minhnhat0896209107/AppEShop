import 'package:base_code/src/models/product/product.dart';
import 'package:base_code/src/ui/main/product/widget/category_button.dart';
import 'package:base_code/src/ui/main/product/widget/quantity_button.dart';
import 'package:flutter/material.dart';

class CartProduct extends StatelessWidget {
  const CartProduct({this.isStroke = true, required this.product, Key? key})
      : super(key: key);
  final bool isStroke;
  final Product product;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: isStroke ? Colors.black.withOpacity(0.05) : null,
      padding: const EdgeInsets.all(12),
      child: Row(children: [
        Image.network(
          product.images![0].url!,
          width: 100,
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name ?? '--',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text((product.price?.toString() ?? '--') + 'đ'),
               CategoryButton(
                text: 'red',
              )
            ],
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        // QuantityButton(product: product, indexProductSize: 0,),
      ]),
    );
  }
}
