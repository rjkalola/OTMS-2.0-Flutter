import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:belcka/pages/company/company_signup/model/company_info.dart';
import 'package:belcka/pages/profile/company_billings/controller/company_billings_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';

class CompanyCardWidget extends StatelessWidget {
  CompanyInfo  company;

  CompanyCardWidget({required this.company});

  final controller = Get.put(CompanyBillingsController());

  @override
  Widget build(BuildContext context) {

    final bool isActive = company.isActiveCompany == 'Active';

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: CardViewDashboardItem(
          child: GestureDetector(
              onTap: () {
                var arguments = {
                  AppConstants.intentKey.companyId: company.id ?? 0,
                };
                controller.moveToScreen(
                    AppRoutes.billingDetailsNewScreen, arguments);
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 12, 16),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  company.name ?? "",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 20),
                                ),
                              ),

                              Container(
                                padding:
                                EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.5,
                                      color: isActive ? Color(0xff32A852) : Color(0xffFF484B)),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  isActive ? "Active" : "Inactive",
                                  style: TextStyle(
                                    color: isActive ? Color(0xff32A852) : Color(0xffFF484B),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              )

                            ],
                          ),
                          SizedBox(height: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'trade '.tr,
                                  style: TextStyle(
                                    color: primaryTextColor_(context),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: company.tradeName ?? "",
                                      style: TextStyle(
                                        color: primaryTextColor_(context),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 6),
                              RichText(
                                text: TextSpan(
                                  text: '(£) ${'net_per_day'.tr} ',
                                  style: TextStyle(
                                    color: primaryTextColor_(context),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: company.netRatePerDay ?? "0.00",
                                      style: TextStyle(
                                        color: primaryTextColor_(context),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 22, color: primaryTextColor_(context))
                  ],
                ),
              ),
          )
      ),
    );
  }
}