import 'dart:convert';

import 'package:belcka/pages/leaves/leave_history/controller/leave_history_repository.dart';
import 'package:belcka/pages/leaves/leave_history/model/leave_history_response.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:get/get.dart';

class LeaveHistoryController extends GetxController {
  final _api = LeaveHistoryRepository();

  final isLoading = false.obs;
  final isInternetNotAvailable = false.obs;
  final isMainViewVisible = false.obs;
  final selectedDateFilterIndex = 1.obs;

  final listItems = <LeaveHistoryInfo>[].obs;
  String startDate = "";
  String endDate = "";
  int userId = 0;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      userId = arguments[AppConstants.intentKey.userId] ?? 0;
    }
    // if (userId == 0) {
    //   userId = UserUtils.getLoginUserId();
    // }
    getLeaveHistory(true);
  }

  void getLeaveHistory(bool showProgress) {
    isLoading.value = showProgress;
    final map = <String, dynamic>{};
    map["company_id"] = ApiConstants.companyId;
    if (userId != 0) map["user_id"] = userId;
    map["start_date"] = startDate;
    map["end_date"] = endDate;
    map["type"] = AppConstants.requestType.leave;

    _api.getLeaveHistory(
      queryParameters: map,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.isSuccess && responseModel.result != null) {
          final response =
              LeaveHistoryResponse.fromJson(jsonDecode(responseModel.result!));
          final rawList = response.info ?? <LeaveHistoryInfo>[];
          print("rawList:"+rawList.length.toString());
          final leaveOnly = rawList
              .where((item) => (item.typeName ?? "").toLowerCase() == "leave")
              .toList();
          print("leaveOnly:"+leaveOnly.length.toString());
          listItems.value = leaveOnly;
          listItems.refresh();
          isMainViewVisible.value = true;
          isInternetNotAvailable.value = false;
        } else {
          AppUtils.showApiResponseMessage(responseModel.statusMessage ?? "");
        }
        isLoading.value = false;
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
        } else if ((error.statusMessage ?? "").isNotEmpty) {
          AppUtils.showApiResponseMessage(error.statusMessage ?? "");
        }
      },
    );
  }
}
