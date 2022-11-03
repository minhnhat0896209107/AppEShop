import 'package:base_code/src/models/product/product.dart';
import 'package:flutter/material.dart';

import '../../../struct/app_color.dart';

class CartProduct extends StatefulWidget {
  const CartProduct({this.isStroke = true, required this.product, Key? key})
      : super(key: key);
  final bool isStroke;
  final Product product;

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  bool hasData = false;
  Product? product;
  int numberQuantity = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    product = widget.product;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
            color: widget.isStroke ? Colors.black.withOpacity(0.05) : null,
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              Image.network(
                product?.images?.first.url?? "https://loremflickr.com/640/480/fashion",
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
                      product?.name ?? '--',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              _quantityButton(product!, numberQuantity)
            ]),
          );
  }
  Widget _quantityButton(Product product, int indexProductSize){
    const Color buttonColor = AppColors.primay;
    return Container(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if(numberQuantity < 2){
                setState(() {
                  numberQuantity == 1;
                });
              }else{
                setState(() {
                  numberQuantity--;
                });
              }
            },
            icon: const Text('-'),
            iconSize: 10,
            splashRadius: 12,
          ),
          Text('${numberQuantity}'),
          IconButton(
            onPressed: () {
     
                setState(() {
                    numberQuantity++;
                });
            },
            icon: const Text('+'),
            iconSize: 10,
            splashRadius: 12,
          ),
        ],
      ),
      decoration: BoxDecoration(
          border: Border.all(color: buttonColor),
          borderRadius: BorderRadius.circular(50)),
      // style: OutlinedButton.styleFrom(
      //     side: const BorderSide(color: buttonColor),
      //     shape: const StadiumBorder(),
      //     primary: buttonColor),
    );
  }
}
