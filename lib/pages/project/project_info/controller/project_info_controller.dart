import 'package:get/get.dart';
import 'package:otm_inventory/pages/project/project_info/controller/project_info_repository.dart';

class ProjectInfoController extends GetxController {
  final _api = ProjectInfoRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isResetEnable = false.obs;
  String startDate = "", endDate = "";
  final RxInt selectedDateFilterIndex = (0).obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      // teamInfo = arguments[AppConstants.intentKey.teamInfo];
    }
    // setInitData();
    // loadResources(true);
  }

  void loadData(bool isProgress) {
    // isLoading.value = isProgress;
    // CompanyResources.getResourcesApi(
    //     flag: AppConstants.companyResourcesFlag.shiftList, listener: this);
  }

  void setInitData() {
    // title.value = 'add_project'.tr;
    /*if (teamInfo != null) {
      title.value = 'Edit Team'.tr;
      teamNameController.value.text = teamInfo?.name ?? "";
      supervisorController.value.text = teamInfo?.supervisorName ?? "";
      supervisorId = teamInfo?.supervisorId ?? 0;
      teamMembersList.addAll(teamInfo?.teamMembers ?? []);
    } else {
      title.value = 'create_new_team'.tr;
      isSaveEnable.value = true;
    }*/
  }

  void clearFilter() {
    isResetEnable.value = false;
    startDate = "";
    endDate = "";
    selectedDateFilterIndex.value = -1;
    loadData(true);
  }
}
