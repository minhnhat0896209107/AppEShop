import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:base_code/src/manager/user_manager.dart';
import 'package:base_code/src/models/user.dart';
import 'package:base_code/src/repositories/auth_repo.dart';
import 'package:base_code/src/struct/api_services/get_user_infor_mixin.dart';
import 'package:base_code/src/struct/base_bloc.dart';
import 'package:base_code/src/struct/const_string.dart';

class AuthBloc extends BloC with UserMixin {
  AuthBloc(UserManager userManager, TargetPlatform defaultTargetPlatform) {
    _userManager = userManager;
    List<String> scopes =
        defaultTargetPlatform == TargetPlatform.iOS ? iOSScopes : androidScopes;
    String? clientId =
        defaultTargetPlatform == TargetPlatform.iOS ? iOSClienId : null;
    _googleSignIn = GoogleSignIn(scopes: scopes, clientId: clientId);
  }
  late UserManager _userManager;
  late GoogleSignIn _googleSignIn;

  final AuthRepository _authRepository = AuthRepository();
  Future login(String email, String pass) async {
    String token = await _authRepository.login(email: email, password: pass);
    storeUserandAddUser(token);
  }

  Future signInWithGoogle() async {
    // Show Google sign in pop up
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

    if (googleSignInAccount != null) {
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      String? accessToken = googleSignInAuthentication.accessToken;
      if (accessToken != null) {
        // print(accessToken);
        String token =
            await _authRepository.signinWithGoogle(googleToken: accessToken);
        storeUserandAddUser(token);
      }
      _googleSignIn.signOut();
    }
  }

  Future storeUserandAddUser(String token) async {
    await _userManager.storeAccessToken(token);
    User? user = await getUserInfor();
    _userManager.updateUser(user);
  }

  @override
  void dispose() {}
}
