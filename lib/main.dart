import 'package:flutter/material.dart';
import 'package:base_code/src/app.dart';
import 'package:base_code/src/manager/user_manager.dart';
import 'package:base_code/src/struct/app_theme.dart';
import 'package:base_code/src/utils/app_strings.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: appTheme,
      home: Provider<UserManager>(
        create: (_) => UserManager(),
        dispose: (_, userManager) => userManager.dispose(),
        child: const AppRoot(),
      ),
    );
  }
}
