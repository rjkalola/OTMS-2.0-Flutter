import 'package:belcka/pages/company/joincompany/controller/join_company_controller.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CompanyDetailsWidget extends StatelessWidget {
  CompanyDetailsWidget({super.key});

  final controller = Get.put(JoinCompanyController());

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              PrimaryTextView(
                text: 'Company Joining:',
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipOval(
                      child: Image.network("${controller.companyLogoUrl ?? ""}",
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Icon(
                            Icons.business,
                            color: Colors.grey.shade500,
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryTextView(
                      text: "${controller.companyName ?? ""}",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }
}
