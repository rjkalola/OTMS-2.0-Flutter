import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otm_inventory/pages/check_in/check_in/controller/check_in_repository.dart';
import 'package:otm_inventory/pages/check_in/check_in/model/check_in_resources_response.dart';
import 'package:otm_inventory/pages/check_in/check_in/model/company_locations_response.dart';
import 'package:otm_inventory/pages/check_in/check_in/model/type_of_work_resources_info.dart';
import 'package:otm_inventory/pages/check_in/check_in/model/type_of_work_resources_response.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:otm_inventory/pages/check_in/dialogs/select_type_of_work_dialog.dart';
import 'package:otm_inventory/pages/common/drop_down_list_dialog.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/pages/common/listener/select_type_of_work_listener.dart';
import 'package:otm_inventory/pages/common/model/file_info.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/location_service_new.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/utils/user_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

import '../../../../utils/app_constants.dart';

class CheckInController extends GetxController
    implements SelectItemListener, SelectTypeOfWorkListener {
  final RxBool isLoading = false.obs,
      isMainViewVisible = false.obs,
      isInternetNotAvailable = false.obs,
      isLocationLoaded = true.obs;

  final _api = CheckInRepository();
  final addressController = TextEditingController().obs;
  final locationController = TextEditingController().obs;
  final tradeController = TextEditingController().obs;
  final typeOfWorkController = TextEditingController().obs;
  final noteController = TextEditingController().obs;
  late GoogleMapController mapController;
  String? latitude, longitude, location;
  final center =
      LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude).obs;
  final locationService = LocationServiceNew();
  final workLogInfo = WorkLogInfo().obs;
  int workLogId = 0,
      addressId = 0,
      tradeId = 0,
      typeOfWorkId = 0,
      locationId = 0,
      companyTaskId = 0,
      projectId = 0;
  String date = "";
  bool isCurrentDay = true, isPriceWork = false;
  final listBeforePhotos = <FilesInfo>[].obs;
  final addressList = <ModuleInfo>[].obs;
  final tradeList = <ModuleInfo>[].obs;
  final locationsList = <ModuleInfo>[].obs;
  final typeOfWorkList = <TypeOfWorkResourcesInfo>[].obs;
  final RxString checkInTime = "".obs;
  CheckInResourcesResponse? checkInResourcesData;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      workLogId = arguments[AppConstants.intentKey.workLogId] ?? 0;
      projectId = arguments[AppConstants.intentKey.projectId] ?? 0;
      isPriceWork = arguments[AppConstants.intentKey.isPriceWork] ?? false;
      print("Project ID:" + projectId.toString());
    }
    checkInTime.value = getCurrentTime();
    if (UserUtils.getLoginUserTradeId() != 0) {
      tradeController.value.text = UserUtils.getLoginUserTrade();
      tradeId = UserUtils.getLoginUserTradeId();
    } else if (UserUtils.isAdmin()) {
      tradeController.value.text = 'admin'.tr;
    }
    /*  LocationInfo? locationInfo = Get.find<AppStorage>().getLastLocation();
    if (locationInfo != null) {
      setLocation(double.parse(locationInfo.latitude ?? "0"),
          double.parse(locationInfo.longitude ?? "0"));
    }
    locationRequest();
    appLifeCycle();*/
    checkInResourcesApi();
  }

  void checkInApi() async {
    Map<String, dynamic> map = {};
    map["user_worklog_id"] = workLogId;
    map["address_id"] = addressId;
    map["trade_id"] = tradeId;
    map["company_task_id"] = companyTaskId;
    map["type_of_work_id"] = typeOfWorkId;
    map["location_id"] = locationId;
    map["comment"] = StringHelper.getText(noteController.value);
    map["location"] = location;
    map["latitude"] = latitude;
    map["longitude"] = longitude;

    multi.FormData formData = multi.FormData.fromMap(map);
    print("reques value:" + map.toString());

    for (int i = 0; i < listBeforePhotos.length; i++) {
      if (!StringHelper.isEmptyString(listBeforePhotos[i].file)) {
        formData.files.add(
          MapEntry(
            "before_attachments[]",
            // or just 'images' depending on your backend
            await multi.MultipartFile.fromFile(
              listBeforePhotos[i].file ?? "",
            ),
          ),
        );
      }
    }

    isLoading.value = true;
    _api.checkIn(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showApiResponseMessage(response.Message ?? "");
          Get.back(result: true);
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        }
      },
    );
  }

  void checkInResourcesApi() async {
    Map<String, dynamic> map = {};
    isLoading.value = true;
    _api.checkInResources(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          CheckInResourcesResponse response = CheckInResourcesResponse.fromJson(
              jsonDecode(responseModel.result!));
          checkInResourcesData = response;

          if (projectId != 0) {
            for (var info in checkInResourcesData!.addresses!) {
              if (info.projectId == projectId) {
                addressList.add(info);
              }
            }
          } else {
            addressList.addAll(checkInResourcesData!.addresses!);
          }

          tradeList.addAll(checkInResourcesData!.trades!);

          getCompanyLocationsApi();
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        }
      },
    );
  }

  void getTypeOfWorkResourcesApi() async {
    Map<String, dynamic> map = {};
    map["trade_id"] = tradeId;
    map["address_id"] = addressId;
    map["company_id"] = ApiConstants.companyId;
    map["is_pricework"] = isPriceWork;
    isLoading.value = true;
    _api.getTypeOfWorkResources(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          TypeOfWorkResourcesResponse response =
              TypeOfWorkResourcesResponse.fromJson(
                  jsonDecode(responseModel.result!));
          if ((response.info ?? []).isNotEmpty) {
            typeOfWorkList.addAll(response.info!);
          }
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        }
      },
    );
  }

  void getCompanyLocationsApi() async {
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    isLoading.value = true;
    _api.getCompanyLocations(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          CompanyLocationsResponse response = CompanyLocationsResponse.fromJson(
              jsonDecode(responseModel.result!));
          if ((response.info ?? []).isNotEmpty) {
            locationsList.addAll(response.info!);
          }
          isMainViewVisible.value = true;
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showApiResponseMessage('no_internet'.tr);
        }
      },
    );
  }

  void appLifeCycle() {
    AppLifecycleListener(
      onResume: () async {
        if (!isLocationLoaded.value) locationRequest();
      },
    );
  }

  Future<void> locationRequest() async {
    bool isLocationLoaded = await locationService.checkLocationService();
    if (isLocationLoaded) {
      fetchLocationAndAddress();
    }
  }

  Future<void> fetchLocationAndAddress() async {
    Position? latLon = await LocationServiceNew.getCurrentLocation();
    if (latLon != null) {
      isLocationLoaded.value = true;
      setLocation(latLon.latitude, latLon.longitude);
    }
  }

  Future<void> setLocation(double? lat, double? lon) async {
    if (lat != null && lon != null) {
      latitude = lat.toString();
      longitude = lon.toString();
      center.value = LatLng(lat, lon);
      location = await LocationServiceNew.getAddressFromCoordinates(lat, lon);
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: center.value, zoom: 15),
      ));
      print("Location:" + "Latitude: ${latitude}, Longitude: ${longitude}");
      print("Address:${location ?? ""}");
    }
  }

  setInitialTime() {}

  String changeFullDateToSortTime(String? date) {
    return !StringHelper.isEmptyString(date)
        ? DateUtil.changeDateFormat(
            date!, DateUtil.DD_MM_YYYY_TIME_24_SLASH2, DateUtil.HH_MM_24)
        : "";
  }

  String getCurrentTime() {
    return DateUtil.getCurrentTimeInFormat(DateUtil.HH_MM_24);
  }

  Future<void> onSelectPhotos(
      String photosType, List<FilesInfo> listPhotos) async {
    var result;
    var arguments = {
      AppConstants.intentKey.photosType: photosType,
      AppConstants.intentKey.photosList: listPhotos,
    };
    // result = await Get.toNamed(AppRoutes.selectBeforeAfterPhotosScreen,
    //     arguments: arguments);

    result = await Navigator.of(Get.context!).pushNamed(
        AppRoutes.selectBeforeAfterPhotosScreen,
        arguments: arguments);

    if (result != null) {
      var arguments = result;
      if (arguments != null) {
        photosType = arguments[AppConstants.intentKey.photosType] ?? "";
        if (photosType == AppConstants.type.beforePhotos) {
          listBeforePhotos.clear();
          listBeforePhotos
              .addAll(arguments[AppConstants.intentKey.photosList] ?? []);
        }
      }
    }
  }

  void showSelectAddressDialog() {
    if (addressList.isNotEmpty) {
      showDropDownDialog(AppConstants.dialogIdentifier.selectAddress,
          'select_address'.tr, addressList, this);
    } else {
      AppUtils.showToastMessage('empty_data_message'.tr);
    }
  }

  void showSelectTradeDialog() {
    if (tradeList.isNotEmpty) {
      showDropDownDialog(AppConstants.dialogIdentifier.selectTrade,
          'select_trade'.tr, tradeList, this);
    } else {
      AppUtils.showToastMessage('empty_data_message'.tr);
    }
  }

  void showSelectLocationDialog() {
    if (locationsList.isNotEmpty) {
      showDropDownDialog(AppConstants.dialogIdentifier.selectLocation,
          'location'.tr, locationsList, this);
    } else {
      AppUtils.showToastMessage('empty_data_message'.tr);
    }
  }

  void showSelectTypeOfWorkDialog() {
    if (typeOfWorkList.isNotEmpty) {
      Get.bottomSheet(
          SelectTypeOfWorkDialog(
            dialogType: AppConstants.dialogIdentifier.selectTypeOfWork,
            list: typeOfWorkList,
            listener: this,
          ),
          backgroundColor: Colors.transparent,
          isScrollControlled: true);
    } else {
      AppUtils.showToastMessage('empty_data_message'.tr);
    }
  }

  void showDropDownDialog(String dialogType, String title,
      List<ModuleInfo> list, SelectItemListener listener) {
    Get.bottomSheet(
        DropDownListDialog(
          title: title,
          dialogType: dialogType,
          list: list,
          listener: listener,
          isCloseEnable: true,
          isSearchEnable: true,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.selectAddress) {
      addressController.value.text = name;
      addressId = id;

      if (tradeId != 0) {
        typeOfWorkController.value.text = "";
        typeOfWorkId = 0;
        companyTaskId = 0;

        typeOfWorkList.clear();
        getTypeOfWorkResourcesApi();
      }
    } else if (action == AppConstants.dialogIdentifier.selectTrade) {
      tradeController.value.text = name;
      tradeId = id;

      typeOfWorkController.value.text = "";
      typeOfWorkId = 0;
      companyTaskId = 0;

      typeOfWorkList.clear();
      getTypeOfWorkResourcesApi();
      // for (var info in checkInResourcesData!.typeOfWorks!) {
      //   if (info.tradeId == tradeId) {
      //     typeOfWorkList.add(info);
      //   }
      // }
    } else if (action == AppConstants.dialogIdentifier.selectTypeOfWork) {
      typeOfWorkController.value.text = name;
      typeOfWorkId = id;
    } else if (action == AppConstants.dialogIdentifier.selectLocation) {
      locationController.value.text = name;
      locationId = id;
    }
  }

  @override
  void onSelectTypeOfWork(int position, int typeOfWorkId, int companyTaskId,
      String name, String action) {
    if (action == AppConstants.dialogIdentifier.selectTypeOfWork) {
      typeOfWorkController.value.text = name;
      this.typeOfWorkId = typeOfWorkId;
      this.companyTaskId = companyTaskId;
    }
  }
}
