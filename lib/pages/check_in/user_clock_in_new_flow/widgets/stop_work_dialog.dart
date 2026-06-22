import 'package:belcka/pages/check_in/user_clock_in_new_flow/widgets/alarm_clock_painter.dart';
import 'package:flutter/material.dart';

class StopWorkDialog extends StatelessWidget {
  final int workedSeconds;
  final VoidCallback onNo;
  final VoidCallback onYes;

  const StopWorkDialog({
    super.key,
    required this.workedSeconds,
    required this.onNo,
    required this.onYes,
  });

  String get _formattedWorkedTime {
    final h = (workedSeconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((workedSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (workedSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 28),

            // Alarm clock
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F0),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AlarmClockPainter(),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'Stop work?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1D2E),
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            const Text(
              'Are you sure want to\nstop working on this job?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: Color(0xFF888AA0),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Worked time row
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  // Calendar + clock icon
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 20,
                          color: Color(0xFF4A6CF7),
                        ),
                        Positioned(
                          right: 6,
                          bottom: 6,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A6CF7),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                            child: const Icon(
                              Icons.access_time,
                              size: 8,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Today's worked time",
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF888AA0),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formattedWorkedTime,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1D2E),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // No / Yes buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  // No — outlined red
                  Expanded(
                    child: GestureDetector(
                      onTap: onNo,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: const Color(0xFFFF4444),
                            width: 1.8,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'No',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFF4444),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Yes — filled green
                  Expanded(
                    child: GestureDetector(
                      onTap: onYes,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4CAF50).withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}