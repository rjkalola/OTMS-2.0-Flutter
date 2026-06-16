import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'project_shift_selection.dart';


//Mock Server Job Data

class JobEntry {
  final String address;
  final String jobType;
  final String? duration;
  final bool isOngoing;

  const JobEntry({
    required this.address,
    required this.jobType,
    this.duration,
    this.isOngoing = false,
  });
}

final List<JobEntry> mockServerJobs = [
  JobEntry(
    address: '112 High Rd, Woodford...',
    jobType: 'Door Installation',
    duration: '04:00',
    isOngoing: false,
  ),
  JobEntry(
    address: '112 High Rd, Woodford...',
    jobType: 'Door Installation',
    isOngoing: true,
  ),
];


class SemiCirclePainter extends CustomPainter {
  final double progress;

  SemiCirclePainter({this.progress = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final outerRadius = size.width / 2 - 10;
    final innerRadius = size.width / 2 - 44;

    // Outer faint track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      math.pi, math.pi, false,
      Paint()
        ..color = Colors.white.withOpacity(0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );

    // Inner faint track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerRadius),
      math.pi, math.pi, false,
      Paint()
        ..color = Colors.white.withOpacity(0.10)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round,
    );

    // Progress arc
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRadius),
        math.pi, math.pi * progress, false,
        Paint()
          ..color = Colors.white.withOpacity(0.9)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round,
      );
    }

    // Dot indicator
    final dotAngle = math.pi + math.pi * progress;
    final dotX = center.dx + outerRadius * math.cos(dotAngle);
    final dotY = center.dy + outerRadius * math.sin(dotAngle);

    canvas.drawCircle(
      Offset(dotX, dotY), 9,
      Paint()..color = Colors.white.withOpacity(0.3),
    );
    canvas.drawCircle(
      Offset(dotX, dotY), 5,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(SemiCirclePainter old) => old.progress != progress;
}

class ClipboardIllustration extends StatelessWidget {
  const ClipboardIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120, height: 120,
      decoration: const BoxDecoration(
        color: Color(0xFFEEEFF5),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: CustomPaint(
          size: const Size(72, 80),
          painter: _ClipboardPainter(),
        ),
      ),
    );
  }
}

class _ClipboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(4, 14, w - 2, h - 10), const Radius.circular(8)),
      Paint()..color = Colors.black.withOpacity(0.08)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 10, w, h - 8), const Radius.circular(8)),
      Paint()..color = Colors.white,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 10, w, h - 8), const Radius.circular(8)),
      Paint()..color = const Color(0xFFF0C040)..style = PaintingStyle.stroke..strokeWidth = 2.5,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.28, 0, w * 0.44, 18), const Radius.circular(5)),
      Paint()..color = const Color(0xFFE05555),
    );
    canvas.drawCircle(Offset(w / 2, 8), 4, Paint()..color = const Color(0xFF333333));

    final lp = Paint()..color = const Color(0xFFCCCEDC)..strokeWidth = 3..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.18, h * 0.42), Offset(w * 0.82, h * 0.42), lp);
    canvas.drawLine(Offset(w * 0.18, h * 0.57), Offset(w * 0.82, h * 0.57), lp);
    canvas.drawLine(Offset(w * 0.18, h * 0.72), Offset(w * 0.59, h * 0.72), lp);
  }

  @override
  bool shouldRepaint(_ClipboardPainter old) => false;
}

// Main Screen

class WorkTimerScreen extends StatefulWidget {
  const WorkTimerScreen({super.key});

  @override
  State<WorkTimerScreen> createState() => _WorkTimerScreenState();
}

