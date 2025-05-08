import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step1_team_users_count_info/controller/team_users_count_info_repository.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

class TeamUsersCountInfoController extends GetxController {
  final _api = TeamUsersCountInfoRepository();
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
    info.name = "1-10";
    list.add(info);

    info = ModuleInfo();
    info.name = "11-30";
    list.add(info);

    info = ModuleInfo();
    info.name = "31-50";
    list.add(info);

    info = ModuleInfo();
    info.name = "51-100";
    list.add(info);

    info = ModuleInfo();
    info.name = "101-200";
    list.add(info);

    info = ModuleInfo();
    info.name = "200+";
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
