import 'package:flutter/material.dart';

class CheckInTask {
  final String id;
  final String title;
  final int durationMinutes;
  bool photoTaken;

  CheckInTask({
    required this.id,
    required this.title,
    required this.durationMinutes,
    this.photoTaken = false,
  });
}

List<CheckInTask> buildTestTasks() => [
  CheckInTask(id: '1', title: 'Task 1', durationMinutes: 100),
  CheckInTask(id: '2', title: 'Task 1', durationMinutes: 100),
  CheckInTask(id: '3', title: 'Task 1', durationMinutes: 100),
];

const String testAddress =
    'Palmhurst,\n600 High Road, Woodford Green,\nGreater London, IG8 0PS';

class CheckInScreen extends StatefulWidget {
  final String address;
  final String currentTime; // e.g. "8:02"
  final VoidCallback? onCheckIn;
  final VoidCallback? onSelectAddress;
  final VoidCallback? onSelectTask;

  const CheckInScreen({
    super.key,
    this.address = testAddress,
    this.currentTime = '8:02',
    this.onCheckIn,
    this.onSelectAddress,
    this.onSelectTask,
  });

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  late List<CheckInTask> _tasks;
  bool _tasksExpanded = true;

  @override
  void initState() {
    super.initState();
    _tasks = buildTestTasks();
  }

  void _toggleTasksExpanded() {
    setState(() {
      _tasksExpanded = !_tasksExpanded;
    });
    widget.onSelectTask?.call();
  }

  void _takePhoto(CheckInTask task) {
    setState(() {
      task.photoTaken = true;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  _BackButton(onTap: () => Navigator.of(context).maybePop()),
                  const Spacer(),
                  _TimePill(time: widget.currentTime),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                children: [
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
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const _LocationIllustration(),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Address card
                  _InfoCard(
                    icon: Icons.location_on,
                    iconBg: const Color(0xFFE8F0FE),
                    iconColor: const Color(0xFF2196F3),
                    title: 'Address',
                    subtitle: widget.address,
                    onTap: widget.onSelectAddress,
                  ),
                  const SizedBox(height: 12),

                  _SelectTaskCard(
                    expanded: _tasksExpanded,
                    onTap: _toggleTasksExpanded,
                  ),

                  AnimatedSize(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    alignment: Alignment.topCenter,
                    child: _tasksExpanded
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 18),
                        Text(
                          'Your Tasks',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Task list
                        ...List.generate(_tasks.length, (i) {
                          final task = _tasks[i];
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom:
                              i == _tasks.length - 1 ? 0 : 10,
                            ),
                            child: _TaskTile(
                              task: task,
                              onTakePhoto: () => _takePhoto(task),
                            ),
                          );
                        }),
                      ],
                    )
                        : const SizedBox(width: double.infinity, height: 0),
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
                onTap: widget.onCheckIn,
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
                    'Check-In',
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

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
    );
  }
}

class _TimePill extends StatelessWidget {
  final String time;

  const _TimePill({required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          Icon(Icons.access_time, size: 14, color: Colors.grey.shade500),
          const SizedBox(width: 6),
          Text(
            time,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationIllustration extends StatelessWidget {
  const _LocationIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 78,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 6,
            child: Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE3E9FB),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),

          Positioned(
            left: 4,
            bottom: 14,
            child: _TreeShape(color: const Color(0xFFC9D6F5)),
          ),
          Positioned(
            right: 6,
            bottom: 16,
            child: _TreeShape(color: const Color(0xFFD3DEF8), size: 0.8),
          ),

          Positioned(
            top: 0,
            left: 6,
            child: _CloudShape(),
          ),
          Positioned(
            top: 8,
            right: 0,
            child: _CloudShape(size: 0.7),
          ),

          Positioned(
            bottom: 28,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF4A6CF7),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A6CF7).withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TreeShape extends StatelessWidget {
  final Color color;
  final double size;

  const _TreeShape({required this.color, this.size = 1.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22 * size,
      height: 28 * size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10 * size),
      ),
    );
  }
}

class _CloudShape extends StatelessWidget {
  final double size;

  const _CloudShape({this.size = 1.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26 * size,
      height: 12 * size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10 * size),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _InfoCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1D2E),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey.shade500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectTaskCard extends StatelessWidget {
  final bool expanded;
  final VoidCallback onTap;

  const _SelectTaskCard({required this.expanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEDE9FE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.assignment,
                color: Color(0xFF7C3AED),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Task',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1D2E),
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "Choose today's task",
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF888AA0),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: AnimatedRotation(
                turns: expanded ? 0.25 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final CheckInTask task;
  final VoidCallback onTakePhoto;

  const _TaskTile({required this.task, required this.onTakePhoto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Task icon
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE8CC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.assignment,
              color: Color(0xFFFF8C00),
              size: 19,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1D2E),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Icons.access_time,
                        size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      '${task.durationMinutes} min',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          task.photoTaken
              ? _AddedButton()
              : _TakePhotoButton(onTap: onTakePhoto),
        ],
      ),
    );
  }
}

class _TakePhotoButton extends StatelessWidget {
  final VoidCallback onTap;

  const _TakePhotoButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF5FF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF4A6CF7).withOpacity(0.4),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              size: 15,
              color: Color(0xFF4A6CF7),
            ),
            const SizedBox(width: 6),
            const Text(
              'Take Photo',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A6CF7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8EC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF4CAF50).withOpacity(0.4),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.camera_alt_outlined,
            size: 15,
            color: Color(0xFF4CAF50),
          ),
          const SizedBox(width: 6),
          const Text(
            'Added',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4CAF50),
            ),
          ),
        ],
      ),
    );
  }
}
