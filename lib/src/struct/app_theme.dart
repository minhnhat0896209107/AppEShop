import 'package:flutter/material.dart';
import 'package:base_code/src/struct/app_color.dart';

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch()
      .copyWith(primary: AppColors.primay, secondary: AppColors.primay),
  scaffoldBackgroundColor: Colors.white,
  platform: TargetPlatform.iOS,
  textTheme: const TextTheme(
    // used for highlight text
    bodyText1: TextStyle(
      color: AppColors.textColor,
      fontWeight: FontWeight.w600,
      fontSize: 14.0,
    ),
    // used for normal text
    bodyText2: TextStyle(
      color: AppColors.textColor,
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    ),
    headline1: TextStyle(
      color: AppColors.textColor,
      fontWeight: FontWeight.w700,
      fontSize: 48,
    ),
    headline2: TextStyle(
      color: AppColors.textColor,
      fontWeight: FontWeight.w700,
      fontSize: 32,
    ),
    headline3: TextStyle(
      color: AppColors.textColor,
      fontWeight: FontWeight.w700,
      fontSize: 32,
    ),
    headline4: TextStyle(
      color: AppColors.textColor,
      fontWeight: FontWeight.w700,
      fontSize: 28,
    ),
    headline5: TextStyle(
      color: AppColors.textColor,
      fontWeight: FontWeight.w700,
      fontSize: 24,
    ),
  ),

  // bottomSheetTheme: const BottomSheetThemeData(
  //   backgroundColor: Colors.white,
  //   shape: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.only(
  //       topLeft: Radius.circular(24),
  //       topRight: Radius.circular(24),
  //     ),
  //   ),
  // ),
  // appBarTheme: const AppBarTheme(
  //   color: Colors.white,
  //   centerTitle: true,
  //   elevation: 0,
  //   titleTextStyle: TextStyle(
  //     color: AppColors.textColor,
  //     fontWeight: FontWeight.w600,
  //     fontSize: 16.0,
  //   ),
  //   iconTheme: IconThemeData(
  //     color: AppColors.textColor,
  //     size: 24.0,
  //   ),
  // ),
);
