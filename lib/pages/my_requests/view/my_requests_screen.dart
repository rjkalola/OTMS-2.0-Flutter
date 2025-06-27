import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/my_requests/controller/my_requests_controller.dart';
import 'package:otm_inventory/pages/my_requests/model/my_request_info.dart';
import 'package:otm_inventory/pages/my_requests/model/my_requests_list_response.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';

class MyRequestsScreen extends StatelessWidget {
  final controller = Get.put(MyRequestsController());
  final List<String> filters = ["Week", "Month", "3 Month", "6 Month", "Year"];
  String selectedFilter = "";

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        color: dashBoardBgColor,
        child: SafeArea(
            child: Scaffold(
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: "My Requests",
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
                    child:Column(
                      children: [
                        // Horizontally scrollable filter chips
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: filters.map((filter) {
                                final isSelected = filter == selectedFilter;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ChoiceChip(
                                    label: Text(filter),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      setState(() {
                                        selectedFilter = filter;
                                        // TODO: Filter your requests based on selectedFilter
                                      });
                                    },
                                    selectedColor: Colors.black,
                                    showCheckmark: false,
                                    labelStyle: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black,
                                    ),
                                    backgroundColor: Colors.white,
                                    shape: StadiumBorder(
                                      side: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        // Requests List
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.all(12),
                            itemCount: controller.myRequestList.length,
                            itemBuilder: (context, index) {
                              final request = controller.myRequestList[index];
                              return RequestCard(request: request);

                            },
                          ),
                        ),
                      ],
                    ),
                ),
              ),
            )
        )
    )
    );
  }

  void setState(Null Function() param0) {

  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;

  const FilterChipWidget({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      backgroundColor: Colors.white,
      shape: StadiumBorder(side: BorderSide(color: Colors.grey.shade300)),
    );
  }
}

class RequestCard extends StatelessWidget {
  final MyRequestInfo request;
  RequestCard({required this.request});
  final controller = Get.put(MyRequestsController());

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: GestureDetector(
          onTap: (){
            String status = request.status ?? "";
            if (status == "pending"){
              var arguments = {
                "request_log_id":request.id ?? 0,
              };
              controller.moveToScreen(
                  AppRoutes.billingRequestScreen, arguments);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black, // Border color
                        width: 1.5,         // Border width
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        request.requestedUserImage ?? "",
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "${request.requestedUser ?? ""}: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: request.message ?? "",
                          ),
                        ],
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      request.status ?? "",
                      style: TextStyle(
                        color: getStatusColor(request.status ?? ""),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: getStatusColor(request.status ?? "").withOpacity(0.1),
                    shape: StadiumBorder(
                      side: BorderSide(color: getStatusColor(request.status ?? ""),),
                    ),
                  )
                ],
              ),

              SizedBox(height: 8),
              Text(request.rejectReason ?? ""),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  request.date ?? "",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color getStatusColor(String status){
  Color color = primaryTextColor;
  if(status == 'approved'){
    color = Colors.green;
  }
  else if(status == 'rejected'){
    color = Colors.red;
  }
  return color;
}