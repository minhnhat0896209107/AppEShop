import 'package:base_code/src/extension/login_type_ex.dart';
import 'package:base_code/src/extension/roles_ex.dart';
import 'package:base_code/src/utils/enums/login_type.dart';
import 'package:base_code/src/utils/enums/roles.dart';

class User {
  User();
  String id = '';
  // List<Role> rolesId = [];
  Role roles = Role.consumer;

  String firstName = '';
  String lastName = '';
  String email = '';
  String avatar = '';
  LoginType loginType = LoginType.normal;
  bool isActive = false;
  double accountBalance = 0;
  String address = '';
  String currentLocation = '';
  factory User.fromJson(Map<String, dynamic> json) {
    User user = User()
      ..id = json['_id'] ?? ''
      ..roles = json['roleId']['roleName'].toString().roleFromString() ??
          Role.consumer
      ..firstName = json['firstName'] ?? ''
      ..lastName = json['lastName'] ?? ''
      ..email = json['email'] ?? ''
      ..avatar = json['avatar'] ?? ''
      ..loginType = json['loginType'].toString().loginTypeFromString()
      ..isActive = json['isActive'] ?? false
      ..accountBalance = double.parse((json['accountBalance'] ?? 0).toString())
      ..address = json['address'] ?? ''
      ..currentLocation = json['currentLocation'] ?? '';
    return user;
  }

  Map<String, dynamic> toBaseJson() {
    throw Exception('This function is not ready');
  }

  bool isEnoughBaseInformation() {
    throw Exception('This function is not ready');
  }
}
