import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/clock_in/controller/clock_in_repository.dart';
import 'package:otm_inventory/pages/check_in/clock_in/view/widgets/select_project_dialog.dart';
import 'package:otm_inventory/pages/check_in/clock_in/view/widgets/select_shift_dialog.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

class ClockInController extends GetxController implements SelectItemListener {
  // final companyNameController = TextEditingController().obs;
  final RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  final _api = ClockInRepository();

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

// void joinCompany(String code, String tradeId, String companyId) async {
//   isLoading.value = true;
//   Map<String, dynamic> map = {};
//   map["trade_id"] = tradeId ?? "";
//   map["code"] = code ?? "";
//   map["company_id"] = companyId ?? "";
//
//   multi.FormData formData = multi.FormData.fromMap(map);
//   // isLoading.value = true;
//   _api.joinCompany(
//     formData: formData,
//     onSuccess: (ResponseModel responseModel) {
//       if (responseModel.statusCode == 200) {
//         JoinCompanyResponse response =
//             JoinCompanyResponse.fromJson(jsonDecode(responseModel.result!));
//         if (response.isSuccess!) {
//           if (response.Data != null) {
//             UserInfo? user = AppStorage().getUserInfo();
//             if (user != null &&
//                 !StringHelper.isEmptyString(
//                     response.Data?.companyName ?? "")) {
//               AppUtils.showToastMessage(
//                   "Now, you are a member of ${response.Data?.companyName ?? ""}");
//             }
//           }
//           moveToDashboard();
//         } else {
//           showSnackBar(response.message!);
//         }
//       } else {
//         showSnackBar(responseModel.statusMessage!);
//       }
//       isLoading.value = false;
//     },
//     onError: (ResponseModel error) {
//       isLoading.value = false;
//       if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
//         showSnackBar('no_internet'.tr);
//       } else if (error.statusMessage!.isNotEmpty) {
//         showSnackBar(error.statusMessage!);
//       }
//     },
//   );
// }

  void showSelectProjectDialog() {
    final List<ModuleInfo> list = <ModuleInfo>[];
    list.add(ModuleInfo());
    list.add(ModuleInfo());
    list.add(ModuleInfo());
    list.add(ModuleInfo());

    Get.bottomSheet(
        SelectProjectDialog(
          dialogType: AppConstants.dialogIdentifier.selectProject,
          list: list,
          listener: this,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  void showSelectShiftDialog() {
    final List<ModuleInfo> list = <ModuleInfo>[];
    list.add(ModuleInfo());
    list.add(ModuleInfo());
    list.add(ModuleInfo());
    list.add(ModuleInfo());

    Get.bottomSheet(
        SelectShiftDialog(
          dialogType: AppConstants.dialogIdentifier.selectShift,
          list: list,
          listener: this,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.selectProject) {
    } else if (action == AppConstants.dialogIdentifier.selectShift) {}
  }
}
