import 'dart:convert';

import 'package:belcka/buyer_app/categories/catalogue_list/controller/buyer_catalogue_repository.dart';
import 'package:belcka/buyer_app/categories/catalogue_list/model/category_info.dart';
import 'package:belcka/buyer_app/categories/catalogue_list/model/category_list_response.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class BuyerCatalogueController extends GetxController {
  final _api = BuyerCatalogueRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  double cardRadius = 12;
  final listItems = <CategoryInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    buyerCatalogueListApi(true);
  }

  void buyerCatalogueListApi(bool isProgress) {
    isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;
    _api.buyerCatalogueList(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          isMainViewVisible.value = true;
          CategoryListResponse response =
              CategoryListResponse.fromJson(jsonDecode(responseModel.result!));
          listItems.value = response.info!;
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          // AppUtils.showSnackBarMessage('no_internet'.tr);
          // Utils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? "");
        }
      },
    );
  }

  Future<void> moveToScreen(
      {required String appRout, dynamic arguments}) async {
    var result = await Get.toNamed(appRout, arguments: arguments);
    if(result != null && result){
      buyerCatalogueListApi(true);
    }

  }

  void onBackPress() {
    Get.back(result: true);
  }
}
