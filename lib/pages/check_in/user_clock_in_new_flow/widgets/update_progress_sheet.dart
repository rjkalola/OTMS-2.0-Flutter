import 'package:belcka/pages/check_in/user_clock_in_new_flow/check_in/model/checkIn_task.dart';
import 'package:flutter/material.dart';

class UpdateProgressSheet extends StatefulWidget {
  final CheckInTask task;
  final void Function(int percent, bool photoTaken, String? note) onSave;

  const UpdateProgressSheet({required this.task, required this.onSave});

  @override
  State<UpdateProgressSheet> createState() => _UpdateProgressSheetState();
}

class _UpdateProgressSheetState extends State<UpdateProgressSheet> {
  late int _selectedPercent;
  late bool _photoTaken;
  late TextEditingController _noteController;

  static const _options = [100, 75, 50, 25, 0];

  @override
  void initState() {
    super.initState();
    _selectedPercent = widget.task.progressPercent;
    _photoTaken = widget.task.photoTaken;
    _noteController = TextEditingController(text: widget.task.note ?? '');
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Color get _progressColor {
    if (_selectedPercent == 100) return const Color(0xFF4CAF50);
    if (_selectedPercent >= 50) return const Color(0xFFFF9800);
    return const Color(0xFFEF5350);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDDEE6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Update Task Progress',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1D2E),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Task info row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE8CC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.assignment, color: Color(0xFFFF8C00), size: 19),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.task.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1D2E),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 12, color: Color(0xFFFF8C00)),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.task.durationMinutes} min',
                              style: const TextStyle(fontSize: 12, color: Color(0xFFFF8C00), fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Question
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'How much of this task\nwas completed?',
                  style: TextStyle(fontSize: 14.5, color: Color(0xFF555770), height: 1.4),
                ),
              ),
              const SizedBox(height: 14),

              // Progress percent selector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _options.map((pct) {
                    final isSelected = _selectedPercent == pct;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedPercent = pct),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF4CAF50) : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFDDDEE6),
                            width: 1.5,
                          ),
                          boxShadow: isSelected
                              ? [BoxShadow(color: const Color(0xFF4CAF50).withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 3))]
                              : [],
                        ),
                        child: Text(
                          '$pct%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : const Color(0xFF555770),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: _selectedPercent / 100,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFEEEFF5),
                        valueColor: AlwaysStoppedAnimation(_progressColor),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$_selectedPercent%',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _progressColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Status banner (only when 100%)
              if (_selectedPercent == 100)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28, height: 28,
                          decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
                          child: const Icon(Icons.check, color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Task is marked as fully completed',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF2E7D32)),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'You can change the progress if the task\nwas not fully completed.',
                                style: TextStyle(fontSize: 11.5, color: Color(0xFF4CAF50), height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Add photo section
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(text: 'Add photo ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1D2E))),
                          TextSpan(text: '(required for 100%)', style: TextStyle(fontSize: 12, color: Color(0xFF888AA0))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => setState(() => _photoTaken = true),
                      child: Container(
                        width: double.infinity,
                        height: 76,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F8FA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _photoTaken
                                ? const Color(0xFF4CAF50).withOpacity(0.5)
                                : const Color(0xFFDDDEE6),
                            width: 1.5,
                            // Dashed effect via CustomPaint is complex; use solid with low opacity for simplicity
                          ),
                        ),
                        child: _photoTaken
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.camera_alt_outlined, color: Color(0xFF4CAF50), size: 22),
                            const SizedBox(width: 8),
                            const Text(
                              'Photo Added',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF4CAF50)),
                            ),
                            const SizedBox(width: 12),
                            // Thumbnail placeholder
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 48, height: 48,
                                color: const Color(0xFF888AA0).withOpacity(0.2),
                                child: const Icon(Icons.image, color: Color(0xFF888AA0), size: 24),
                              ),
                            ),
                          ],
                        )
                            : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined, color: Color(0xFF888AA0), size: 22),
                            SizedBox(height: 4),
                            Text('Tap to add photo', style: TextStyle(fontSize: 12.5, color: Color(0xFF888AA0))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Add note section
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add note (optional)',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1D2E)),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F8FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFDDDEE6), width: 1.2),
                      ),
                      child: TextField(
                        controller: _noteController,
                        maxLines: 3,
                        maxLength: 200,
                        style: const TextStyle(fontSize: 13.5, color: Color(0xFF1A1D2E)),
                        decoration: InputDecoration(
                          hintText: 'Add a note about this task...',
                          hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: InputBorder.none,
                          counterStyle: const TextStyle(fontSize: 11, color: Color(0xFF888AA0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Save Progress button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onSave(_selectedPercent, _photoTaken, _noteController.text.isEmpty ? null : _noteController.text);
                  },
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4A6CF7), Color(0xFF3A5CE5)],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(color: const Color(0xFF4A6CF7).withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 5)),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Save Progress',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),

              // Cancel
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 16),
                child: Center(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF888AA0)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}