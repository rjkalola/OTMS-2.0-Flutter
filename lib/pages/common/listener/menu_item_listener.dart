import 'package:belcka/web_services/response/module_info.dart';

abstract class MenuItemListener {
  void onSelectMenuItem(ModuleInfo info,String dialogType);
}
