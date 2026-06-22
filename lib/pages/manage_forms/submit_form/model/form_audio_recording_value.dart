class FormAudioRecordingValue {
  FormAudioRecordingValue({
    required this.path,
    required this.displayName,
    this.durationSeconds = 0,
  });

  final String path;
  final String displayName;
  final int durationSeconds;
}
