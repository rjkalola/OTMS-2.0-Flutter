import 'package:flutter/material.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class Payment {
  final String address;
  final String postcode;
  final double amount;
  final DateTime date;
  final PaymentStatus status;

  const Payment({
    required this.address,
    required this.postcode,
    required this.amount,
    required this.date,
    required this.status,
  });
}

enum PaymentStatus { paid, pending, overdue }

final _received = [
  Payment(address: '1 Topham, Woodgreen', postcode: 'IG2 9PS', amount: 25000, date: DateTime(2025, 9, 16), status: PaymentStatus.paid),
  Payment(address: '24 Topham, Woodgreen', postcode: 'IP2 1PS', amount: 25000, date: DateTime(2025, 9, 16), status: PaymentStatus.paid),
  Payment(address: '168 Topham, Woodgreen', postcode: 'EG2 1PS', amount: 50000, date: DateTime(2025, 7, 12), status: PaymentStatus.paid),
  Payment(address: '3 Topham, Woodgreen', postcode: 'IG2 1PS', amount: 50000, date: DateTime(2025, 6, 13), status: PaymentStatus.paid),
  Payment(address: '12 Topham, Woodgreen', postcode: 'IG3 2PS', amount: 25000, date: DateTime(2025, 5, 20), status: PaymentStatus.paid),
  Payment(address: '7 Topham, Woodgreen', postcode: 'IP1 3PS', amount: 50000, date: DateTime(2025, 4, 8), status: PaymentStatus.paid),
];

final _invoiced = [
  Payment(address: '55 Topham, Woodgreen', postcode: 'IG4 1PS', amount: 30000, date: DateTime(2025, 10, 1), status: PaymentStatus.pending),
  Payment(address: '88 Topham, Woodgreen', postcode: 'EG1 2PS', amount: 45000, date: DateTime(2025, 9, 28), status: PaymentStatus.overdue),
  Payment(address: '101 Topham, Woodgreen', postcode: 'IG2 5PS', amount: 20000, date: DateTime(2025, 9, 15), status: PaymentStatus.pending),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class AllPaymentsScreen extends StatefulWidget {
  const AllPaymentsScreen({super.key});

  @override
  State<AllPaymentsScreen> createState() => _AllPaymentsScreenState();
}

class _AllPaymentsScreenState extends State<AllPaymentsScreen>
    with SingleTickerProviderStateMixin {
  int _tab = 0; // 0 = Received, 1 = Invoiced
  bool _incVat = false;
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;

  List<Payment> get _payments => _tab == 0 ? _received : _invoiced;

  double get _total {
    final sum = _payments.fold(0.0, (s, p) => s + p.amount);
    return _incVat ? sum * 1.2 : sum;
  }

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
    if (t == _tab) return;
    setState(() => _tab = t);
    _ctrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildTabBar(),
            _buildSummaryBanner(),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  // ─── App Bar ─────────────────────────────────────────────────────────────

  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 10, 16, 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 18, color: Color(0xFF1E293B)),
            onPressed: () {},
          ),
          const Text('All Payments',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.4)),
          const Spacer(),
          // VAT toggle
          GestureDetector(
            onTap: () => setState(() => _incVat = !_incVat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _incVat
                    ? const Color(0xFF2563EB)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: _incVat
                        ? const Color(0xFF2563EB)
                        : const Color(0xFFE2E8F0)),
              ),
              child: Text(
                _incVat ? 'Inc. VAT' : 'Ex. VAT',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color:
                        _incVat ? Colors.white : const Color(0xFF64748B)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _SmallIconBtn(icon: Icons.open_in_new_rounded),
          const SizedBox(width: 4),
          _SmallIconBtn(icon: Icons.more_vert_rounded),
        ],
      ),
    );
  }

  // ─── Tab Bar ─────────────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          _TabItem(
              label: 'Received',
              count: _received.length,
              selected: _tab == 0,
              onTap: () => _switchTab(0)),
          _TabItem(
              label: 'Invoiced',
              count: _invoiced.length,
              selected: _tab == 1,
              onTap: () => _switchTab(1)),
        ],
      ),
    );
  }

  // ─── Summary Banner ───────────────────────────────────────────────────────

  Widget _buildSummaryBanner() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _tab == 0
              ? [const Color(0xFF16A34A), const Color(0xFF22C55E)]
              : [const Color(0xFF1D4ED8), const Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (_tab == 0
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
                  _tab == 0 ? 'Total Received' : 'Total Invoiced',
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
                    _fmtGbp(_total),
                    key: ValueKey(_total),
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
                        _incVat ? 'Inc. VAT (20%)' : 'Exc. VAT',
                        style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_payments.length} transactions',
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
          _MiniBarChart(payments: _payments),
        ],
      ),
    );
  }

  // ─── Payment List ─────────────────────────────────────────────────────────

  Widget _buildList() {
    // Group by month
    final grouped = <String, List<Payment>>{};
    for (final p in _payments) {
      final key = _monthYear(p.date);
      grouped.putIfAbsent(key, () => []).add(p);
    }

    return FadeTransition(
      opacity: _fadeAnim,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        children: [
          for (final entry in grouped.entries) ...[
            _GroupHeader(month: entry.key, total: entry.value.fold(0.0, (s, p) => s + p.amount)),
            const SizedBox(height: 8),
            ...entry.value.map((p) => _PaymentTile(payment: p, incVat: _incVat)),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

// ─── Sub-Widgets ──────────────────────────────────────────────────────────────

class _SmallIconBtn extends StatelessWidget {
  final IconData icon;
  const _SmallIconBtn({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Icon(icon, size: 16, color: const Color(0xFF64748B)),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _TabItem(
      {required this.label,
      required this.count,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected
                    ? const Color(0xFF2563EB)
                    : const Color(0xFFE2E8F0),
                width: selected ? 2.5 : 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF94A3B8)),
              ),
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFEFF6FF)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? const Color(0xFF2563EB)
                          : const Color(0xFF94A3B8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  final String month;
  final double total;

  const _GroupHeader({required this.month, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(month,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF94A3B8),
                letterSpacing: 0.5)),
        Text(_fmtGbp(total),
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF64748B))),
      ],
    );
  }
}

