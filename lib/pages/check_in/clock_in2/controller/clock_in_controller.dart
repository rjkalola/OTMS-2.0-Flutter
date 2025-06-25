import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otm_inventory/pages/check_in/clock_in2/controller/clock_in_repository.dart';
import 'package:otm_inventory/pages/check_in/clock_in2/model/check_in_response.dart';
import 'package:otm_inventory/pages/check_in/clock_in2/model/check_out_response.dart';
import 'package:otm_inventory/pages/check_in/clock_in2/model/new_time_sheet_resources_response.dart';
import 'package:otm_inventory/pages/check_in/clock_in2/model/start_work_response.dart';
import 'package:otm_inventory/pages/check_in/clock_in2/model/stop_work_response.dart';
import 'package:otm_inventory/pages/check_in/clock_in2/view/widgets/select_project_dialog.dart';
import 'package:otm_inventory/pages/check_in/clock_in2/view/widgets/select_shift_dialog.dart';
import 'package:otm_inventory/pages/check_in/clock_in2/view/widgets/shift_summery_dialog.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/pages/dashboard/models/dashboard_response.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/controller/home_tab_repository.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/location_service_new.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class ClockInController extends GetxController implements SelectItemListener {
  // final companyNameController = TextEditingController().obs;
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs;
  final _api = ClockInRepository();
  late GoogleMapController mapController;
  final center = LatLng(37.42796133580664, -122.085749655962).obs;
  final dashboardResponse = DashboardResponse().obs;
  final resourcesData = NewTimeSheetResourcesResponse().obs;
  String? latitude, longitude, location, pwProjectId, shiftId;
  final timeLogId = "".obs, checkLogId = "".obs;
  bool locationLoaded = false;
  Position? latLon = null;
  final locationService = LocationServiceNew();

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      // fromSignUp.value =
      //     arguments[AppConstants.intentKey.fromSignUpScreen] ?? "";
    }
    timeLogId.value = Get.find<AppStorage>().getTimeLogId();
    checkLogId.value = Get.find<AppStorage>().getCheckLogId();
    pwProjectId = Get.find<AppStorage>().getProjectId();
    shiftId = Get.find<AppStorage>().getShiftId();
    // getDashboardApi(true);
    appLifeCycle();
  }

  void appLifeCycle() {
    AppLifecycleListener(
      onResume: () async {
        if (!locationLoaded) locationRequest();
      },
    );
  }

  void getDashboardApi(bool isProgress) {
    isLoading.value = isProgress;
    HomeTabRepository().getDashboardResponse(
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          DashboardResponse response =
              DashboardResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
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
              // user = user.copyWith(
              //     userTypeId: updatedJson['user_type_id'],
              //     isOwner: updatedJson['is_owner'],
              //     shiftId: updatedJson['shift_id'],
              //     shiftName: updatedJson['shift_name'],
              //     shiftType: updatedJson['shift_type'],
              //     teamId: updatedJson['team_id'],
              //     teamName: updatedJson['team_name'],
              //     currencySymbol: updatedJson['currency_symbol'],
              //     companyId: updatedJson['company_id'],
              //     companyName: updatedJson['company_name'],
              //     companyImage: updatedJson['company_image']);
              Get.find<AppStorage>().setUserInfo(user);
            }
            Get.find<AppStorage>().setDashboardResponse(response);
            getNewTimesheetResources();
          } else {
            AppUtils.showApiResponseMessage(response.message!);
          }
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage!);
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        // if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        //   isInternetNotAvailable.value = true;
        //   // Utils.showApiResponseMessage('no_internet'.tr);
        // } else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showApiResponseMessage(error.statusMessage!);
        // }
      },
    );
  }

  void getNewTimesheetResources() {
    isLoading.value = true;
    _api.getNewTimesheetResources(
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          NewTimeSheetResourcesResponse response =
              NewTimeSheetResourcesResponse.fromJson(
                  jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            resourcesData.value = response;
            isMainViewVisible.value = true;
            locationRequest();
          } else {
            AppUtils.showApiResponseMessage(response.message!);
          }
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage!);
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // Utils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage!);
        }
      },
    );
  }

  void startWork() async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["pw_project_id"] = pwProjectId ?? "";
    map["shift_id"] = shiftId ?? "";
    map["latitude"] = latitude ?? "";
    map["longitude"] = longitude ?? "";
    map["location"] = location ?? "";
    map["user_id"] = AppUtils.getLoginUserId();
    map["supervisor_id"] = dashboardResponse.value.supervisorId ?? "";
    map["team_id"] = dashboardResponse.value.teamId ?? "";
    map["note"] = "";
    map["device_type"] = AppConstants.deviceType;
    if (kDebugMode) print("Request Parameter ==> ${map.toString()}");
    multi.FormData formData = multi.FormData.fromMap(map);
    // isLoading.value = true;
    _api.startWork(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          StartWorkResponse response =
              StartWorkResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            timeLogId.value = (response.timelogId ?? 0).toString();
            Get.find<AppStorage>().setTimeLogId(timeLogId.value);
            Get.find<AppStorage>().setProjectId(pwProjectId ?? "0");
            Get.find<AppStorage>().setShiftId(shiftId ?? "0");
          } else {
            AppUtils.showApiResponseMessage(response.message!);
          }
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage!);
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage!);
        }
      },
    );
  }

  void checkIn() async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["pw_project_id"] = pwProjectId ?? "";
    map["shift_id"] = shiftId ?? "";
    map["latitude"] = latitude ?? "";
    map["longitude"] = longitude ?? "";
    map["location"] = location ?? "";
    map["user_id"] = AppUtils.getLoginUserId();
    map["supervisor_id"] = dashboardResponse.value.supervisorId ?? "";
    map["team_id"] = dashboardResponse.value.teamId ?? "";
    map["note"] = "";
    map["device_type"] = AppConstants.deviceType;

    multi.FormData formData = multi.FormData.fromMap(map);
    // isLoading.value = true;
    _api.checkIn(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          CheckInResponse response =
              CheckInResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            checkLogId.value = (response.checklogId ?? 0).toString();
            Get.find<AppStorage>().setTimeLogId(checkLogId.value);
          } else {
            AppUtils.showApiResponseMessage(response.message!);
          }
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage!);
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage!);
        }
      },
    );
  }

  void stopWork() async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["id"] = timeLogId.value;
    map["shift_id"] = shiftId ?? "";
    map["latitude"] = latitude ?? "";
    map["longitude"] = longitude ?? "";
    map["location"] = location ?? "";
    map["user_id"] = AppUtils.getLoginUserId();
    map["supervisor_id"] = dashboardResponse.value.supervisorId ?? "";
    map["team_id"] = dashboardResponse.value.teamId ?? "";
    map["note"] = "";
    map["device_type"] = AppConstants.deviceType;

    multi.FormData formData = multi.FormData.fromMap(map);
    // isLoading.value = true;
    _api.stopWork(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          StopWorkResponse response =
              StopWorkResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            timeLogId.value = "";
            checkLogId.value = "";
            pwProjectId = "";
            shiftId = "";
            Get.find<AppStorage>().setTimeLogId(timeLogId.value);
            Get.find<AppStorage>().setCheckLogId(checkLogId.value);
            Get.find<AppStorage>().setProjectId(pwProjectId!);
            Get.find<AppStorage>().setShiftId(shiftId!);
          } else {
            AppUtils.showApiResponseMessage(response.message!);
          }
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage!);
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage!);
        }
      },
    );
  }

  void checkOut() async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["id"] = checkLogId.value;
    map["shift_id"] = shiftId ?? "";
    map["latitude"] = latitude ?? "";
    map["longitude"] = longitude ?? "";
    map["location"] = location ?? "";
    map["user_id"] = AppUtils.getLoginUserId();
    map["supervisor_id"] = dashboardResponse.value.supervisorId ?? "";
    map["team_id"] = dashboardResponse.value.teamId ?? "";
    map["note"] = "";
    map["device_type"] = AppConstants.deviceType;

    multi.FormData formData = multi.FormData.fromMap(map);
    // isLoading.value = true;
    _api.stopWork(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          CheckOutResponse response =
              CheckOutResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            checkLogId.value = "";
            Get.find<AppStorage>().setCheckLogId(checkLogId.value);
          } else {
            AppUtils.showApiResponseMessage(response.message!);
          }
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage!);
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage!);
        }
      },
    );
  }

  void showSelectProjectDialog() {
    Get.bottomSheet(
        SelectProjectDialog(
          dialogType: AppConstants.dialogIdentifier.selectProject,
          list: resourcesData.value.projects ?? [],
          listener: this,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  void showSelectShiftDialog() {
    Get.bottomSheet(
        SelectShiftDialog(
          dialogType: AppConstants.dialogIdentifier.selectShift,
          list: resourcesData.value.shifts ?? [],
          listener: this,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  showShiftSummeryDialog() {
    Get.bottomSheet(
        ShiftSummeryDialog(
          dialogType: AppConstants.dialogIdentifier.selectShift,
          listener: this,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.selectProject) {
      print("Project Id:" + id.toString());
      print("Project name:" + name);
      pwProjectId = id.toString();
      showSelectShiftDialog();
    } else if (action == AppConstants.dialogIdentifier.selectShift) {
      print("Shift Id:" + id.toString());
      print("Shift name:" + name);
      shiftId = id.toString();
      startWork();
    }
  }

  Future<void> locationRequest() async {
    locationLoaded = await locationService.checkLocationService();
    if (locationLoaded) {
      fetchLocationAndAddress();
    }
  }

  Future<void> fetchLocationAndAddress() async {
    print("fetchLocationAndAddress");
    latLon = await LocationServiceNew.getCurrentLocation();
    if (latLon != null) {
      latitude = latLon!.latitude.toString();
      longitude = latLon!.longitude.toString();
      location = await LocationServiceNew.getAddressFromCoordinates(
          latLon!.latitude, latLon!.longitude);
      center.value = LatLng(latLon!.latitude, latLon!.longitude);
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: center.value, zoom: 15),
      ));
      print("Location:" +
          "Latitude: ${latLon!.latitude}, Longitude: ${latLon!.longitude}");
      print("Address:${location ?? ""}");
    } else {
      print("Location:" + "Location permission denied or services disabled");
      print("Address:" + "Could not retrieve address");
    }
  }

  bool isWorking() {
    return !StringHelper.isEmptyString(timeLogId.value) &&
        timeLogId.value != "0";
  }

  bool isCheckIn() {
    return !StringHelper.isEmptyString(checkLogId.value) &&
        checkLogId.value != "0";
  }

  onClickCheckInButton() async {
    var result;
    var arguments = {
      AppConstants.intentKey.addressList: resourcesData.value.projectAddresses,
    };
    // result =
    //     await Get.toNamed(AppRoutes.selectAddressScreen, arguments: arguments);

    // if (result != null) {}
  }
}
