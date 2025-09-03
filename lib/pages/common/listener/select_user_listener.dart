import 'package:belcka/pages/common/model/user_info.dart';

abstract class SelectUserListener {
  void onSelectMultipleUser(String dialogIdentifier, List<UserInfo> listUsers);
  void onSelectUser(String dialogIdentifier, UserInfo userInfo);
}
