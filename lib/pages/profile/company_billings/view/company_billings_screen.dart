import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/billing_details_screen.dart';
import 'package:otm_inventory/pages/profile/company_billings/controller/company_billings_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';

class CompanyBillingsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> companies = [
    {
      'name': 'DCK Construction',
      'trade': 'Backend',
      'rate': '200.00',
      'status': 'Active'
    },
    {
      'name': 'Tagir Construction',
      'trade': 'Backend',
      'rate': '184.00',
      'status': 'Active'
    },
    {
      'name': 'DOM Construction',
      'trade': 'Backend',
      'rate': '184.00',
      'status': 'Inactive'
    },
  ];
  final controller = Get.put(CompanyBillingsController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      color: dashBoardBgColor,
      child: SafeArea(
        child: Scaffold(
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: "Companies",
            isCenterTitle: false,
            bgColor: dashBoardBgColor,
            isBack: true,
          ),
          backgroundColor: dashBoardBgColor,
          body: ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: controller.isInternetNotAvailable.value
                ? const Center(
              child: Text("No Internet"),
            )
                : Visibility(
                visible: controller.isMainViewVisible.value,
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: companies.length,
                  itemBuilder: (context, index) {
                    return CompanyCard(company: companies[index]);
                  },
                )
          ),
        ),
      )
    )
    )
    );
  }
}

class CompanyCard extends StatelessWidget {
  final Map<String, dynamic> company;
  const CompanyCard({required this.company});

  @override
  Widget build(BuildContext context) {
    final bool isActive = company['status'] == 'Active';

    return
      GestureDetector(
        onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BillingDetailsScreen(),
        ),
      );
    },child:
      Container(
      margin: EdgeInsets.only(bottom: 11),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(
              width: 1.5,
              color: Color(0xffD8D8DD))),
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
                        company['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 22),
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
                        company['status'],
                        style: TextStyle(
                          color: isActive ? Color(0xff32A852) : Color(0xffFF484B),
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
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
                        text: 'Trade ',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            text: company['trade'],
                            style: TextStyle(
                              color: Colors.black,
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
                        text: '(£) Net Per Day ',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            text: company['rate'],
                            style: TextStyle(
                              color: Colors.black,
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
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54)
        ],
      ),
    ));
  }
}