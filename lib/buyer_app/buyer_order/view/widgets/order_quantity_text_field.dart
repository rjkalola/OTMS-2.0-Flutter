import 'dart:io';

import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrderQuantityTextField extends StatefulWidget {
  final int value;
  final int? min;
  final int? max;
  final ValueChanged<int> onChanged;
  final double width;
  final double height;
  final double? borderRadius;
  final int? maxLength;

  final FocusNode? focusNode;

  const OrderQuantityTextField({
    super.key,
    required this.value,
    required this.onChanged,
    this.min,
    this.max,
    this.width = 48,
    this.height = 32,
    this.borderRadius,
    this.maxLength,
    this.focusNode,
  });

  @override
  State<OrderQuantityTextField> createState() => _OrderQuantityTextFieldState();
}

class _OrderQuantityTextFieldState extends State<OrderQuantityTextField> {
  late TextEditingController _controller;
  bool _isUpdatingText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(covariant OrderQuantityTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value &&
        _controller.text != widget.value.toString()) {
      _controller.text = widget.value.toString();
    }
  }

  void _onChanged(String value) {
    if (_isUpdatingText) return;

    // If user clears the field
    if (value.isEmpty) {
      // int fallbackValue = widget.min ?? 0;
      int fallbackValue = 0;

      _isUpdatingText = true;
      _controller.text = fallbackValue.toString();
      _controller.selection =
          TextSelection.collapsed(offset: _controller.text.length);
      _isUpdatingText = false;

      widget.onChanged(fallbackValue);
      return;
    }

    final qty = int.tryParse(value);
    if (qty == null) return;

    int finalQty = qty;

    // Min check
    if (widget.min != null && finalQty < widget.min!) {
      finalQty = widget.min!;
    }

    // Max check
    if (widget.max != null && finalQty > widget.max!) {
      finalQty = widget.max!;
    }

    // Force corrected value back to TextField
    if (finalQty.toString() != value) {
      _isUpdatingText = true;
      _controller.text = finalQty.toString();
      _controller.selection =
          TextSelection.collapsed(offset: _controller.text.length);
      _isUpdatingText = false;
    }

    widget.onChanged(finalQty);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TextField(
        controller: _controller,
        focusNode: Platform.isIOS ? widget.focusNode : null,
        textAlign: TextAlign.center,
        cursorColor: secondaryExtraLightTextColor_(context),
        cursorWidth: 1.2,
        cursorHeight: 16,
        cursorRadius: const Radius.circular(1),
        style: const TextStyle(fontSize: 15),
        keyboardType: TextInputType.number,
        maxLength: widget.maxLength,
        buildCounter: (_,
                {required currentLength, maxLength, required isFocused}) =>
            null,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 6),
            borderSide:
                BorderSide(color: focusedTextFieldBorderColor_(context)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 6),
            borderSide:
                BorderSide(color: focusedTextFieldBorderColor_(context)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 6),
            borderSide: BorderSide(color: normalTextFieldBorderColor_(context)),
          ),
        ),
        onChanged: _onChanged,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
