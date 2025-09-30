import 'dart:convert';

import 'package:belcka/pages/common/listener/menu_item_listener.dart';
import 'package:belcka/pages/common/menu_items_list_bottom_dialog.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:belcka/pages/check_in/check_in/controller/check_in_repository.dart';
import 'package:belcka/pages/check_in/check_in/model/check_in_resources_response.dart';
import 'package:belcka/pages/check_in/check_in/model/type_of_work_resources_info.dart';
import 'package:belcka/pages/check_in/check_in/model/type_of_work_resources_response.dart';
import 'package:belcka/pages/check_in/check_out/controller/check_out_repository.dart';
import 'package:belcka/pages/check_in/check_out/model/check_log_details_response.dart';
import 'package:belcka/pages/check_in/clock_in/controller/clock_in_utils_.dart';
import 'package:belcka/pages/check_in/clock_in/model/check_log_info.dart';
import 'package:belcka/pages/check_in/dialogs/select_type_of_work_dialog.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/listener/select_type_of_work_listener.dart';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/location_service_new.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/web_services/response/response_model.dart';

import '../../../../utils/app_constants.dart';
import '../../../common/drop_down_list_dialog.dart';

class CheckOutController extends GetxController
    implements SelectItemListener, SelectTypeOfWorkListener, MenuItemListener {
  final RxBool isLoading = false.obs,
      isMainViewVisible = false.obs,
      isInternetNotAvailable = false.obs,
      isLocationLoaded = true.obs,
      isPriceWork = false.obs;
  final RxInt progress = 0.obs;
  final _api = CheckOutRepository();
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
  int checkLogId = 0,
      addressId = 0,
      tradeId = 0,
      typeOfWorkId = 0,
      locationId = 0,
      companyTaskId = 0,
      projectId = 0,
      initialProgress = 0,
      selectedPhotosIndex = 0;
  String date = "", selectedPhotosType = "";

  bool isCurrentDay = true;
  final listBeforePhotos = <FilesInfo>[].obs;
  final listAfterPhotos = <FilesInfo>[].obs;
  final checkLogInfo = CheckLogInfo().obs;
  final checkInTime = "".obs, checkOutTime = "".obs;
  final listBeforeRemoveIds = <String>[];
  CheckInResourcesResponse? checkInResourcesData;
  final addressList = <ModuleInfo>[].obs;
  final tradeList = <ModuleInfo>[].obs;
  final typeOfWorkList = <TypeOfWorkResourcesInfo>[].obs;
  final selectedTypeOfWorkList = <TypeOfWorkResourcesInfo>[].obs;

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
      isPriceWork.value =
          arguments[AppConstants.intentKey.isPriceWork] ?? false;
      print("isPriceWork.value:" + isPriceWork.value.toString());
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
    locationController.value.text = checkLogInfo.value.locationName ?? "-";
    tradeController.value.text = checkLogInfo.value.tradeName ?? "-";
    typeOfWorkController.value.text = checkLogInfo.value.companyTaskName ?? "-";

    addressId = checkLogInfo.value.addressId ?? 0;
    tradeId = checkLogInfo.value.tradeId ?? 0;
    companyTaskId = checkLogInfo.value.companyTaskTd ?? 0;
    locationId = checkLogInfo.value.locationId ?? 0;

    /*for (var before in checkLogInfo.value.beforeAttachments!) {
      listBeforePhotos.add(FilesInfo(
          id: before.id, imageUrl: before.imageUrl, thumbUrl: before.thumbUrl));
    }

    for (var after in checkLogInfo.value.afterAttachments!) {
      listAfterPhotos.add(FilesInfo(
          id: after.id, imageUrl: after.imageUrl, thumbUrl: after.thumbUrl));
    }*/

    selectedTypeOfWorkList.addAll(checkLogInfo.value.taskList ?? []);
    setTypeOfWorkText();
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
          initialProgress = response.totalProgress ?? 0;
          progress.value =
              StringHelper.isEmptyString(checkLogInfo.value.checkoutDateTime)
                  ? ((response.totalProgress ?? 0) == 0
                      ? 100
                      : response.totalProgress ?? 0)
                  : (checkLogInfo.value.progress ?? 0);
          // isPriceWork.value = response.info!.isPricework ?? false;
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
    /* map["total_progress"] = progress.value;
    if (initialProgress == 0) {
      map["new_progress"] = progress.value;
    } else {
      map["new_progress"] = progress.value - initialProgress;
    }*/
    map["address_id"] = addressId;
    map["trade_id"] = tradeId;
    // map["company_task_id"] = companyTaskId;
    // map["type_of_work_id"] = typeOfWorkId;
    map["comment"] = StringHelper.getText(noteController.value);
    map["before_attachment_remove_ids"] =
        StringHelper.getCommaSeparatedStringIds(listBeforeRemoveIds);
    map["location"] = location;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    for (int i = 0; i < selectedTypeOfWorkList.length; i++) {
      map["new_progress[${selectedTypeOfWorkList[i].companyTaskId}]"] =
          (selectedTypeOfWorkList[i].progress ?? 0) > 0
              ? (selectedTypeOfWorkList[i].progress ?? 0)
              : 100;
    }

    multi.FormData formData = multi.FormData.fromMap(map);
    print("reques value:" + map.toString());

    /* List<FilesInfo> listBefore = [];
    for (var before in listBeforePhotos) {
      if (!StringHelper.isEmptyString(before.imageUrl) &&
          (before.id ?? 0) == 0) {
        listBefore.add(before);
      }
    }
    for (int i = 0; i < listBefore.length; i++) {
      print("before:" + listBefore[i].imageUrl!);
      formData.files.add(
        MapEntry(
          "before_attachments[]",
          // or just 'images' depending on your backend
          await multi.MultipartFile.fromFile(
            listBefore[i].imageUrl ?? "",
          ),
        ),
      );
    }

    List<FilesInfo> listAfter = [];
    for (var after in listAfterPhotos) {
      if (!StringHelper.isEmptyString(after.imageUrl) && (after.id ?? 0) == 0) {
        listAfter.add(after);
      }
    }
    for (int i = 0; i < listAfter.length; i++) {
      print("after:" + listAfter[i].imageUrl!);
      formData.files.add(
        MapEntry(
          "after_attachments[]",
          // or just 'images' depending on your backend
          await multi.MultipartFile.fromFile(
            listAfter[i].imageUrl ?? "",
          ),
        ),
      );
    }*/

    for (int i = 0; i < selectedTypeOfWorkList.length; i++) {
      print("index:" + i.toString());
      List<FilesInfo> listBeforePhotos = [];
      for (var photo in selectedTypeOfWorkList[i].beforeAttachments!) {
        if (!StringHelper.isEmptyString(photo.imageUrl) &&
            (photo.id ?? 0) == 0) {
          listBeforePhotos.add(photo);
        }
      }
      for (var photo in listBeforePhotos) {
        print(
            "before_company_task_attachments[${selectedTypeOfWorkList[i].companyTaskId}]:" +
                photo.imageUrl!);
        formData.files.add(
          MapEntry(
            "before_company_task_attachments[${selectedTypeOfWorkList[i].companyTaskId}]",
            await multi.MultipartFile.fromFile(
              photo.imageUrl ?? "",
            ),
          ),
        );
      }

      List<FilesInfo> listAfterPhotos = [];
      for (var photo in selectedTypeOfWorkList[i].afterAttachments!) {
        if (!StringHelper.isEmptyString(photo.imageUrl) &&
            (photo.id ?? 0) == 0) {
          listAfterPhotos.add(photo);
        }
      }

      for (var photo in listAfterPhotos) {
        print(
            "after_company_task_attachments[${selectedTypeOfWorkList[i].companyTaskId}]:" +
                photo.imageUrl!);
        formData.files.add(
          MapEntry(
            "after_company_task_attachments[${selectedTypeOfWorkList[i].companyTaskId}]",
            await multi.MultipartFile.fromFile(
              photo.imageUrl ?? "",
            ),
          ),
        );
      }
    }
    print("------------------------------------------------");

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

  void getTypeOfWorkResourcesApi() async {
    Map<String, dynamic> map = {};
    map["trade_id"] = tradeId;
    map["address_id"] = addressId;
    map["company_id"] = ApiConstants.companyId;
    map["is_pricework"] = isPriceWork;
    isLoading.value = true;
    CheckInRepository().getTypeOfWorkResources(
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

  void onSelectTypeOfWorkPhotos(int position) {
    selectedPhotosIndex = position;
    /* onSelectPhotos(
        selectedTypeOfWorkList[selectedPhotosIndex].beforeAttachments ?? [],
        selectedTypeOfWorkList[selectedPhotosIndex].afterAttachments ?? []);*/
    // showPhotosTypeDialog(Get.context!);
    onSelectPhotos(AppConstants.type.afterPhotos,
        selectedTypeOfWorkList[position].afterAttachments ?? []);
  }

  Future<void> typeOfWorkDetails(TypeOfWorkResourcesInfo info) async {
    var result;

    var arguments = {
      AppConstants.intentKey.typeOfWorkInfo: info,
      AppConstants.intentKey.afterPhotosList: info.afterAttachments ?? [],
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

  void showPhotosTypeDialog(BuildContext context) {
    List<ModuleInfo> listItems = [];
    // listItems.add(ModuleInfo(
    //     name: 'archive'.tr, action: AppConstants.action.archiveShift));
    listItems.add(ModuleInfo(
        name: 'photos_before'.tr, action: AppConstants.action.beforePhotos));
    listItems.add(ModuleInfo(
        name: 'photos_after'.tr, action: AppConstants.action.afterPhotos));
    showCupertinoModalPopup(
      context: context,
      builder: (_) =>
          MenuItemsListBottomDialog(list: listItems, listener: this),
    );
  }

  @override
  void onSelectMenuItem(ModuleInfo info, String dialogType) {
    // if (info.action == AppConstants.action.beforePhotos) {
    //   selectedPhotosType = AppConstants.type.beforePhotos;
    //   onSelectPhotos(selectedPhotosType,
    //       selectedTypeOfWorkList[selectedPhotosIndex].beforeAttachments ?? []);
    // } else if (info.action == AppConstants.action.afterPhotos) {
    //   selectedPhotosType = AppConstants.type.afterPhotos;
    //   onSelectPhotos(selectedPhotosType,
    //       selectedTypeOfWorkList[selectedPhotosIndex].afterAttachments ?? []);
    // }
  }

  /* Future<void> onSelectPhotos(
      List<FilesInfo> listBeforePhotos, List<FilesInfo> listAfterPhotos) async {
    var result;
    var arguments = {
      AppConstants.intentKey.removeIdsList: listBeforeRemoveIds,
      AppConstants.intentKey.beforePhotosList: listBeforePhotos,
      AppConstants.intentKey.afterPhotosList: listAfterPhotos,
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
        // photosType = arguments[AppConstants.intentKey.photosType] ?? "";
        */ /* if (photosType == AppConstants.type.beforePhotos) {
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
        }*/ /*
        // if (photosType == AppConstants.type.beforePhotos) {

        var beforeList = <FilesInfo>[].obs;
        beforeList
            .addAll(arguments[AppConstants.intentKey.beforePhotosList] ?? []);
        selectedTypeOfWorkList[selectedPhotosIndex].beforeAttachments = [];
        selectedTypeOfWorkList[selectedPhotosIndex]
            .beforeAttachments!
            .addAll(beforeList);
        listBeforeRemoveIds.clear();
        listBeforeRemoveIds
            .addAll(arguments[AppConstants.intentKey.removeIdsList] ?? []);

        // selectedTypeOfWorkList.refresh();
        // } else if (photosType == AppConstants.type.afterPhotos) {

        var afterList = <FilesInfo>[].obs;
        afterList
            .addAll(arguments[AppConstants.intentKey.afterPhotosList] ?? []);
        selectedTypeOfWorkList[selectedPhotosIndex].afterAttachments = [];
        selectedTypeOfWorkList[selectedPhotosIndex]
            .afterAttachments!
            .addAll(afterList);

        selectedTypeOfWorkList.refresh();

        // }
      }
    }
  }*/

  Future<void> onSelectPhotos(
      String photosType, List<FilesInfo> listPhotos) async {
    var result;
    var arguments = {
      AppConstants.intentKey.photosType: photosType,
      AppConstants.intentKey.afterPhotosList: listPhotos,
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
        if (photosType == AppConstants.type.afterPhotos) {
          var filesList = <FilesInfo>[].obs;
          filesList
              .addAll(arguments[AppConstants.intentKey.afterPhotosList] ?? []);
          selectedTypeOfWorkList[selectedPhotosIndex].afterAttachments = [];
          selectedTypeOfWorkList[selectedPhotosIndex]
              .afterAttachments!
              .addAll(filesList);
          selectedTypeOfWorkList.refresh();
        }
      }
    }
  }

  bool isValidPhotos() {
    bool valid = true;
    for (var info in selectedTypeOfWorkList) {
      if (StringHelper.isEmptyList(info.beforeAttachments) ||
          StringHelper.isEmptyList(info.afterAttachments)) {
        valid = false;
        break;
      }
    }
    return valid;
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
    if (typeOfWorkList.isNotEmpty) {
      Get.bottomSheet(
          SelectTypeOfWorkDialog(
            dialogType: AppConstants.dialogIdentifier.selectTypeOfWork,
            list: typeOfWorkList,
            selectedItemList: [],
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
    } else if (action == AppConstants.dialogIdentifier.selectTypeOfWork) {
      typeOfWorkController.value.text = name;
      typeOfWorkId = id;
    }
  }

  // @override
  // void onSelectTypeOfWork(int position, int typeOfWorkId, int companyTaskId,
  //     String name, String action) {
  //   if (action == AppConstants.dialogIdentifier.selectTypeOfWork) {
  //     typeOfWorkController.value.text = name;
  //     this.typeOfWorkId = typeOfWorkId;
  //     this.companyTaskId = companyTaskId;
  //   }
  // }

  @override
  void onSelectTypeOfWork(
      List<TypeOfWorkResourcesInfo> listAllItems, String action) {}

  void setTypeOfWorkText() {
    if (selectedTypeOfWorkList.isNotEmpty) {
      typeOfWorkController.value.text =
          "${selectedTypeOfWorkList.length} ${'task_selected'.tr}";
    } else {
      typeOfWorkController.value.text = "-";
    }
  }

  List<String> getTaskIds() {
    List<String> listIds = [];
    // List<String> listTypeOfWorkIds = [];
    List<String> listTaskIds = [];

    for (var item in selectedTypeOfWorkList) {
      listTaskIds.add((item.companyTaskId ?? 0).toString());
    }

    // String typeOfWorkIds = listTypeOfWorkIds.join(",");
    // listIds.add(typeOfWorkIds);

    String taskIds = listTaskIds.join(",");
    listIds.add(taskIds);

    return listIds;
  }
}
