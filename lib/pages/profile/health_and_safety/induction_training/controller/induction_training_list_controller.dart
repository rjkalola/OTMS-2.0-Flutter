import 'dart:convert';
import 'package:belcka/pages/profile/health_and_safety/induction_training/controller/induction_training_list_repository.dart';
import 'package:belcka/pages/profile/health_and_safety/induction_training/model/induction_info_model.dart';
import 'package:belcka/pages/profile/health_and_safety/induction_training/model/induction_response.dart';
import 'package:belcka/pages/profile/health_and_safety/near_miss_list/controller/near_miss_list_repository.dart';
import 'package:belcka/pages/profile/health_and_safety/near_miss_list/model/near_miss_report_Info.dart';
import 'package:belcka/pages/profile/health_and_safety/near_miss_list/model/near_miss_response.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as dio;

class InductionTrainingListController extends GetxController{
  final _api = InductionTrainingListRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;

  final inductionTrainingList = <InductionInfoModel>[].obs;
  List<InductionInfoModel> tempList = [];

  @override
  void onInit() {
    super.onInit();
    fetchInductionTrainingList();
  }

  void fetchInductionTrainingList() {
    isLoading.value = true;
    Map<String, dynamic> map = {};
    map["company_id"] = ApiConstants.companyId;

    _api.getInductionTrainingListAPI(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {

          InductionResponse response = InductionResponse.fromJson(
              jsonDecode(responseModel.result!));

          tempList.clear();
          tempList.addAll(response.info ?? []);

          inductionTrainingList.value = tempList;
          inductionTrainingList.refresh();


          isMainViewVisible.value = true;
          isLoading.value = false;

        }
        else{
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? "");
          isLoading.value = false;
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

  Future<void> moveToScreen(String rout, dynamic arguments) async {
    var result = await Get.toNamed(rout, arguments: arguments);
    if (result != null && result) {
      fetchInductionTrainingList();
    }
  }

  void onBackPress() {
    Get.back(result: true);
  }
}