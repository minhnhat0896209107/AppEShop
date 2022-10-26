import 'package:base_code/src/struct/app_color.dart';
import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({required this.imageUrl, required this.title, Key? key})
      : super(key: key);
  final String imageUrl;
  final String title;
  @override
  Widget build(BuildContext context) {
    const Color buttonColor = AppColors.pinkDark;

    return OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
            side: const BorderSide(color: buttonColor),
            shape: const StadiumBorder(),
            primary: buttonColor),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Image.asset(
                imageUrl,
                width: 24,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(title)
            ],
          ),
        ));
  }
}
