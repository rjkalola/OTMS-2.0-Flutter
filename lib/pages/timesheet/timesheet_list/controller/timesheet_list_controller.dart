import 'package:get/get.dart';
import 'package:otm_inventory/pages/timesheet/timesheet_list/controller/timesheet_list_repository.dart';

class TimeSheetListController extends GetxController {
  final RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs;
  final _api = TimesheetListRepository();

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      // fromSignUp.value =
      //     arguments[AppConstants.intentKey.fromSignUpScreen] ?? "";
    }
  }
}
