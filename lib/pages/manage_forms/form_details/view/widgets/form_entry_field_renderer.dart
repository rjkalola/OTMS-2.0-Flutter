import 'dart:convert';
import 'dart:typed_data';

import 'package:belcka/pages/manage_forms/form_details/controller/form_details_controller.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/shared/form_entry_attachment_tile.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/shared/form_entry_field_card.dart';
import 'package:belcka/pages/manage_forms/submit_form/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/submit_form/model/form_field_type.dart';
import 'package:belcka/pages/manage_forms/submit_form/view/widgets/shared/form_description_html_content.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FormEntryFieldRenderer extends StatelessWidget {
  const FormEntryFieldRenderer({
    super.key,
    required this.field,
    this.isNested = false,
  });

  final FormFieldModel field;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    switch (field.normalizedType) {
      case FormFieldType.description:
        return _DescriptionFieldView(field: field, isNested: isNested);
      case FormFieldType.group:
        return _GroupFieldView(field: field);
      case FormFieldType.dropdown:
        return _SelectionFieldView(field: field, isNested: isNested);
      case FormFieldType.imageSelection:
        return _ImageSelectionFieldView(field: field, isNested: isNested);
      case FormFieldType.location:
        return _LocationFieldView(field: field, isNested: isNested);
      case FormFieldType.rating:
        return _RatingFieldView(field: field, isNested: isNested);
      case FormFieldType.imageUpload:
      case FormFieldType.scanner:
      case FormFieldType.signature:
        return _ImageFilesFieldView(field: field, isNested: isNested);
      case FormFieldType.fileUpload:
        return _FileUploadFieldView(field: field, isNested: isNested);
      case FormFieldType.videoUpload:
        return _VideoFieldView(field: field, isNested: isNested);
      case FormFieldType.audioRecording:
        return _AudioFieldView(field: field, isNested: isNested);
      case FormFieldType.yesNo:
        return _YesNoFieldView(field: field, isNested: isNested);
      case FormFieldType.numbersSlider:
        return _SliderFieldView(field: field, isNested: isNested);
      default:
        return _TextFieldView(field: field, isNested: isNested);
    }
  }
}

class _DescriptionFieldView extends StatelessWidget {
  const _DescriptionFieldView({required this.field, required this.isNested});

  final FormFieldModel field;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    final content = field.label ?? '';
    if (StringHelper.isEmptyString(content)) return const SizedBox.shrink();

    return FormEntryFieldCard(
      label: '',
      isNested: isNested,
      child: FormDescriptionHtmlContent(html: content),
    );
  }
}

class _GroupFieldView extends StatelessWidget {
  const _GroupFieldView({required this.field});

  final FormFieldModel field;

  @override
  Widget build(BuildContext context) {
    final children = field.fields ?? [];
    if (children.isEmpty) return const SizedBox.shrink();

    return FormEntryFieldCard(
      label: field.label ?? '',
      isRequired: field.isRequired,
      description: field.description,
      child: Column(
        children: [
          const SizedBox(height: 8),
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            FormEntryFieldRenderer(field: children[i], isNested: true),
          ],
        ],
      ),
    );
  }
}

class _TextFieldView extends StatelessWidget {
  const _TextFieldView({required this.field, required this.isNested});

  final FormFieldModel field;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormDetailsController>();
    final value = controller.textValue(field.id);

    return FormEntryFieldCard(
      label: field.label ?? '',
      isRequired: field.isRequired,
      description: field.description,
      isNested: isNested,
      child: FormEntryTextValue(value: value),
    );
  }
}

class _SelectionFieldView extends StatelessWidget {
  const _SelectionFieldView({required this.field, required this.isNested});

  final FormFieldModel field;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormDetailsController>();
    final fieldId = field.id ?? '';
    final options = field.options ?? [];
    final selected = controller.selectedOptions(fieldId);
    final allowsMultiple = field.multipleSelection == true;