class _WorkTimerScreenState extends State<WorkTimerScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  Project? _selectedProject;
  Shift? _selectedShift;
  List<JobEntry> _jobs = [];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _onStartWorkTapped() {
    if (_isRunning) {
      // Already running — Stop Work
      _stopWork();
    } else if (_selectedProject == null || _selectedShift == null) {
      _showSelectionFlow();
    } else {
      _startCounting();
    }
  }

  void _showSelectionFlow() {
    ProjectShiftSelector.start(
      context: context,
      onComplete: (project, shift) {
        setState(() {
          _selectedProject = project;
          _selectedShift = shift;
          // Simulate server response
          _jobs = mockServerJobs;
        });
        _startCounting();
      },
    );
  }

  void _startCounting() {
    setState(() {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _elapsedSeconds++);
      });
      _pulseController.repeat(reverse: true);
      _isRunning = true;
    });
  }

  void _stopWork() {
    _timer?.cancel();
    _pulseController.stop();
    _pulseController.reset();
    setState(() {
      _elapsedSeconds = 0;
      _isRunning = false;
      _selectedProject = null;
      _selectedShift = null;
      _jobs = [];
    });
  }

  String get _formattedTime {
    final h = (_elapsedSeconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((_elapsedSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  double get _arcProgress => (_elapsedSeconds % 3600) / 3600.0;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final screenH = MediaQuery.of(context).size.height;
    final headerH = _isRunning ? screenH * 0.30 : screenH * 0.32;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      body: Column(
        children: [
          _buildHeader(headerH, topPad),
          Expanded(
            child: _isRunning ? _buildActiveBody() : _buildIdleBody(),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  // Header

  Widget _buildHeader(double height, double topPad) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A6CF7), Color(0xFF3A5CE5)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          // Arc painter
          Positioned.fill(
            child: CustomPaint(
              painter: SemiCirclePainter(progress: _arcProgress),
            ),
          ),

          Positioned(
            top: topPad + 10,
            left: 16,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 40, height: 40,
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
          ),

          Positioned(
            left: 0, right: 0, bottom: 28,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isRunning && _selectedProject != null) ...[
                  Text(
                    _selectedProject!.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (_, child) => Transform.scale(
                    scale: _isRunning ? _pulseAnimation.value : 1.0,
                    child: child,
                  ),
                  child: Text(
                    _formattedTime,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      height: 1.05,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdleBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const ClipboardIllustration(),
        const SizedBox(height: 28),
        const Text(
          'Start Work to see something',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1D2E),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Track your time, stay focused and\nget things done.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.5,
            color: const Color(0xFF1A1D2E).withOpacity(0.45),
            height: 1.55,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveBody() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      children: [
        _buildProjectCard(),
        const SizedBox(height: 12),
        ..._jobs.map((job) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildJobCard(job),
        )),
      ],
    );
  }

  Widget _buildProjectCard() {
    final shift = _selectedShift;
    final project = _selectedProject;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shift badge
          if (shift != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: Row(
                children: [
                  Container(
                    width: 20, height: 20,
                    decoration: BoxDecoration(
                      color: shift.iconBgColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(shift.icon, size: 13,
                        color: _shiftBadgeColor(shift.iconBgColor)),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    shift.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _shiftBadgeColor(shift.iconBgColor),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Row(
              children: [
                Container(
                  width: 4, height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A6CF7),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    project?.name ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1D2E),
                    ),
                  ),
                ),
                // Ongoing pill
                _OngoingPill(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _shiftBadgeColor(Color bg) {
    final map = {
      const Color(0xFFFFF9E6): const Color(0xFFF59E0B),
      const Color(0xFFE8F4FD): const Color(0xFF2196F3),
      const Color(0xFFF0EEFF): const Color(0xFF7C3AED),
    };
    return map[bg] ?? const Color(0xFFFF8C00);
  }
  Widget _buildJobCard(JobEntry job) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Location icon
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.location_on,
              color: Color(0xFF4A6CF7),
              size: 20,
            ),
          ),
          const SizedBox(width: 10),

          // Address + job type
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.address,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1D2E),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F0FE),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    job.jobType,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4A6CF7),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Duration or Ongoing pill
          if (job.isOngoing)
            _OngoingPill()
          else
            Text(
              job.duration ?? '',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1D2E),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    if (!_isRunning) {
      // Idle: single green Start Work button
      return Container(
        color: const Color(0xFFF2F3F7),
        padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPad + 16),
        child: _GreenButton(
          label: 'Start Work',
          icon: Icons.play_arrow,
          onTap: _onStartWorkTapped,
        ),
      );
    }

    // Active: Stop Work | Swap icon | Check-In
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16, 14, 16, bottomPad + 16),
      child: Row(
        children: [
          // Stop Work
          Expanded(
            child: GestureDetector(
              onTap: _stopWork,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4444),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF4444).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.stop, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Stop Work',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          GestureDetector(
            onTap: _showSelectionFlow,
            child: Container(
              width: 52, height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFF4A6CF7),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x334A6CF7),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.swap_horiz, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 10),

          // Check-In
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Check-In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
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

class _OngoingPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7, height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF4A6CF7),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          const Text(
            'Ongoing',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4A6CF7),
            ),
          ),
        ],
      ),
    );
  }
}

class _GreenButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _GreenButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CAF50).withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
