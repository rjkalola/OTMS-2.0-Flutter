import 'package:belcka/pages/project/project_analytics/labor_details/model/labor_details_model.dart';
import 'package:belcka/pages/project/project_analytics/material_details/controller/materials_details_controller.dart';
import 'package:belcka/pages/project/project_analytics/material_details/model/material_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class MaterialsDetailsScreen extends StatefulWidget {
  const MaterialsDetailsScreen({super.key});

  @override
  State<MaterialsDetailsScreen> createState() => _MaterialsDetailsScreenState();
}

class _MaterialsDetailsScreenState extends State<MaterialsDetailsScreen>
    with SingleTickerProviderStateMixin {

  final controller = Get.put(MaterialsDetailsController());

  // Summary counts
  int get completedCount => filtered.where((o) => o.status == OrderStatus.completed).length;
  int get returnedCount => filtered.where((o) => o.status == OrderStatus.returned).length;
  int get cancelledCount => filtered.where((o) => o.status == OrderStatus.cancelled).length;
  double get filteredTotal => filtered.fold(0.0, (s, o) => s + o.amount);

  List<MaterialOrder> get filtered {
    var list = controller.orders;
    if (controller.searchQuery.isNotEmpty) {
      final q = controller.searchQuery.toLowerCase();
      list = list.where((o) =>
      o.orderId.toLowerCase().contains(q) ||
          o.address.toLowerCase().contains(q) ||
          o.user.toLowerCase().contains(q) || _statusLabel(o.status).toLowerCase().contains(q)
      ).toList();
    }
    return list;
  }

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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
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
    );
  }

  // ─── App Bar ─────────────────────────────────────────────────────────────

  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 10, 12, 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Color(0xFF1E293B)),
            onPressed: () {},
          ),
          const Text('Materials Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), letterSpacing: -0.4)),
          const Spacer(),
          _AppBarBtn(icon: Icons.search_rounded, active: controller.searchOpen, onTap: () {
            setState(() {
              controller.searchOpen = !controller.searchOpen;
              if (!controller.searchOpen) { controller.searchQuery = ''; controller.searchCtrl.clear(); }
            });
          }),
          const SizedBox(width: 4),
          _AppBarBtn(icon: Icons.tune_rounded, onTap: () {}),
          const SizedBox(width: 4),
          _AppBarBtn(icon: Icons.more_vert_rounded, onTap: () {}),
        ],
      ),
    );
  }

  // ─── Budget Card ──────────────────────────────────────────────────────────

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
                    Text(_fmtGbp(controller.totalBudget),
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
                    Text('+${_fmtGbp(controller.overspending)}',
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
              _BudgetStat(label: 'Spent', value: _fmtGbp(controller.spent), dotColor: Colors.white),
              const Spacer(),
              _BudgetStat(label: 'Overspending', value: _fmtGbp(controller.overspending), dotColor: Colors.white38, alignRight: true),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Period Row ───────────────────────────────────────────────────────────

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
          Expanded(child: _StatChip(label: 'Completed', count: completedCount, color: const Color(0xFF22C55E))),
          const SizedBox(width: 8),
          Expanded(child: _StatChip(label: 'Returned', count: returnedCount, color: const Color(0xFFF97316))),
          const SizedBox(width: 8),
          Expanded(child: _StatChip(label: 'Cancelled', count: cancelledCount, color: const Color(0xFFEF4444))),
          const SizedBox(width: 8),
          Expanded(child: _StatChip(label: 'Total', count: filtered.length, color: const Color(0xFF6366F1))),
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
    final orders = filtered;
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
              child: _OrderTile(order: orders[i]),
            ),
          );
        },
        childCount: orders.length,
      ),
    );
  }

  // Helpers
  String _statusLabel(OrderStatus s) {
    switch (s) {
      case OrderStatus.completed: return 'Completed';
      case OrderStatus.returned: return 'Returned';
      case OrderStatus.cancelled: return 'Cancelled';
      case OrderStatus.pending: return 'Pending';
    }
  }
}

// ─── Order Tile ───────────────────────────────────────────────────────────────

class _OrderTile extends StatefulWidget {
  final MaterialOrder order;
  const _OrderTile({required this.order});

