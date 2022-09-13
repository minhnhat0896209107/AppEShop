import 'package:base_code/src/utils/enums/login_type.dart';

extension LoginTypeExtension on String {
  LoginType loginTypeFromString() {
    switch (this) {
      case 'normal':
        return LoginType.normal;
      case 'google':
        return LoginType.google;
      case 'facebook':
        return LoginType.facebook;
      default:
        return LoginType.normal;
    }
  }
}
