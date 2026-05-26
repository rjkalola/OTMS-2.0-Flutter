import 'package:belcka/pages/project/project_analytics/all_payments/controller/all_payments_controller.dart';
import 'package:belcka/pages/project/project_analytics/all_payments/model/payments_model.dart';
import 'package:belcka/pages/project/project_analytics/all_payments/view/widgets/group_header.dart';
import 'package:belcka/pages/project/project_analytics/all_payments/view/widgets/mini_bar_chart.dart';
import 'package:belcka/pages/project/project_analytics/all_payments/view/widgets/payment_tile.dart';
import 'package:belcka/pages/project/project_analytics/all_payments/view/widgets/small_icon_btn.dart';
import 'package:belcka/pages/project/project_analytics/all_payments/view/widgets/tab_item.dart';
import 'package:belcka/pages/user_orders/widgets/orders_base_app_bar.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AllPaymentsScreen extends StatefulWidget {
  const AllPaymentsScreen({super.key});

  @override
  State<AllPaymentsScreen> createState() => _AllPaymentsScreenState();
}

class _AllPaymentsScreenState extends State<AllPaymentsScreen>
    with SingleTickerProviderStateMixin {

  final controller = Get.put(AllPaymentsController());

  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _switchTab(int t) {
    if (t == controller.tab) return;
    setState(() => controller.tab = t);
    _ctrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Obx(() => Scaffold(
      backgroundColor: dashBoardBgColor_(context),
      appBar: OrdersBaseAppBar(
        appBar: AppBar(),
        title: 'All Payments',
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
              },
            )
                : Visibility(
                visible: controller.isMainViewVisible.value,
                child: Column(
                  children: [
                    _buildTabBar(),
                    _buildSummaryBanner(),
                    Expanded(child: _buildList()),
                  ],
                )),
          )
      ),
    ));
  }

  List<Widget>? actionButtons() {
    return [
      SmallIconBtn(icon: Icons.open_in_new_rounded),
      const SizedBox(width: 8),
      SmallIconBtn(icon: Icons.more_vert_rounded),
      SizedBox(width: 16,)
    ];
  }

  // ─── Tab Bar
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          TabItem(
              label: 'Received',
              count: controller.received.length,
              selected: controller.tab == 0,
              onTap: () => _switchTab(0)),
          TabItem(
              label: 'Invoiced',
              count: controller.invoiced.length,
              selected: controller.tab == 1,
              onTap: () => _switchTab(1)),
        ],
      ),
    );
  }

  // ─── Summary Banner

  Widget _buildSummaryBanner() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: controller.tab == 0
              ? [const Color(0xFF16A34A), const Color(0xFF22C55E)]
              : [const Color(0xFF1D4ED8), const Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (controller.tab == 0
                    ? const Color(0xFF22C55E)
                    : const Color(0xFF3B82F6))
                .withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.tab == 0 ? 'Total Received' : 'Total Invoiced',
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5),
                ),
                const SizedBox(height: 4),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    fmtGbp(controller.total),
                    key: ValueKey(controller.total),
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -1),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        controller.incVat ? 'Inc. VAT (20%)' : 'Exc. VAT',
                        style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${controller.payments.length} transactions',
                      style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white60,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Mini chart bars
          MiniBarChart(payments: controller.payments),
        ],
      ),
    );
  }

  // ─── Payment List ─────────────────────────────────────────────────────────

  Widget _buildList() {
    // Group by month
    final grouped = <String, List<Payment>>{};
    for (final p in controller.payments) {
      final key = monthYear(p.date);
      grouped.putIfAbsent(key, () => []).add(p);
    }

    return FadeTransition(
      opacity: _fadeAnim,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        children: [
          for (final entry in grouped.entries) ...[
            GroupHeader(month: entry.key, total: entry.value.fold(0.0, (s, p) => s + p.amount)),
            const SizedBox(height: 8),
            ...entry.value.map((p) => PaymentTile(payment: p, incVat: controller.incVat)),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}