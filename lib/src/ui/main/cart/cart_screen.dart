import 'package:base_code/src/api/global_api.dart';
import 'package:base_code/src/blocs/cart_bloc.dart';
import 'package:base_code/src/commons/widgets/loading_widget.dart';
import 'package:base_code/src/models/cart.dart';
import 'package:base_code/src/models/product/product.dart';
import 'package:base_code/src/struct/app_color.dart';
import 'package:base_code/src/ui/main/cart/cart_product.dart';
import 'package:base_code/src/ui/main/momo_webview/momo_screen.dart';
import 'package:base_code/src/ui/main/order/order_screen.dart';
import 'package:base_code/src/ui/main/product/widget/icon_text_button.dart';
import 'package:base_code/src/utils/app_image.dart';
import 'package:base_code/src/utils/app_strings.dart';
import 'package:base_code/src/utils/integer_extension.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartBloC bloC;
  late List<Cart> listCart = [];
  List<int> listNumberQuantity = [];
  late SharedPreferences pref;

  @override
  void initState() {
    listCart = globalApi.listCart;
    if (listCart.length == 0) {
      checkListProduct();
    }
    for (Cart i in listCart) {
      listNumberQuantity.add(i.numberQuantityBuy!);
    }
    super.initState();
  }

  void checkListProduct() async {
    pref = await SharedPreferences.getInstance();
    pref.setString("listCart", "[]");
  }
  @override
  Widget build(BuildContext context) {
    print("list cart == ${listCart.length}");
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
                      print("list cart1 == ${cartProducts.length} ");
                      String totalPrice = getTotalPrice(cartProducts);
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
                                      (index) => _cartDetail(
                                          index % 2 == 0,
                                          cartProducts[index],
                                          listCart[index],
                                          index))),
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
                                          totalPrice,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                    IconTextButton(
                                        imageUrl: AppImages.wallet,
                                        title: AppStrings.checkout,
                                        onTap: () async {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => OrderScreen(),));
                                          setState(() {
                                            
                                          });
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

  Widget _cartDetail(bool isStroke, Product? product, Cart cart, int index) {
    return Container(
      color: isStroke ? Colors.black.withOpacity(0.05) : null,
      padding: const EdgeInsets.all(12),
      child: Row(children: [
        Image.network(
          product?.images?.first.url ??
              "https://loremflickr.com/640/480/fashion",
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
        _quantityButton(product!, index)
      ]),
    );
  }

  Widget _quantityButton(Product product, index) {
    const Color buttonColor = AppColors.primay;
    return Container(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (listNumberQuantity[index] < 2) {
                setState(() {
                  listNumberQuantity == 1;
                });
              } else {
                setState(() {
                  listNumberQuantity[index]--;
                });
              }
            },
            icon: const Text('-'),
            iconSize: 10,
            splashRadius: 12,
          ),
          Text('${listNumberQuantity[index]}'),
          IconButton(
            onPressed: () {
              setState(() {
                listNumberQuantity[index]++;
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

  String getTotalPrice(List<Product> products) {
    int total = 0;
    for (int i = 0; i < products.length; i++) {
      total += products[i].price! * listNumberQuantity[i];
    }
    return total.formatMoney;
  }
}
