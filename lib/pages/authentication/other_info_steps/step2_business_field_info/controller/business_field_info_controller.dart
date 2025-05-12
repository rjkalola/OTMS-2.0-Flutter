import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step1_team_users_count_info/controller/team_users_count_info_repository.dart';
import 'package:otm_inventory/pages/authentication/other_info_steps/step2_business_field_info/controller/business_field_info_repository.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

class BusinessFieldInfoController extends GetxController {
  final _api = BusinessFieldInfoRepository();
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  final listItems = <ModuleInfo>[].obs;
  final selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    listItems.value = getItemsList();
  }

  onClickContinueButton(){
    Get.toNamed(AppRoutes.selectToolScreen);
  }

  List<ModuleInfo> getItemsList() {
    var list = <ModuleInfo>[];
    ModuleInfo? info;

    info = ModuleInfo();
    info.name = "Construction";
    list.add(info);

    info = ModuleInfo();
    info.name = "Heathcare & Wellness";
    list.add(info);

    info = ModuleInfo();
    info.name = "Food Services";
    list.add(info);

    info = ModuleInfo();
    info.name = "Shops & Retail";
    list.add(info);

    info = ModuleInfo();
    info.name = "Cleaning & Sanitation";
    list.add(info);

    info = ModuleInfo();
    info.name = "Production & Logistics";
    list.add(info);

    info = ModuleInfo();
    info.name = "Security & Patrol";
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
