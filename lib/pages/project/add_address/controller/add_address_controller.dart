import 'dart:convert';

import 'package:belcka/pages/project/add_address/controller/add_address_repository.dart';
import 'package:belcka/pages/project/address_list/model/address_info.dart';
import 'package:belcka/pages/project/project_info/model/project_info.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/google_place_service.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAddressController extends GetxController {
  final siteAddressController = TextEditingController().obs;
  final searchAddressController = TextEditingController().obs;

  final formKey = GlobalKey<FormState>();
  final _api = AddAddressRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSaveEnable = false.obs,
      isClearVisible = false.obs;

  final title = ''.obs;
  double latitude = 0, longitude = 0;

  ProjectInfo? projectInfo;
  AddressInfo? addressDetailsInfo;

  late GoogleMapController mapController;
  final selectedLatLng =
      LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude).obs;
  final RxDouble circleRadius = 50.0.obs; // meters
  final placesService =
      GooglePlacesService("AIzaSyAdLpTcvwOWzhK4maBtriznqiw5MwBNcZw");
  var searchResults = <Map<String, dynamic>>[].obs;

  RxSet<Circle> get circles => {
        Circle(
          circleId: const CircleId("circle"),
          center: selectedLatLng.value,
          radius: circleRadius.value,
          fillColor: Color(0x4D0065ff),
          strokeColor: Colors.blue,
          strokeWidth: 2,
        )
      }.obs;

  RxSet<Marker> get marker => {
        Marker(
          markerId: MarkerId("center"),
          position: selectedLatLng.value,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: ""),
        )
      }.obs;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void onInit() {
    super.onInit();
    isMainViewVisible.value = true;
    var arguments = Get.arguments;
    if (arguments != null) {
      projectInfo = arguments[AppConstants.intentKey.projectInfo];
      addressDetailsInfo = arguments[AppConstants.intentKey.addressDetailsInfo];
    }
    if (addressDetailsInfo != null) {
      title.value = 'update_address'.tr;
      latitude = addressDetailsInfo?.latitude ?? 0;
      longitude = addressDetailsInfo?.longitude ?? 0;
      if (latitude != 0 && longitude != 0) {
        selectedLatLng.value = LatLng(latitude, longitude);
      }
      double radius = addressDetailsInfo?.radius?.toDouble() ?? 0;
      circleRadius.value = radius != 0 ? radius : 50;

      siteAddressController.value.text = addressDetailsInfo?.name ?? "";
    } else {
      title.value = 'add_address'.tr;
    }
  }

  void addAddressApi() async {
    if (valid()) {
      Map<String, dynamic> map = {};
      map["project_id"] = projectInfo?.id ?? 0;
      map["name"] = StringHelper.getText(siteAddressController.value);
      map["lat"] = latitude;
      map["lng"] = longitude;
      map["type"] = "circle";
      map["boundary"] =
          "{\"lat\":$latitude,\"lng\":$longitude,\"radius\":${circleRadius.value.toInt()}}";
      print("Data:" + map.toString());
      isLoading.value = true;
      _api.addAddress(
        data: map,
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
          } else if (error.statusMessage!.isNotEmpty) {
            AppUtils.showApiResponseMessage(error.statusMessage);
          }
        },
      );
    }
  }

  void updateAddressApi() async {
    if (valid()) {
      Map<String, dynamic> map = {};
      map["id"] = addressDetailsInfo?.id ?? 0;
      map["project_id"] = addressDetailsInfo?.projectId ?? 0;
      map["name"] = StringHelper.getText(siteAddressController.value);
      map["lat"] = latitude;
      map["lng"] = longitude;
      map["type"] = "circle";
      map["boundary"] =
          "{\"lat\":$latitude,\"lng\":$longitude,\"radius\":${circleRadius.value.toInt()}}";
      print("Data:" + map.toString());
      isLoading.value = true;
      _api.updateAddress(
        data: map,
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
          } else if (error.statusMessage!.isNotEmpty) {
            AppUtils.showApiResponseMessage(error.statusMessage);
          }
        },
      );
    }
  }

  void deleteAddressApi() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["id"] = projectInfo?.id ?? 0;
    _api.deleteAddress(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          AppUtils.showToastMessage(response.Message ?? "");
          Get.back(result: true);
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showApiResponseMessage('no_internet'.tr);
          // Utils.showApiResponseMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  bool valid() {
    return formKey.currentState!.validate();
  }

  Future<void> searchPlaces(String input) async {
    if (input.isEmpty) return;
    searchResults.value = await placesService.getAutocomplete(input);
  }

  Future<void> selectPlace(String placeId) async {
    final loc = await placesService.getLatLngFromPlaceId(placeId);
    final latLng = LatLng(loc['lat']!, loc['lng']!);
    latitude = latLng.latitude;
    longitude = latLng.longitude;

    selectedLatLng.value = latLng;
    // final controller = await mapController.future;
    mapController.animateCamera(CameraUpdate.newLatLng(latLng));
    searchResults.clear();
  }

  void clearSearch() {
    searchAddressController.value.text = "";
    isClearVisible.value = false;
    searchResults.clear();
    FocusScope.of(Get.context!).unfocus();
  }
}
