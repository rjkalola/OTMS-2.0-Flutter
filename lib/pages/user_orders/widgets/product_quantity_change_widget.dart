import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductQuantityChangeWidget extends StatefulWidget {
  final bool isSubQuantity;
  final int quantity;
  final String unit;
  final Function(int value)? onChanged;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final FocusNode? focusNode;

  const ProductQuantityChangeWidget({
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
  State<ProductQuantityChangeWidget> createState() =>
      _ProductQuantityWidgetState();
}

class _ProductQuantityWidgetState extends State<ProductQuantityChangeWidget> {
  late TextEditingController _textController;

  static const double _boxHeight = 34;
  static const double _boxWidth = 34;
  static const double _qtyBoxWidth = 60;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.quantity.toString());
  }

  @override
  void didUpdateWidget(covariant ProductQuantityChangeWidget oldWidget) {
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
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: widget.onDecrease,
          borderRadius: BorderRadius.circular(45),
          child: Container(
            width: _boxWidth,
            height: _boxHeight,
            alignment: Alignment.center,
            child: widget.quantity == 1
                ? Icon(Icons.delete_outline,
                    size: 20, color: primaryTextColor_(context))
                : Icon(Icons.remove,
                    size: 20, color: primaryTextColor_(context)),
          ),
        ),
        const SizedBox(width: 4),
        widget.isSubQuantity
            ? SizedBox(
                width: _qtyBoxWidth,
                height: _boxHeight,
                child: Align(
                  alignment: Alignment.center,
                  child: TextField(
                    controller: _textController,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    focusNode: widget.focusNode,
                    cursorColor: Colors.grey.shade400,
                    style: const TextStyle(
                        fontSize: 14, height: 1.0, fontWeight: FontWeight.w500),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: false),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      isCollapsed: true,
                      filled: true,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    onSubmitted: (_) => _commitQtyFromField(),
                    onTapOutside: (_) {
                      FocusScope.of(context).unfocus();
                      _commitQtyFromField();
                    },
                  ),
                ),
              )
            : Container(
                width: _qtyBoxWidth,
                height: _boxHeight,
                alignment: Alignment.center,
                child: Text(
                  widget.quantity.toString(),
                  style: const TextStyle(
                      fontSize: 14, height: 1.0, fontWeight: FontWeight.w500),
                ),
              ),
        const SizedBox(width: 4),
        InkWell(
          borderRadius: BorderRadius.circular(45),
          onTap: widget.onIncrease,
          child: Container(
            width: _boxWidth,
            height: _boxHeight,
            alignment: Alignment.center,
            child: Icon(
              Icons.add,
              size: 20,
              color: primaryTextColor_(context),
            ),
          ),
        ),
        if (widget.isSubQuantity && widget.unit.isNotEmpty) ...[
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 56),
            child: Text(
              widget.unit,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final content = Container(
          constraints: const BoxConstraints(minHeight: 34),
          padding: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(45),
          ),
          child: row,
        );

        // FittedBox must sit *inside* a width cap so the Row is scaled down
        // instead of overflowing (ConstrainedBox around Container does not shrink Row).
        if (!constraints.hasBoundedWidth) {
          return FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: content,
          );
        }
        return Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: constraints.maxWidth,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: content,
            ),
          ),
        );
      },
    );
  }
}
