import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/pages/dashboard/controller/dashboard_controller.dart';
import 'package:otm_inventory/pages/dashboard/models/dashboard_response.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/controller/home_tab_repository.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/model/DashboardActionItemInfo.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/model/pie_chart_info.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/model/request_count_response.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

class HomeTabController extends GetxController {
  final _api = HomeTabRepository();
  RxBool isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isUpdateLocationVisible = false.obs,
      isUpdateLocationDividerVisible = false.obs,
      isNextUpdateLocationTimeVisible = false.obs,
      isStopTimer = false.obs;

  RxString nextUpdateLocationTime = "".obs,
      previousUpdateLocationTime = "".obs,
      updateLocationTime = "".obs,
      earningSummeryAmount = "".obs,
      totalWorkHours = "".obs;
  RxInt nextUpdateLocationId = 0.obs, previousUpdateLocationId = 0.obs;

  final List<List<DashboardActionItemInfo>> listHeaderButtons_ =
      DataUtils.generateChunks(DataUtils.getHeaderActionButtonsList(), 3).obs;
  final List<DashboardActionItemInfo> listHeaderButtons =
      DataUtils.getHeaderActionButtonsList().obs;
  final selectedActionButtonPagerPosition = 0.obs, pendingRequestCount = 0.obs;
  final dashboardActionButtonsController = PageController(
    initialPage: 0,
  );
  final dashboardController = Get.put(DashboardController());
  final dashboardResponse = DashboardResponse().obs;

  @override
  void onInit() {
    super.onInit();
    // getRegisterResources();
  }

  void onActionButtonClick(String action) {
    if (action == AppConstants.action.clockIn) {
      Get.toNamed(AppRoutes.clockInScreen);
    } else if (action == AppConstants.action.store) {
      Get.offNamed(AppRoutes.storeListScreen);
    } else if (action == AppConstants.action.stocks) {
      Get.offNamed(AppRoutes.stockListScreen);
    } else if (action == AppConstants.action.suppliers) {
      Get.offNamed(AppRoutes.supplierListScreen);
    } else if (action == AppConstants.action.categories) {
      Get.offNamed(AppRoutes.categoryListScreen);
    }
  }

