import 'package:belcka/pages/check_in/user_clock_in_new_flow/check_in/model/checkIn_task.dart';
import 'package:flutter/material.dart';

class SelectTaskWithTasksCard extends StatelessWidget {
  final bool expanded;
  final List<CheckInTask> tasks;
  final bool isCheckedIn;
  final VoidCallback onToggle;
  final void Function(CheckInTask) onTakePhoto;
  final void Function(CheckInTask) onProgressTap;

  const SelectTaskWithTasksCard({
    required this.expanded,
    required this.tasks,
    required this.isCheckedIn,
    required this.onToggle,
    required this.onTakePhoto,
    required this.onProgressTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: expanded
                ? const BorderRadius.vertical(top: Radius.circular(16))
                : BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE9FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.assignment, color: Color(0xFF7C3AED), size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Task',
                          style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: Color(0xFF1A1D2E)),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "Choose today's task",
                          style: TextStyle(fontSize: 12.5, color: Color(0xFF888AA0), height: 1.4),
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
                      child: Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: expanded
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(height: 1, color: Color(0xFFF0F1F5)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: Text(
                    'Your Tasks',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
                  child: Column(
                    children: List.generate(tasks.length, (i) {
                      final task = tasks[i];
                      return Padding(
                        padding: EdgeInsets.only(bottom: i == tasks.length - 1 ? 0 : 8),
                        child: _TaskTile(
                          task: task,
                          isCheckedIn: isCheckedIn,
                          insideCard: true,
                          onTakePhoto: () => onTakePhoto(task),
                          onProgressTap: () => onProgressTap(task),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final CheckInTask task;
  final bool isCheckedIn;
  final bool insideCard;
  final VoidCallback onTakePhoto;
  final VoidCallback onProgressTap;

  const _TaskTile({
    required this.task,
    required this.isCheckedIn,
    this.insideCard = false,
    required this.onTakePhoto,
    required this.onProgressTap,
  });

  Color get _barColor {
    if (task.progressPercent == 100) return const Color(0xFF4CAF50);
    if (task.progressPercent >= 50) return const Color(0xFFFF9800);
    return const Color(0xFFEF5350);
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: const Color(0xFFFFE8CC), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.assignment, color: Color(0xFFFF8C00), size: 19),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: Color(0xFF1A1D2E))),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 12, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text('${task.durationMinutes} min', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Progress percent
            Text(
              '${task.progressPercent}%',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _barColor),
            ),
            const SizedBox(width: 8),
            // Photo button
            task.photoTaken ? _AddedButton() : _TakePhotoButton(onTap: onTakePhoto),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: task.progressPercent / 100,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFEEEFF5),
                  valueColor: AlwaysStoppedAnimation(_barColor),
                ),
              ),
            ),
            if (isCheckedIn) ...[
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onProgressTap,
                child: Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: _barColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.edit, color: _barColor, size: 14),
                ),
              ),
            ],
          ],
        ),
      ],
    );

    if (insideCard) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: content,
      );
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: content,
    );
  }
}
class _AddedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8EC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.4), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.camera_alt_outlined, size: 14, color: Color(0xFF4CAF50)),
          SizedBox(width: 5),
          Text('Added', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF4CAF50))),
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF5FF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF4A6CF7).withOpacity(0.4), width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.camera_alt_outlined, size: 14, color: Color(0xFF4A6CF7)),
            SizedBox(width: 5),
            Text('Take Photo', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF4A6CF7))),
          ],
        ),
      ),
    );
  }
}