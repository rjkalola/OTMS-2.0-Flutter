import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otm_inventory/pages/check_in/check_in/controller/check_in_repository.dart';
import 'package:otm_inventory/pages/check_in/check_in/model/check_in_resources_response.dart';
import 'package:otm_inventory/pages/check_in/check_out/controller/check_out_repository.dart';
import 'package:otm_inventory/pages/check_in/check_out/model/check_log_details_response.dart';
import 'package:otm_inventory/pages/check_in/clock_in/controller/clock_in_utils_.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/check_log_info.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/pages/common/model/file_info.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/location_service_new.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

import '../../../../utils/app_constants.dart';
import '../../../common/drop_down_list_dialog.dart';

class CheckOutController extends GetxController implements SelectItemListener {
  final RxBool isLoading = false.obs,
      isMainViewVisible = false.obs,
      isInternetNotAvailable = false.obs,
      isLocationLoaded = true.obs;

  final _api = CheckOutRepository();
  final addressController = TextEditingController().obs;
  final tradeController = TextEditingController().obs;
  final typeOfWorkController = TextEditingController().obs;
  final noteController = TextEditingController().obs;
  late GoogleMapController mapController;
  String? latitude, longitude, location;
  final center =
      LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude).obs;
  final locationService = LocationServiceNew();
  int checkLogId = 0,
      addressId = 0,
      tradeId = 0,
      typeOfWorkId = 0,
      projectId = 0;
  String date = "";
  bool isCurrentDay = true;
  final listBeforePhotos = <FilesInfo>[].obs;
  final listAfterPhotos = <FilesInfo>[].obs;
  final checkLogInfo = CheckLogInfo().obs;
  final checkInTime = "".obs, checkOutTime = "".obs;
  final listBeforeRemoveIds = <String>[];
  CheckInResourcesResponse? checkInResourcesData;
  final addressList = <ModuleInfo>[].obs;
  final tradeList = <ModuleInfo>[].obs;
  final typeOfWorkList = <ModuleInfo>[].obs;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      checkLogId = arguments[AppConstants.intentKey.checkLogId] ?? 0;
      projectId = arguments[AppConstants.intentKey.projectId] ?? 0;
    }
    getCheckLogDetailsApi();
    /* LocationInfo? locationInfo = Get.find<AppStorage>().getLastLocation();
    if (locationInfo != null) {
      setLocation(double.parse(locationInfo.latitude ?? "0"),
          double.parse(locationInfo.longitude ?? "0"));
    }
    locationRequest();
    appLifeCycle();*/
  }

  void setInitialData() {
    checkInTime.value = DateUtil.changeFullDateToSortTime(
        checkLogInfo.value.checkinDateTime ?? "");
    checkOutTime.value =
        !StringHelper.isEmptyString(checkLogInfo.value.checkoutDateTime)
            ? DateUtil.changeFullDateToSortTime(
                checkLogInfo.value.checkoutDateTime ?? "")
            : getCurrentTime();
    addressController.value.text = checkLogInfo.value.addressName ?? "-";
    tradeController.value.text = checkLogInfo.value.tradeName ?? "-";
    typeOfWorkController.value.text = checkLogInfo.value.typeOfWorkName ?? "-";

    addressId = checkLogInfo.value.addressId ?? 0;
    tradeId = checkLogInfo.value.tradeId ?? 0;
    typeOfWorkId = checkLogInfo.value.typeOfWorkId ?? 0;

    for (var before in checkLogInfo.value.beforeAttachments!) {
      listBeforePhotos.add(FilesInfo(
          id: before.id, file: before.imageUrl, fileThumb: before.thumbUrl));
    }

    for (var after in checkLogInfo.value.afterAttachments!) {
      listAfterPhotos.add(FilesInfo(
          id: after.id, file: after.imageUrl, fileThumb: after.thumbUrl));
    }
  }

  Future<void> getCheckLogDetailsApi() async {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["checklog_id"] = checkLogId ?? 0;

    _api.getCheckLogDetails(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          CheckLogDetailsResponse response = CheckLogDetailsResponse.fromJson(
              jsonDecode(responseModel.result!));
          checkLogInfo.value = response.info!;
          isCurrentDay =
              ClockInUtils.isCurrentDay(checkLogInfo.value.dateAdded ?? "");
          print("isCurrentDay:" + isCurrentDay.toString());
          setInitialTime();
          setInitialData();
          checkInResourcesApi();
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          // isInternetNotAvailable.value = true;
          AppUtils.showApiResponseMessage('no_internet'.tr);
        }
      },
    );
  }

  void checkOutApi() async {
    Map<String, dynamic> map = {};
    map["checklog_id"] = checkLogInfo.value.id ?? 0;
    map["address_id"] = addressId;
    map["trade_id"] = tradeId;
    map["type_of_work_id"] = typeOfWorkId;
    map["comment"] = StringHelper.getText(addressController.value);
    map["before_attachment_remove_ids"] =
        StringHelper.getCommaSeparatedStringIds(listBeforeRemoveIds);
    map["location"] = location;
    map["latitude"] = latitude;
    map["longitude"] = longitude;

    multi.FormData formData = multi.FormData.fromMap(map);
    print("reques value:" + map.toString());

    List<FilesInfo> listBefore = [];
    for (var before in listBeforePhotos) {
      if (!StringHelper.isEmptyString(before.file) && (before.id ?? 0) == 0) {
        listBefore.add(before);
      }
    }
    for (int i = 0; i < listBefore.length; i++) {
      print("before:" + listBefore[i].file!);
      formData.files.add(
        MapEntry(
          "before_attachments[]",
          // or just 'images' depending on your backend
          await multi.MultipartFile.fromFile(
            listBefore[i].file ?? "",
          ),
        ),
      );
    }

    List<FilesInfo> listAfter = [];
    for (var after in listAfterPhotos) {
      if (!StringHelper.isEmptyString(after.file) && (after.id ?? 0) == 0) {
        listAfter.add(after);
      }
    }
    for (int i = 0; i < listAfter.length; i++) {
      print("after:" + listBefore[i].file!);
      formData.files.add(
        MapEntry(
          "after_attachments[]",
          // or just 'images' depending on your backend
          await multi.MultipartFile.fromFile(
            listAfter[i].file ?? "",
          ),
        ),
      );
    }

    isLoading.value = true;
    _api.checkOut(
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
    CheckInRepository().checkInResources(
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
      AppConstants.intentKey.removeIdsList: listBeforeRemoveIds,
      AppConstants.intentKey.photosType: photosType,
      AppConstants.intentKey.photosList: listPhotos,
      AppConstants.intentKey.isEditable:
          StringHelper.isEmptyString(checkLogInfo.value.checkoutDateTime),
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
          listBeforeRemoveIds.clear();
          listBeforeRemoveIds
              .addAll(arguments[AppConstants.intentKey.removeIdsList] ?? []);
          print("Remove Ids List:" + listBeforeRemoveIds.length.toString());
        } else if (photosType == AppConstants.type.afterPhotos) {
          listAfterPhotos.clear();
          listAfterPhotos
              .addAll(arguments[AppConstants.intentKey.photosList] ?? []);
        }
      }
    }
  }

  void showSelectAddressDialog() {
    if (StringHelper.isEmptyString(checkLogInfo.value.checkoutDateTime)) {
      if (addressList.isNotEmpty) {
        showDropDownDialog(AppConstants.dialogIdentifier.selectAddress,
            'select_address'.tr, addressList, this);
      } else {
        AppUtils.showToastMessage('empty_data_message'.tr);
      }
    }
  }

  void showSelectTradeDialog() {
    if (StringHelper.isEmptyString(checkLogInfo.value.checkoutDateTime)) {
      if (tradeList.isNotEmpty) {
        showDropDownDialog(AppConstants.dialogIdentifier.selectTrade,
            'select_trade'.tr, tradeList, this);
      } else {
        AppUtils.showToastMessage('empty_data_message'.tr);
      }
    }
  }

  void showSelectTypeOfWorkDialog() {
    if (StringHelper.isEmptyString(checkLogInfo.value.checkoutDateTime)) {
      if (typeOfWorkList.isNotEmpty) {
        showDropDownDialog(AppConstants.dialogIdentifier.selectTypeOfWork,
            'type_of_work'.tr, typeOfWorkList, this);
      } else {
        AppUtils.showToastMessage('empty_data_message'.tr);
      }
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
    } else if (action == AppConstants.dialogIdentifier.selectTrade) {
      tradeController.value.text = name;
      tradeId = id;

      typeOfWorkController.value.text = "";
      typeOfWorkId = 0;

      typeOfWorkList.clear();
      for (var info in checkInResourcesData!.typeOfWorks!) {
        if (info.tradeId == tradeId) {
          typeOfWorkList.add(info);
        }
      }
    } else if (action == AppConstants.dialogIdentifier.selectTypeOfWork) {
      typeOfWorkController.value.text = name;
      typeOfWorkId = id;
    }
  }
}
