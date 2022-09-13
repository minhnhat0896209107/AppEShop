import 'package:flutter/material.dart';
import 'package:base_code/src/manager/user_manager.dart';
import 'package:base_code/src/models/user.dart';
import 'package:base_code/src/utils/app_strings.dart';
import 'package:provider/provider.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    final User? currentUser = context.read<UserManager>().userStream.value;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('${currentUser?.email}'),
            Text('${currentUser?.roles.toString()}'),
            Text('${currentUser?.loginType.toString()}'),
            TextButton(
                onPressed: () {
                  context.read<UserManager>().clearUser();
                },
                child: const Text(AppStrings.logout))
          ],
        ),
      ),
    );
  }
}
