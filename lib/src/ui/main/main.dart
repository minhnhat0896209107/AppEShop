import 'package:base_code/src/manager/user_manager.dart';
import 'package:base_code/src/ui/main/cart/cart_screen.dart';
import 'package:base_code/src/ui/main/common/app_bar.dart';
import 'package:base_code/src/ui/main/home_screen/home_screen.dart';
import 'package:base_code/src/ui/main/order/order_screen.dart';
import 'package:base_code/src/ui/main/order_momo/order_momo_screen.dart';
import 'package:base_code/src/ui/main/product/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:base_code/src/utils/app_strings.dart';
import 'package:provider/provider.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int selectedIndex = 0;
  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProductScreen(),
    const CartScreen(),
    const OrderMomoScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _drawer(),
      appBar: customAppbar,
      body: _screens[selectedIndex],
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Text(AppStrings.menu),
          ),
          ListTile(
            title: const Text(AppStrings.home),
            onTap: () {
              changeIndex(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(AppStrings.product),
            onTap: () {
              changeIndex(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(AppStrings.cart),
            onTap: () {
              changeIndex(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(AppStrings.order),
            onTap: () {
              changeIndex(3);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(AppStrings.logout),
            onTap: () {
              context.read<UserManager>().clearUser();
            },
          ),
        ],
      ),
    );
  }
}
