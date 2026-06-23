// ─── Data Models ──────────────────────────────────────────────────────────────

class CheckInTask {
  final String id;
  final String title;
  final int durationMinutes;
  bool photoTaken;
  int progressPercent; // 0, 25, 50, 75, 100
  String? note;

  CheckInTask({
    required this.id,
    required this.title,
    required this.durationMinutes,
    this.photoTaken = false,
    this.progressPercent = 100, // default 100% per spec
    this.note,
  });
}
