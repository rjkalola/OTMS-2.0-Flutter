import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
class OrderDetailsEditableNotesField extends StatelessWidget {
  final String value;
  final Function(String) onChanged;
  final int maxLength;
  final bool enabled;

  const OrderDetailsEditableNotesField({
    super.key,
    required this.value,
    required this.onChanged,
    this.maxLength = 500,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: TextField(
            enabled: enabled,
            controller: TextEditingController(text: value)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: value.length),
              ),
            maxLines: 1,
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxLength),
            ],
            onChanged: onChanged,
            decoration: const InputDecoration(
              hintText: "Notes:",
              prefixIcon: Icon(Icons.add_photo_alternate_outlined, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: Text(
              '${value.length}/$maxLength',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
*/

class OrderDetailsEditableNotesField extends StatelessWidget {
  final String value;
  final Function(String) onChanged;
  final VoidCallback onAttachmentTap;
  final int attachmentCount;
  final int maxLength;
  final bool enabled;
  final Color? borderColor;

  const OrderDetailsEditableNotesField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onAttachmentTap,
    this.attachmentCount = 0,
    this.maxLength = 500,
    this.enabled = true,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: borderColor ?? Colors.grey.shade400),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_photo_alternate_outlined, color: Colors.grey),
                      onPressed: enabled ? onAttachmentTap : null,
                    ),
                    if (attachmentCount > 0)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                          child: Text(
                            '$attachmentCount',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              Expanded(
                child: TextField(
                  enabled: enabled,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: value,
                      selection: TextSelection.collapsed(offset: value.length),
                    ),
                  ),
                  maxLines: 1,
                  inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
                  onChanged: onChanged,
                  decoration: const InputDecoration(
                    hintText: "Notes:",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),

        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 6, right: 8),
            child: Text(
              '${value.length}/$maxLength',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}