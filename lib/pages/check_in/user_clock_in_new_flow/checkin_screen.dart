import 'package:belcka/pages/check_in/user_clock_in_new_flow/check_in/model/checkIn_task.dart';
import 'package:belcka/pages/check_in/user_clock_in_new_flow/widgets/glass_back_button.dart';
import 'package:belcka/pages/check_in/user_clock_in_new_flow/widgets/info_card.dart';
import 'package:belcka/pages/check_in/user_clock_in_new_flow/widgets/location_illustration.dart';
import 'package:belcka/pages/check_in/user_clock_in_new_flow/widgets/select_task_with_tasks_card.dart';
import 'package:belcka/pages/check_in/user_clock_in_new_flow/widgets/time_pill.dart';
import 'package:belcka/pages/check_in/user_clock_in_new_flow/widgets/update_progress_sheet.dart';
import 'package:flutter/material.dart';

List<CheckInTask> buildTestTasks() => [
  CheckInTask(id: '1', title: 'Task 1', durationMinutes: 100),
  CheckInTask(id: '2', title: 'Task 1', durationMinutes: 100),
  CheckInTask(id: '3', title: 'Task 1', durationMinutes: 100),
];

const String testAddress =
    'Palmhurst,\n600 High Road, Woodford Green,\nGreater London, IG8 0PS';

class CheckInScreen extends StatefulWidget {
  final String address;
  final String currentTime;
  final VoidCallback? onCheckOut;
  final VoidCallback? onSelectAddress;
  final VoidCallback? onSelectTask;

  const CheckInScreen({
    super.key,
    this.address = testAddress,
    this.currentTime = '8:02',
    this.onCheckOut,
    this.onSelectAddress,
    this.onSelectTask,
  });

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  late List<CheckInTask> _tasks;
  bool _tasksExpanded = true;
  bool _isCheckedIn = false;

  @override
  void initState() {
    super.initState();
    _tasks = buildTestTasks();
  }

  void _toggleTasksExpanded() {
    setState(() => _tasksExpanded = !_tasksExpanded);
    widget.onSelectTask?.call();
  }

  void _handleMainButton() {
    if (!_isCheckedIn) {
      setState(() => _isCheckedIn = true);
    } else {
      widget.onCheckOut?.call();
    }
  }

  void _openProgressSheet(CheckInTask task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          UpdateProgressSheet(
            task: task,
            onSave: (percent, photoTaken, note) {
              setState(() {
                task.progressPercent = percent;
                task.photoTaken = photoTaken;
                task.note = note;
              });
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GlassBackButton(onTap: () => Navigator.of(context).maybePop()),
                  const Spacer(),
                  TimePill(time: widget.currentTime),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                children: [
                  // Title + illustration
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Check-In',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1D2E),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Let's start your work day",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const LocationIllustration(),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Address card
                  InfoCard(
                    icon: Icons.location_on,
                    iconBg: const Color(0xFFE8F0FE),
                    iconColor: const Color(0xFF2196F3),
                    title: 'Address',
                    subtitle: widget.address,
                    onTap: widget.onSelectAddress,
                  ),
                  const SizedBox(height: 12),

                  // ── Trade card
                  InfoCard(
                    icon: Icons.engineering,
                    iconBg: const Color(0xFFE8F5E9),
                    iconColor: const Color(0xFF2E7D32),
                    title: 'Trade',
                    subtitle: 'Plumber',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  SelectTaskWithTasksCard(
                    expanded: _tasksExpanded,
                    tasks: _tasks,
                    isCheckedIn: _isCheckedIn,
                    onToggle: _toggleTasksExpanded,
                    onTakePhoto: (task) =>
                        setState(() => task.photoTaken = true),
                    onProgressTap: _openProgressSheet,
                  ),
                ],
              ),
            ),

            // Bottom button — Check-In / Check-Out
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
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
                20, 16, 20,
                MediaQuery
                    .of(context)
                    .padding
                    .bottom + 16,
              ),
              child: GestureDetector(
                onTap: _handleMainButton,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _isCheckedIn
                          ? [const Color(0xFFEF5350), const Color(0xFFC62828)]
                          : [const Color(0xFF4CAF50), const Color(0xFF388E3C)],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: (_isCheckedIn
                            ? const Color(0xFFEF5350)
                            : const Color(0xFF4CAF50))
                            .withOpacity(0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      _isCheckedIn ? 'Check-out' : 'Check-In',
                      key: ValueKey(_isCheckedIn),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
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