import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/clock_in/controller/clock_in_repository.dart';
import 'package:otm_inventory/pages/check_in/clock_in/view/widgets/select_project_dialog.dart';
import 'package:otm_inventory/pages/check_in/clock_in/view/widgets/select_shift_dialog.dart';
import 'package:otm_inventory/pages/check_in/select_address/controller/select_address_repository.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/utils/app_constants.dart';
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

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.selectProject) {
    } else if (action == AppConstants.dialogIdentifier.selectShift) {}
  }


}
