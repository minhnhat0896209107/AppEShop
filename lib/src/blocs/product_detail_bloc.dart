import 'package:base_code/src/blocs/base_bloc.dart';
import 'package:base_code/src/models/product.dart';
import 'package:base_code/src/repositories/product_repo.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class ProductDetailBloC extends BaseBloC {
  final ProductRepository _productRepository = ProductRepository();
  final BehaviorSubject<Product> _productController =
      BehaviorSubject<Product>();
  Stream<Product> get productStream => _productController.stream;
  void init({required Product product}) {
    _productController.add(product);
  }

  void getProductDetail({required String id}) async {
    try {
      Product product = await _productRepository.getProductDetail(id: id);
      _productController.add(product);
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  @override
  void dispose() {}
}
