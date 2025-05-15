import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step3_select_tools/controller/select_tools_repository.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

class SelectToolsController extends GetxController {
  final _api = SelectToolsRepository();
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  final listItems = <ModuleInfo>[].obs;
  final selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    listItems.value = getItemsList();
  }

  List<ModuleInfo> getItemsList() {
    var list = <ModuleInfo>[];
    ModuleInfo? info;

    info = ModuleInfo();
    info.name = "Time Clock";
    list.add(info);

    info = ModuleInfo();
    info.name = "TimeSheets";
    list.add(info);

    info = ModuleInfo();
    info.name = "Tasks";
    list.add(info);

    info = ModuleInfo();
    info.name = "Projects";
    list.add(info);

    return list;
  }

// bool valid(bool isAutoLogin) {
//   if (!isAutoLogin) {
//     return formKey.currentState!.validate();
//   } else {
//     return true;
//   }
// }
}
