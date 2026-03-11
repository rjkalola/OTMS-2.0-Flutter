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
    this.focusNode
  });

  @override
  State<ProductQuantityWidget> createState() => _ProductQuantityWidgetState();
}

class _ProductQuantityWidgetState extends State<ProductQuantityWidget> {

  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller =
        TextEditingController(text: widget.quantity.toString());
  }

  @override
  void didUpdateWidget(covariant ProductQuantityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.quantity != widget.quantity) {
      controller.text = widget.quantity.toString();
    }
  }

  @override
  Widget build(BuildContext context) {

    // SUB QUANTITY → editable decimal field
    if (widget.isSubQuantity) {
      return Row(
        children: [
          SizedBox(
            width: 60,
            height: 32,
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              focusNode: widget.focusNode,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: false),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                widget.onChanged?.call(int.tryParse(value) ?? 0);
              },
            ),
          ),

          const SizedBox(width: 6),

          Text(
            widget.unit,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      );
    }

    // NORMAL QUANTITY → + -
    return Row(
      children: [
        // minus
        InkWell(
          onTap: widget.onDecrease,
          child: Container(
            width: 32,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text("-", style: TextStyle(fontSize: 18)),
          ),
        ),

        const SizedBox(width: 6),

        // qty
        Container(
          width: 50,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            widget.quantity.toInt().toString(),
            style: const TextStyle(fontSize: 14),
          ),
        ),

        const SizedBox(width: 6),

        // plus
        InkWell(
          onTap: widget.onIncrease,
          child: Container(
            width: 32,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text("+", style: TextStyle(fontSize: 18)),
          ),
        ),
      ],
    );
  }
}