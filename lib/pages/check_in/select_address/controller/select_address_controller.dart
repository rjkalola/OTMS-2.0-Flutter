import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/select_address/controller/select_address_repository.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/pages/common/select_Item_list_dialog.dart';
import 'package:otm_inventory/pages/manageattachment/listener/select_attachment_listener.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

class SelectAddressController extends GetxController
    implements SelectItemListener {
  // final companyNameController = TextEditingController().obs;
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isClearVisible = false.obs;
  final _api = SelectAddressRepository();
  final searchController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      // fromSignUp.value =
      //     arguments[AppConstants.intentKey.fromSignUpScreen] ?? "";
    }
    // getRegisterResources();
  }

// void getRegisterResources() {
//   isLoading.value = true;
//   SignUp1Repository().getRegisterResources(
//     onSuccess: (ResponseModel responseModel) {
//       if (responseModel.statusCode == 200) {
//         // fetchLocationAndAddress();
//         LocationServiceNew().checkLocationService();
//         setRegisterResourcesResponse(RegisterResourcesResponse.fromJson(
//             jsonDecode(responseModel.result!)));
//         list.addAll(registerResourcesResponse.value.currency ?? []);
//         if (mExtensionId.value != 0 &&
//             !StringHelper.isEmptyList(
//                 registerResourcesResponse.value.countries)) {
//           for (var info in registerResourcesResponse.value.countries!) {
//             if (info.id! == mExtensionId.value) {
//               mFlag.value = info.flagImage!;
//               break;
//             }
//           }
//         }
//       } else {
//         AppUtils.showSnackBarMessage(responseModel.statusMessage!);
//       }
//       isLoading.value = false;
//     },
//     onError: (ResponseModel error) {
//       isLoading.value = false;
//       if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
//         isInternetNotAvailable.value = true;
//         // Utils.showSnackBarMessage('no_internet'.tr);
//       } else if (error.statusMessage!.isNotEmpty) {
//         AppUtils.showSnackBarMessage(error.statusMessage!);
//       }
//     },
//   );
// }

  Future<void> searchItem(String value) async {
    // List<StoreInfo> results = [];
    // if (value.isEmpty) {
    //   results = tempList;
    // } else {
    //   results = tempList
    //       .where((element) =>
    //       element.storeName!.toLowerCase().contains(value.toLowerCase()))
    //       .toList();
    // }
    // storeList.value = results;
  }

  showSortByDialog() async {
    var listOptions = <ModuleInfo>[].obs;
    ModuleInfo? info;

    info = ModuleInfo();
    info.name = "A-Z";
    info.action = AppConstants.action.aToZ;
    listOptions.add(info);

    info = ModuleInfo();
    info.name = "Z-A";
    info.action = AppConstants.action.zToA;
    listOptions.add(info);

    info = ModuleInfo();
    info.name = 'status'.tr;
    info.action = AppConstants.action.status;
    listOptions.add(info);

    showOptionsDialog(
        AppConstants.dialogIdentifier.sortByDialog, 'sort_by_'.tr, listOptions);
  }

  showFilterByDialog() async {
    var listOptions = <ModuleInfo>[].obs;
    ModuleInfo? info;

    info = ModuleInfo();
    info.name = 'ready_to_start_work'.tr;
    info.action = AppConstants.action.readyToStartWork;
    listOptions.add(info);

    info = ModuleInfo();
    info.name = 'in_progress'.tr;
    info.action = AppConstants.action.inProgress;
    listOptions.add(info);

    info = ModuleInfo();
    info.name = 'completed'.tr;
    info.action = AppConstants.action.completed;
    listOptions.add(info);

    showOptionsDialog(
        AppConstants.dialogIdentifier.filterByDialog, 'filter_by_'.tr, listOptions);
  }

  void showOptionsDialog(
      String dialogType, String title, List<ModuleInfo> list) {
    Get.bottomSheet(
        SelectItemListDialog(
            title: title, dialogType: "", list: list, listener: this),
        backgroundColor: Colors.transparent,
        enableDrag: false,
        isScrollControlled: false);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.selectProject) {
    } else if (action == AppConstants.dialogIdentifier.selectShift) {}
  }
}
