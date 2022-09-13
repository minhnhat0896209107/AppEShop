import 'package:base_code/src/utils/enums/roles.dart';

extension RoleExtension on String {
  Role? roleFromString() {
    switch (this) {
      case 'consumer':
        return Role.consumer;
      case 'partner':
        return Role.partner;
      case 'dealer':
        return Role.dealer;
      default:
        return null;
    }
  }
}
