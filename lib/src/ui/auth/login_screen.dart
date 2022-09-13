import 'package:flutter/material.dart';
import 'package:base_code/src/blocs/auth_bloc.dart';
import 'package:base_code/src/utils/app_strings.dart';
import 'package:base_code/src/utils/helpers.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

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
                  await context
                      .read<AuthBloc>()
                      .login(emailController.text, passwordController.text);
                  Navigator.pop(context);
                } catch (error) {
                  debugPrint(error.toString());
                  Navigator.pop(context);
                  showErrorDialog(context, error);
                }
              },
              child: const Text(AppStrings.login)),
          // FutureBuilder<Object>(
          //     future: Firebase.initializeApp(
          //       options: DefaultFirebaseOptions.currentPlatform,
          //     ),
          //     builder: (context, snapshot) {
          //       if (!snapshot.hasData) {
          //         return Container();
          //       }
          //       return const Text('Loading');
          //     }),
          TextButton(
              onPressed: () async {
                try {
                  showLoading(context, message: AppStrings.logingIn);
                  await context.read<AuthBloc>().signInWithGoogle();
                  Navigator.pop(context);
                } catch (error) {
                  debugPrint(error.toString());
                  Navigator.pop(context);
                  showErrorDialog(context, error);
                }
              },
              child: const Text(AppStrings.signinWithGoogle))
        ]),
      ),
    );
  }
}
