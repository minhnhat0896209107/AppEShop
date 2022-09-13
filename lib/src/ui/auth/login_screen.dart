import 'package:base_code/src/manager/user_manager.dart';
import 'package:base_code/src/models/user.dart';
import 'package:base_code/src/repositories/auth_repo.dart';
import 'package:base_code/src/struct/api_services/get_user_infor_mixin.dart';
import 'package:flutter/material.dart';
import 'package:base_code/src/utils/app_strings.dart';
import 'package:base_code/src/utils/helpers.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with UserMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();
  late final UserManager _userManager = context.read<UserManager>();

  Future storeUserandAddUser(String token) async {
    await _userManager.storeAccessToken(token);
    User? user = await getUserInfor();
    _userManager.updateUser(user);
  }

  Future login(String email, String pass) async {
    String token = await _authRepository.login(email: email, password: pass);
    storeUserandAddUser(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextFormField(
            controller: emailController,
          ),
          TextFormField(
            controller: passwordController,
          ),
          TextButton(
              onPressed: () async {
                try {
                  showLoading(context, message: AppStrings.logingIn);
                  await login(emailController.text, passwordController.text);
                  Navigator.pop(context);
                } catch (error) {
                  debugPrint(error.toString());
                  Navigator.pop(context);
                  showErrorDialog(context, error);
                }
              },
              child: const Text(AppStrings.login)),
        ]),
      ),
    );
  }
}
