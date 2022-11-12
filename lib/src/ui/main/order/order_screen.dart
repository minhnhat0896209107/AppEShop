// ignore_for_file: prefer_const_constructors

import 'package:base_code/src/blocs/cart_bloc.dart';
import 'package:base_code/src/blocs/order_bloc.dart';
import 'package:base_code/src/models/deliver_infomation/deliver_information.dart';
import 'package:base_code/src/models/order.dart';
import 'package:base_code/src/struct/app_color.dart';
import 'package:base_code/src/ui/main/main.dart';
import 'package:base_code/src/utils/helpers.dart';
import 'package:base_code/src/utils/integer_extension.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/global_api.dart';
import '../../../commons/widgets/loading_widget.dart';
import '../../../manager/user_manager.dart';
import '../../../models/cart.dart';
import '../../../models/product/product.dart';
import '../../../repositories/order_repo.dart';
import '../../../utils/app_image.dart';
import '../../../utils/app_strings.dart';
import '../common/app_bar.dart';
import '../momo_webview/momo_screen.dart';
import '../product/widget/icon_text_button.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController edtName = TextEditingController();
  final TextEditingController edtPhone = TextEditingController();
  final TextEditingController edtAddress = TextEditingController();
  final TextEditingController edtNote = TextEditingController();
  int page = 0;
  PageController controller = PageController(initialPage: 0);
  DeliverInformation deliver = DeliverInformation();
  late CartBloC bloC;
  late OrderBloc orderBloc;
  late List<Cart> listCart = [];
  List<int> listNumberQuantity = [];
  late SharedPreferences pref;
  late Order order = Order();
  List<Item> items = [];
  final OrderRepository _orderRepository = OrderRepository();
  String? url;
  Future postOrder() async {
     print(
        "ORDERPOST== ${order.items?.length} \t ${order.name} \t ${order.phone} \t ${order.address}");

    url = await _orderRepository.postOrder(order: order);
  }

  @override
  void initState() {
    listCart = globalApi.listCart;
    if (listCart.length == 0) {
      checkListProduct();
    }
    for (Cart i in listCart) {
      listNumberQuantity.add(i.numberQuantityBuy!);
      var item = Item(productSizeId: i.productSizeId, quantity: i.numberQuantityBuy);
      items.add(item);
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    deliver = DeliverInformation();
    super.dispose();
  }

  void checkListProduct() async {
    pref = await SharedPreferences.getInstance();
    pref.setString("listCart", "[]");
  }

  @override
  Widget build(BuildContext context) {
    print("AAAA == ${items.length}");

    return Scaffold(
        appBar: customAppbar,
        body: Stack(
          children: [
            Container(
              color: AppColors.pinkLight,
            ),
            PageView(
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (value) {
                setState(() {
                  page = value;
                });
              },
              children: [_pageInput(), _pageInforOrder()],
              controller: controller,
            )
          ],
        ));
  }

  Widget _pageInput() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 100,
            child: Text(
              AppStrings.order,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: Text(
              AppStrings.deliveryInformation,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          _inputInformation(
              "${AppStrings.name} *", edtName, TextInputType.text),
          _inputInformation(
              "${AppStrings.phoneNumber} *", edtPhone, TextInputType.phone),
          _inputInformation(
              "${AppStrings.address} *", edtAddress, TextInputType.text),
          _inputInformation(AppStrings.note, edtNote, TextInputType.text),
          _nextPageInforOrder()
        ],
      ),
    );
  }

  Widget _inputInformation(
      String hintText, TextEditingController controller, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 10, right: 30),
      child: Container(
        child: TextField(
          keyboardType: type,
          decoration:
              InputDecoration(border: OutlineInputBorder(), hintText: hintText),
          controller: controller,
        ),
      ),
    );
  }

  Widget _nextPageInforOrder() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 20, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Main(),
                )),
            child: Text(AppStrings.cancelOrder),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  if (edtName.text.isEmpty ||
                      edtAddress.text.isEmpty ||
                      edtPhone.text.isEmpty) {
                    showErrorDialog(context, AppStrings.inputInformation);
                  } else {
                    deliver
                      ..name = edtName.text.toString()
                      ..address = edtAddress.text.toString()
                      ..phoneNumber = edtPhone.text.toString()
                      ..note = edtNote.text.toString();

                    setState(() {
                      page++;
                      controller.animateToPage(page,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    });
                  }
                },
                child: Text(
                  AppStrings.next,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  Widget _pageInforOrder() {
    print(
        "DELIVER == ${deliver.name} \t ${deliver.address} \t ${deliver.phoneNumber} \t ${deliver.note} \t ");
    return Provider<CartBloC>(
      create: (context) => CartBloC(),
      builder: (context, child) {
        bloC = context.read<CartBloC>();
        bloC.getInCartProduct();
        bloC.init();
        return StreamBuilder<List<Product>>(
            stream: bloC.listCartStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: loadingWidget);
              }
              List<Product> cartProducts = snapshot.data!;

              String totalPrice = getTotalPrice(cartProducts);
              if (cartProducts.isEmpty) {
                return Image.asset(AppImages.cartEmpty);
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 100,
                        child: Text(
                          AppStrings.order,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: Text(
                          "${AppStrings.order} (${cartProducts.length} products)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                      _listOrder(cartProducts),
                      SizedBox(
                        height: 10,
                      ),
                      _lineHeight(),
                      _inforPrice(
                          AppStrings.price, totalPrice, FontWeight.w500),
                      _inforPrice(AppStrings.ship, "0d", FontWeight.w500),
                      _inforPrice(AppStrings.discount, "0d", FontWeight.w500),
                      _inforPrice(
                          AppStrings.total, totalPrice, FontWeight.w700),
                      _lineHeight(),
                      _backInforInput(),
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 10, bottom: 30),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Main(),
                                )),
                            child: Text(AppStrings.cancelOrder),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            });
      },
    );
  }

  Widget _listOrder(List<Product> cartProducts) {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 5),
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: cartProducts.length,
          itemBuilder: (context, index) {
            Product product = cartProducts[index];
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Image.network(
                          product.images?.first.url ??
                              "https://loremflickr.com/640/480/fashion",
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 55),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            "${listCart[index].numberQuantityBuy}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            shape: BoxShape.circle,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name ?? '--',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        listCart[index].size ?? '--',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Text(
                    (listCart[index].numberQuantityBuy! * product.price!).formatMoney ??
                        '--',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            );
          },
        ));
  }

  Widget _inforPrice(String text, String price, FontWeight fontWeight) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            price,
            style: TextStyle(fontSize: 20, fontWeight: fontWeight),
          ),
        ],
      ),
    );
  }

  Widget _lineHeight() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      width: MediaQuery.of(context).size.width,
      height: 1,
      color: Colors.black,
    );
  }

  Widget _backInforInput() {
    order
      ..items = items
      ..address = deliver.address
      ..name = deliver.name
      ..phone = deliver.phoneNumber
      ..note = deliver.note;
    print(
        "ORDERBUILD== ${order.items?.length} \t ${order.name} \t ${order.phone} \t ${order.address}");

    print(
        "DELIVER1 == ${deliver.name} \t ${deliver.phoneNumber} \t ${deliver.address} \t ${deliver.note} \t ");
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    page--;
                    controller.animateToPage(page,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  });
                },
                child: Text(
                  AppStrings.prev,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
          ),
          IconTextButton(
              imageUrl: AppImages.wallet,
              title: AppStrings.checkout,
              onTap: () async {
                // setState(() {});
                try {
                  await postOrder();
                  print("URL == $url \t ${UserManager.globalToken}");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MomoScreen(url: url),
                      ));
                  listCart = [];
                  pref = await SharedPreferences.getInstance();
                  pref.setString("listCart", "[]");
                } catch (error, stackStrace) {

                  debugPrint(error.toString());
                  debugPrintStack(stackTrace: stackStrace);
                  showErrorDialog(context, error);
                }

                setState(() {});
              })
        ],
      ),
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
