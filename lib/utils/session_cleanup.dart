import 'package:belcka/pages/check_in/user_check_in/controller/user_check_in_controller.dart';
import 'package:belcka/pages/check_in/user_check_out/controller/user_check_out_controller.dart';
import 'package:belcka/pages/check_in/user_clock_in/controller/user_clock_in_controller.dart';
import 'package:belcka/pages/check_in/user_stop_shift/controller/user_stop_shift_controller.dart';
import 'package:get/get.dart';

class SessionCleanup {
  static void clearControllersOnLogout() {
    _deleteIfRegistered<UserClockInController>();
    _deleteIfRegistered<UserCheckInController>();
    _deleteIfRegistered<UserCheckOutController>();
    _deleteIfRegistered<UserStopShiftController>();
  }

  static void _deleteIfRegistered<T>() {
    if (Get.isRegistered<T>()) {
      Get.delete<T>(force: true);
    }
  }
}
