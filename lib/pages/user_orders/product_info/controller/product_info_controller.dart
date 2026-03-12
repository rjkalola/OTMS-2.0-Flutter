import 'dart:convert';
import 'package:belcka/pages/common/model/file_info.dart';
import 'package:belcka/pages/user_orders/product_details/model/product_details_response.dart';
import 'package:belcka/pages/user_orders/product_info/controller/product_info_repository.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class ProductInfoController extends GetxController{
  RxBool isDeliverySelected = true.obs;
  final _api = ProductInfoRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;

  int productId = 0;
  final product = ProductInfo().obs;
  bool isDataUpdated = false;
  final Map<int, int> currentImageIndex = {};

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      productId = arguments["product_id"] ?? 0;
    }
    fetchProductDetails();
  }
  void fetchProductDetails() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["product_id"] = productId;

    _api.getProductDetailsAPI(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          ProductDetailsResponse response =
          ProductDetailsResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.info != null){
            product.value = response.info!;
            prepareProductImages();
          }
          isMainViewVisible.value = true;
        }
        else{
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }
  void prepareProductImages() {
    if (product.value.productImages == null) {
      product.value.productImages = [];
    }

    final exists = product.value.productImages!.any((img) => img.imageUrl == product.value.imageUrl);
    if (!exists) {
      product.value.productImages!.insert(
        0,
        FilesInfo(
          id: 0,
          imageUrl: product.value.imageUrl,
          thumbUrl: product.value.thumbUrl,
        ),
      );
    }
  }
  void toggleBookmark() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    map["product_id"] = product.value.id;

    _api.bookmarkAPI(
      data: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isDataUpdated = true;
          fetchProductDetails();
        }
        else{
          isLoading.value = false;
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  void onBackPress() {
    Get.back(result: isDataUpdated);
  }
}