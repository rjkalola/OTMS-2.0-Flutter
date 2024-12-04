import '../../../web_services/response/module_info.dart';

abstract class SelectMultiItemListener {
  void onSelectMultiItem(List<ModuleInfo> tempList, String action);
}
