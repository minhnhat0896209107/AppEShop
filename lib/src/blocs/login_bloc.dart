import 'package:base_code/src/blocs/base_bloc.dart';
import 'package:base_code/src/manager/user_manager.dart';
import 'package:base_code/src/models/user.dart';
import 'package:base_code/src/repositories/user_repo.dart';

class LoginBloC extends BaseBloC {
  late final UserManager _userManager;
  late final UserRepository _userRepository = UserRepository();
  LoginBloC(this._userManager);
  void checkAuthStatus() async {
    String? token = await UserManager.getAccessToken();
    if (token != null) {
      await _userManager.storeAccessToken(token);
      User? user = await _userRepository.getUserInfor();
      if (user != null) {
        _userManager.updateUser(user);
      }
    }
  }

  @override
  void dispose() {}
}
