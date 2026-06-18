import 'package:flutter/material.dart';
import 'dart:math' as math;

class ActivityItem {
  final String title;
  final String address;
  final bool isCompleted;

  const ActivityItem({
    required this.title,
    required this.address,
    this.isCompleted = true,
  });
}

class ShiftSummary {
  final String date; // e.g. "11 June 2026"
  final String startedTime; // e.g. "07:43"
  final String finishedTime; // e.g. "16:50"
  final String workedTime; // e.g. "07:50"
  final double netPayable;
  final double penalties;
  final List<ActivityItem> activities;

  const ShiftSummary({
    required this.date,
    required this.startedTime,
    required this.finishedTime,
    required this.workedTime,
    required this.netPayable,
    required this.penalties,
    required this.activities,
  });

  double get totalPayable => netPayable - penalties;
}

final ShiftSummary testShiftSummary = ShiftSummary(
  date: '11 June 2026',
  startedTime: '07:43',
  finishedTime: '16:50',
  workedTime: '07:50',
  netPayable: 97.92,
  penalties: 0.00,
  activities: const [
    ActivityItem(
      title: 'Door Installation',
      address: '112 High Rd, Woodford Green, IG8 0PS',
      isCompleted: true,
    ),
    ActivityItem(
      title: 'Window Repair',
      address: '45 Forest Rd, Walthamstow, E17 3BA',
      isCompleted: true,
    ),
  ],
);

class ShiftCompletedScreen extends StatefulWidget {
  final ShiftSummary summary;
  final VoidCallback? onDone;

  const ShiftCompletedScreen({
    super.key,
    required this.summary,
    this.onDone,
  });

  @override
  State<ShiftCompletedScreen> createState() => _ShiftCompletedScreenState();
}

class _ShiftCompletedScreenState extends State<ShiftCompletedScreen> {
  bool _activityExpanded = false;

  String _currency(double value) {
    return '£${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final summary = widget.summary;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        color: Color(0xFF555770),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                children: [
                  Center(child: _SuccessBadge()),
                  const SizedBox(height: 18),

                  const Center(
                    child: Text(
                      'Shift completed',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1D2E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      'Great job today!',
                      style: TextStyle(
                        fontSize: 14.5,
                        color: const Color(0xFF1A1D2E).withOpacity(0.45),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            summary.date,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                summary.startedTime,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1A1D2E),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Started',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.grey.shade400,
                          size: 20,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                summary.finishedTime,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1A1D2E),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Finished',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9EEFC),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Worked time',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                summary.workedTime,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1A1D2E),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const _ClockPotIllustration(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 26,
                                    height: 26,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE8F0FE),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.attach_money,
                                      size: 16,
                                      color: Color(0xFF3D6CF5),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Total earnings',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _currency(summary.netPayable),
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2196F3),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: 1,
                          height: 64,
                          color: const Color(0xFFF0F1F5),
                          margin: const EdgeInsets.symmetric(horizontal: 14),
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _BreakdownRow(
                                label: 'Net payable',
                                value: _currency(summary.netPayable),
                              ),
                              const SizedBox(height: 8),
                              _BreakdownRow(
                                label: 'Penalties',
                                value: _currency(summary.penalties),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 1,
                                color: const Color(0xFFF0F1F5),
                              ),
                              const SizedBox(height: 8),
                              _BreakdownRow(
                                label: 'Total Payable',
                                value: _currency(summary.totalPayable),
                                bold: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            setState(() {
                              _activityExpanded = !_activityExpanded;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 16,
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    "Today's activity",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1A1D2E),
                                    ),
                                  ),
                                ),
                                AnimatedRotation(
                                  turns: _activityExpanded ? 0.5 : 0,
                                  duration:
                                      const Duration(milliseconds: 200),
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFFE0E1E8),
                                        width: 1.4,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 18,
                                      color: Color(0xFF555770),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeInOut,
                          child: _activityExpanded
                              ? Column(
                                  children: [
                                    const Divider(
                                      height: 1,
                                      color: Color(0xFFF0F1F5),
                                    ),
                                    ...summary.activities
                                        .map((a) => _ActivityTile(item: a)),
                                    const SizedBox(height: 6),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 14,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                MediaQuery.of(context).padding.bottom + 16,
              ),
              child: GestureDetector(
                onTap: widget.onDone ?? () => Navigator.of(context).maybePop(),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4CAF50).withOpacity(0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 130,
      child: CustomPaint(
        painter: _DottedRingPainter(),
        child: Center(
          child: Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(
              color: Color(0xFFD9F2DE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Color(0xFF2E9E4F),
              size: 38,
            ),
          ),
        ),
      ),
    );
  }
}

class _DottedRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const dotCount = 20;
    final paint = Paint()..color = const Color(0xFFBFE6CB);

    for (int i = 0; i < dotCount; i++) {
      final angle = (2 * math.pi / dotCount) * i;
      final dx = center.dx + radius * math.cos(angle);
      final dy = center.dy + radius * math.sin(angle);
      canvas.drawCircle(Offset(dx, dy), 2.2, paint);
    }
  }

  @override
  bool shouldRepaint(_DottedRingPainter oldDelegate) => false;
}

class _ClockPotIllustration extends StatelessWidget {
  const _ClockPotIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF8FB8F0), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CustomPaint(
                painter: _SimpleClockHandsPainter(),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 22,
              height: 26,
              decoration: BoxDecoration(
                color: const Color(0xFF6FA8E8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Container(
                  width: 12,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SimpleClockHandsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = const Color(0xFF4A6CF7)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, Offset(center.dx, center.dy - 10), paint);
    canvas.drawLine(center, Offset(center.dx + 7, center.dy + 2), paint);
    canvas.drawCircle(center, 1.8, Paint()..color = const Color(0xFF4A6CF7));
  }

  @override
  bool shouldRepaint(_SimpleClockHandsPainter oldDelegate) => false;
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _BreakdownRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            color: bold ? const Color(0xFF1A1D2E) : Colors.grey.shade500,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: bold ? const Color(0xFF2196F3) : const Color(0xFF1A1D2E),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final ActivityItem item;

  const _ActivityTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 14, 12),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: item.isCompleted
                  ? const Color(0xFFD9F2DE)
                  : const Color(0xFFFFF3E0),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.isCompleted ? Icons.check : Icons.access_time,
              size: 15,
              color: item.isCompleted
                  ? const Color(0xFF2E9E4F)
                  : const Color(0xFFFF8C00),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1D2E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.address,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
        ],
      ),
    );
  }
}