  void getDashboardApi(bool isProgress) {
    dashboardController.isLoading.value = isProgress;
    _api.getDashboardResponse(
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          DashboardResponse response =
              DashboardResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            isMainViewVisible.value = true;
            dashboardResponse.value = response;
          /*  var user = Get.find<AppStorage>().getUserInfo();
            if ((response.userTypeId ?? 0) != 0) {
              Map<String, dynamic> updatedJson = {
                "user_type_id": response.userTypeId ?? 0,
                "is_owner": response.isOwner ?? false,
                "shift_id": response.shiftId ?? 0,
                "shift_name": response.shiftName ?? "",
                "shift_type": response.shiftType ?? 0,
                "team_id": response.teamId ?? 0,
                "team_name": response.teamName ?? "",
                "currency_symbol": response.currencySymbol ?? "\\u20b9",
                "company_id": response.companyId ?? 0,
                "company_name": response.companyName ?? "",
                "company_image": response.companyImage ?? "",
              };
              user = user.copyWith(
                  userTypeId: updatedJson['user_type_id'],
                  isOwner: updatedJson['is_owner'],
                  shiftId: updatedJson['shift_id'],
                  shiftName: updatedJson['shift_name'],
                  shiftType: updatedJson['shift_type'],
                  teamId: updatedJson['team_id'],
                  teamName: updatedJson['team_name'],
                  currencySymbol: updatedJson['currency_symbol'],
                  companyId: updatedJson['company_id'],
                  companyName: updatedJson['company_name'],
                  companyImage: updatedJson['company_image']);
              Get.find<AppStorage>().setUserInfo(user);
            }*/
            Get.find<AppStorage>().setDashboardResponse(response);
            if (!StringHelper.isEmptyString(response.checkinDateTime)) {
              isStopTimer.value = false;
              startTimer();
            } else {
              isStopTimer.value = true;
            }
            if ((response.companyId ?? 0) > 0) {
              getRequestCountApi(false);
            }
          } else {
            AppUtils.showSnackBarMessage(response.message!);
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
        dashboardController.isLoading.value = false;
      },
      onError: (ResponseModel error) {
        dashboardController.isLoading.value = false;
        // if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        //   isInternetNotAvailable.value = true;
        //   // Utils.showSnackBarMessage('no_internet'.tr);
        // } else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }

  void getRequestCountApi(bool isProgress) {
    _api.getRequestCountResponse(
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          RequestCountResponse response =
              RequestCountResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            pendingRequestCount.value = response.pendingCount ?? 0;
          } else {
            AppUtils.showSnackBarMessage(response.message!);
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
        // dashboardController.isLoading.value = false;
      },
      onError: (ResponseModel error) {
        // dashboardController.isLoading.value = false;
        // if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        //   isInternetNotAvailable.value = true;
        //   // Utils.showSnackBarMessage('no_internet'.tr);
        // } else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }

  void setInitData(DashboardResponse? response) {
    if (response != null) {
      dashboardResponse.value = response;
    }
  }

  startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (isStopTimer.value) {
        timer.cancel();
      }
      setNextUpdateLocationTime();
      earningSummeryAmount.value = getEarningSummery();
      totalWorkHours.value = getWorkingHours();
      print("timer running");
    });
  }

  void setNextUpdateLocationTime() {
    try {
      bool isTodayWorkStarted = false;
      final checkInDateFormat = DateFormat(DateUtil.YYYY_MM_DD_TIME_24_DASH2);
      final dateFormat = DateFormat(DateUtil.YYYY_MM_DD_DASH);
      if (!StringHelper.isEmptyString(
          dashboardResponse.value.checkinDateTime)) {
        DateTime checkInDate = checkInDateFormat
            .parse(dashboardResponse.value.checkinDateTime ?? "");
        isTodayWorkStarted = DateUtils.isSameDay(checkInDate, DateTime.now());
      }
     /* if (isTodayWorkStarted &&
          !StringHelper.isEmptyList(AppStorage().getUserInfo().locations)) {
        List<Locations> locations = AppStorage().getUserInfo().locations!;
        int index = -1;
        String checkInDate = dateFormat.format(
            checkInDateFormat.parse(dashboardResponse.value.checkinDateTime!));
        for (int i = 0; i < locations.length; i++) {
          DateTime time =
              checkInDateFormat.parse("$checkInDate ${locations[i].time!}");
          DateTime currentTime = DateTime.now();
          if (time.isAfter(currentTime)) {
            index = i;
            break;
          }
        }
        if (index != -1) {
          nextUpdateLocationTime.value = locations[index].time!;
          nextUpdateLocationId.value = locations[index].id!;
          isUpdateLocationVisible.value = true;
          isUpdateLocationDividerVisible.value = true;
          isNextUpdateLocationTimeVisible.value = true;

          if (!locations[index].status!) {
            updateLocationTime.value = DateUtil.changeDateFormat(
                nextUpdateLocationTime.value,
                DateUtil.HH_MM_SS_24_2,
                DateUtil.HH_MM_24);
            // binding.txtUpdateLocationTime.setText(time);

            if (index > 0 && !locations[index - 1].status!) {
              if (!StringHelper.isEmptyString(
                  locations[index - 1].extraMin ?? "")) {
                DateTime previousTime = checkInDateFormat
                    .parse("$checkInDate ${locations[index - 1].time!}");
                DateTime currentTime = DateTime.now();

                int timeDifferent =
                    currentTime.millisecond - previousTime.millisecond;
                double totalSeconds = timeDifferent / 1000;
                int extraMin = int.parse(locations[index - 1].extraMin!) * 60;
                if (totalSeconds <= extraMin) {
                  previousUpdateLocationTime.value = locations[index - 1].time!;
                  previousUpdateLocationId.value = locations[index - 1].id!;
                  // ((DashboardActivity) getActivity()).showUpdateLocationRemainingTime(extraMin - totalSeconds);
                } else {
                  // ((DashboardActivity) getActivity()).hideUpdateLocationRemainingTime();
                }
              } else {
                // ((DashboardActivity) getActivity()).hideUpdateLocationRemainingTime();
              }
            } else {
              // ((DashboardActivity) getActivity()).hideUpdateLocationRemainingTime();
            }
          } else {
            if (locations.length - 1 > index) {
              nextUpdateLocationTime.value = locations[index + 1].time!;
              nextUpdateLocationId.value = locations[index + 1].id!;
              updateLocationTime.value = DateUtil.changeDateFormat(
                  nextUpdateLocationTime.value,
                  DateUtil.HH_MM_SS_24_2,
                  DateUtil.HH_MM_24);
              // binding.txtUpdateLocationTime.setText(time);
            } else {
              hideUpdateLocationView();
            }
          }
        } else {
          isUpdateLocationVisible.value = true;
          isUpdateLocationDividerVisible.value = true;
          isNextUpdateLocationTimeVisible.value = false;

          if (!locations[locations.length - 1].status! &&
              !StringHelper.isEmptyString(
                  locations[locations.length - 1].extraMin!)) {
            DateTime previousTime = checkInDateFormat
                .parse("$checkInDate ${locations[locations.length - 1].time!}");
            DateTime currentTime = DateTime.now();
            int timeDifferent =
                currentTime.millisecond - previousTime.millisecond;
            double totalSeconds = timeDifferent / 1000;
            int extraMin =
                int.parse(locations[locations.length - 1].extraMin!) * 60;
            if (totalSeconds <= extraMin) {
              previousUpdateLocationTime.value =
                  locations[locations.length - 1].time!;
              previousUpdateLocationId.value =
                  locations[locations.length - 1].id!;
              // ((DashboardActivity) getActivity()).showUpdateLocationRemainingTime(extraMin - totalSeconds);
            } else {
              // ((DashboardActivity) getActivity()).hideUpdateLocationRemainingTime();
            }
          } else {
            // ((DashboardActivity) getActivity()).hideUpdateLocationRemainingTime();
          }
        }
      } else {
        hideUpdateLocationView();
      }*/
    } catch (e, s) {
      print("Error: $e");
      print("Stack Trace: $s");
    }
  }

  void hideUpdateLocationView() {
    // ((DashboardActivity) getActivity()).hideUpdateLocationRemainingTime();
    isUpdateLocationVisible.value = false;
    isUpdateLocationDividerVisible.value = false;
    isNextUpdateLocationTimeVisible.value = false;
    updateLocationTime.value = "";
  }

  String getEarningSummery() {
    String earningSummery = "";
    if (!StringHelper.isEmptyString(dashboardResponse.value.checkinDateTime)) {
      try {
        double totalWorkHour = 0, totalBreakHour = 0;
        int priceWorkEarning = dashboardResponse.value.priceworkEarning ?? 0;
        var listOuterBreakPieChart = <PieChartInfo>[];
        if (!StringHelper.isEmptyList(dashboardResponse.value.workLogs)) {
          for (int i = 0; i < dashboardResponse.value.workLogs!.length; i++) {
            if (dashboardResponse.value.workLogs![i].shiftType ==
                AppConstants.shiftType.regularShift) {
              if (!StringHelper.isEmptyString(
                      dashboardResponse.value.workLogs![i].start) &&
                  !StringHelper.isEmptyString(
                      dashboardResponse.value.workLogs![i].end)) {
                totalWorkHour = totalWorkHour +
                    dashboardResponse.value.workLogs![i].workMinutes! *
                        60 *
                        1000;
              } else {
                String startTime = getStartTime(
                    dashboardResponse.value.workLogs![i].start ?? "",
                    dashboardResponse.value.shiftStartTime ?? "",
                    dashboardResponse.value.shiftEndTime ?? "");
                String endTime = getEndTime(
                    dashboardResponse.value.workLogs![i].end ?? "",
                    dashboardResponse.value.shiftStartTime ?? "",
                    dashboardResponse.value.shiftEndTime ?? "");
                if (!StringHelper.isEmptyString(startTime) &&
                    !StringHelper.isEmptyString(endTime)) {
                  PieChartInfo pieChartInfo = getPieChartInfo(
                      startTime, endTime, AppConstants.type.OUTER_WORK);
                  totalWorkHour = totalWorkHour + pieChartInfo.milliseconds!;

                  if (!StringHelper.isEmptyList(
                      dashboardResponse.value.shiftBreaks)) {
                    for (int j = 0;
                        j < dashboardResponse.value.shiftBreaks!.length;
                        j++) {
                      if (getStartStopBreakTime(
                              startTime,
                              endTime,
                              dashboardResponse.value.shiftBreaks![j].start,
                              dashboardResponse.value.shiftBreaks![j].end) !=
                          null)
                        listOuterBreakPieChart.add(getStartStopBreakTime(
                            startTime,
                            endTime,
                            dashboardResponse.value.shiftBreaks![j].start,
                            dashboardResponse.value.shiftBreaks![j].end)!);
                    }
                  }
                }
              }
            }
          }
        }

        if (listOuterBreakPieChart.length > 0) {
          for (int i = 0; i < listOuterBreakPieChart.length; i++) {
            totalBreakHour =
                totalBreakHour + listOuterBreakPieChart[i].milliseconds!;
          }
        }
        double timerTimeInMillis = totalWorkHour - totalBreakHour;

        NumberFormat formatter = NumberFormat("##.##");
        // String currency = AppStorage().getUserInfo().currencySymbol ?? "";
        String currency = "";
        if (!StringHelper.isEmptyString(
            dashboardResponse.value.hourlyRate.toString())) {
          double timerTimeInSeconds = timerTimeInMillis / 1000;
          if (timerTimeInSeconds < 0) timerTimeInSeconds = 0;
          double totalRate = (timerTimeInSeconds *
                  dashboardResponse.value.hourlyRate!.toDouble()) /
              3600;

          if (AppStorage().isWeeklySummeryCounter()) {
            earningSummery = currency +
                formatter.format(priceWorkEarning +
                    totalRate +
                    double.parse(AppStorage().getWeeklySummeryAmount()));
          } else {
            earningSummery =
                currency + formatter.format(priceWorkEarning + totalRate);
          }
        } else {
          earningSummery = currency + formatter.format(priceWorkEarning);
        }
//                }
      } catch (e, s) {
        print("Error: $e");
        print("Stack Trace: $s");
      }
    }
    return earningSummery;
  }

  String getWorkingHours() {
    String totalWorkingHours = "";
    if (!StringHelper.isEmptyString(dashboardResponse.value.checkinDateTime)) {
      double totalWorkHour = 0, totalBreakHour = 0;

      var listOuterBreakPieChart = <PieChartInfo>[];

      if (!StringHelper.isEmptyList(dashboardResponse.value.workLogs)) {
        for (int i = 0; i < dashboardResponse.value.workLogs!.length; i++) {
          String startTime = getStartTime(
              dashboardResponse.value.workLogs![i].start ?? "",
              dashboardResponse.value.shiftStartTime ?? "",
              dashboardResponse.value.shiftEndTime ?? "");
          String endTime = getEndTime(
              dashboardResponse.value.workLogs![i].end ?? "",
              dashboardResponse.value.shiftStartTime ?? "",
              dashboardResponse.value.shiftEndTime ?? "");
          if (!StringHelper.isEmptyString(startTime) &&
              !StringHelper.isEmptyString(endTime)) {
            PieChartInfo pieChartInfo = getPieChartInfo(
                startTime, endTime, AppConstants.type.OUTER_WORK);
            totalWorkHour = totalWorkHour + pieChartInfo.milliseconds!;

            if (!StringHelper.isEmptyList(
                dashboardResponse.value.shiftBreaks)) {
              for (int j = 0;
                  j < dashboardResponse.value.shiftBreaks!.length;
                  j++) {
                if (getStartStopBreakTime(
                        startTime,
                        endTime,
                        dashboardResponse.value.shiftBreaks![j].start,
                        dashboardResponse.value.shiftBreaks![j].end) !=
                    null)
                  listOuterBreakPieChart.add(getStartStopBreakTime(
                      startTime,
                      endTime,
                      dashboardResponse.value.shiftBreaks![j].start,
                      dashboardResponse.value.shiftBreaks![j].end)!);
              }
            }
          }
        }
      }

      if (listOuterBreakPieChart.length > 0) {
        for (int i = 0; i < listOuterBreakPieChart.length; i++) {
          totalBreakHour =
              totalBreakHour + listOuterBreakPieChart[i].milliseconds!;
        }
      }

      double timerTimeInMillis = totalWorkHour - totalBreakHour;

      int totalSeconds = (timerTimeInMillis / 1000).round();
      int hours = totalSeconds ~/ 3600;
      int minutes = (totalSeconds % 3600) ~/ 60;
      int seconds = totalSeconds % 60;

      totalWorkingHours = '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    } else {
      totalWorkingHours = "00:00:00";
    }
    return totalWorkingHours;
  }

  PieChartInfo getPieChartInfo(String start, String end, int type) {
    PieChartInfo info = PieChartInfo();
    info.type = type;
    DateFormat simpleDateFormat = DateFormat(DateUtil.YYYY_MM_DD_TIME_24_DASH2);

    try {
      DateTime date1 = simpleDateFormat.parse(start);
      DateTime? date2 = null;
      if (end != null) {
        date2 = simpleDateFormat.parse(end);
      } else {
        date2 = DateTime.now();
      }
      Duration difference = date2.difference(date1);
      info.milliseconds = difference.inMilliseconds;
    } catch (e, s) {
      print("Error: $e");
      print("Stack Trace: $s");
    }
    return info;
  }

  PieChartInfo? getStartStopBreakTime(String? startTime, String? endTime,
      String? startBreakTime, String? endBreakTime) {
    DateTime? finalStartBreak = null, finalStopBreak = null;
    PieChartInfo? pieChartInfo = null;
    if (!StringHelper.isEmptyString(startTime) &&
        !StringHelper.isEmptyString(endTime) &&
        !StringHelper.isEmptyString(startBreakTime) &&
        !StringHelper.isEmptyString(endBreakTime)) {
      DateFormat simpleDateFormat =
          DateFormat(DateUtil.YYYY_MM_DD_TIME_24_DASH2);
      DateFormat simpleDateFormat2 = new DateFormat(DateUtil.YYYY_MM_DD_DASH);

      try {
        DateTime startWork = simpleDateFormat.parse(startTime ?? "");
        DateTime stopWork = simpleDateFormat.parse(endTime ?? "");

        String checkInDate = "";
        if (!StringHelper.isEmptyString(
            dashboardResponse.value.checkinDateTime)) {
          checkInDate = simpleDateFormat2.format(simpleDateFormat
              .parse(dashboardResponse.value.checkinDateTime ?? ""));
        } else {
          checkInDate = simpleDateFormat2.format(DateTime.now());
        }

        DateTime startBreak =
            simpleDateFormat.parse("$checkInDate $startBreakTime");
        DateTime stopBreak =
            simpleDateFormat.parse("$checkInDate $endBreakTime");

        if (startWork.isBefore(startBreak) && stopWork.isAfter(startBreak)) {
          if ((stopWork.isBefore(stopBreak) || stopWork == stopBreak)) {
            finalStartBreak = startBreak;
            finalStopBreak = stopWork;
          } else if (stopWork.isAfter(stopBreak)) {
            finalStartBreak = startBreak;
            finalStopBreak = stopBreak;
          }
        } else if ((startWork.isAfter(startBreak) || startWork == startBreak) &&
            (startWork.isBefore(stopBreak) || startWork == stopBreak)) {
          if (stopWork.isBefore(stopBreak) || stopWork == stopBreak) {
            finalStartBreak = startWork;
            finalStopBreak = stopWork;
          } else if (stopWork.isAfter(stopBreak)) {
            finalStartBreak = startWork;
            finalStopBreak = stopBreak;
          }
        }

        if (finalStartBreak != null && finalStopBreak != null)
          pieChartInfo = getPieChartInfo(
              simpleDateFormat.format(finalStartBreak),
              simpleDateFormat.format(finalStopBreak),
              AppConstants.type.OUTER_BREAK);
      } catch (e, s) {
        print("Error: $e");
        print("Stack Trace: $s");
      }
    }
    return pieChartInfo;
  }

  String getStartTime(
      String startTime, String workStartTime, String workEndTime) {
    DateTime? finalStartTime = null;
    String strFinalStartTime = "";
    DateFormat simpleDateFormat = DateFormat(DateUtil.YYYY_MM_DD_TIME_24_DASH2);
    DateFormat simpleDateFormat2 = DateFormat(DateUtil.YYYY_MM_DD_DASH);

    // Calendar calendar = Calendar.getInstance();
    try {
      DateTime startTimeDate = simpleDateFormat.parse(startTime);
      String checkInDate = "";
      if (!StringHelper.isEmptyString(
          dashboardResponse.value.checkinDateTime ?? "")) {
        checkInDate = simpleDateFormat2.format(simpleDateFormat
            .parse(dashboardResponse.value.checkinDateTime ?? ""));
      } else {
        checkInDate = simpleDateFormat2.format(DateTime.now());
      }

      DateTime defaultStartTime =
          simpleDateFormat.parse(checkInDate + " " + workStartTime);
      DateTime defaultEndTime =
          simpleDateFormat.parse(checkInDate + " " + workEndTime);

      if (startTimeDate.isBefore(defaultStartTime) ||
          startTimeDate == defaultStartTime) {
        finalStartTime = defaultStartTime;
      } else if (startTimeDate.isAfter(defaultStartTime) &&
          (startTimeDate.isBefore(defaultEndTime) ||
              startTimeDate == defaultEndTime)) {
        finalStartTime = startTimeDate;
      }

      if (finalStartTime != null)
        strFinalStartTime = simpleDateFormat.format(finalStartTime);
    } catch (e, s) {
      print("Error: $e");
      print("Stack Trace: $s");
    }

    return strFinalStartTime;
  }

  String getEndTime(String endTime, String workStartTime, String workEndTime) {
    DateTime? finalEndTime = null;
    String strFinalEndTime = "";
    DateFormat simpleDateFormat = DateFormat(DateUtil.YYYY_MM_DD_TIME_24_DASH2);
    DateFormat simpleDateFormat2 = DateFormat(DateUtil.YYYY_MM_DD_DASH);

    try {
      DateTime? endTimeDate = null;
      if (!StringHelper.isEmptyString(endTime))
        endTimeDate = simpleDateFormat.parse(endTime);
      else
        endTimeDate = DateTime.now();

      /*  Date defaultStartTime = simpleDateFormat.parse(simpleDateFormat2.format(calendar.getTime()) + " " + workStartTime);
            Date defaultEndTime = simpleDateFormat.parse(simpleDateFormat2.format(calendar.getTime()) + " " + workEndTime);*/

      String checkInDate = "";
      if (!StringHelper.isEmptyString(
          dashboardResponse.value.checkinDateTime)) {
        checkInDate = simpleDateFormat2.format(simpleDateFormat
            .parse(dashboardResponse.value.checkinDateTime ?? ""));
      } else {
        checkInDate = simpleDateFormat2.format(DateTime.now());
      }

      DateTime defaultStartTime =
          simpleDateFormat.parse("$checkInDate $workStartTime");
      DateTime defaultEndTime =
          simpleDateFormat.parse("$checkInDate $workEndTime");

      if ((endTimeDate.isAfter(defaultStartTime) ||
              endTimeDate == defaultStartTime) &&
          (endTimeDate.isBefore(defaultEndTime) ||
              endTimeDate == defaultEndTime) &&
          DateUtils.isSameDay(
              simpleDateFormat2.parse(checkInDate), DateTime.now())) {
        finalEndTime = endTimeDate;
      } else if ((endTimeDate.isAfter(defaultStartTime) ||
                  endTimeDate == defaultStartTime) &&
              endTimeDate.isAfter(defaultEndTime) ||
          DateUtils.isSameDay(
              simpleDateFormat2.parse(checkInDate), DateTime.now())) {
        finalEndTime = defaultEndTime;
      }

      if (finalEndTime != null)
        strFinalEndTime = simpleDateFormat.format(finalEndTime);
    } catch (e, s) {
      print("Error: $e");
      print("Stack Trace: $s");
    }

    return strFinalEndTime;
  }
}
