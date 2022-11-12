
import 'package:base_code/src/blocs/base_bloc.dart';
import 'package:base_code/src/models/order_momo/order_momo.dart';
import 'package:base_code/src/repositories/order_momo_repo.dart';
import 'package:rxdart/rxdart.dart';

class OrderMomoBloc extends BaseBloC{

  final BehaviorSubject<List<OrderMomo>> _orderMomoController = BehaviorSubject<List<OrderMomo>>();
  Stream<List<OrderMomo>> get orderMomoStream => _orderMomoController.stream;
  final OrderMomoRepository _orderMomoRepository = OrderMomoRepository();

  void getListOrderMomo() async{
    List<OrderMomo> listOrder = await _orderMomoRepository.getListProduct();
    _orderMomoController.add(listOrder);
  }
 
  @override
  void dispose() {
    _orderMomoController.close();
    // TODO: implement dispose
  }

}