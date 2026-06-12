import 'dart:convert';

import 'package:belcka/pages/project/check_in_records/model/check_in_records_info.dart';
import 'package:belcka/pages/project/check_in_records/model/check_in_records_response.dart';
import 'package:belcka/pages/workshop/workshop_user_checklogs/controller/workshop_user_checklogs_repository.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class WorkshopUserChecklogsController extends GetxController {
  final _api = WorkshopUserChecklogsRepository();

  final listItems = <CheckInRecordsInfo>[].obs;
  final selectedDateFilterIndex = 1.obs;
  final isLoading = false.obs;
  final isInternetNotAvailable = false.obs;
  final isMainViewVisible = false.obs;

  String startDate = '';
  String endDate = '';
  int userId = 0;
  String userName = '';

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      userId = arguments[AppConstants.intentKey.userId] ?? 0;
      userName = arguments[AppConstants.intentKey.userName] ?? '';
      startDate = arguments[AppConstants.intentKey.startDate] ?? '';
      endDate = arguments[AppConstants.intentKey.endDate] ?? '';
      selectedDateFilterIndex.value =
          arguments[AppConstants.intentKey.index] ?? 1;
    }
    getWorkshopUserChecklogsApi(true);
  }

  void getWorkshopUserChecklogsApi(bool isProgress) {
    isLoading.value = isProgress;
    final map = <String, dynamic>{
      'user_id': userId,
      'start_date': startDate,
      'end_date': endDate,
    };

    _api.getWorkshopUserChecklogs(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess && responseModel.result != null) {
          isMainViewVisible.value = true;
          final response = CheckInRecordsResponse.fromJson(
              jsonDecode(responseModel.result!) as Map<String, dynamic>);
          if (response.isSuccess == true) {
            listItems.assignAll(response.info ?? []);
          } else {
            AppUtils.showSnackBarMessage(response.message ?? '');
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage ?? '');
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if (!StringHelper.isEmptyString(error.statusMessage)) {
          AppUtils.showSnackBarMessage(error.statusMessage ?? '');
        }
      },
    );
  }

  void clearFilter() {
    startDate = '';
    endDate = '';
    selectedDateFilterIndex.value = -1;
  }

  Future<void> moveToChecklogDetails(int checkLogId) async {
    final arguments = {
      AppConstants.intentKey.checkLogId: checkLogId,
    };
    final result =
        await Get.toNamed(AppRoutes.checkOutScreen, arguments: arguments);
    if (result != null && result) {
      getWorkshopUserChecklogsApi(true);
    }
  }
}
