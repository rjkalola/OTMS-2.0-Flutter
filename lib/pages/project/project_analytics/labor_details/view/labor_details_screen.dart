import 'package:belcka/pages/project/project_analytics/labor_details/controller/labor_details_controller.dart';
import 'package:belcka/pages/project/project_analytics/labor_details/model/labor_details_model.dart';
import 'package:belcka/pages/project/project_analytics/labor_details/view/widgets/app_bar_btn.dart';
import 'package:belcka/pages/project/project_analytics/labor_details/view/widgets/budget_legend.dart';
import 'package:belcka/pages/project/project_analytics/labor_details/view/widgets/circular_progress.dart';
import 'package:belcka/pages/project/project_analytics/labor_details/view/widgets/labor_tile.dart';
import 'package:belcka/pages/project/project_analytics/labor_details/view/widgets/meta_item.dart';
import 'package:belcka/pages/project/project_analytics/labor_details/view/widgets/summary_chip.dart';
import 'package:belcka/pages/user_orders/widgets/orders_base_app_bar.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LaborDetailsScreen extends StatefulWidget {
  const LaborDetailsScreen({super.key});

  @override
  State<LaborDetailsScreen> createState() => _LaborDetailsScreenState();
}

class _LaborDetailsScreenState extends State<LaborDetailsScreen>
    with SingleTickerProviderStateMixin {

  final controller = Get.put(LaborDetailsController());

  @override
  void initState() {
    super.initState();
    controller.ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
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
        title: 'Labor Details',
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
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: _buildBudgetCard()),
                  SliverToBoxAdapter(child: _buildMetaRow()),
                  SliverToBoxAdapter(child: _buildFilterRow()),
                  SliverToBoxAdapter(child: _buildSummaryRow()),
                  if (controller.searchOpen) SliverToBoxAdapter(child: _buildSearchBar()),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                    sliver: _buildEntriesList(),
                  ),
                ],
              ),
            ),
          ],
        )),
        )
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      AppBarBtn(
        icon: Icons.search_rounded,
        active: controller.searchOpen,
        onTap: () => setState(() {
          controller.searchOpen = !controller.searchOpen;
          if (!controller.searchOpen) {
            controller.searchQuery = '';
            controller.searchCtrl.clear();
          }
        }),
      ),
      const SizedBox(width: 4),
      AppBarBtn(icon: Icons.tune_rounded, onTap: () {}),
      const SizedBox(width: 4),
      AppBarBtn(icon: Icons.more_vert_rounded, onTap: () {}),
      SizedBox(width: 16,)
    ];
  }

  // Budget Card
  Widget _buildBudgetCard() {
    final progress = (controller.spent / controller.totalBudget).clamp(0.0, 1.0);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF166534), Color(0xFF22C55E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF22C55E).withOpacity(0.3),
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
                    const Text('Labor Budget',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white60,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.4)),
                    const SizedBox(height: 4),
                    Text(
                      fmtGbp(controller.totalBudget, decimals: 0),
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -1),
                    ),
                  ],
                ),
              ),
              // Circular progress
              CircularProgress(
                progress: progress,
                label: '${(progress * 100).toStringAsFixed(0)}%',
                sublabel: 'used',
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 6,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              BudgetLegend(
                  dot: Colors.white,
                  label: 'Spent',
                  value: fmtGbp(controller.spent)),
              const Spacer(),
              BudgetLegend(
                  dot: Colors.white38,
                  label: 'Available',
                  value: fmtGbp(controller.available),
                  alignRight: true),
            ],
          ),
        ],
      ),
    );
  }

  //Meta Row

  Widget _buildMetaRow() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          MetaItem(
            icon: Icons.calendar_month_rounded,
            iconColor: const Color(0xFF6366F1),
            label: 'Period',
            value: '01 Jan – 31 Dec 25',
          ),
          SizedBox(height: 8,),
          MetaItem(
            icon: Icons.group_rounded,
            iconColor: const Color(0xFF0EA5E9),
            label: 'Workers',
            value: '${controller.allEntries.length} people',
          ),
        ],
      ),
    );
  }

  // ─── Filter Row ───────────────────────────────────────────────────────────

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
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
                  color: selected
                      ? const Color(0xFF22C55E)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF22C55E).withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          )
                        ],
                ),
                child: Center(
                  child: Text(label,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF94A3B8))),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  //Summary Row

  Widget _buildSummaryRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: SummaryChip(
              icon: Icons.access_time_rounded,
              color: const Color(0xFF6366F1),
              label: 'Total Hours',
              value: '${controller.totalHours.toStringAsFixed(0)}h',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SummaryChip(
              icon: Icons.payments_rounded,
              color: const Color(0xFF22C55E),
              label: 'Total Paid',
              value: fmtGbp(controller.totalPaid, decimals: 0),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SummaryChip(
              icon: Icons.people_alt_rounded,
              color: const Color(0xFF0EA5E9),
              label: 'Workers',
              value: '${controller.filtered.length}',
            ),
          ),
        ],
      ),
    );
  }

  //Search Bar

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: controller.searchCtrl,
          autofocus: true,
          onChanged: (v) => setState(() => controller.searchQuery = v),
          decoration: InputDecoration(
            hintText: 'Search by name or role…',
            hintStyle: const TextStyle(
                color: Color(0xFFCBD5E1), fontSize: 13),
            prefixIcon: const Icon(Icons.search_rounded,
                color: Color(0xFF94A3B8), size: 20),
            suffixIcon: controller.searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: Color(0xFF94A3B8), size: 18),
                    onPressed: () =>
                        setState(() {
                          controller.searchQuery = '';
                          controller.searchCtrl.clear();
                        }),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  // Entries List

  Widget _buildEntriesList() {
    final entries = controller.filtered;
    if (entries.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              children: [
                Icon(Icons.search_off_rounded,
                    size: 48, color: Colors.grey[300]),
                const SizedBox(height: 12),
                Text('No results for "$controller.searchQuery"',
                    style: const TextStyle(
                        color: Color(0xFF94A3B8), fontSize: 14)),
              ],
            ),
          ),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, i) {
          final delay = (i * 0.07).clamp(0.0, 0.6);
          final itemAnim = CurvedAnimation(
            parent: controller.ctrl,
            curve: Interval(delay, (delay + 0.4).clamp(0, 1),
                curve: Curves.easeOutCubic),
          );
          return AnimatedBuilder(
            animation: itemAnim,
            builder: (_, child) => Opacity(
              opacity: itemAnim.value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - itemAnim.value)),
                child: child,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: LaborTile(entry: entries[i]),
            ),
          );
        },
        childCount: entries.length,
      ),
    );
  }
}
