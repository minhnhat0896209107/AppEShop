import 'package:base_code/src/struct/api_services/auth_url.dart';
import 'package:base_code/src/struct/api_services/base_repository.dart';

class AuthRepository extends BaseRepository {
  Future<String> login(
      {required String email, required String password}) async {
    Map<String, String> body = {'email': email, 'password': password};
    var respond = await postMethod(AuthUrl.login, body: body);
    if (respond['success']) {
      return respond['data']['token'];
    } else {
      throw Exception(respond['message']);
    }
  }

  Future<String> signinWithGoogle({required String googleToken}) async {
    Map<String, String> body = {'googleToken': googleToken};
    var respond = await postMethod(AuthUrl.signinWithGoogle, body: body);
    if (respond['success']) {
      return respond['data']['token'];
    } else {
      throw Exception(respond['message']);
    }
  }
}
