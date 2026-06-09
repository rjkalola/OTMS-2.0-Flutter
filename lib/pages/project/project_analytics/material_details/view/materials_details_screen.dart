import 'package:belcka/pages/project/project_analytics/labor_details/model/labor_details_model.dart';
import 'package:belcka/pages/project/project_analytics/labor_details/view/widgets/app_bar_btn.dart';
import 'package:belcka/pages/project/project_analytics/material_details/controller/materials_details_controller.dart';
import 'package:belcka/pages/project/project_analytics/material_details/view/widgets/budget_stat.dart';
import 'package:belcka/pages/project/project_analytics/material_details/view/widgets/order_tile.dart';
import 'package:belcka/pages/project/project_analytics/material_details/view/widgets/stat_chip.dart';
import 'package:belcka/pages/user_orders/widgets/orders_base_app_bar.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class MaterialsDetailsScreen extends StatefulWidget {
  const MaterialsDetailsScreen({super.key});

  @override
  State<MaterialsDetailsScreen> createState() => _MaterialsDetailsScreenState();
}

class _MaterialsDetailsScreenState extends State<MaterialsDetailsScreen>
    with SingleTickerProviderStateMixin {

  final controller = Get.put(MaterialsDetailsController());

  @override
  void initState() {
    super.initState();
    controller.ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    controller.fadeAnim = CurvedAnimation(parent: controller.ctrl, curve: Curves.easeOut);
    controller.ctrl.forward();
  }

  @override
  void dispose() {
    controller.ctrl.dispose();
    controller.searchCtrl.dispose();
    super.dispose();
  }

  void _setFilter(FilterPeriod f) {
    setState(() => controller.filter = f);
    controller.ctrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Scaffold(
      backgroundColor: dashBoardBgColor_(context),
      appBar: OrdersBaseAppBar(
        appBar: AppBar(),
        title: "Materials Details".tr,
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
              //controller.getProjectAnalyticsApi();
            },
          )
              : Visibility(
          visible: controller.isMainViewVisible.value,
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(child: _buildBudgetCard()),
                    SliverToBoxAdapter(child: _buildPeriodRow()),
                    SliverToBoxAdapter(child: _buildFilterRow()),
                    SliverToBoxAdapter(child: _buildStatusSummary()),
                    if (controller.searchOpen) SliverToBoxAdapter(child: _buildSearchBar()),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                      sliver: _buildOrdersList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        )
      ),
    );
  }
  List<Widget>? actionButtons() {
    return [
      SizedBox(
        width: 6,
      ),
      AppBarBtn(icon: Icons.search_rounded, active: controller.searchOpen, onTap: () {
        setState(() {
          controller.searchOpen = !controller.searchOpen;
          if (!controller.searchOpen) { controller.searchQuery = ''; controller.searchCtrl.clear(); }
        });
      }),
      const SizedBox(width: 4),
      AppBarBtn(icon: Icons.tune_rounded, onTap: () {}),
      const SizedBox(width: 4),
      AppBarBtn(icon: Icons.more_vert_rounded, onTap: () {}),
      SizedBox(width: 16,),
    ];
  }

  // ─── Budget Card

  Widget _buildBudgetCard() {
    final progress = (controller.spent / controller.totalBudget).clamp(0.0, 1.0);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7F1D1D), Color(0xFFEF4444)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF4444).withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Materials Budget',
                        style: TextStyle(fontSize: 12, color: Colors.white60, fontWeight: FontWeight.w500, letterSpacing: 0.4)),
                    const SizedBox(height: 4),
                    Text(fmtGbp(controller.totalBudget),
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1)),
                  ],
                ),
              ),
              // Overspending badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 13, color: Colors.white),
                    const SizedBox(width: 4),
                    Text('+${fmtGbp(controller.overspending)}',
                        style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Full progress bar (overspent = full red)
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.5), blurRadius: 6, offset: const Offset(0, 1))],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              BudgetStat(label: 'Spent', value: fmtGbp(controller.spent), dotColor: Colors.white),
              const Spacer(),
              BudgetStat(label: 'Overspending', value: fmtGbp(controller.overspending), dotColor: Colors.white38, alignRight: true),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Period Row

  Widget _buildPeriodRow() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.calendar_month_rounded, size: 18, color: Color(0xFFEF4444)),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Period', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
              SizedBox(height: 2),
              Text('01 Jan 25  –  31 Dec 25',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('Change', style: TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ─── Filter Row ───────────────────────────────────────────────────────────

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: FilterPeriod.values.map((f) {
          final selected = controller.filter == f;
          final label = f.name[0].toUpperCase() + f.name.substring(1);
          return Expanded(
            child: GestureDetector(
              onTap: () => _setFilter(f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFFEF4444) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: selected
                          ? const Color(0xFFEF4444).withOpacity(0.35)
                          : Colors.black.withOpacity(0.04),
                      blurRadius: selected ? 10 : 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(label,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: selected ? Colors.white : const Color(0xFF94A3B8))),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Status Summary ───────────────────────────────────────────────────────
  Widget _buildStatusSummary() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Expanded(child: StatChip(label: 'Completed', count: controller.completedCount, color: const Color(0xFF22C55E))),
          const SizedBox(width: 8),
          Expanded(child: StatChip(label: 'Returned', count: controller.returnedCount, color: const Color(0xFFF97316))),
          const SizedBox(width: 8),
          Expanded(child: StatChip(label: 'Cancelled', count: controller.cancelledCount, color: const Color(0xFFEF4444))),
          const SizedBox(width: 8),
          Expanded(child: StatChip(label: 'Total', count: controller.filtered.length, color: const Color(0xFF6366F1))),
        ],
      ),
    );
  }

  // ─── Search Bar ───────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: TextField(
          controller: controller.searchCtrl,
          autofocus: true,
          onChanged: (v) => setState(() => controller.searchQuery = v),
          decoration: InputDecoration(
            hintText: 'Search orders, address, user…',
            hintStyle: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13),
            prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 20),
            suffixIcon: controller.searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8), size: 18),
                    onPressed: () => setState(() { controller.searchQuery = ''; controller.searchCtrl.clear(); }),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  // ─── Orders List ──────────────────────────────────────────────────────────

  Widget _buildOrdersList() {
    final orders = controller.filtered;
    if (orders.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              children: [
                Icon(Icons.inbox_rounded, size: 48, color: Colors.grey[300]),
                const SizedBox(height: 12),
                Text('No orders found', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
              ],
            ),
          ),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, i) {
          final delay = (i * 0.07).clamp(0.0, 0.55);
          final itemAnim = CurvedAnimation(
            parent: controller.ctrl,
            curve: Interval(delay, (delay + 0.4).clamp(0, 1), curve: Curves.easeOutCubic),
          );
          return AnimatedBuilder(
            animation: itemAnim,
            builder: (_, child) => Opacity(
              opacity: itemAnim.value,
              child: Transform.translate(offset: Offset(0, 20 * (1 - itemAnim.value)), child: child),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OrderTile(order: orders[i]),
            ),
          );
        },
        childCount: orders.length,
      ),
    );
  }
}
