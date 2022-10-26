import 'package:base_code/src/struct/app_color.dart';
import 'package:flutter/material.dart';

class QuantityButton extends StatelessWidget {
  const QuantityButton({this.value = 1, Key? key}) : super(key: key);
  final int value;
  @override
  Widget build(BuildContext context) {
    const Color buttonColor = AppColors.primay;
    return OutlinedButton(
      onPressed: () {},
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Text('-'),
            iconSize: 10,
            splashRadius: 12,
          ),
          Text('$value'),
          IconButton(
            onPressed: () {},
            icon: const Text('+'),
            iconSize: 10,
            splashRadius: 12,
          ),
        ],
      ),
      style: OutlinedButton.styleFrom(
          side: const BorderSide(color: buttonColor),
          shape: const StadiumBorder(),
          primary: buttonColor),
    );
  }
}
