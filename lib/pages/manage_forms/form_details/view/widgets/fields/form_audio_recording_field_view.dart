import 'dart:async';

import 'package:belcka/pages/manage_forms/form_details/controller/form_details_controller.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_audio_recording_value.dart';
import 'package:belcka/pages/manage_forms/form_details/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/shared/form_audio_recording_player.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/shared/form_field_label.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class FormAudioRecordingFieldView extends StatefulWidget {
  const FormAudioRecordingFieldView({
    super.key,
    required this.field,
    this.isNested = false,
  });

  final FormFieldModel field;
  final bool isNested;

  @override
  State<FormAudioRecordingFieldView> createState() =>
      _FormAudioRecordingFieldViewState();
}

class _FormAudioRecordingFieldViewState
    extends State<FormAudioRecordingFieldView> {
  final AudioRecorder _recorder = AudioRecorder();
  Timer? _recordingTimer;
  bool _isRecording = false;
  int _recordingSeconds = 0;

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  Future<bool> _ensureMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isGranted) return true;

    status = await Permission.microphone.request();
    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      AppUtils.showSnackBarMessage('microphone_permission_denied'.tr);
      await openAppSettings();
    } else {
      AppUtils.showSnackBarMessage('microphone_permission_required'.tr);
    }
    return false;
  }

  Future<void> _startRecording(FormDetailsController controller) async {
    final fieldId = widget.field.id ?? '';
    if (StringHelper.isEmptyString(fieldId)) return;

    if (!await _ensureMicrophonePermission()) return;

    try {
      if (await _recorder.isRecording()) {
        await _recorder.stop();
      }

      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = p.join(directory.path, 'form_audio_$timestamp.m4a');

      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: path,
      );

      if (!mounted) return;
      setState(() {
        _isRecording = true;
        _recordingSeconds = 0;
      });

      _recordingTimer?.cancel();
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() => _recordingSeconds++);
      });
    } on MissingPluginException {
      AppUtils.showSnackBarMessage('audio_recording_unavailable'.tr);
    } on PlatformException {
      AppUtils.showSnackBarMessage('audio_recording_failed'.tr);
    }
  }

  Future<void> _stopRecording(FormDetailsController controller) async {
    final fieldId = widget.field.id ?? '';
    _recordingTimer?.cancel();

    try {
      final path = await _recorder.stop();

      if (!mounted) return;
      setState(() {
        _isRecording = false;
      });

      if (StringHelper.isEmptyString(path) ||
          StringHelper.isEmptyString(fieldId)) {
        return;
      }

      final recordedAt = DateTime.now();
      final displayName =
          'Audio recording ${DateFormat('HH:mm:ss').format(recordedAt)}';

      controller.setAudioRecording(
        fieldId,
        FormAudioRecordingValue(
          path: path!,
          displayName: displayName,
          durationSeconds: _recordingSeconds,
        ),
      );
    } on MissingPluginException {
      if (mounted) {
        setState(() => _isRecording = false);
      }
      AppUtils.showSnackBarMessage('audio_recording_unavailable'.tr);
    } on PlatformException {
      if (mounted) {
        setState(() => _isRecording = false);
      }
      AppUtils.showSnackBarMessage('audio_recording_failed'.tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormDetailsController>();
    final fieldId = widget.field.id ?? '';
    final accentColor = defaultAccentColor_(context);
    final stopColor = rejectTextColor_(context);

    return Obx(
      () {
        final recording = controller.getAudioRecording(fieldId);
        final hasRecording = recording != null;
        final hasError = controller.showValidationErrors.value &&
            controller.isFieldInvalid(fieldId);

        return CardViewDashboardItem(
          borderRadius: widget.isNested ? 12 : 16,
          margin: widget.isNested
              ? const EdgeInsets.symmetric(horizontal: 4)
              : const EdgeInsets.fromLTRB(16, 0, 16, 12),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormFieldLabel(
                label: widget.field.label ?? '',
                isRequired: widget.field.isRequired,
              ),
              if (!StringHelper.isEmptyString(widget.field.description)) ...[
                const SizedBox(height: 4),
                SubtitleTextView(
                  text: widget.field.description!,
                  fontSize: 14,
                  color: secondaryExtraLightTextColor_(context),
                  maxLine: 4,
                ),
              ],
              if (hasRecording && !_isRecording) ...[
                const SizedBox(height: 12),
                FormAudioRecordingPlayer(
                  key: ValueKey(recording.path),
                  filePath: recording.path,
                  title: recording.displayName,
                  initialDurationSeconds: recording.durationSeconds,
                ),
              ],
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isRecording
                      ? () => _stopRecording(controller)
                      : () => _startRecording(controller),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        _isRecording ? stopColor : accentColor,
                    side: BorderSide(
                      color: _isRecording ? stopColor : dividerColor_(context),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: const StadiumBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.mic_none_outlined,
                        size: 18,
                        color: _isRecording ? stopColor : accentColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isRecording
                            ? 'stop_recording'.tr
                            : hasRecording
                                ? 'record_again'.tr
                                : 'record_audio'.tr,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: _isRecording ? stopColor : accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (hasError && widget.field.isRequired) ...[
                const SizedBox(height: 6),
                Text(
                  'this_field_is_required'.tr,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: rejectTextColor_(context),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
