import 'dart:convert';

import 'package:belcka/pages/check_in/check_in/controller/check_in_repository.dart';
import 'package:belcka/pages/check_in/check_in/model/check_in_resources_response.dart';
import 'package:belcka/pages/check_in/check_in/model/check_outside_boundary_response.dart';
import 'package:belcka/pages/check_in/check_in/model/company_locations_response.dart';
import 'package:belcka/pages/check_in/check_in/model/type_of_work_resources_info.dart';
import 'package:belcka/pages/check_in/check_in/model/type_of_work_resources_response.dart';
import 'package:belcka/pages/check_in/clock_in/model/location_info.dart';
import 'package:belcka/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:belcka/pages/check_in/dialogs/select_type_of_work_dialog.dart';
import 'package:belcka/pages/common/drop_down_list_dialog.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/listener/select_type_of_work_listener.dart';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/location_service_new.dart';
import 'package:belcka/utils/map_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../utils/app_constants.dart';

class CheckInController extends GetxController
    implements SelectItemListener, SelectTypeOfWorkListener {
  final RxBool isLoading = false.obs,
      isMainViewVisible = false.obs,
      isInternetNotAvailable = false.obs,
      isLocationLoaded = true.obs;
  final formKey = GlobalKey<FormState>();
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
      projectId = 0,
      selectedPhotosIndex = 0;
  String date = "";
  bool isCurrentDay = true, isPriceWork = false;
  final listBeforePhotos = <FilesInfo>[].obs;
  final addressList = <ModuleInfo>[].obs;
  final tradeList = <ModuleInfo>[].obs;
  final locationsList = <ModuleInfo>[].obs;
  final typeOfWorkList = <TypeOfWorkResourcesInfo>[].obs;
  final selectedTypeOfWorkList = <TypeOfWorkResourcesInfo>[].obs;
  final RxString checkInTime = "".obs;
  CheckInResourcesResponse? checkInResourcesData;
  final RxSet<Marker> markers = <Marker>{}.obs;

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
      print("tradeId:" + tradeId.toString());
    } else if (UserUtils.isAdmin()) {
      tradeController.value.text = 'admin'.tr;
    }
    LocationInfo? locationInfo = Get.find<AppStorage>().getLastLocation();
    if (locationInfo != null) {
      setLocation(double.parse(locationInfo.latitude ?? "0"),
          double.parse(locationInfo.longitude ?? "0"));
    }
    locationRequest();
    appLifeCycle();
    checkInResourcesApi();
  }

  void checkInApi() async {
    Map<String, dynamic> map = {};
    map["user_worklog_id"] = workLogId;
    map["address_id"] = addressId;
    map["trade_id"] = tradeId;
    // map["company_task_id"] = companyTaskId;
    // map["type_of_work_id"] = typeOfWorkId;
    List<String> listParams = listParamIds();
    map["company_task_ids"] = listParams[1];
    map["type_of_work_ids"] = listParams[0];
    map["location_id"] = locationId;
    map["comment"] = StringHelper.getText(noteController.value);
    map["location"] = location;
    map["latitude"] = latitude;
    map["longitude"] = longitude;

    multi.FormData formData = multi.FormData.fromMap(map);
    print("reques value:" + map.toString());

    /* for (int i = 0; i < listBeforePhotos.length; i++) {
      if (!StringHelper.isEmptyString(listBeforePhotos[i].imageUrl)) {
        formData.files.add(
          MapEntry(
            "before_attachments[]",
            // or just 'images' depending on your backend
            await multi.MultipartFile.fromFile(
              listBeforePhotos[i].imageUrl ?? "",
            ),
          ),
        );
      }
    }*/

    for (int i = 0; i < selectedTypeOfWorkList.length; i++) {
      if (selectedTypeOfWorkList[i].beforeAttachments != null) {
        List<FilesInfo> listPhotos = [];
        String photosKey = "";
        if ((selectedTypeOfWorkList[i].typeOfWorkId ?? 0) != 0 &&
            (selectedTypeOfWorkList[i].companyTaskId ?? 0) == 0) {
          photosKey =
              "before_type_of_work_attachments[${selectedTypeOfWorkList[i].typeOfWorkId}]";
        } else if ((selectedTypeOfWorkList[i].typeOfWorkId ?? 0) == 0 &&
            (selectedTypeOfWorkList[i].companyTaskId ?? 0) != 0) {
          photosKey =
              "before_company_task_attachments[${selectedTypeOfWorkList[i].companyTaskId}]";
        }
        print("photosKey:" + photosKey);
        for (var photo in selectedTypeOfWorkList[i].beforeAttachments!) {
          if (!StringHelper.isEmptyString(photo.imageUrl) &&
              (photo.id ?? 0) == 0) {
            listPhotos.add(photo);
          }
        }
        for (int j = 0; j < listPhotos.length; j++) {
          print("before:" + listPhotos[j].imageUrl!);
          formData.files.add(
            MapEntry(
              photosKey,
              // or just 'images' depending on your backend
              await multi.MultipartFile.fromFile(
                listPhotos[j].imageUrl ?? "",
              ),
            ),
          );
        }
      }
      print("------------------------------------------------");
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
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["latitude"] = latitude ?? "";
    map["longitude"] = longitude ?? "";
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

  void getTypeOfWorkResourcesApi(
      {required int addressId,
      required bool isPriceWork,
      bool? isFromDialog}) async {
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
          if (isFromDialog ?? false) {
            showSelectTypeOfWorkDialog();
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

  void checkLocationOutsideBoundaryApi(int addressId, String address) async {
    Map<String, dynamic> map = {};
    map["address_id"] = addressId;
    map["latitude"] = latitude ?? "";
    map["longitude"] = longitude ?? "";
    isLoading.value = true;
    _api.checkLocationOutsideBoundary(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          CheckOutsideBoundaryResponse response =
              CheckOutsideBoundaryResponse.fromJson(
                  jsonDecode(responseModel.result!));
          if (response.outSideBoundary ?? false) {
            AppUtils.showApiResponseMessage(response.message ?? "");
          } else {
            addressController.value.text = address;
            this.addressId = addressId;
            if (tradeId != 0) {
              typeOfWorkController.value.text = "";
              typeOfWorkId = 0;
              companyTaskId = 0;

              selectedTypeOfWorkList.clear();
              setTypeOfWorkText();

              typeOfWorkList.clear();
              getTypeOfWorkResourcesApi(
                  addressId: addressId, isPriceWork: isPriceWork);
            }
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
      setLocationPin(center.value);
      final currentPosition = await mapController.getZoomLevel();
      print("currentPosition:" + currentPosition.toString());
      mapController.moveCamera(
        CameraUpdate.newLatLngZoom(
          center.value, // target
          currentPosition, // zoom level
        ),
      );
      //   mapController.animateCamera(CameraUpdate.newCameraPosition(
      //   CameraPosition(target: center.value, zoom: 15),
      // ));
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
      AppConstants.intentKey.beforePhotosList: listPhotos,
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
          var filesList = <FilesInfo>[].obs;
          filesList
              .addAll(arguments[AppConstants.intentKey.beforePhotosList] ?? []);
          selectedTypeOfWorkList[selectedPhotosIndex].beforeAttachments = [];
          selectedTypeOfWorkList[selectedPhotosIndex]
              .beforeAttachments!
              .addAll(filesList);
          selectedTypeOfWorkList.refresh();
        }
      }
    }
  }

  bool isValidPhotos() {
    bool valid = true;
    for (var info in selectedTypeOfWorkList) {
      if (StringHelper.isEmptyList(info.beforeAttachments)) {
        valid = false;
        break;
      }
    }
    return valid;
  }

  void setTypeOfWorkText() {
    if (selectedTypeOfWorkList.isNotEmpty) {
      typeOfWorkController.value.text =
          "${selectedTypeOfWorkList.length} ${'task_selected'.tr}";
    } else {
      typeOfWorkController.value.text = "";
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

  Future<void> typeOfWorkDetails(TypeOfWorkResourcesInfo info) async {
    var result;

    var arguments = {
      AppConstants.intentKey.typeOfWorkInfo: info,
      AppConstants.intentKey.isEditable: false,
      AppConstants.intentKey.beforePhotosList: info.beforeAttachments ?? [],
    };

    result = await Navigator.of(Get.context!)
        .pushNamed(AppRoutes.typeOfWorkDetailsScreen, arguments: arguments);

    if (result != null) {
      var arguments = result;
      if (arguments != null) {
        // if (photosType == AppConstants.type.beforePhotos) {
        //   var filesList = <FilesInfo>[].obs;
        //   filesList
        //       .addAll(arguments[AppConstants.intentKey.beforePhotosList] ?? []);
        //   selectedTypeOfWorkList[selectedPhotosIndex].beforeAttachments = [];
        //   selectedTypeOfWorkList[selectedPhotosIndex]
        //       .beforeAttachments!
        //       .addAll(filesList);
        //   selectedTypeOfWorkList.refresh();
        // }
      }
    }
  }

  void onSelectTypeOfWorkPhotos(int position) {
    selectedPhotosIndex = position;
    onSelectPhotos(AppConstants.type.beforePhotos,
        selectedTypeOfWorkList[position].beforeAttachments ?? []);
  }

  void showSelectTypeOfWorkDialog() {
    // if (typeOfWorkList.isNotEmpty) {
    if (tradeId != 0) {
      Get.bottomSheet(
          SelectTypeOfWorkDialog(
            dialogType: AppConstants.dialogIdentifier.selectTypeOfWork,
            list: typeOfWorkList,
            selectedItemList: selectedTypeOfWorkList,
            listener: this,
          ),
          backgroundColor: Colors.transparent,
          isScrollControlled: true);
    } else {
      AppUtils.showToastMessage('please_select_trade'.tr);
    }
    // } else {
    //   AppUtils.showToastMessage('empty_data_message'.tr);
    // }
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
      checkLocationOutsideBoundaryApi(id, name);
    } else if (action == AppConstants.dialogIdentifier.selectTrade) {
      tradeController.value.text = name;
      tradeId = id;

      typeOfWorkController.value.text = "";
      typeOfWorkId = 0;
      companyTaskId = 0;

      selectedTypeOfWorkList.clear();
      setTypeOfWorkText();

      typeOfWorkList.clear();
      getTypeOfWorkResourcesApi(addressId: addressId, isPriceWork: isPriceWork);
    } else if (action == AppConstants.dialogIdentifier.selectTypeOfWork) {
      typeOfWorkController.value.text = name;
      typeOfWorkId = id;
    } else if (action == AppConstants.dialogIdentifier.selectLocation) {
      locationController.value.text = name;
      locationId = id;
    }
  }

  /*@override
  void onSelectTypeOfWork(int position, int typeOfWorkId, int companyTaskId,
      String name, String action) {
    if (action == AppConstants.dialogIdentifier.selectTypeOfWork) {
      typeOfWorkController.value.text = name;
      this.typeOfWorkId = typeOfWorkId;
      this.companyTaskId = companyTaskId;
    } else if (action == AppConstants.dialogIdentifier.selectTypeOfDayWork) {
      typeOfWorkList.clear();
      getTypeOfWorkResourcesApi(
          addressId: 0, isPriceWork: false, isFromDialog: true);
    }
  }*/

  @override
  void onSelectTypeOfWork(
      List<TypeOfWorkResourcesInfo> listSelectedItems, String action) {
    if (action == AppConstants.dialogIdentifier.selectTypeOfWork) {
      selectedTypeOfWorkList.clear();
      selectedTypeOfWorkList.value = listSelectedItems;
      setTypeOfWorkText();
      // typeOfWorkController.value.text = name;
      // this.typeOfWorkId = typeOfWorkId;
      // this.companyTaskId = companyTaskId;
    } else if (action == AppConstants.dialogIdentifier.selectTypeOfDayWork) {
      typeOfWorkList.clear();
      getTypeOfWorkResourcesApi(
          addressId: 0, isPriceWork: false, isFromDialog: true);
    }
  }

  List<String> listParamIds() {
    List<String> listIds = [];
    List<String> listTypeOfWorkIds = [];
    List<String> listTaskIds = [];

    for (var item in selectedTypeOfWorkList) {
      if ((item.typeOfWorkId ?? 0) != 0 && (item.companyTaskId ?? 0) == 0) {
        listTypeOfWorkIds.add(item.typeOfWorkId.toString());
      } else if ((item.typeOfWorkId ?? 0) == 0 &&
          (item.companyTaskId ?? 0) != 0) {
        listTaskIds.add(item.companyTaskId.toString());
      }
    }

    String typeOfWorkIds = listTypeOfWorkIds.join(",");
    String taskIds = listTaskIds.join(",");
    listIds.add(typeOfWorkIds);
    listIds.add(taskIds);

    return listIds;
  }

  Future<void> setLocationPin(LatLng? latLng) async {
    if (latLng != null) {
      final icon = await MapUtils.createIcon(
          assetPath: Drawable.bluePin, width: 24, height: 34);
      final newMarker = Marker(
        markerId: MarkerId('checkin'),
        position: latLng,
        icon: icon,
        infoWindow: InfoWindow(title: 'Check In'),
      );

      // Important: copy the existing markers to trigger reactive update
      // final updatedMarkers = Set<Marker>.from(markers);
      // updatedMarkers.add(newMarker);
      // markers.value = updatedMarkers;

      markers.removeWhere((m) => m.markerId == newMarker.markerId);
      markers.add(newMarker);
      markers.refresh();
    }
  }
}
