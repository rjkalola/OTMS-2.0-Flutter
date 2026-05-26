import 'dart:math' as math;
import 'package:belcka/pages/project/project_analytics/all_budget/controller/all_budget_controller.dart';
import 'package:belcka/pages/project/project_analytics/all_budget/model/budget_category.dart';
import 'package:belcka/pages/project/project_analytics/all_budget/view/widgets/view_details_btn.dart';
import 'package:belcka/pages/user_orders/widgets/orders_base_app_bar.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AllBudgetScreen extends StatefulWidget {
  const AllBudgetScreen({super.key});

  @override
  State<AllBudgetScreen> createState() => _AllBudgetScreenState();
}

class _AllBudgetScreenState extends State<AllBudgetScreen>
    with SingleTickerProviderStateMixin {

  final controller = Get.put(AllBudgetController());

  late AnimationController _ctrl;
  late List<Animation<double>> _anims;

  double get _totalBudget =>
      controller.categories.fold(0.0, (s, c) => s + c.total);
  double get _totalSpent =>
      controller.categories.fold(0.0, (s, c) => s + c.spent);
  double get _totalRemaining => _totalBudget - _totalSpent;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1100));
    _anims = List.generate(
      controller.categories.length + 1,
      (i) => CurvedAnimation(
        parent: _ctrl,
        curve: Interval(i * 0.12, (i * 0.12 + 0.6).clamp(0, 1),
            curve: Curves.easeOutCubic),
      ),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Scaffold(
      backgroundColor: dashBoardBgColor_(context),
      appBar: OrdersBaseAppBar(
        appBar: AppBar(),
        title: 'All Budget',
        isCenterTitle: false,
        isBack: true,
        widgets: actionButtons(),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child:ModalProgressHUD(
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
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  children: [
                    _buildTotalCard(_anims[0]),
                    const SizedBox(height: 12),
                    ...List.generate(
                      controller.categories.length,
                          (i) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildCategoryCard(controller.categories[i], i, _anims[i + 1]),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFooterNote(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      _IconBtn(icon: Icons.open_in_new_rounded),
      const SizedBox(width: 8),
      _IconBtn(icon: Icons.more_vert_rounded),
      SizedBox(width: 16,)
    ];
  }
  // ─── Total Card ───────────────────────────────────────────────────────────

  Widget _buildTotalCard(Animation<double> anim) {
    final progress = (_totalSpent / _totalBudget).clamp(0.0, 1.0);
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
            .animate(anim),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withOpacity(0.35),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Budget',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3)),
                      const SizedBox(height: 4),
                      Text(
                        _fmtGbp(_totalBudget),
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -1),
                      ),
                    ],
                  ),
                  _MiniDonut(
                    progress: progress,
                    color: Colors.white,
                    trackColor: Colors.white24,
                    label: '${(progress * 100).toStringAsFixed(0)}%',
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Segmented progress bar
              _SegmentedBar(categories: controller.categories, total: _totalBudget),
              const SizedBox(height: 12),
              Row(
                children: [
                  _LegendDot(
                      color: Colors.white60,
                      label: '${_fmtGbp(_totalSpent)} spent'),
                  const Spacer(),
                  _LegendDot(
                      color: const Color(0xFF86EFAC),
                      label: '${_fmtGbp(_totalRemaining.abs())} left'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Category Card ────────────────────────────────────────────────────────
  Widget _buildCategoryCard(BudgetCategory cat, int index, Animation<double> anim) {
    final isSelected = controller.selectedIndex == index;

    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
            .animate(anim),
        child: GestureDetector(
          onTap: () =>
              setState(() => controller.selectedIndex = isSelected ? null : index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? cat.color.withOpacity(0.6)
                    : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? cat.color.withOpacity(0.15)
                      : Colors.black.withOpacity(0.04),
                  blurRadius: isSelected ? 20 : 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category icon
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: cat.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(_catIcon(cat.name),
                          size: 20, color: cat.color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cat.name,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                  letterSpacing: -0.2)),
                          const SizedBox(height: 2),
                          Text(
                            _fmtGbp(cat.total),
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF0F172A),
                                letterSpacing: -0.5,
                                shadows: [
                                  Shadow(
                                      color: cat.color.withOpacity(0.0),
                                      blurRadius: 0)
                                ]),
                          ),
                        ],
                      ),
                    ),
                    ViewDetailsBtn(
                      color: cat.color,
                      onTap: (){
                        if (cat.type == "labor"){
                          controller.moveToScreen(AppRoutes.laborDetailsScreen,[]);
                        }
                        else if (cat.type == "materials"){
                          controller.moveToScreen(AppRoutes.materialsDetailsScreen,[]);
                        }
                        else if (cat.type == "others"){

                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Progress bar
                _AnimatedProgressBar(
                  progress: cat.progress,
                  color: cat.color,
                  overspent: cat.isOverspent,
                  anim: anim,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                                color: cat.color.withOpacity(0.5),
                                shape: BoxShape.circle)),
                        const SizedBox(width: 5),
                        Text(
                          '-${_fmtGbp(cat.spent)} spent',
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    cat.isOverspent
                        ? Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  size: 12, color: Color(0xFFEF4444)),
                              const SizedBox(width: 3),
                              Text(
                                '+${_fmtGbp(cat.spent - cat.total)} overspending',
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFFEF4444),
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          )
                        : Text(
                            '${_fmtGbp(cat.remaining)} left',
                            style: TextStyle(
                                fontSize: 11,
                                color: cat.color,
                                fontWeight: FontWeight.w700),
                          ),
                  ],
                ),
                // Expanded details on tap
                if (isSelected) ...[
                  const SizedBox(height: 14),
                  Divider(color: Colors.grey[100]),
                  const SizedBox(height: 10),
                  _DetailRow(label: 'Budget Allocated', value: _fmtGbp(cat.total)),
                  const SizedBox(height: 6),
                  _DetailRow(label: 'Amount Spent', value: _fmtGbp(cat.spent), valueColor: cat.color),
                  const SizedBox(height: 6),
                  _DetailRow(
                    label: cat.isOverspent ? 'Overspent By' : 'Remaining',
                    value: _fmtGbp((cat.remaining).abs()),
                    valueColor: cat.isOverspent
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF22C55E),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Footer ───────────────────────────────────────────────────────────────

  Widget _buildFooterNote() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded,
              size: 16, color: Color(0xFFF59E0B)),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Materials budget is overspent. Review allocations or raise a change order.',
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF92400E),
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  IconData _catIcon(String name) {
    switch (name) {
      case 'Labor':
        return Icons.people_alt_rounded;
      case 'Materials':
        return Icons.inventory_2_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}

// ─── Reusable widgets ─────────────────────────────────────────────────────────

class _IconBtn extends StatelessWidget {
  final IconData icon;
  const _IconBtn({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Icon(icon, size: 17, color: const Color(0xFF64748B)),
    );
  }
}

class _AnimatedProgressBar extends StatelessWidget {
  final double progress;
  final Color color;
  final bool overspent;
  final Animation<double> anim;

  const _AnimatedProgressBar({
    required this.progress,
    required this.color,
    required this.overspent,
    required this.anim,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: anim,
      builder: (_, __) => Stack(
        children: [
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          FractionallySizedBox(
            widthFactor: progress * anim.value,
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: overspent
                      ? [const Color(0xFFFCA5A5), const Color(0xFFEF4444)]
                      : [color.withOpacity(0.5), color],
                ),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.35),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedBar extends StatelessWidget {
  final List<BudgetCategory> categories;
  final double total;

  const _SegmentedBar({required this.categories, required this.total});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Row(
        children: categories.map((c) {
          final w = (c.spent / total).clamp(0.0, 1.0);
          return Expanded(
            flex: (w * 1000).round(),
            child: Container(
              height: 6,
              color: c.color,
              margin: const EdgeInsets.only(right: 2),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MiniDonut extends StatelessWidget {
  final double progress;
  final Color color;
  final Color trackColor;
  final String label;

  const _MiniDonut({
    required this.progress,
    required this.color,
    required this.trackColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: CustomPaint(
        painter: _MiniDonutPainter(
            progress: progress, color: color, trackColor: trackColor),
        child: Center(
          child: Text(label,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Colors.white)),
        ),
      ),
    );
  }
}

class _MiniDonutPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;

  _MiniDonutPainter(
      {required this.progress,
      required this.color,
      required this.trackColor});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy) - 5;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);

    canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi,
        false,
        Paint()
          ..color = trackColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..strokeCap = StrokeCap.round);

    canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w500)),
        Text(value,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: valueColor ?? const Color(0xFF0F172A))),
      ],
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

String _fmtGbp(double v) {
  final abs = v.abs();
  String s;
  if (abs == abs.roundToDouble()) {
    s = abs.toStringAsFixed(0);
  } else {
    s = abs.toStringAsFixed(2);
  }
  // Insert thousands comma
  final parts = s.split('.');
  final intPart = parts[0];
  final buf = StringBuffer();
  for (int i = 0; i < intPart.length; i++) {
    if (i > 0 && (intPart.length - i) % 3 == 0) buf.write(',');
    buf.write(intPart[i]);
  }
  return '£${buf.toString()}${parts.length > 1 ? '.${parts[1]}' : ''}';
}
