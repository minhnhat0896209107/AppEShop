import 'package:base_code/src/blocs/cart_bloc.dart';
import 'package:base_code/src/commons/widgets/loading_widget.dart';
import 'package:base_code/src/models/product/product.dart';
import 'package:base_code/src/struct/app_color.dart';
import 'package:base_code/src/ui/main/cart/cart_product.dart';
import 'package:base_code/src/ui/main/order/order_screen.dart';
import 'package:base_code/src/ui/main/product/widget/icon_text_button.dart';
import 'package:base_code/src/utils/app_image.dart';
import 'package:base_code/src/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartBloC bloC;
  @override
  Widget build(BuildContext context) {
    return Provider<CartBloC>(
        create: (context) => CartBloC(),
        builder: (context, _) {
          bloC = context.read<CartBloC>();
          bloC.getInCartProduct();
          bloC.init();
          return Container(
            color: AppColors.pinkLight,
            child: SingleChildScrollView(
              child: Column(children: [
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 100,
                  child: const Text(
                    AppStrings.cart,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                  ),
                ),
                StreamBuilder<List<Product>>(
                    stream: bloC.listCartStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: loadingWidget);
                      }
                      List<Product> cartProducts = snapshot.data!;
                      print("XYZ == ${cartProducts.length}");
                      double totalPrice = getTotalPrice(cartProducts);
                      if (cartProducts.isEmpty) {
                        return Image.asset(AppImages.cartEmpty);
                      } else {
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    AppStrings.product,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    AppStrings.quantity,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                  children: List.generate(
                                      cartProducts.length,
                                      (index) => CartProduct(
                                            product: cartProducts[index],
                                            isStroke: index % 2 == 0,
                                          ))),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(AppStrings.total + ':'),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          totalPrice.toInt().toString() + 'đ',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                    IconTextButton(
                                        imageUrl: AppImages.wallet,
                                        title: AppStrings.checkout,
                                        onTap: () {
                                        })
                                  ]),
                            )
                          ],
                        );
                      }
                    })
              ]),
            ),
          );
        });
  }

  double getTotalPrice(List<Product> products) {
    double total = 0;
    for (Product product in products) {
      total += product.price ?? 0;
    }
    return total;
  }
}
