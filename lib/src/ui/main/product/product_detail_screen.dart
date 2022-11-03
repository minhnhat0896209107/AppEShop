import 'package:base_code/src/blocs/product_detail_bloc.dart';
import 'package:base_code/src/models/product/product.dart';
import 'package:base_code/src/models/product/product_size/product_size.dart';
import 'package:base_code/src/struct/app_color.dart';
import 'package:base_code/src/ui/main/cart/cart_screen.dart';
import 'package:base_code/src/ui/main/common/app_bar.dart';
import 'package:base_code/src/ui/main/home_screen/widgets/slider_widget.dart';
import 'package:base_code/src/ui/main/product/widget/category_button.dart';
import 'package:base_code/src/ui/main/product/widget/icon_text_button.dart';
import 'package:base_code/src/ui/main/product/widget/quantity_button.dart';
import 'package:base_code/src/utils/app_image.dart';
import 'package:base_code/src/utils/app_strings.dart';
import 'package:base_code/src/utils/app_textstyle.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../api/global_api.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({required this.product, Key? key})
      : super(key: key);
  final Product product;
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late ProductDetailBloC bloC;
  final CarouselController _carouselController = CarouselController();
  bool isCheckSelect = false;
  int? indexSelect;
  int totalPrice = 0;
  int numberQuantity = 1;
  @override
  Widget build(BuildContext context) {

    return Provider<ProductDetailBloC>(
        create: ((context) => ProductDetailBloC()),
        builder: (context, child) {
          bloC = context.read<ProductDetailBloC>();
          bloC.init(product: widget.product);
          bloC.getProductDetail(slug: widget.product.slug!);
          return Scaffold(
            appBar: customAppbar,
            body: StreamBuilder<Product>(
                stream: bloC.productStream,
                builder: (context, snapshot) {
                  Product product = snapshot.data!;
                  return Container(
                    color: AppColors.pinkLight,
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        const SizedBox(
                          height: 80,
                        ),
                        _slider(product),
                        _productDetail(product),
                        _description(product),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    )),
                  );
                }),
          );
        });
  }

  Widget _slider(Product product) {
    return Stack(
      children: [
        SliderWidget(
          listImage: product.images,
          controller: _carouselController,
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.pinkDark,
                  child: IconButton(
                      iconSize: 12,
                      splashRadius: 14,
                      color: Colors.white,
                      onPressed: () {
                        _carouselController.previousPage();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 12,
                      )),
                ),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.pinkDark,
                  child: IconButton(
                      iconSize: 12,
                      splashRadius: 14,
                      onPressed: () {
                        _carouselController.nextPage();
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 12,
                      )),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _productDetail(Product product) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(50)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          (product.category?.name ?? '--').toUpperCase(),
          style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 20,
              fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                (product.name ?? '--'),
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: AppTextStyle.headlineStyle,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 25),
          child: Row(
            children: [
              Flexible(child: _rateDrawer()),
              const SizedBox(
                width: 20,
              ),
              const Text('2.9 ${AppStrings.review}'),
              const SizedBox(
                width: 20,
              ),
              Container(
                height: 15,
                width: 2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.primay),
              ),
              const SizedBox(
                width: 20,
              ),
              Text("${product.stock} ${AppStrings.stock}"),
            ],
          ),
        ),
        Row(
          children: [
            Text(
              '${product.price} đ',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
          ],
        ),
        Container(
          height: 30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: product.productSizes!.length,
            itemBuilder: (context, index) {
              ProductSize productSize = product.productSizes![index];
              if (index == 0) {
                return Row(
                  children: [
                    const Text('${AppStrings.size}:'),
                    const SizedBox(
                      width: 8,
                    ),
                    CategoryButton(
                      onPressed: () {
                        setState(() {
                          isCheckSelect = true;
                          indexSelect = index;
                        });
                      },
                      text: productSize.size?.name ?? "--",
                      buttonStatus: productSize.quantity == 0
                          ? ButtonStatus.disabled
                          : isCheckSelect && indexSelect == index
                              ? ButtonStatus.selected
                              : ButtonStatus.normal,
                    ),
                    const SizedBox(
                      width: 8,
                    )
                  ],
                );
              }
              return Row(
                children: [
                  CategoryButton(
                    onPressed: () {
                      setState(() {
                        isCheckSelect = true;
                        indexSelect = index;
                      });
                    },
                    text: productSize.size?.name ?? "--",
                    buttonStatus: productSize.quantity == 0
                        ? ButtonStatus.disabled
                        : isCheckSelect && indexSelect == index
                            ? ButtonStatus.selected
                            : ButtonStatus.normal,
                  ),
                  const SizedBox(
                    width: 8,
                  )
                ],
              );
            },
          ),
        ),
        SizedBox(height: 10,),
        Row(
          children:  [
            Text('${AppStrings.quantity}:'),
            SizedBox(
              width: 8,
            ),
            _quantityButton(product, indexSelect ?? -1),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          children: [
            const Text('${AppStrings.total}:'),
            const SizedBox(
              width: 5,
            ),
            Text(
              '${product.price! * numberQuantity} đ',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 30),
            ),
            
          ],
        ),
        Row(
          children: [
            IconTextButton(
              onTap: () {
                bloC.addToCart(product);
              },
              imageUrl: AppImages.cart,
              title: AppStrings.addToCart,
            ),
            const SizedBox(
              width: 20,
            ),
            IconTextButton(
              onTap: () {},
              imageUrl: AppImages.wallet,
              title: AppStrings.buyNow,
            ),
          ],
        )
      ]),
    );
  }

  Widget _rateDrawer({int rate = 3}) {
    return Row(
      children: [
        ...List.generate(
            rate,
            (index) => Image.asset(
                  AppImages.starFill,
                  height: 12,
                )).toList(),
        ...List.generate(
            5 - rate,
            (index) => Image.asset(
                  AppImages.starOutline,
                  height: 12,
                )).toList(),
      ],
    );
  }

  Widget _description(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(product.description ?? '--'),
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
              if(numberQuantity > widget.product.productSizes![indexProductSize].quantity! && indexProductSize != -1){
                setState(() {
                  numberQuantity == widget.product.productSizes![indexProductSize].quantity;
                });
              }else{
                setState(() {
                    numberQuantity++;
                });
              }
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
