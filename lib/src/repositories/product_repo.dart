import 'package:base_code/src/api/global_api.dart';
import 'package:base_code/src/models/product/product.dart';
import 'package:base_code/src/struct/api_services/base_api.dart';
import 'package:base_code/src/struct/api_services/product_url.dart';

class ProductRepository {
  final BaseApi _baseApi = BaseApi();
  String querySearch = "";
  String checkLatest = "";
  String sortAssen = "";
  Future<List<Product>> getListProduct(

      {String search = '',
      bool isCheckLatest = false,
      int sortAssending = 0, int page = 1}) async {
      search != "" ? querySearch =  "category|\$eq|$search" :  querySearch = "";
      isCheckLatest ? checkLatest = "createdAt" : checkLatest = "";
      sortAssending == 0 ?sortAssen = "price" : sortAssen ="-price";
 

    var respond =
        await _baseApi.getMethod("${ProductUrl.listProduct}?page=$page&filter=$querySearch&sort=$sortAssen");
    globalApi.totalPageProduct = respond['data']['meta']['totalPages'];
    print("ISCHECH == ${respond['data']['meta']['totalPages']}");
    if (respond['success']) {

      return (respond['data']['items'] as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } else {
      throw 'Server Error';
    }
  }

  Future<List<Product>> getListProductSearch([String search = '']) async {
    Map<String, dynamic> params = {};
    if (search.isNotEmpty) {
      params.addAll({'search': search});
    }
    var respond =
        await _baseApi.getMethod(ProductUrl.listProduct, param: params);
    if (respond['success']) {
      return (respond['data']['items'] as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } else {
      throw 'Server Error';
    }
  }

  Future<Product> getProductDetail({required String slug}) async {
    String url = '${ProductUrl.getProductById}/$slug';

    var respond = await _baseApi.getMethod(url, param: {});
    if (respond['success']) {
      //TODO
      var data = (respond['data']);
      print("DDDDDDD ${data['discount']}");
      return Product.fromJson(data);
    } else {
      throw 'Server Error';
    }
  }
}
