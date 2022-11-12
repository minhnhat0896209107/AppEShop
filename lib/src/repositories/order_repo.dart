
import 'dart:convert';

import 'package:base_code/src/models/deliver_infomation/deliver_information.dart';
import 'package:base_code/src/struct/api_services/order_url.dart';

import '../models/order.dart';
import '../models/product/product.dart';
import '../struct/api_services/base_api.dart';

class OrderRepository{
  final BaseApi _baseApi = BaseApi();

  Future<String> postOrder({required Order order}) async {

      var repsponse = await _baseApi.postMethod(OrderUrl.order, body: order);
      if(repsponse['success']){
        return repsponse['data']['payUrl'];
      }else {
        return '';
      }

  }
}