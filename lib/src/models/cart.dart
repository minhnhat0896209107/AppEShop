
import 'package:base_code/src/models/product/product.dart';

class Cart{
  String? idProduct;
  int? quantity;
  int? numberQuantityBuy;
  String? size;
  int? productSizeId;
  Product? product;

  Cart({
    this.idProduct,
    this.quantity,
    this.numberQuantityBuy,
    this.size,
    this.productSizeId,
    this.product
  });
}