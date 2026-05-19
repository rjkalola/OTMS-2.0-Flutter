import 'package:belcka/pages/project/project_analytics/controller/project_analytics_controller.dart';
import 'package:belcka/pages/project/project_analytics/model/project_analytics_model.dart';
import 'package:belcka/pages/project/project_analytics/view/project_analytics_header.dart';
import 'package:belcka/pages/project/project_analytics/view/widgets/budget_row.dart';
import 'package:belcka/pages/project/project_analytics/view/widgets/donut_chart.dart';
import 'package:belcka/pages/project/project_analytics/view/widgets/donut_section.dart';
import 'package:belcka/pages/project/project_analytics/view/widgets/glass_card.dart';
import 'package:belcka/pages/project/project_analytics/view/widgets/payment_row.dart';
import 'package:belcka/pages/project/project_analytics/view/widgets/pill_badge.dart';
import 'package:belcka/pages/project/project_analytics/view/widgets/project_analytics_segment_control.dart';
import 'package:belcka/pages/project/project_analytics/view/widgets/stat_card.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class ProjectAnalyticsScreen extends StatefulWidget {
  const ProjectAnalyticsScreen({super.key});
  @override
  State<ProjectAnalyticsScreen> createState() => _ProjectAnalyticsScreenState();
}

class _ProjectAnalyticsScreenState extends State<ProjectAnalyticsScreen>
    with SingleTickerProviderStateMixin {

  final controller = Get.put(ProjectAnalyticsController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    AppUtils.setStatusBarColor();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Obx(
        () => Scaffold(
          backgroundColor: dashBoardBgColor_(context),
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: "project_analytics".tr,
            isCenterTitle: false,
            isBack: true,
            widgets: actionButtons(),
          ),
          body: SafeArea(
            top: false,
            bottom: false,
            child: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? NoInternetWidget(
                onPressed: () {
                  controller.isInternetNotAvailable.value = false;
                  controller.getProjectAnalyticsApi();
                },
              )
                  : Visibility(
                visible: controller.isMainViewVisible.value,
                child: Column(
                  children: [
                    ProjectAnalyticsHeader(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildBudgetCard(),
                              const SizedBox(height: 16),
                              _buildPaymentsCard(),
                              // const SizedBox(height: 16),
                              // _buildQuickStats(),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  List<Widget>? actionButtons() {
    return [
      SizedBox(
        width: 6,
      ),
      Visibility(
        visible: UserUtils.isAdmin(),
        child: IconButton(
          icon: Icon(Icons.more_vert_outlined),
          onPressed: () {
            /*
            if (UserUtils.isAdmin()) {
              controller.showMenuItemsDialog(Get.context!);
            }
            */
          },
        ),
      ),
    ];
  }

  // ─── Budget Card
  Widget _buildBudgetCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text('budget'.tr,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3)),
              PillBadge(label: 'all_budgets'.tr, onTap: () {}),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: controller.budgets
                      .map((b) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: BudgetRow(item: b),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 120,
                height: 120,
                child: DonutChart(
                  sections: [
                    DonutSection(value: 110000, color: const Color(0xFF22C55E)),
                    DonutSection(value: 220500, color: const Color(0xFFF97316)),
                    DonutSection(value: 30000, color: const Color(0xFF60A5FA)),
                    DonutSection(value: 89500, color: const Color(0xFFE2E8F0)),
                  ],
                  centerLabel: 'profit'.tr,
                  centerValue: '£50,000',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Payments Card
  Widget _buildPaymentsCard() {
    final total = controller.received.fold(0.0, (s, p) => s + p.amount);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text('payments'.tr,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3)),
              PillBadge(label: 'all_payments'.tr, onTap: () {}),
            ],
          ),
          const SizedBox(height: 16),
          // Tab Bar
          ProjectAnalyticsSegmentControl(),
          const SizedBox(height: 20),
          // Total
          Center(
            child: Column(
              children: [
                Text(
                  '£${_fmt(total)}',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF22C55E),
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  '${controller.received.length} ${'transactions'.tr}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Divider
          Divider(color: lightGreyColor(context), thickness: 1),
          const SizedBox(height: 4),
          // Payment list
          ...controller.received.map((p) => PaymentRow(payment: p)),
        ],
      ),
    );
  }

  // ─── Quick Stats
  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
            child: StatCard(
                icon: Icons.trending_up_rounded,
                iconColor: const Color(0xFF22C55E),
                label: 'Revenue',
                value: '£430k')),
        const SizedBox(width: 12),
        Expanded(
            child: StatCard(
                icon: Icons.schedule_rounded,
                iconColor: const Color(0xFFF59E0B),
                label: 'Pending',
                value: '£80k')),
        const SizedBox(width: 12),
        Expanded(
            child: StatCard(
                icon: Icons.warning_amber_rounded,
                iconColor: const Color(0xFFF97316),
                label: 'Overrun',
                value: '£20.5k')),
      ],
    );
  }

  String _fmt(double v) {
    if (v >= 1000) {
      final s = v.toStringAsFixed(2);
      // Insert comma
      final parts = s.split('.');
      final intPart = parts[0];
      final dec = parts[1];
      final buf = StringBuffer();
      for (int i = 0; i < intPart.length; i++) {
        if (i > 0 && (intPart.length - i) % 3 == 0) buf.write(',');
        buf.write(intPart[i]);
      }
      return '${buf.toString()}.$dec';
    }
    return v.toStringAsFixed(2);
  }
}
