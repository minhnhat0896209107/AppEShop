import 'package:base_code/src/struct/api_services/auth_url.dart';
import 'package:base_code/src/struct/api_services/base_api.dart';

class AuthRepository {
  final BaseApi _baseApi = BaseApi();
  Future<String> login(
      {required String email, required String password}) async {
    Map<String, String> body = {'email': email, 'password': password};
    var respond = await _baseApi.postMethod(AuthUrl.login, body: body);
    if (respond['success']) {
      return respond['data']['token'];
    } else {
      throw Exception(respond['message']);
    }
  }
}