class _PaymentTile extends StatefulWidget {
  final Payment payment;
  final bool incVat;

  const _PaymentTile({required this.payment, required this.incVat});

  @override
  State<_PaymentTile> createState() => _PaymentTileState();
}

class _PaymentTileState extends State<_PaymentTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.payment;
    final amount = widget.incVat ? p.amount * 1.2 : p.amount;
    final statusColor = _statusColor(p.status);
    final statusLabel = _statusLabel(p.status);

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Address icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(Icons.home_work_rounded,
                      size: 20, color: statusColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.address,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A)),
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(p.postcode,
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _fmtGbp(amount),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: statusColor,
                          letterSpacing: -0.3),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(statusLabel,
                          style: TextStyle(
                              fontSize: 10,
                              color: statusColor,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 12),
              Divider(color: Colors.grey[100]),
              const SizedBox(height: 8),
              _InfoRow(
                  label: 'Date',
                  value: _fmtDate(p.date)),
              const SizedBox(height: 4),
              _InfoRow(
                  label: 'Net Amount',
                  value: _fmtGbp(p.amount)),
              if (widget.incVat) ...[
                const SizedBox(height: 4),
                _InfoRow(
                    label: 'VAT (20%)',
                    value: _fmtGbp(p.amount * 0.2),
                    valueColor: const Color(0xFF94A3B8)),
                const SizedBox(height: 4),
                _InfoRow(
                    label: 'Total Inc. VAT',
                    value: _fmtGbp(p.amount * 1.2),
                    valueColor: statusColor),
              ],
              const SizedBox(height: 4),
              _InfoRow(label: 'Reference', value: '#REF-${p.postcode.replaceAll(' ', '')}'),
            ],
          ],
        ),
      ),
    );
  }

  Color _statusColor(PaymentStatus s) {
    switch (s) {
      case PaymentStatus.paid:
        return const Color(0xFF22C55E);
      case PaymentStatus.pending:
        return const Color(0xFFF59E0B);
      case PaymentStatus.overdue:
        return const Color(0xFFEF4444);
    }
  }

  String _statusLabel(PaymentStatus s) {
    switch (s) {
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.overdue:
        return 'Overdue';
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
        Text(value,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: valueColor ?? const Color(0xFF0F172A))),
      ],
    );
  }
}

// ─── Mini Bar Chart ───────────────────────────────────────────────────────────

class _MiniBarChart extends StatelessWidget {
  final List<Payment> payments;
  const _MiniBarChart({required this.payments});

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) return const SizedBox.shrink();
    final max = payments.map((p) => p.amount).reduce((a, b) => a > b ? a : b);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: payments.take(5).map((p) {
        final h = (p.amount / max) * 36;
        return Container(
          width: 6,
          height: h,
          margin: const EdgeInsets.only(left: 3),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

String _fmtGbp(double v) {
  final s = v % 1 == 0 ? v.toStringAsFixed(2) : v.toStringAsFixed(2);
  final parts = s.split('.');
  final buf = StringBuffer();
  for (int i = 0; i < parts[0].length; i++) {
    if (i > 0 && (parts[0].length - i) % 3 == 0) buf.write(',');
    buf.write(parts[0][i]);
  }
  return '£${buf.toString()}.${parts[1]}';
}

String _monthYear(DateTime d) {
  const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${months[d.month]} ${d.year}';
}

String _fmtDate(DateTime d) {
  const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${d.day} ${months[d.month]} ${d.year}';
}
