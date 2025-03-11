import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/authentication/otp_verification/model/user_info.dart';
import 'package:otm_inventory/pages/dashboard/controller/dashboard_controller.dart';
import 'package:otm_inventory/pages/dashboard/models/dashboard_response.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_repository.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/DashboardActionItemInfo.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/request_count_response.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';
import 'package:intl/intl.dart';

class HomeTabController extends GetxController {
  final _api = HomeTabRepository();
  RxBool isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isPendingRequest = false.obs,
      isUpdateLocationVisible = false.obs,
      isUpdateLocationDividerVisible = false.obs,
      isNextUpdateLocationTimeVisible = false.obs;

  RxString nextUpdateLocationTime = "".obs,
      previousUpdateLocationTime = "".obs,
      updateLocationTime = "".obs;
  RxInt nextUpdateLocationId = 0.obs, previousUpdateLocationId = 0.obs;

  final List<List<DashboardActionItemInfo>> listHeaderButtons_ =
      DataUtils.generateChunks(DataUtils.getHeaderActionButtonsList(), 3).obs;
  final List<DashboardActionItemInfo> listHeaderButtons =
      DataUtils.getHeaderActionButtonsList().obs;
  final selectedActionButtonPagerPosition = 0.obs, pendingRequestCount = 0.obs;
  final dashboardActionButtonsController = PageController(
    initialPage: 0,
  );
  final dashboardController = Get.put(DashboardController());
  final dashboardResponse = DashboardResponse().obs;

  @override
  void onInit() {
    super.onInit();
    // getRegisterResources();
  }

