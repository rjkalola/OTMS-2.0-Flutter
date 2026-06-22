import 'dart:async';
import 'package:belcka/pages/check_in/user_clock_in_new_flow/widgets/clip_board_illustration.dart';
import 'package:belcka/pages/check_in/user_clock_in_new_flow/widgets/green_button.dart';
import 'package:belcka/pages/check_in/user_clock_in_new_flow/widgets/on_going_pill.dart';
import 'package:belcka/pages/check_in/user_clock_in_new_flow/widgets/stop_work_dialog.dart';
import 'package:belcka/pages/check_in/user_clock_in_new_flow/widgets/semi_circle_painter.dart';
import 'package:belcka/pages/check_in/user_clock_in_new_flow/widgets/tree_line_painter.dart';
import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';
import '../project_shift_selection.dart';
import '../shift_completed_screen.dart';

class JobEntry {
  final String address;
  final String jobType;
  final String? duration; // e.g. "04:00" or null if ongoing
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
      //_stopWork();
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

  void _showStopWorkDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.45),
      barrierDismissible: false,
      builder: (_) =>
          StopWorkDialog(
            workedSeconds: _elapsedSeconds,
            onNo: () => Navigator.of(context).pop(),
            onYes: () {
              Navigator.of(context).pop();
              _confirmStopWork();
            },
          ),
    );
  }

  void _confirmStopWork() {
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

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            ShiftCompletedScreen(
              summary: testShiftSummary,
              onDone: () {
                Navigator.of(context).pop(); // close ShiftCompletedScreen
              },
            ),
      ),
    );
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
    final topPad = MediaQuery
        .of(context)
        .padding
        .top;
    final screenH = MediaQuery
        .of(context)
        .size
        .height;
    final headerH = _isRunning ? screenH * 0.30 : screenH * 0.32;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Column(
        children: [
          _buildHeader(headerH, topPad),
          Expanded(
            child: _isRunning ? _buildActiveBody() : SizedBox(),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildHeader(double height, double topPad) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E376D), Color(0xFF3B6AD3)],
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
                decoration: BoxDecoration(
                  color: backgroundColor_(context),
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
                  size: 32,
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
                  builder: (_, child) =>
                      Transform.scale(
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
  Widget _buildActiveBody() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
      children: [
        CustomPaint(
          painter: TreeLinePainter(
            jobCount: _jobs.length,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProjectCard(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 42),
                child: Column(
                  children: _jobs.map((job) =>
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildJobCard(job),
                      ),
                  ).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

// --- PROJECT CARD WITH OVERLAPPING ACCENT & FLOATING BADGE ---
  Widget _buildProjectCard() {
    final shift = _selectedShift;
    final project = _selectedProject;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main Card Body
        Container(
          margin: const EdgeInsets.only(left: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 20, 24),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    project?.name ?? 'Hackney OT',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF11142D),
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                OngoingPill(),
              ],
            ),
          ),
        ),

        // Overlapping Left Accent Bar
        Positioned(
          left: 10,
          top: 4,
          bottom: 4,
          child: Container(
            width: 14,

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4F7CFF), Color(0xFF7BA5FF)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
            ),
          ),
        ),

        // Floating Shift Badge ("Daywork")
        if (shift != null)
          Positioned(
            top: -14,
            left: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF2E6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wb_sunny_rounded, size: 14, color: Color(0xFFE28743)),
                  const SizedBox(width: 6),
                  Text(
                    shift.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFE28743),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
  Widget _buildJobCard(JobEntry job) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F4FA), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rounded Location Icon Circle
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFEBF1FF),
              borderRadius: BorderRadius.circular(23),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: Color(0xFF3B66F5),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          // Address + Job Type Tag
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.address,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF11142D),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF1FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    job.jobType,
                    style:  TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3B66F5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Dynamic Right side: Duration Text or Ongoing Pill
          job.isOngoing
              ?  OngoingPill()
              : Text(
            job.duration ?? '00:00',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Color _shiftBadgeColor(Color bg) {
    final map = {
      Color(0xFFFFF9E6): Color(0xFFF59E0B),
      Color(0xFFE8F4FD): Color(0xFF2196F3),
      Color(0xFFF0EEFF): Color(0xFF7C3AED),
    };
    return map[bg] ?? const Color(0xFFFF8C00);
  }

  Widget _buildBottomBar() {
    final bottomPad = MediaQuery
        .of(context)
        .padding
        .bottom;

    if (!_isRunning) {
      // Idle: single green Start Work button
      return Container(
        color: const Color(0xFFF4F4F4),
        padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPad ),
        child: GreenButton(
          label: 'Start Work',
          icon: Icons.play_arrow,
          onTap: _onStartWorkTapped,
        ),
      );
    }
    // Active: Stop Work | Swap icon | Check-In
    return Container(
      padding: EdgeInsets.fromLTRB(24, 27, 24, bottomPad + 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          width: 1.5,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 32,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Stop Work
          Expanded(
            child: GestureDetector(
              onTap: _showStopWorkDialog,
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF484B),
                  borderRadius: BorderRadius.circular(30),
                  // Blur / Glow
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF484B),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(width: 10),
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
          // Swap / Switch icon button (blue circle)
          GestureDetector(
            onTap: _showSelectionFlow,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFF0D6EFD),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF007AFF),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.swap_horiz_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Check-In
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFF32A852),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF32A852),
                      blurRadius: 10,
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