import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:base_code/src/blocs/auth_bloc.dart';
import 'package:base_code/src/manager/user_manager.dart';
import 'package:base_code/src/ui/auth/login_screen.dart';
import 'package:provider/provider.dart';

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProxyProvider<UserManager, AuthBloc>(
      update: (context, userManager, previous) =>
          previous ?? AuthBloc(userManager, defaultTargetPlatform),
      child: const LoginScreen(),
    );
  }
}