    return FormEntryFieldCard(
      label: field.label ?? '',
      isRequired: field.isRequired,
      description: field.description,
      isNested: isNested,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < options.length; i++) ...[
              if (i > 0) const SizedBox(height: 8),
              _ReadOnlyOptionRow(
                label: options[i],
                isSelected: selected.contains(options[i]),
                isCheckbox: allowsMultiple,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyOptionRow extends StatelessWidget {
  const _ReadOnlyOptionRow({
    required this.label,
    required this.isSelected,
    required this.isCheckbox,
  });

  final String label;
  final bool isSelected;
  final bool isCheckbox;

  @override
  Widget build(BuildContext context) {
    final accentColor = defaultAccentColor_(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: isCheckbox
              ? Checkbox(
                  value: isSelected,
                  onChanged: null,
                  activeColor: accentColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                    vertical: -4,
                  ),
                )
              : Radio<String>(
                  value: label,
                  groupValue: isSelected ? label : null,
                  onChanged: null,
                  activeColor: accentColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                    vertical: -4,
                  ),
                ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: primaryTextColor_(context),
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ImageSelectionFieldView extends StatelessWidget {
  const _ImageSelectionFieldView({
    required this.field,
    required this.isNested,
  });

  final FormFieldModel field;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormDetailsController>();
    final fieldId = field.id ?? '';
    final options = field.imageSelectionOptions;
    final selectedIndex = controller.selectedIndex(fieldId);
    final allowsMultiple = field.multipleSelection == true;

    return FormEntryFieldCard(
      label: field.label ?? '',
      isRequired: field.isRequired,
      description: field.description,
      isNested: isNested,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            for (var i = 0; i < options.length; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              _ImageSelectionOptionRow(
                label: field.imageSelectionDisplayLabelAt(i),
                imageBytes: _decodeOptionImageBytes(field.getOptionImageAt(i)),
                isSelected: allowsMultiple
                    ? controller.selectedOptions(fieldId).contains('$i')
                    : selectedIndex == i,
                isCheckbox: allowsMultiple,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Uint8List? _decodeOptionImageBytes(String? value) {
  if (StringHelper.isEmptyString(value)) return null;
  try {
    final data = value!;
    final commaIndex = data.indexOf(',');
    final encoded = commaIndex == -1 ? data : data.substring(commaIndex + 1);
    return base64Decode(encoded);
  } catch (_) {
    return null;
  }
}

class _ImageSelectionOptionRow extends StatelessWidget {
  const _ImageSelectionOptionRow({
    required this.label,
    required this.imageBytes,
    required this.isSelected,
    required this.isCheckbox,
  });

  final String label;
  final Uint8List? imageBytes;
  final bool isSelected;
  final bool isCheckbox;

  @override
  Widget build(BuildContext context) {
    final accentColor = defaultAccentColor_(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? accentColor : dividerColor_(context),
          width: isSelected ? 2 : 1,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(8, 10, 12, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: isCheckbox
                ? Checkbox(
                    value: isSelected,
                    onChanged: null,
                    activeColor: accentColor,
                  )
                : Radio<String>(
                    value: label,
                    groupValue: isSelected ? label : null,
                    onChanged: null,
                    activeColor: accentColor,
                  ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    color: primaryTextColor_(context),
                  ),
                ),
                if (imageBytes != null) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      imageBytes!,
                      height: 90,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationFieldView extends StatelessWidget {
  const _LocationFieldView({required this.field, required this.isNested});

  final FormFieldModel field;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormDetailsController>();
    final location = controller.locationValue(field.id);
    final lat = double.tryParse('${location?['lat']}');
    final lng = double.tryParse('${location?['lng']}');
    final address = location?['address']?.toString() ?? '';
    final hasCoordinates = lat != null && lng != null;

    return FormEntryFieldCard(
      label: field.label ?? '',
      isRequired: field.isRequired,
      description: field.description,
      isNested: isNested,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasCoordinates) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on, size: 18, color: rejectTextColor_(context)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '$lat, $lng',
                    style: TextStyle(
                      fontSize: 15,
                      color: primaryTextColor_(context),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 180,
                width: double.infinity,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(lat, lng),
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId(field.id ?? 'location'),
                      position: LatLng(lat, lng),
                    ),
                  },
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  liteModeEnabled: true,
                ),
              ),
            ),
          ],
          if (!StringHelper.isEmptyString(address))
            FormEntryTextValue(value: address, topSpacing: 10),
        ],
      ),
    );
  }
}

class _RatingFieldView extends StatelessWidget {
  const _RatingFieldView({required this.field, required this.isNested});

  final FormFieldModel field;
  final bool isNested;

  static const Color _selectedStarColor = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormDetailsController>();
    final rating = controller.ratingValue(field.id);
    final starCount = field.ratingStars;
    final unselectedColor = secondaryExtraLightTextColor_(context);

    return FormEntryFieldCard(
      label: field.label ?? '',
      isRequired: field.isRequired,
      description: field.description,
      isNested: isNested,
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var index = 1; index <= starCount; index++)
              Icon(
                index <= rating ? Icons.star : Icons.star_border,
                size: 32,
                color: index <= rating ? _selectedStarColor : unselectedColor,
              ),
          ],
        ),
      ),
    );
  }
}

class _ImageFilesFieldView extends StatelessWidget {
  const _ImageFilesFieldView({required this.field, required this.isNested});

  final FormFieldModel field;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormDetailsController>();
    final files = controller.filesFor(field.id);

    return FormEntryFieldCard(
      label: field.label ?? '',
      isRequired: field.isRequired,
      description: field.description,
      isNested: isNested,
      child: files.isEmpty
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final file in files)
                    FormEntryImageThumbnail(file: file),
                ],
              ),
            ),
    );
  }
}

