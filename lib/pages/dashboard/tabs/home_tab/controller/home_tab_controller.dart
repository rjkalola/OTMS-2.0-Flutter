import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/controller/dashboard_controller.dart';
import 'package:otm_inventory/pages/dashboard/models/dashboard_response.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_repository.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/dashboard_grid_item_info.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/data_utils.dart';

class HomeTabController extends GetxController {
  final _api = HomeTabRepository();
  RxBool isInternetNotAvailable = false.obs, isMainViewVisible = true.obs;

  // RxString nextUpdateLocationTime = "".obs;

  final List<DashboardGridItemInfo> listGridItems =
      DataUtils.getDashboardGridItemsList().obs;
  final dashboardController = Get.put(DashboardController());
  final dashboardResponse = DashboardResponse().obs;

  @override
  void onInit() {
    super.onInit();
    // getRegisterResources();
  }

  void onActionButtonClick(String action) {
    if (action == AppConstants.action.clockIn) {
      Get.toNamed(AppRoutes.clockInScreen);
    } else if (action == AppConstants.action.store) {
      Get.offNamed(AppRoutes.storeListScreen);
    } else if (action == AppConstants.action.stocks) {
      Get.offNamed(AppRoutes.stockListScreen);
    } else if (action == AppConstants.action.suppliers) {
      Get.offNamed(AppRoutes.supplierListScreen);
    } else if (action == AppConstants.action.categories) {
      Get.offNamed(AppRoutes.categoryListScreen);
    }
  }

/* void getDashboardApi(bool isProgress) {
    dashboardController.isLoading.value = isProgress;
    _api.getDashboardResponse(
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          DashboardResponse response =
              DashboardResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            isMainViewVisible.value = true;
            dashboardResponse.value = response;
            var user = Get.find<AppStorage>().getUserInfo();
            if ((response.userTypeId ?? 0) != 0) {
              Map<String, dynamic> updatedJson = {
                "user_type_id": response.userTypeId ?? 0,
                "is_owner": response.isOwner ?? false,
                "shift_id": response.shiftId ?? 0,
                "shift_name": response.shiftName ?? "",
                "shift_type": response.shiftType ?? 0,
                "team_id": response.teamId ?? 0,
                "team_name": response.teamName ?? "",
                "currency_symbol": response.currencySymbol ?? "\\u20b9",
                "company_id": response.companyId ?? 0,
                "company_name": response.companyName ?? "",
                "company_image": response.companyImage ?? "",
              };
              user = user.copyWith(
                  userTypeId: updatedJson['user_type_id'],
                  isOwner: updatedJson['is_owner'],
                  shiftId: updatedJson['shift_id'],
                  shiftName: updatedJson['shift_name'],
                  shiftType: updatedJson['shift_type'],
                  teamId: updatedJson['team_id'],
                  teamName: updatedJson['team_name'],
                  currencySymbol: updatedJson['currency_symbol'],
                  companyId: updatedJson['company_id'],
                  companyName: updatedJson['company_name'],
                  companyImage: updatedJson['company_image']);
              Get.find<AppStorage>().setUserInfo(user);
            }
            Get.find<AppStorage>().setDashboardResponse(response);
            if (!StringHelper.isEmptyString(response.checkinDateTime)) {
              isStopTimer.value = false;
              startTimer();
            } else {
              isStopTimer.value = true;
            }
            if ((response.companyId ?? 0) > 0) {
              getRequestCountApi(false);
            }
          } else {
            AppUtils.showSnackBarMessage(response.message!);
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
        dashboardController.isLoading.value = false;
      },
      onError: (ResponseModel error) {
        dashboardController.isLoading.value = false;
        // if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        //   isInternetNotAvailable.value = true;
        //   // Utils.showSnackBarMessage('no_internet'.tr);
        // } else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }*/
}
