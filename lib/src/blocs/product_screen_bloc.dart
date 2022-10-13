import 'package:base_code/src/blocs/base_bloc.dart';
import 'package:base_code/src/models/product.dart';
import 'package:base_code/src/repositories/product_repo.dart';
import 'package:rxdart/subjects.dart';

class ProductScreenBloC extends BaseBloC {
  final BehaviorSubject<List<Product>> _productController =
      BehaviorSubject<List<Product>>();
  Stream<List<Product>> get productStream => _productController.stream;
  final ProductRepository _productRepository = ProductRepository();
  void getListProducts() async {
    List<Product> products = await _productRepository.getListProduct();
    _productController.add(products);
  }

  @override
  void dispose() {
    _productController.close();
  }
}
