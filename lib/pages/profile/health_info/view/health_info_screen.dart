import 'package:belcka/pages/profile/health_info/controller/health_info_controller.dart';
import 'package:belcka/pages/user_orders/widgets/orders_base_app_bar.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:provider/provider.dart'; // Ensure provider is in pubspec.yaml

class HealthInfoScreen extends StatelessWidget {
   HealthInfoScreen({super.key});

  final controller = Get.put(HealthInfoController());

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HealthInfoController(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop || result != null) return;
          controller.onBackPress();
        },
        child: Container(
          color: backgroundColor_(context),
          child: Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: OrdersBaseAppBar(
              appBar: AppBar(),
              title: 'Health Info',
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
              onBackPressed: (){
                controller.onBackPress();
              },
            ),
            body: Consumer<HealthInfoController>(
              builder: (context, controller, child) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildSectionCard(
                        title: "Emergency Contact",
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildTextField("First Name", controller.firstNameController)),
                              const SizedBox(width: 12),
                              Expanded(child: _buildTextField("Last Name", controller.lastNameController)),
                            ],
                          ),
                          _buildTextField("Email", controller.emailController),
                          Row(
                            children: [
                              Expanded(child: _buildTextField("Post Code", controller.postCodeController)),
                              const SizedBox(width: 8),
                              ElevatedButton(onPressed: () {}, child: const Text("Search")),
                            ],
                          ),
                          _buildTextField("Address", controller.addressController, maxLines: 3),
                          _buildTextField("Phone Number", controller.phoneController, prefixText: "+44 "),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildSectionCard(
                        title: "Health Info",
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildTextField("Height (cm)", controller.heightController)),
                              const SizedBox(width: 12),
                              Expanded(child: _buildTextField("Weight (kg)", controller.weightController)),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text("Select Yes if you have the following:",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                          ),
                          ...controller.conditions.keys.map((condition) {
                            return _buildQuestionRow(condition, controller);
                          }).toList(),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        value: controller.isAgreed,
                        onChanged: controller.toggleAgreement,
                        title: const Text("I confirm the information provided is true."),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          onPressed: controller.isAgreed ? controller.submitForm : null,
                          child: const Text("SAVE INFORMATION"),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return CardViewDashboardItem(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, String? prefixText}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixText: prefixText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }

  Widget _buildQuestionRow(String question, HealthInfoController controller) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(question, style: const TextStyle(fontSize: 14))),
            Row(
              children: [
                const Text("Yes"),
                Radio<bool>(
                  value: true,
                  groupValue: controller.conditions[question],
                  onChanged: (val) => controller.updateCondition(question, val),
                ),
                const Text("No"),
                Radio<bool>(
                  value: false,
                  groupValue: controller.conditions[question],
                  onChanged: (val) => controller.updateCondition(question, val),
                ),
              ],
            ),
          ],
        ),
        const Divider(height: 1),
      ],
    );
  }
}