class _FileUploadFieldView extends StatelessWidget {
  const _FileUploadFieldView({required this.field, required this.isNested});

  final FormFieldModel field;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormDetailsController>();
    final files = controller.filesFor(field.id);

    return FormEntryFieldCard(
      label: field.label ?? '',
      isRequired: field.isRequired,
      description: field.description,
      isNested: isNested,
      child: files.isEmpty
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  for (var i = 0; i < files.length; i++) ...[
                    if (i > 0) const SizedBox(height: 10),
                    FormEntryAttachmentTile(file: files[i]),
                  ],
                ],
              ),
            ),
    );
  }
}

class _VideoFieldView extends StatelessWidget {
  const _VideoFieldView({required this.field, required this.isNested});

  final FormFieldModel field;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormDetailsController>();
    final files = controller.filesFor(field.id);

    return FormEntryFieldCard(
      label: field.label ?? '',
      isRequired: field.isRequired,
      description: field.description,
      isNested: isNested,
      child: files.isEmpty
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  for (var i = 0; i < files.length; i++) ...[
                    if (i > 0) const SizedBox(height: 10),
                    FormEntryAttachmentTile(file: files[i]),
                  ],
                ],
              ),
            ),
    );
  }
}

class _AudioFieldView extends StatelessWidget {
  const _AudioFieldView({required this.field, required this.isNested});

  final FormFieldModel field;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormDetailsController>();
    final files = controller.filesFor(field.id);

    return FormEntryFieldCard(
      label: field.label ?? '',
      isRequired: field.isRequired,
      description: field.description,
      isNested: isNested,
      child: files.isEmpty
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  for (var i = 0; i < files.length; i++) ...[
                    if (i > 0) const SizedBox(height: 10),
                    _NetworkAudioPlayer(
                      url: files[i].url ?? '',
                      title: files[i].displayName,
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}

class _NetworkAudioPlayer extends StatefulWidget {
  const _NetworkAudioPlayer({
    required this.url,
    required this.title,
  });

  final String url;
  final String title;

  @override
  State<_NetworkAudioPlayer> createState() => _NetworkAudioPlayerState();
}

class _NetworkAudioPlayerState extends State<_NetworkAudioPlayer> {
  late final AudioPlayer _player;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _isPlaying = state == PlayerState.playing);
    });
  }

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlayback() async {
    if (StringHelper.isEmptyString(widget.url)) return;
    if (_isPlaying) {
      await _player.pause();
      return;
    }
    await _player.play(UrlSource(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = defaultAccentColor_(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: dividerColor_(context)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: _togglePlayback,
            child: Icon(
              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              color: accentColor,
              size: 34,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                color: primaryTextColor_(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _YesNoFieldView extends StatelessWidget {
  const _YesNoFieldView({required this.field, required this.isNested});

  final FormFieldModel field;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormDetailsController>();
    final selected = controller.textValue(field.id) ?? '';
    final options = field.yesNoOptions;
    final accentColor = defaultAccentColor_(context);

    return FormEntryFieldCard(
      label: field.label ?? '',
      isRequired: field.isRequired,
      description: field.description,
      isNested: isNested,
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Wrap(
          spacing: 10,
          runSpacing: 8,
          children: [
            for (final option in options)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: selected.toLowerCase() == option.toLowerCase() ||
                          (selected.toLowerCase() == 'true' &&
                              option.toLowerCase() == 'yes') ||
                          (selected.toLowerCase() == 'false' &&
                              option.toLowerCase() == 'no')
                      ? accentColor.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected.toLowerCase() == option.toLowerCase() ||
                            (selected.toLowerCase() == 'true' &&
                                option.toLowerCase() == 'yes') ||
                            (selected.toLowerCase() == 'false' &&
                                option.toLowerCase() == 'no')
                        ? accentColor
                        : dividerColor_(context),
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 15,
                    color: primaryTextColor_(context),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SliderFieldView extends StatelessWidget {
  const _SliderFieldView({required this.field, required this.isNested});

  final FormFieldModel field;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormDetailsController>();
    final value = controller.sliderValue(field.id);
    final accentColor = defaultAccentColor_(context);

    return FormEntryFieldCard(
      label: field.label ?? '',
      isRequired: field.isRequired,
      description: field.description,
      isNested: isNested,
      child: value == null
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Slider(
                    value: value.clamp(field.sliderMin, field.sliderMax),
                    min: field.sliderMin,
                    max: field.sliderMax,
                    onChanged: null,
                    activeColor: accentColor,
                  ),
                  Text(
                    value.toString(),
                    style: TextStyle(
                      fontSize: 15,
                      color: primaryTextColor_(context),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
