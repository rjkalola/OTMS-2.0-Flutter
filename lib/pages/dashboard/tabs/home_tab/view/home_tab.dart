import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/authentication/otp_verification/model/user_info.dart';
import 'package:otm_inventory/pages/dashboard/controller/dashboard_controller.dart';
import 'package:otm_inventory/pages/dashboard/models/DashboardActionItemInfo.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';

import '../../../../../res/colors.dart';
import '../../../../../utils/app_storage.dart';
import '../../../../../widgets/CustomProgressbar.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final dashboardController = Get.put(DashboardController());
  late var userInfo = UserInfo();
  int selectedActionButtonPagerPosition = 0;

  @override
  void initState() {
    // showProgress();
    // setHeaderActionButtons();
    userInfo = Get.find<AppStorage>().getUserInfo();
    print("HOme initState");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return SafeArea(child: Obx(() {
      return ModalProgressHUD(
        inAsyncCall: dashboardController.isLoading.value,
        opacity: 0,
        progressIndicator: const CustomProgressbar(),
        child: Obx(() => Scaffold(
              backgroundColor: Colors.white,
              // backgroundColor: const Color(0xfff4f5f7),
              body: Visibility(
                visible: dashboardController.isMainViewVisible.value,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 9, 16, 0),
                    child: Row(
                      children: [
                        ImageUtils.setNetworkImage(
                            "https://www.pngmart.com/files/22/User-Avatar-Profile-PNG-Isolated-Transparent-Picture.png",
                            48),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text("Welcome, Ravi Kalola",
                              style: TextStyle(
                                color: primaryTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              )),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(16, 6, 16, 0),
                      decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6))),
                      child: SingleChildScrollView(
                        child: Column(children: [
                          setDashboardActionButtonsList(
                              _generateChunks(getHeaderActionButtonsList(), 3)),
                          setDashboardActionButtonsDotsList(
                              _generateChunks(getHeaderActionButtonsList(), 3)
                                  .length),
                          SizedBox(height: 12),
                          Divider(
                            thickness: 3,
                            color: dividerColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 12, 14, 12),
                            child: Row(children: [
                              Container(
                                  padding: EdgeInsets.all(9),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Color(AppUtils.haxColor("#e4d3f4"))),
                                  child: SvgPicture.asset(
                                    "assets/images/icon_requests_count.svg",
                                  )),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                                child: Center(
                                  child: Text("3 Pending Requests",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: primaryTextColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                      )),
                                ),
                              )),
                              Icon(
                                Icons.keyboard_arrow_right,
                                size: 24,
                                color: defaultAccentColor,
                              ),
                            ]),
                          ),
                          Divider(
                            thickness: 3,
                            color: dividerColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 12, 14, 12),
                            child: Row(children: [
                              Container(
                                  padding: EdgeInsets.all(9),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Color(AppUtils.haxColor("#e4d3f4"))),
                                  child: SvgPicture.asset(
                                    "assets/images/icon_requests_count.svg",
                                  )),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                                child: Center(
                                  child: Text("Pending Task 3",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: primaryTextColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                      )),
                                ),
                              )),
                              Icon(
                                Icons.keyboard_arrow_right,
                                size: 24,
                                color: defaultAccentColor,
                              ),
                            ]),
                          ),
                          Divider(
                            thickness: 3,
                            color: dividerColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 12, 14, 12),
                            child: Row(children: [
                              Container(
                                padding: EdgeInsets.all(9),
                                width: 40,
                                height: 40,
                              ),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Schedule work 08:00 - 22:00",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: secondaryLightTextColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          )),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text("00:30:00",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: primaryTextColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 24,
                                          )),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text("Work Started: 06 Dec, 12:38",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: secondaryLightTextColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          )),
                                    ],
                                  ),
                                ),
                              )),
                              Icon(
                                Icons.keyboard_arrow_right,
                                size: 24,
                                color: defaultAccentColor,
                              ),
                            ]),
                          ),
                          Divider(
                            thickness: 3,
                            color: dividerColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 12, 14, 12),
                            child: Row(children: [
                              Container(
                                  padding: EdgeInsets.all(9),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(
                                          AppUtils.haxColor("#80BAC6F1"))),
                                  child: SvgPicture.asset(
                                    "assets/images/ic_earning_summary.svg",
                                  )),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                                child: Center(
                                  child: Column(
                                    children: const [
                                      Text("Today's Summery",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: primaryTextColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15,
                                          )),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text("30.41",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: primaryTextColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 24,
                                          )),
                                    ],
                                  ),
                                ),
                              )),
                              Icon(
                                Icons.keyboard_arrow_right,
                                size: 24,
                                color: defaultAccentColor,
                              ),
                            ]),
                          ),
                          setScheduleBreaksList(),
                          Divider(
                            thickness: 3,
                            color: dividerColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 12, 14, 12),
                            child: Row(children: [
                              Container(
                                  padding: EdgeInsets.all(9),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Color(AppUtils.haxColor("#ddeafb"))),
                                  child: SvgPicture.asset(
                                    "assets/images/ic_map.svg",
                                  )),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                                child: Center(
                                  child: Column(
                                    children: const [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("2/28",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: primaryTextColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                              )),
                                          SizedBox(
                                            width: 9,
                                          ),
                                          Text("Location Updates",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: primaryTextColor,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                              ))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("15:05",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: primaryTextColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                              )),
                                          SizedBox(
                                            width: 9,
                                          ),
                                          Text("Next Updates",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: primaryTextColor,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                              Icon(
                                Icons.keyboard_arrow_right,
                                size: 24,
                                color: defaultAccentColor,
                              ),
                            ]),
                          ),
                        ]),
                      ),
                    ),
                  )
                ]),
              ),
            )),
      );
    }));
  }

  List<DashboardActionItemInfo> getHeaderActionButtonsList() {
    var arrayItems = <DashboardActionItemInfo>[];

    DashboardActionItemInfo? info;

    info = DashboardActionItemInfo();
    info.id = AppConstants.action.clockIn;
    info.title = "Clock In";
    info.image = "assets/images/ic_time_clock.svg";
    info.backgroundColor = "#ddeafb";
    arrayItems.add(info);

    info = DashboardActionItemInfo();
    info.id = AppConstants.action.quickTask;
    info.title = "Tasks";
    info.image = "assets/images/ic_task_dashboard.svg";
    info.backgroundColor = "#f8dbd6";
    arrayItems.add(info);

    info = DashboardActionItemInfo();
    info.id = AppConstants.action.map;
    info.title = "Map";
    info.image = "assets/images/ic_map.svg";
    info.backgroundColor = "#defff4";
    arrayItems.add(info);

    info = DashboardActionItemInfo();
    info.id = AppConstants.action.teams;
    info.title = "Teams";
    info.image = "assets/images/ic_teams.svg";
    info.backgroundColor = "#fce8df";
    arrayItems.add(info);

    info = DashboardActionItemInfo();
    info.id = AppConstants.action.users;
    info.title = "Users";
    info.image = "assets/images/ic_users_dashboard.svg";
    info.backgroundColor = "#fef9d1";
    arrayItems.add(info);

    info = DashboardActionItemInfo();
    info.id = AppConstants.action.timeSheet;
    info.title = "Timesheet";
    info.image = "assets/images/ic_dashboard_timesheet_button.svg";
    info.backgroundColor = "#e4d3f4";
    arrayItems.add(info);

    return arrayItems;
    List<List<DashboardActionItemInfo>> chunks = _generateChunks(arrayItems, 3);
    print("List Size:${chunks.length}");
  }

  List<List<DashboardActionItemInfo>> _generateChunks(
      List<DashboardActionItemInfo> inList, int chunkSize) {
    List<List<DashboardActionItemInfo>> outList = [];
    List<DashboardActionItemInfo> tmpList = [];
    int counter = 0;

    for (int current = 0; current < inList.length; current++) {
      if (counter != chunkSize) {
        tmpList.add(inList[current]);
        counter++;
      }
      if (counter == chunkSize || current == inList.length - 1) {
        outList.add(tmpList.toList());
        tmpList.clear();
        counter = 0;
      }
    }
    return outList;
  }

  Widget setDashboardActionButtonsList(
          List<List<DashboardActionItemInfo>> list) =>
      Container(
        width: double.infinity,
        height: 90,
        margin: EdgeInsets.only(top: 22),
        child: PageView.builder(
            itemCount: list.length,
            onPageChanged: (int page) {
              setState(() {
                selectedActionButtonPagerPosition = page;
              });
            },
            itemBuilder: (context, index) {
              return GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  children: List.generate(
                    list[index].length,
                    (position) {
                      return InkWell(
                        child: Column(
                          children: [
                            Container(
                                padding: EdgeInsets.all(14),
                                width: 80,
                                height: 54,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(6),
                                    color: Color(AppUtils.haxColor(list[index]
                                            [position]
                                        .backgroundColor!))),
                                child: SvgPicture.asset(
                                  list[index][position].image!,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                list[index][position].title!,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          if (list[index][position].id ==
                              AppConstants.action.users) {
                            // Navigator.push(context, MaterialPageRoute(
                            //   builder: (context) {
                            //     return UserListScreen();
                            //   },
                            // ));
                          }
                          print("Index:$index || Position:$position");
                        },
                      );
                    },
                  ));
            }),
      );

  Widget setDashboardActionButtonsDotsList(int size) => Container(
        margin: EdgeInsets.only(top: 4),
        height: 12,
        alignment: Alignment.center,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: List.generate(
            size,
            (position) => Container(
              margin: EdgeInsets.all(3),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: (position == selectedActionButtonPagerPosition)
                    ? Colors.blue
                    : Colors.black26,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      );

  Widget setScheduleBreaksList() => Container(
        margin: EdgeInsets.only(top: 4),
        alignment: Alignment.center,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: List.generate(
            2,
            (position) => Column(
              children: [
                Divider(
                  thickness: 3,
                  color: dividerColor,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 14, 12),
                  child: Row(children: [
                    Container(
                        padding: EdgeInsets.all(9),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(AppUtils.haxColor("#fee8d0"))),
                        child: SvgPicture.asset(
                          "assets/images/ic_break.svg",
                        )),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                      child: Center(
                        child: Column(
                          children: const [
                            Text("Schedule break 08:00 - 22:00",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: secondaryLightTextColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                )),
                            SizedBox(
                              height: 3,
                            ),
                            Text("00:30:00",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                ))
                          ],
                        ),
                      ),
                    )),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 24,
                      color: defaultAccentColor,
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      );

// @override
// void dispose() {
//   homeTabController.dispose();
//   super.dispose();
// }
}
