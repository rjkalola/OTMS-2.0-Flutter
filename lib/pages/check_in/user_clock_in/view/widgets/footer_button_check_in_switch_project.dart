import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/check_in/user_clock_in/controller/user_clock_in_controller.dart';
import 'package:belcka/res/colors.dart';

class FooterButtonCheckInSwitchProject extends StatelessWidget {
  FooterButtonCheckInSwitchProject({super.key});

  final controller = Get.put(UserClockInController());

  static const Color _stopColor = Color(0xFFFF484B);
  static const Color _swapColor = Color(0xFF0D6EFD);
  static const Color _swapGlowColor = Color(0xFF007AFF);
  static const Color _checkInColor = Color(0xFF32A852);
  static const Color _disabledColor = Color(0xFF9E9E9E);

  List<BoxShadow> _glowShadow(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.62),
          blurRadius: 10,
        ),
      ];

  void _onStopShiftPressed() {
    if (controller.isChecking.value) {
      controller.showCheckOutWarningDialog();
    } else {
      controller.showStopWorkConfirmDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isWorking = controller.workLogData.value.userIsWorking ?? false;
      final isOnLeave = controller.isOnLeave.value;

      if (!isWorking && isOnLeave) {
        return const SizedBox.shrink();
      }

      return Container(
        decoration: BoxDecoration(
          color: backgroundColor_(context),
          border: Border.all(
            color: Colors.black.withOpacity(0.08),
            width: 1,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: isWorking
                ? Row(
                    children: [
                      Expanded(
                        child: _buildStopButton(),
                      ),
                      const SizedBox(width: 10),
                      _buildSwapButton(),
                      const SizedBox(width: 10),
                      if (controller.workLogData.value.isCheckIn ?? false)
                        Expanded(
                          child: _buildCheckInButton(),
                        ),
                    ],
                  )
                : _buildStartShiftButton(),
          ),
        ),
      );
    });
  }

  Widget _buildStopButton() {
    final isDisabled = controller.isChecking.value;

    return GestureDetector(
      onTap: _onStopShiftPressed,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: isDisabled ? _disabledColor : _stopColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: _glowShadow(isDisabled ? _disabledColor : _stopColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isDisabled) ...[
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Text(
              'stop_shift'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwapButton() {
    return GestureDetector(
      onTap: () {
        controller.getFormSubmissionStatusApi(isSwitchProject: true);
      },
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: _swapColor,
          shape: BoxShape.circle,
          boxShadow: _glowShadow(_swapGlowColor),
        ),
        child: const Icon(
          Icons.swap_horiz_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildCheckInButton() {
    final isChecking = controller.isChecking.value;
    final canCheckIn = controller.workLogData.value.isCheckIn ?? false;
    final isEnabled = isChecking || canCheckIn;
    final color = isChecking
        ? _stopColor
        : canCheckIn
            ? _checkInColor
            : _disabledColor;

    return GestureDetector(
      onTap: isEnabled
          ? () {
              if (isChecking) {
                controller.onCLickCheckOutButton();
              } else {
                controller.onCLickCheckInButton();
              }
            }
          : null,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isEnabled ? _glowShadow(color) : null,
        ),
        child: Center(
          child: Text(
            isChecking ? 'check_out_'.tr : 'check_in_'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartShiftButton() {
    return GestureDetector(
      onTap: () {
        controller.getFormSubmissionStatusApi(isSwitchProject: false);
      },
      child: Container(
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
          color: _checkInColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: _glowShadow(_checkInColor),
        ),
        child: Center(
          child: Text(
            'start_shift'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
