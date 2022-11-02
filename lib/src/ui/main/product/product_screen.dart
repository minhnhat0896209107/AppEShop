import 'package:base_code/src/blocs/product_screen_bloc.dart';
import 'package:base_code/src/commons/widgets/loading_widget.dart';
import 'package:base_code/src/models/product/product.dart';
import 'package:base_code/src/struct/app_color.dart';
import 'package:base_code/src/ui/main/home_screen/widgets/product_item.dart';
import 'package:base_code/src/utils/app_boxshadow.dart';
import 'package:base_code/src/utils/app_image.dart';
import 'package:base_code/src/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late ProductScreenBloC _bloC;
  @override
  Widget build(BuildContext context) {
    return Provider<ProductScreenBloC>(
        create: (_) => ProductScreenBloC(),
        dispose: (_, bloc) => bloc.dispose(),
        builder: (context, _) {
          _bloC = context.read<ProductScreenBloC>();
          _bloC.getListProducts();
          return Container(
            color: AppColors.pinkLight,
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 100, bottom: 50),
                    child: _searchBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _categoryItem(AppStrings.allCategories),
                    _categoryItem(AppStrings.priceAscending)
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        child:
                            _categoryItem(AppStrings.latest, hasLogo: false)),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: 1,
                      height: 15,
                      color: AppColors.primay,
                    ),
                    Flexible(
                        child: _categoryItem(AppStrings.bestSeller,
                            hasLogo: false))
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                _productGridView(),
                const SizedBox(
                  height: 30,
                ),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            AppImages.share,
                            width: 24,
                          ),
                          const SizedBox(
                            width: 11,
                          ),
                          const Text(AppStrings.nextPage)
                        ],
                      ),
                    )),
                const SizedBox(
                  height: 100,
                ),
              ]),
            ),
          );
        });
  }

  Widget _searchBox() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), boxShadow: boxShadows),
      child: TextField(
        onChanged: (value) {
          _bloC.searchSink.add(value);
        },
        style: const TextStyle(color: AppColors.secondary),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          fillColor: Colors.white,
          hintText: AppStrings.searchSomething,
          suffixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              AppImages.search,
              width: 40,
            ),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _categoryItem(String title, {bool hasLogo = true}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title),
        const SizedBox(
          width: 5,
        ),
        if (hasLogo)
          Image.asset(
            AppImages.dropdown,
            width: 12,
          )
      ],
    );
  }

  Widget _productGridView() {
    return StreamBuilder<List<Product>?>(
        stream: _bloC.productStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Product>? products = snapshot.data;
            print("Length1 == ${products?[0].images!.first.url}");
            print("Length2 == ${products?[1].images!.first.url}");
            print("Length3 == ${products?[2].images!.first.url}");
            if (products == null) {
              return const SizedBox(
                height: 500,
                child: CircularProgressIndicator(color: AppColors.pinkLight),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 170 / 280,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemBuilder: (context, index) {
                    return ProductItem(
                      url:  products[index].images!.first.url!,
                      product: products[index],
                    );
                  }),
            );
          }
          return loadingWidget;
        });
  }
}
