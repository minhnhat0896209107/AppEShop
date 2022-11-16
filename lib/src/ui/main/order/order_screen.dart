// ignore_for_file: prefer_const_constructors

import 'package:base_code/src/blocs/cart_bloc.dart';
import 'package:base_code/src/blocs/order_bloc.dart';
import 'package:base_code/src/models/deliver_infomation/deliver_information.dart';
import 'package:base_code/src/models/order.dart';
import 'package:base_code/src/models/order_momo/order_momo.dart';
import 'package:base_code/src/struct/app_color.dart';
import 'package:base_code/src/ui/main/main.dart';
import 'package:base_code/src/utils/helpers.dart';
import 'package:base_code/src/utils/integer_extension.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/global_api.dart';
import '../../../blocs/order_momo_bloc.dart';
import '../../../commons/widgets/loading_widget.dart';
import '../../../manager/user_manager.dart';
import '../../../models/cart.dart';
import '../../../models/order_momo/order_item/order_item.dart';
import '../../../models/product/product.dart';
import '../../../repositories/order_repo.dart';
import '../../../utils/app_image.dart';
import '../../../utils/app_strings.dart';
import '../common/app_bar.dart';
import '../momo_webview/momo_screen.dart';
import '../product/widget/icon_text_button.dart';

class OrderScreen extends StatefulWidget {
  int? id;
  OrderScreen({Key? key, this.id}) : super(key: key);

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
  List<Item> itemsOrder = [];
  final OrderRepository _orderRepository = OrderRepository();
  String? url;
  late OrderMomoBloc _orderMomoBloc;
  int? idOrderMomo;
  OrderMomo? orderMomo;
  List<Product> cartProducts = [];

  Future postOrder() async {
    print(
        "ORDERPOST== ${order.items?.length} \t ${order.name} \t ${order.phone} \t ${order.address}");

    url = await _orderRepository.postOrder(order: order);
  }

