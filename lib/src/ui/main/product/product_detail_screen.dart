import 'package:base_code/src/blocs/product_detail_bloc.dart';
import 'package:base_code/src/models/product.dart';
import 'package:base_code/src/struct/app_color.dart';
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
  @override
  Widget build(BuildContext context) {
    return Provider<ProductDetailBloC>(
        create: ((context) => ProductDetailBloC()),
        builder: (context, child) {
          bloC = context.read<ProductDetailBloC>();
          bloC.init(product: widget.product);
          bloC.getProductDetail(id: widget.product.id!);
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
          listImage: [product.imageUrl!],
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
          (product.category ?? '--').toUpperCase(),
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: AppColors.pink,
                  borderRadius: BorderRadius.circular(50)),
              child: Row(children: [
                Image.asset(
                  AppImages.sale,
                  height: 24,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(AppStrings.sale50)
              ]),
            )
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
              const Text('123 ${AppStrings.stock}'),
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
            const SizedBox(
              width: 5,
            ),
            Text(
              '${product.price} đ',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: AppColors.secondary,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w400,
                  fontSize: 16),
            ),
          ],
        ),
        Row(
          children: const [
            Text('${AppStrings.color}:'),
            SizedBox(
              width: 8,
            ),
            CategoryButton(
              text: 'red',
              buttonStatus: ButtonStatus.disabled,
            ),
            SizedBox(
              width: 8,
            ),
            CategoryButton(
              text: 'blue',
              buttonStatus: ButtonStatus.normal,
            ),
            SizedBox(
              width: 8,
            ),
            CategoryButton(
              text: 'green',
              buttonStatus: ButtonStatus.selected,
            )
          ],
        ),
        Row(
          children: const [
            Text('${AppStrings.size}:'),
            SizedBox(
              width: 8,
            ),
            CategoryButton(
              text: 'XS',
              buttonStatus: ButtonStatus.disabled,
            ),
            SizedBox(
              width: 8,
            ),
            CategoryButton(
              text: 'S',
              buttonStatus: ButtonStatus.normal,
            ),
            SizedBox(
              width: 8,
            ),
            CategoryButton(
              text: 'M',
              buttonStatus: ButtonStatus.selected,
            ),
            SizedBox(
              width: 8,
            ),
            CategoryButton(
              text: 'L',
              buttonStatus: ButtonStatus.normal,
            ),
          ],
        ),
        Row(
          children: const [
            Text('${AppStrings.quantity}:'),
            SizedBox(
              width: 8,
            ),
            QuantityButton(),
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
              '${product.price} đ',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 30),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              '${product.price} đ',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: AppColors.secondary,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w400,
                  fontSize: 20),
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
}
