// ignore_for_file: prefer_const_constructors

import 'package:base_code/src/models/deliver_infomation/deliver_information.dart';
import 'package:base_code/src/struct/app_color.dart';
import 'package:base_code/src/ui/main/main.dart';
import 'package:base_code/src/utils/helpers.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_image.dart';
import '../../../utils/app_strings.dart';
import '../product/widget/icon_text_button.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController edtName = TextEditingController();
  final TextEditingController edtPhone = TextEditingController();
  final TextEditingController edtCity = TextEditingController();
  final TextEditingController edtDistrict = TextEditingController();
  final TextEditingController edtWard = TextEditingController();
  final TextEditingController edtNote = TextEditingController();
  int page = 0;
  PageController controller = PageController(initialPage: 0);
  DeliverInformation deliver = DeliverInformation();

  @override
  void dispose() {
    // TODO: implement dispose
    deliver = DeliverInformation();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return Column(
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
        _inputInformation("${AppStrings.name} *", edtName, TextInputType.text),
        _inputInformation(
            "${AppStrings.phoneNumber} *", edtPhone, TextInputType.phone),
        _inputInformation("${AppStrings.city} *", edtCity, TextInputType.text),
        _inputInformation(
            "${AppStrings.district} *", edtDistrict, TextInputType.text),
        _inputInformation("${AppStrings.ward} *", edtWard, TextInputType.text),
        _inputInformation(AppStrings.note, edtNote, TextInputType.text),
        _nextPageInforOrder()
      ],
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
                      edtCity.text.isEmpty ||
                      edtDistrict.text.isEmpty ||
                      edtPhone.text.isEmpty ||
                      edtWard.text.isEmpty) {
                    showErrorDialog(context, AppStrings.inputInformation);
                  } else {
                    deliver
                      ..name = edtName.text.toString()
                      ..city = edtCity.text.toString()
                      ..phoneNumber = edtPhone.text.toString()
                      ..district = edtDistrict.text.toString()
                      ..ward = edtWard.text.toString()
                      ..note = edtNote.text.toString();
                    print(
                        "DELIVER1 == ${deliver.name} \t ${deliver.city} \t ${deliver.phoneNumber} \t ${deliver.district} \t ${deliver.ward} \t ${deliver.note} \t ");

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
        "DELIVER == ${deliver.name} \t ${deliver.city} \t ${deliver.phoneNumber} \t ${deliver.district} \t ${deliver.ward} \t ${deliver.note} \t ");
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
              "${AppStrings.order} (20 products)",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          _listOrder(),
          _listOrder(),
          SizedBox(
            height: 20,
          ),
          _lineHeight(),
          _inforPrice(AppStrings.price, "4.000.000d", FontWeight.w500),
          _inforPrice(AppStrings.ship, "32.000d", FontWeight.w500),
          _inforPrice(AppStrings.discount, "-15.000d", FontWeight.w500),
          _inforPrice(AppStrings.total, "4.017.000d", FontWeight.w700),
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

  Widget _listOrder() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Image.network(
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
                      "1",
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
              children: const [
                Text(
                  AppStrings.makeYourStyle ?? '--',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Size" ?? '--',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 5),
            child: Text(
              "Price" ?? '--',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
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
              onTap: () {})
        ],
      ),
    );
  }
}
