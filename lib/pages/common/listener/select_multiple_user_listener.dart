import 'package:otm_inventory/pages/common/model/user_info.dart';

abstract class SelectMultipleUserListener {
  void onSelectMultipleUser(String dialogIdentifier, List<UserInfo> listUsers);
}
