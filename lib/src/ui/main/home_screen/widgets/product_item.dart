import 'package:base_code/src/commons/widgets/rounded_image.dart';
import 'package:base_code/src/models/product.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({required this.url, required this.product, Key? key})
      : super(key: key);
  final Product product;
  final String url;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(50)),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          LayoutBuilder(builder: (context, constraints) {
            return Column(children: [
              SizedBox(
                height: constraints.maxWidth,
                child: RoundedImage(url: url),
              ),
              Text(product.name ?? '--'),
              Text(
                '${product.price} đ',
                style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
            ]);
          }),
        ],
      ),
    );
  }
}
