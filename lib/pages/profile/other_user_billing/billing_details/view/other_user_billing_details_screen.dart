import 'package:belcka/pages/profile/billing_details_new/view/widgets/info_card.dart';
import 'package:belcka/pages/profile/billing_details_new/view/widgets/navigation_card.dart';
import 'package:belcka/pages/profile/billing_details_new/view/widgets/no_billing_data_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../controller/other_user_billing_details_controller.dart';

class OtherUserBillingDetailsScreen extends StatefulWidget {
  const OtherUserBillingDetailsScreen({super.key});

  @override
  State<OtherUserBillingDetailsScreen> createState() => _OtherUserBillingDetailsScreenState();
}

class _OtherUserBillingDetailsScreenState extends State<OtherUserBillingDetailsScreen> {
  final controller = Get.put(OtherUserBillingDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: "billing_info".tr,
            isCenterTitle: false,
            bgColor: dashBoardBgColor_(context),
            isBack: true,
          ),
          backgroundColor: dashBoardBgColor_(context),
          body: ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: controller.isInternetNotAvailable.value
                ?  Center(
              child: Text('no_internet_text'.tr),
            )
                : Visibility(
                visible: controller.isMainViewVisible.value,
                child: (controller
                    .billingInfo.value.id ?? 0) != 0 ? Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //profile UI
                              Container(
                                padding: EdgeInsets.fromLTRB(16, 14, 16, 0),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Avatar
                                    UserAvtarView(
                                      imageSize: 60,
                                      imageUrl: controller
                                          .billingInfo.value.userThumbImage ??
                                          "",
                                    ),
                                    SizedBox(height: 10),
                                    // Name
                                    Text(
                                      controller.billingInfo.value.name ?? "",
                                      style: TextStyle(
                                          fontSize: 24, fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: (){
                                        AppUtils.onClickPhoneNumber("${controller.billingInfo.value.extension ?? ""}${controller.billingInfo.value.phone ?? ""}");
                                      },
                                        child: InfoCard(label: 'phone_number'.tr, value:"${controller.billingInfo.value.extension ?? ""} ${controller.billingInfo.value.phone ?? ""}", isLink: true)),

                                    GestureDetector(
                                      onTap: (){
                                        if ((controller.billingInfo.value.email ?? "").isNotEmpty){
                                          AppUtils.copyEmail(controller.billingInfo.value.email ?? "");
                                        }
                                      },
                                        child: InfoCard(label: 'email'.tr, value: controller.billingInfo.value.email ?? "", isLink: true)),
                                    NavigationCard(value: controller.address,isShowArrow: false,),
                                    NavigationCard(label: 'tax_info'.tr, value: controller.taxInfo,isShowArrow: false,),
                                    NavigationCard(label: 'bank_details'.tr, value: controller.bankDetails,isShowArrow: false,),
                                    NavigationCard(
                                      label: "rates".tr,
                                      value: controller.billingInfo.value.net_rate_perDay != ""
                                          ? "${controller.billingInfo.value.tradeName ?? ""} - ${controller.billingInfo.value.currency ?? ""}${controller.billingInfo.value.net_rate_perDay}"
                                          : "${controller.billingInfo.value.tradeName ?? ""}",
                                      isShowArrow: false,
                                    ),
                                    Divider(color: dividerColor_(context), height: 12),
                                    SizedBox(height: 12),
                                    NavigationCard(value: "payslips".tr,isShowArrow: false,),
                                    NavigationCard(value: "payment".tr,isShowArrow: false,),
                                    NavigationCard(value: "invoice".tr,isShowArrow: false,),
                                  ],
                                ),
                              ),
                            ],
                          )),
                        ),
                      ],
                    ) : NoBillingDataView()),
          ),
        ),
      ),
    ),);
  }

  List<Widget>? actionButtons() {
    return [
      Visibility(
        visible: (controller.billingInfo.value.id ?? 0) != 0 &&
          (controller.billingInfo.value.statusText ?? "") != "pending",
          child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: ElevatedButton(
          onPressed: () {
            {

            }
          },
          style: ElevatedButton.styleFrom(
            fixedSize: Size(100, 40),
            backgroundColor: defaultAccentColor_(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          child: Text('edit'.tr, style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold)),
        ),
      ))
    ];
  }
}


