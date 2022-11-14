import 'package:base_code/src/commons/widgets/loading_widget.dart';
import 'package:base_code/src/ui/main/order/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../blocs/order_momo_bloc.dart';
import '../../../models/order_momo/order_momo.dart';
import '../../../struct/app_color.dart';
import '../../../utils/app_image.dart';
import '../../../utils/app_strings.dart';
import 'package:base_code/src/utils/integer_extension.dart';
import 'package:base_code/src/utils/datetime_extension.dart';

class OrderMomoScreen extends StatefulWidget {
  const OrderMomoScreen({Key? key}) : super(key: key);

  @override
  State<OrderMomoScreen> createState() => _OrderMomoScreenState();
}

class _OrderMomoScreenState extends State<OrderMomoScreen> {
  late OrderMomoBloc _orderMomoBloc = OrderMomoBloc();
  @override
  Widget build(BuildContext context) {
    return Provider<OrderMomoBloc>(
      create: (context) => OrderMomoBloc(),
      dispose: (context, bloc) => bloc.dispose(),
      builder: (context, child) {
        _orderMomoBloc = context.read<OrderMomoBloc>();
        _orderMomoBloc.getListOrderMomo();
        return StreamBuilder<List<OrderMomo>>(
            stream: _orderMomoBloc.orderMomoStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<OrderMomo> orderMomos = snapshot.data!;
                print("Lenght ordermomo == ${orderMomos.length}");
                if (orderMomos.isEmpty) {
                  return Image.asset(
                    AppImages.cartEmpty,
                    width: 300,
                    height: 300,
                  );
                }
                return Container(
                  decoration: const BoxDecoration(color: AppColors.pinkLight),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 100,
                        child: const Text(
                          AppStrings.order,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                OrderMomo orderMomo = orderMomos[index];
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OrderScreen(
                                              id: orderMomo.id,
                                            ),
                                          ));
                                    },
                                    child: _itemOrder(orderMomo));
                              },
                              separatorBuilder: (context, index) => Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    height: 2,
                                    color: Colors.black,
                                  ),
                              itemCount: orderMomos.length))
                    ],
                  ),
                );
              } else
                return loadingWidget;
            });
      },
    );
  }

  Widget _itemOrder(OrderMomo orderMomo) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${orderMomo.orderItems?[0].productSize?.product?.name}" ??
                        '--',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Text(
                    int.parse(orderMomo.total!).formatMoney,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  orderMomo.createdAt!.dateTimeToDDMMYYYY,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  orderMomo.status ?? "--",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
