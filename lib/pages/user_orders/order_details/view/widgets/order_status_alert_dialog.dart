import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';

class OrderStatusAlertDialog extends StatefulWidget {
  final String title;
  final String description;
  final String confirmText;
  final String cancelText;
  final bool showTextField;
  final String? textFieldHint;
  final TextEditingController? controller;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final Color confirmColor;

  const OrderStatusAlertDialog({
    super.key,
    required this.title,
    required this.description,
    this.confirmText = 'Cancel Order',
    this.cancelText = 'Keep Order',
    this.showTextField = false,
    this.textFieldHint,
    this.controller,
    required this.onConfirm,
    required this.onCancel,
    this.confirmColor = const Color(0xFFFF0000),
  });

  @override
  State<OrderStatusAlertDialog> createState() => _OrderStatusAlertDialogState();
}

class _OrderStatusAlertDialogState extends State<OrderStatusAlertDialog> {
  bool _isButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    if (widget.showTextField) {
      _isButtonEnabled = widget.controller?.text.isNotEmpty ?? false;
      widget.controller?.addListener(_handleTextChanged);
    }
  }

  void _handleTextChanged() {
    final bool isNotEmpty = widget.controller?.text.trim().isNotEmpty ?? false;
    if (isNotEmpty != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TitleTextView(text:widget.title,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center),
            const SizedBox(height: 12),

            TitleTextView(text:widget.description,
                fontSize: 15,
                textAlign: TextAlign.center),

            if (widget.showTextField) ...[
              const SizedBox(height: 16),
              TextField(
                controller: widget.controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: widget.textFieldHint ?? 'Enter cancellation reason...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),
            Row(
              children: [
                // Confirm Button
                Expanded(
                  child: Opacity(
                    opacity: _isButtonEnabled ? 1.0 : 0.5,
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled ? widget.onConfirm : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.confirmColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: TitleTextView(text:widget.confirmText,
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Cancel/Keep Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onCancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF999999),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: TitleTextView(text: widget.cancelText,
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}