  @override
  State<_OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<_OrderTile> {
  bool _expanded = false;

  Color get _statusColor {
    switch (widget.order.status) {
      case OrderStatus.completed: return const Color(0xFF22C55E);
      case OrderStatus.returned: return const Color(0xFFF97316);
      case OrderStatus.cancelled: return const Color(0xFFEF4444);
      case OrderStatus.pending: return const Color(0xFF6366F1);
    }
  }

  String get _statusLabel {
    switch (widget.order.status) {
      case OrderStatus.completed: return 'Completed';
      case OrderStatus.returned: return 'Returned';
      case OrderStatus.cancelled: return 'Cancelled';
      case OrderStatus.pending: return 'Pending';
    }
  }

  IconData get _statusIcon {
    switch (widget.order.status) {
      case OrderStatus.completed: return Icons.check_circle_rounded;
      case OrderStatus.returned: return Icons.keyboard_return_rounded;
      case OrderStatus.cancelled: return Icons.cancel_rounded;
      case OrderStatus.pending: return Icons.hourglass_top_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _expanded ? _statusColor.withOpacity(0.4) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _expanded
                  ? _statusColor.withOpacity(0.12)
                  : Colors.black.withOpacity(0.04),
              blurRadius: _expanded ? 20 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: status badge + items count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _statusColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _statusColor.withOpacity(0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_statusIcon, size: 11, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(_statusLabel,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                // Items fraction
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.inventory_2_rounded, size: 12, color: Color(0xFF94A3B8)),
                      const SizedBox(width: 4),
                      Text('${o.itemsDelivered}/${o.itemsTotal}',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Order ID + date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order: ${o.orderId}',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), letterSpacing: -0.2)),
                Text(_fmtDate(o.date),
                    style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 8),
            // Divider
            Divider(color: Colors.grey[100], height: 1),
            const SizedBox(height: 8),
            // Amount + address + user
            Row(
              children: [
                // Left: amount + address
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.payments_rounded, size: 13, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 5),
                          Text(_fmtGbp(o.amount),
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, size: 13, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 4),
                          Text(o.address,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: _statusColor,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  decorationColor: _statusColor)),
                        ],
                      ),
                    ],
                  ),
                ),
                // Right: user
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('User', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(o.user,
                            style: TextStyle(
                                fontSize: 12,
                                color: _statusColor,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(width: 4),
                        Container(
                          width: 22, height: 22,
                          decoration: BoxDecoration(
                            color: _statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              o.user.split(' ').map((w) => w[0]).take(2).join(),
                              style: TextStyle(fontSize: 9, color: _statusColor, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            // Expanded detail
            if (_expanded) ...[
              const SizedBox(height: 12),
              Divider(color: Colors.grey[100], height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _DetailStat(label: 'Order ID', value: o.orderId, color: _statusColor)),
                  Expanded(child: _DetailStat(label: 'Items', value: '${o.itemsDelivered}/${o.itemsTotal}', color: _statusColor)),
                  Expanded(child: _DetailStat(label: 'Amount', value: _fmtGbp(o.amount), color: _statusColor)),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 13, color: _statusColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _statusNote(o.status),
                        style: TextStyle(fontSize: 11, color: _statusColor, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _statusNote(OrderStatus s) {
    switch (s) {
      case OrderStatus.completed: return 'All items delivered and confirmed.';
      case OrderStatus.returned: return 'Items were returned to supplier.';
      case OrderStatus.cancelled: return 'Order was cancelled before delivery.';
      case OrderStatus.pending: return 'Awaiting delivery confirmation.';
    }
  }
}

// ─── Reusable Sub-Widgets ─────────────────────────────────────────────────────

class _AppBarBtn extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  const _AppBarBtn({required this.icon, this.active = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFEF2F2) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: active ? const Color(0xFFEF4444) : const Color(0xFFE2E8F0)),
        ),
        child: Icon(icon, size: 17, color: active ? const Color(0xFFEF4444) : const Color(0xFF64748B)),
      ),
    );
  }
}

class _BudgetStat extends StatelessWidget {
  final String label;
  final String value;
  final Color dotColor;
  final bool alignRight;
  const _BudgetStat({required this.label, required this.value, required this.dotColor, this.alignRight = false});

  @override
  Widget build(BuildContext context) {
    final dot = Container(width: 7, height: 7, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle));
    final labelW = Text(label, style: const TextStyle(fontSize: 10, color: Colors.white60, fontWeight: FontWeight.w500));
    return Column(
      crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: alignRight ? [labelW, const SizedBox(width: 5), dot] : [dot, const SizedBox(width: 5), labelW],
        ),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _StatChip({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
            child: Center(child: Text('$count', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: color))),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _DetailStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _DetailStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
      ],
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

String _fmtGbp(double v) {
  final s = v.toStringAsFixed(2);
  final parts = s.split('.');
  final buf = StringBuffer();
  for (int i = 0; i < parts[0].length; i++) {
    if (i > 0 && (parts[0].length - i) % 3 == 0) buf.write(',');
    buf.write(parts[0][i]);
  }
  return '£${buf.toString()}.${parts[1]}';
}

String _fmtDate(DateTime d) {
  const m = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${d.day.toString().padLeft(2, '0')} ${m[d.month]} ${d.year}';
}