  void onActionButtonClick(String action) {
    if (action == AppConstants.action.items) {
      Get.offNamed(AppRoutes.productListScreen);
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

  void getDashboardApi(bool isProgress) {
    dashboardController.isLoading.value = isProgress;
    _api.getDashboardResponse(
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          DashboardResponse response =
              DashboardResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            isMainViewVisible.value = true;
            dashboardResponse.value = response;
            AppStorage().setDashboardResponse(response);
            getRequestCountApi(false);
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
  }

  void getRequestCountApi(bool isProgress) {
    _api.getRequestCountResponse(
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          RequestCountResponse response =
              RequestCountResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            pendingRequestCount.value = response.pendingCount ?? 0;
            isPendingRequest.value = (response.pendingCount ?? 0) > 0;
          } else {
            AppUtils.showSnackBarMessage(response.message!);
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
        // dashboardController.isLoading.value = false;
      },
      onError: (ResponseModel error) {
        // dashboardController.isLoading.value = false;
        // if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        //   isInternetNotAvailable.value = true;
        //   // Utils.showSnackBarMessage('no_internet'.tr);
        // } else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }

  void setInitData(DashboardResponse? response) {
    if (response != null) {
      dashboardResponse.value = response;
    }
  }

  void setNextUpdateLocationTime() {
    try {
      bool isTodayWorkStarted = false;
      final checkInDateFormat = DateFormat(DateUtil.YYYY_MM_DD_TIME_24_DASH2);
      final dateFormat = DateFormat(DateUtil.YYYY_MM_DD_DASH);

      if (!StringHelper.isEmptyString(
          dashboardResponse.value.checkinDateTime)) {
        DateTime checkInDate = checkInDateFormat
            .parse(dashboardResponse.value.checkinDateTime ?? "");
        isTodayWorkStarted = DateUtils.isSameDay(checkInDate, DateTime.now());
      }
      if (isTodayWorkStarted &&
          StringHelper.isEmptyList(AppStorage().getUserInfo().locations)) {
        List<Locations> locations = AppStorage().getUserInfo().locations!;
        int index = -1;
        String checkInDate = dateFormat.format(
            checkInDateFormat.parse(dashboardResponse.value.checkinDateTime!));
        for (int i = 0; i < locations.length; i++) {
          DateTime time =
              checkInDateFormat.parse("$checkInDate ${locations[i].time!}");
          DateTime currentTime = DateTime.now();
          if (time.isAfter(currentTime)) {
            index = i;
            break;
          }
        }
        if (index != -1) {
          nextUpdateLocationTime.value = locations[index].time!;
          nextUpdateLocationId.value = locations[index].id!;
          isUpdateLocationVisible.value = true;
          isUpdateLocationDividerVisible.value = true;
          isNextUpdateLocationTimeVisible.value = true;

          if (!locations[index].status!) {
            updateLocationTime.value = DateUtil.changeDateFormat(
                nextUpdateLocationTime.value,
                DateUtil.HH_MM_SS_24_2,
                DateUtil.HH_MM_24);
            // binding.txtUpdateLocationTime.setText(time);

            if (index > 0 && !locations[index - 1].status!) {
              if (!StringHelper.isEmptyString(
                  locations[index - 1].extraMin ?? "")) {
                DateTime previousTime = checkInDateFormat
                    .parse("$checkInDate ${locations[index - 1].time!}");
                DateTime currentTime = DateTime.now();
                DateTime extraTime = checkInDateFormat
                    .parse("$checkInDate ${locations[index - 1].extraTime!}");

                int timeDifferent =
                    currentTime.millisecond - previousTime.millisecond;
                double totalSeconds = timeDifferent / 1000;
                int extraMin = int.parse(locations[index - 1].extraMin!) * 60;
                if (totalSeconds <= extraMin) {
                  previousUpdateLocationTime.value = locations[index - 1].time!;
                  previousUpdateLocationId.value = locations[index - 1].id!;
                  // ((DashboardActivity) getActivity()).showUpdateLocationRemainingTime(extraMin - totalSeconds);
                } else {
                  // ((DashboardActivity) getActivity()).hideUpdateLocationRemainingTime();
                }
              } else {
                // ((DashboardActivity) getActivity()).hideUpdateLocationRemainingTime();
              }
            } else {
              // ((DashboardActivity) getActivity()).hideUpdateLocationRemainingTime();
            }
          } else {
            if (locations.length - 1 > index) {
              nextUpdateLocationTime.value = locations[index + 1].time!;
              nextUpdateLocationId.value = locations[index + 1].id!;
              updateLocationTime.value = DateUtil.changeDateFormat(
                  nextUpdateLocationTime.value,
                  DateUtil.HH_MM_SS_24_2,
                  DateUtil.HH_MM_24);
              // binding.txtUpdateLocationTime.setText(time);
            } else {
              hideUpdateLocationView();
            }
          }
        } else {
          isUpdateLocationVisible.value = true;
          isUpdateLocationDividerVisible.value = true;
          isNextUpdateLocationTimeVisible.value = false;

          if (!locations[locations.length - 1].status! &&
              !StringHelper.isEmptyString(
                  locations[locations.length - 1].extraMin!)) {
            DateTime previousTime = checkInDateFormat
                .parse("$checkInDate ${locations[locations.length - 1].time!}");
            DateTime extraTime = checkInDateFormat.parse(
                "$checkInDate ${locations[locations.length - 1].extraMin!}");
            DateTime currentTime = DateTime.now();
            int timeDifferent =
                currentTime.millisecond - previousTime.millisecond;
            double totalSeconds = timeDifferent / 1000;
            int extraMin =
                int.parse(locations[locations.length - 1].extraMin!) * 60;
            if (totalSeconds <= extraMin) {
              previousUpdateLocationTime.value =
                  locations[locations.length - 1].time!;
              previousUpdateLocationId.value =
                  locations[locations.length - 1].id!;
              // ((DashboardActivity) getActivity()).showUpdateLocationRemainingTime(extraMin - totalSeconds);
            } else {
              // ((DashboardActivity) getActivity()).hideUpdateLocationRemainingTime();
            }
          } else {
            // ((DashboardActivity) getActivity()).hideUpdateLocationRemainingTime();
          }
        }
      } else {
        hideUpdateLocationView();
      }
    } on Exception catch (_, ex) {}
  }

  void hideUpdateLocationView() {
    // ((DashboardActivity) getActivity()).hideUpdateLocationRemainingTime();
    isUpdateLocationVisible.value = false;
    isUpdateLocationDividerVisible.value = false;
    isNextUpdateLocationTimeVisible.value = false;
    updateLocationTime.value = "";
  }
}