  @override
  void initState() {
    print("AAAAAAA1 ${globalApi.listCart} \t ${listCart}");

    idOrderMomo = widget.id;
    listCart = globalApi.listCart;

    for (Cart i in listCart) {
      listNumberQuantity.add(i.numberQuantityBuy!);
      cartProducts.add(i.product!);
      var item =
          Item(productSizeId: i.productSizeId, quantity: i.numberQuantityBuy);
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

  @override
  Widget build(BuildContext context) {
    print("AAAAAAA ${globalApi.listCart} \t ${listCart}");
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
    return Provider<OrderMomoBloc>(
      create: (context) => OrderMomoBloc(),
      builder: (context, child) {
        _orderMomoBloc = context.read<OrderMomoBloc>();
        _orderMomoBloc.getDetailOrderMomo(idOrderMomo.toString());
        return StreamBuilder<OrderMomo>(
            stream: _orderMomoBloc.orderMomoDetailStream,
            builder: (context, snapshot) {
              orderMomo = snapshot.data;
              if (snapshot.connectionState == ConnectionState.waiting){
                return loadingWidget;
              }
              if (orderMomo == null)
                return Image.asset(AppImages.cartEmpty);
              else {
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
                          AppStrings.deliveryInformation,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      _inputInformation(
                          orderMomo != null
                              ? orderMomo!.name!
                              : "${AppStrings.name} *",
                          edtName,
                          TextInputType.text,
                          orderMomo),
                      _inputInformation(
                          orderMomo != null
                              ? orderMomo!.phone!
                              : "${AppStrings.phoneNumber} *",
                          edtPhone,
                          TextInputType.phone,
                          orderMomo),
                      _inputInformation(
                          orderMomo != null
                              ? orderMomo!.address!
                              : "${AppStrings.address} *",
                          edtAddress,
                          TextInputType.text,
                          orderMomo),
                      _inputInformation(
                          orderMomo == null
                              ? AppStrings.note
                              : orderMomo?.note != null
                                  ? orderMomo?.note
                                  : "",
                          edtNote,
                          TextInputType.text,
                          orderMomo),
                      _nextPageInforOrder(orderMomo)
                    ],
                  ),
                );
              }
            });
      },
    );
  }

  Widget _inputInformation(String hintText, TextEditingController controller,
      TextInputType type, OrderMomo? orderMomo) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 10, right: 30),
      child: Container(
        child: TextField(
          enabled: orderMomo != null ? false : true,
          keyboardType: type,
          decoration:
              InputDecoration(border: OutlineInputBorder(), hintText: hintText),
          controller: controller,
        ),
      ),
    );
  }

  Widget _nextPageInforOrder(OrderMomo? orderMomo) {
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
                  if (orderMomo != null) {
                    setState(() {
                      page++;
                      controller.animateToPage(page,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    });
                  } else {
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
    print("AAAAAAA2 ${globalApi.listCart} \t ${listCart}");
  
    if (orderMomo != null) {
     return  SingleChildScrollView(
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
                "${AppStrings.order} (${orderMomo!.orderItems!.length} products)",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            _listOrderMomo(orderMomo!.orderItems!),
            SizedBox(
              height: 10,
            ),
            _lineHeight(),
            _inforPrice(AppStrings.price,
                int.parse(orderMomo!.total!).formatMoney, FontWeight.w500),
            _inforPrice(AppStrings.ship, "0d", FontWeight.w500),
            _inforPrice(AppStrings.discount, "0d", FontWeight.w500),
            _inforPrice(AppStrings.total,
                int.parse(orderMomo!.total!).formatMoney, FontWeight.w700),
            _lineHeight(),
            _backInforInput(orderMomo),
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
    } else {
      String totalPrice = getTotalPrice(cartProducts);

      return listCart.isEmpty
          ? Image.asset(AppImages.cartEmpty)
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 100,
                    child: Text(
                      AppStrings.order,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Text(
                      "${AppStrings.order} (${cartProducts.length} products)",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  _listOrder(cartProducts),
                  SizedBox(
                    height: 10,
                  ),
                  _lineHeight(),
                  _inforPrice(AppStrings.price, totalPrice, FontWeight.w500),
                  _inforPrice(AppStrings.ship, "0d", FontWeight.w500),
                  _inforPrice(AppStrings.discount, "0d", FontWeight.w500),
                  _inforPrice(AppStrings.total, totalPrice, FontWeight.w700),
                  _lineHeight(),
                  _backInforInput(null),
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
                    (listCart[index].numberQuantityBuy! * product.price!)
                            .formatMoney ??
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

  Widget _listOrderMomo(List<OrderItem> orderItems) {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 5),
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: orderItems.length,
          itemBuilder: (context, index) {
            OrderItem orderItem = orderItems[index];
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Image.network(
                          orderItem.productSize?.product!.images!.first.url ??
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
                            "${orderItem.quantity}",
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
                        orderItem.productSize?.product!.images!.first.name ??
                            '--',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        orderItem.productSize?.size!.name ?? '--',
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
                    int.parse(orderItem.price!).formatMoney ?? '--',
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

  Widget _backInforInput(OrderMomo? orderMomo) {
    itemsOrder = [];
    if (orderMomo != null) {
      for (var i in orderMomo.orderItems!) {
        var item = Item(productSizeId: i.productSizeId, quantity: i.quantity);
        itemsOrder.add(item);
      }
      order
        ..items = itemsOrder
        ..address = orderMomo.address
        ..name = orderMomo.name
        ..phone = orderMomo.phone
        ..note = orderMomo.note;
    } else {
      order
        ..items = items
        ..address = deliver.address
        ..name = deliver.name
        ..phone = deliver.phoneNumber
        ..note = deliver.note;
    }

    print(
        "ORDERBUILD== ${order.items?.length} \t ${order.name} \t ${order.phone} \t ${order.address}");

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
          Visibility(
            visible: orderMomo!.status != 'cancelled',
            child: IconTextButton(
                imageUrl: AppImages.wallet,
                title: AppStrings.checkout,
                onTap: () async {
                  try {
                    await postOrder();
                    print("URL == $url \t ${UserManager.globalToken}");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MomoScreen(url: url),
                        )).then((value) {
                      globalApi.listCart = [];
                      listCart = [];
                      setState(() {
                      
                    });
                    });
                    
                  } catch (error, stackStrace) {
                    debugPrint(error.toString());
                    debugPrintStack(stackTrace: stackStrace);
                    showErrorDialog(context, error);
                  }
          
                  setState(() {});
                }),
          )
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
