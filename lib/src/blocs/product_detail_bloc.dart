import 'dart:convert';

import 'package:base_code/src/blocs/base_bloc.dart';
import 'package:base_code/src/models/product/product.dart';
import 'package:base_code/src/repositories/product_repo.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/toast_utils.dart';

class ProductDetailBloC extends BaseBloC {
  final ProductRepository _productRepository = ProductRepository();
  final BehaviorSubject<Product> _productController =
      BehaviorSubject<Product>();
  Stream<Product> get productStream => _productController.stream;
  void init({required Product product}) {
    _productController.add(product);
  }

  void getProductDetail({required String slug}) async {
    try {
      print("AAAAAaslug == ${slug}");

      Product product = await _productRepository.getProductDetail(slug: slug);
      _productController.add(product);
      print("AAAAAa == ${product.id}");
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void addToCart(Product product) async {
    ToastUtils.showToast('Add to Cart success');

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? jsonProducts = pref.getString('listCart');
    jsonProducts ??= '[]';
    List listMapProduct = (json.decode(jsonProducts));
    listMapProduct.add(product.toJson());
    pref.setString('listCart', json.encode(listMapProduct));
  }

  @override
  void dispose() {}
}
