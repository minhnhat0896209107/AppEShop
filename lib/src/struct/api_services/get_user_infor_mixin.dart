import 'package:flutter/material.dart';
import 'package:base_code/src/manager/user_manager.dart';
import 'package:base_code/src/models/user.dart';
import 'package:base_code/src/struct/api_services/base_repository.dart';
import 'package:base_code/src/struct/api_services/user_url.dart';

// this Mixin will be used on both Spash screen and Login screen
mixin UserMixin {
  final BaseRepository _baseRepository = BaseRepository();

  Future<User?> getUserInfor() async {
    // get token from local storage
    String? token = await UserManager.getAccessToken();
    if (token != null) {
      UserManager.updateGlobalToken(token);
      try {
        var respond = await _baseRepository.getMethod(UserUrl.userInfor);
        if (respond['success']) {
          return User.fromJson(respond['data']);
        }
      } catch (error) {
        debugPrint(error.toString());
      }
    }
    return null;
  }
}
