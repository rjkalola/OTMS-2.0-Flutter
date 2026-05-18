import 'dart:math' as math;
import 'package:flutter/material.dart';

class BudgetItem {
  final String label;
  final double amount;
  final double spent;
  final Color color;
  final bool overspent;
  final double? overspentBy;

  const BudgetItem({
    required this.label,
    required this.amount,
    required this.spent,
    required this.color,
    this.overspent = false,
    this.overspentBy,
  });
}

class Payment {
  final String address;
  final String postcode;
  final double amount;
  final DateTime date;

  const Payment({
    required this.address,
    required this.postcode,
    required this.amount,
    required this.date,
  });
}

// ─── Main Screen ─────────────────────────────────────────────────────────────

class ProjectAnalyticsScreen extends StatefulWidget {
  const ProjectAnalyticsScreen({super.key});

  @override
  State<ProjectAnalyticsScreen> createState() => _ProjectAnalyticsScreenState();
}

class _ProjectAnalyticsScreenState extends State<ProjectAnalyticsScreen>
    with SingleTickerProviderStateMixin {
  int _selectedPaymentTab = 0;
  late AnimationController _animController;
  late Animation<double> _fadeIn;

  final List<BudgetItem> budgets = const [
    BudgetItem(label: 'Labor', amount: 150000, spent: 110000, color: Color(0xFF22C55E)),
    BudgetItem(
        label: 'Materials',
        amount: 200000,
        spent: 220500.42,
        color: Color(0xFFF97316),
        overspent: true,
        overspentBy: 20500.42),
    BudgetItem(label: 'Others', amount: 60000, spent: 30000, color: Color(0xFF60A5FA)),
  ];

  final List<Payment> received = [
    Payment(address: '1 Topham, Woodgreen', postcode: 'IG2 9PS', amount: 25000, date: _d(2025, 9, 16)),
    Payment(address: '24 Topham, Woodgreen', postcode: 'IP2 1PS', amount: 25000, date: _d(2025, 9, 16)),
    Payment(address: '168 Topham, Woodgreen', postcode: 'EG2 1PS', amount: 50000, date: _d(2025, 7, 12)),
    Payment(address: '3 Topham, Woodgreen', postcode: 'IG2 1PS', amount: 50000, date: _d(2025, 6, 13)),
  ];

  static DateTime _d(int y, int m, int d) => DateTime(y, m, d);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeIn,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 20),
                  _buildBudgetCard(),
                  const SizedBox(height: 16),
                  _buildPaymentsCard(),
                  const SizedBox(height: 16),
                  _buildQuickStats(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── App Bar ─────────────────────────────────────────────────────────────
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Color(0xFF1E293B)),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F4F8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.open_in_new_rounded, size: 18, color: Color(0xFF1E293B)),
            onPressed: () {},
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8, right: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F4F8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.more_vert_rounded, size: 18, color: Color(0xFF1E293B)),
            onPressed: () {},
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.fadeTitle],
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Project Analytics',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Camden FRA',
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xFF0F172A),
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.arrow_forward_ios_rounded,
                      size: 10, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Budget Card ─────────────────────────────────────────────────────────

  Widget _buildBudgetCard() {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Budget',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3)),
              _PillBadge(label: 'All Budgets', onTap: () {}),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: budgets
                      .map((b) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _BudgetRow(item: b),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 120,
                height: 120,
                child: _DonutChart(
                  sections: [
                    DonutSection(value: 110000, color: const Color(0xFF22C55E)),
                    DonutSection(value: 220500, color: const Color(0xFFF97316)),
                    DonutSection(value: 30000, color: const Color(0xFF60A5FA)),
                    DonutSection(value: 89500, color: const Color(0xFFE2E8F0)),
                  ],
                  centerLabel: 'Profit',
                  centerValue: '£50,000',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Payments Card ────────────────────────────────────────────────────────

  Widget _buildPaymentsCard() {
    final total = received.fold(0.0, (s, p) => s + p.amount);

    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Payments',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3)),
              _PillBadge(label: 'All Payments', onTap: () {}),
            ],
          ),
          const SizedBox(height: 16),
          // Tab Bar
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                _TabButton(
                  label: 'Received',
                  selected: _selectedPaymentTab == 0,
                  onTap: () => setState(() => _selectedPaymentTab = 0),
                ),
                _TabButton(
                  label: 'Invoiced',
                  selected: _selectedPaymentTab == 1,
                  onTap: () => setState(() => _selectedPaymentTab = 1),
                ),
              ],
            ),
          ),
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
                  '${received.length} transactions',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Divider
          Divider(color: Colors.grey[100], thickness: 1),
          const SizedBox(height: 4),
          // Payment list
          ...received.map((p) => _PaymentRow(payment: p)),
        ],
      ),
    );
  }

  // ─── Quick Stats ──────────────────────────────────────────────────────────

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
            child: _StatCard(
                icon: Icons.trending_up_rounded,
                iconColor: const Color(0xFF22C55E),
                label: 'Revenue',
                value: '£430k')),
        const SizedBox(width: 12),
        Expanded(
            child: _StatCard(
                icon: Icons.schedule_rounded,
                iconColor: const Color(0xFFF59E0B),
                label: 'Pending',
                value: '£80k')),
        const SizedBox(width: 12),
        Expanded(
            child: _StatCard(
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

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _PillBadge extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PillBadge({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFBFDBFE), width: 1),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF2563EB),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _BudgetRow extends StatelessWidget {
  final BudgetItem item;
  const _BudgetRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final progress = (item.spent / item.amount).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item.label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569))),
            Text(
              '£${_fmtShort(item.amount)}',
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: item.color.withOpacity(0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        if (item.overspent)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                const Icon(Icons.warning_rounded, size: 10, color: Color(0xFFF97316)),
                const SizedBox(width: 3),
                Text(
                  'Overspending  +£${_fmtShort(item.overspentBy!)}',
                  style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFFF97316),
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _fmtShort(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)},000';
    return v.toStringAsFixed(0);
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final Payment payment;
  const _PaymentRow({required this.payment});

  @override
  Widget build(BuildContext context) {
    final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateStr = '${payment.date.day} ${months[payment.date.month]} ${payment.date.year}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.home_work_rounded,
                size: 18, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.address,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A)),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${payment.postcode} · $dateStr',
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '£${(payment.amount / 1000).toStringAsFixed(0)}k',
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF22C55E)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('Paid',
                    style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF16A34A),
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  const _StatCard(
      {required this.icon,
      required this.iconColor,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(height: 10),
          Text(value,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A))),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  const _NavIcon({required this.icon, required this.active});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFEFF6FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            size: 24,
            color: active ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1),
          ),
        ),
        if (active)
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}

// ─── Custom Donut Chart ───────────────────────────────────────────────────────

class DonutSection {
  final double value;
  final Color color;
  const DonutSection({required this.value, required this.color});
}

class _DonutChart extends StatelessWidget {
  final List<DonutSection> sections;
  final String centerLabel;
  final String centerValue;
  const _DonutChart(
      {required this.sections,
      required this.centerLabel,
      required this.centerValue});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DonutPainter(sections: sections),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(centerLabel,
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w500)),
            Text(
              centerValue,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2563EB)),
            ),
          ],
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<DonutSection> sections;
  _DonutPainter({required this.sections});

  @override
  void paint(Canvas canvas, Size size) {
    final total = sections.fold(0.0, (s, e) => s + e.value);
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = math.min(cx, cy) - 6;
    const strokeW = 14.0;
    const gap = 0.04;

    double startAngle = -math.pi / 2;

    for (final s in sections) {
      final sweep = (s.value / total) * (2 * math.pi) - gap;
      final paint = Paint()
        ..color = s.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: radius),
        startAngle,
        sweep,
        false,
        paint,
      );
      startAngle += sweep + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
