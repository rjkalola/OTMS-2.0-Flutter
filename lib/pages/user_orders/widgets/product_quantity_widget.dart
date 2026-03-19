import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductQuantityWidget extends StatefulWidget {
  final bool isSubQuantity;
  final int quantity;
  final String unit;
  final Function(int value)? onChanged;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final FocusNode? focusNode;

  const ProductQuantityWidget({
    super.key,
    required this.isSubQuantity,
    required this.quantity,
    required this.unit,
    this.onChanged,
    this.onIncrease,
    this.onDecrease,
    this.focusNode,
  });

  @override
  State<ProductQuantityWidget> createState() => _ProductQuantityWidgetState();
}

class _ProductQuantityWidgetState extends State<ProductQuantityWidget> {
  late TextEditingController _textController;

  static const double _boxHeight = 32;
  static const double _boxWidth = 32;
  static const double _qtyBoxWidth = 64;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.quantity.toString());
  }

  @override
  void didUpdateWidget(covariant ProductQuantityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity) {
      _textController.text = widget.quantity.toString();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _commitQtyFromField() {
    final value = int.tryParse(_textController.text) ?? widget.quantity;
    final clamped = value < 1 ? 1 : value;
    if (clamped != widget.quantity) {
      _textController.text = clamped.toString();
      widget.onChanged?.call(clamped);
    } else {
      _textController.text = widget.quantity.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: widget.onDecrease,
          child: Container(
            width: _boxWidth,
            height: _boxHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text("-", style: TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(width: 6),
        widget.isSubQuantity
            ? SizedBox(
                width: _qtyBoxWidth,
                height: _boxHeight,
                child: TextField(
                  controller: _textController,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  focusNode: widget.focusNode,
                  cursorColor: Colors.grey.shade400,
                  style: const TextStyle(fontSize: 14, height: 1.0),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  onSubmitted: (_) => _commitQtyFromField(),
                  onTapOutside: (_) {
                    FocusScope.of(context).unfocus();
                    _commitQtyFromField();
                  },
                ),
              )
            : Container(
                width: _qtyBoxWidth,
                height: _boxHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.quantity.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
        const SizedBox(width: 6),
        InkWell(
          onTap: widget.onIncrease,
          child: Container(
            width: _boxWidth,
            height: _boxHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text("+", style: TextStyle(fontSize: 18)),
          ),
        ),
        if (widget.isSubQuantity && widget.unit.isNotEmpty) ...[
          const SizedBox(width: 6),
          Text(
            widget.unit,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ],
    );
  }
}
