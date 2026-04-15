import 'package:belcka/pages/profile/health_and_safety/health_and_safety_service/health_and_safety_service.dart';
import 'package:belcka/pages/profile/health_and_safety/health_and_safety_service/hs_resource_types_info.dart';
import 'package:belcka/pages/profile/health_and_safety/hs_resource_types/hs_management_type.dart';
import 'package:get/get.dart';

class HsResourceTypesListController extends GetxController{
  bool isDataUpdated = false;
  final healthAndSafetyService = Get.find<HealthAndSafetyService>();
  HSManagementType? selectedManagementType;
  RxString selectedTypeTitle = "".obs;
  final managementTypeList = <HSResourceTypesInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      selectedManagementType = arguments["selectedManagementType"] ?? HSManagementType;
    }
    selectedTypeTitle.value = selectedManagementType?.title ?? "";

    if (selectedManagementType == HSManagementType.hazards){
      managementTypeList.value = healthAndSafetyService.hazards;
    }
    else if (selectedManagementType == HSManagementType.incidentTypes){
      managementTypeList.value = healthAndSafetyService.incidentTypes;
    }
    else{
      managementTypeList.value = healthAndSafetyService.threatLevels;
    }
  }

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {

    }
  }

  void onBackPress() {
    Get.back(result: isDataUpdated);
  }
}