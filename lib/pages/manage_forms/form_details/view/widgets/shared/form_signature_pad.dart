import 'package:belcka/pages/manage_forms/form_details/model/form_signature_value.dart';
import 'package:flutter/material.dart';

class FormSignaturePad extends StatefulWidget {
  static const Color canvasColor = Colors.white;
  static const Color inkColor = Color(0xFF1A1A1A);
  static const Color canvasBorderColor = Color(0xFFBDBDBD);
  static const Color canvasWrapperColor = Color(0xFFF4F5F7);
  const FormSignaturePad({
    super.key,
    required this.value,
    this.onChanged,
    this.readOnly = false,
    this.height = 180,
    this.borderRadius = 10,
  });

  final FormSignatureValue value;
  final ValueChanged<FormSignatureValue>? onChanged;
  final bool readOnly;
  final double height;
  final double borderRadius;

  @override
  State<FormSignaturePad> createState() => _FormSignaturePadState();
}

class _FormSignaturePadState extends State<FormSignaturePad> {
  late List<List<Offset>> _strokes;
  late Size _canvasSize;

  @override
  void initState() {
    super.initState();
    _syncFromWidget();
  }

  @override
  void didUpdateWidget(FormSignaturePad oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.readOnly) {
      _syncFromWidget();
    }
  }

  void _syncFromWidget() {
    _strokes = widget.value.strokes
        .map((stroke) => List<Offset>.from(stroke))
        .toList(growable: true);
    _canvasSize = widget.value.canvasSize;
  }

  void _notifyChanged() {
    widget.onChanged?.call(
      FormSignatureValue(
        strokes: _strokes
            .map((stroke) => List<Offset>.from(stroke))
            .toList(growable: false),
        canvasSize: _canvasSize,
      ),
    );
  }

  void clear() {
    if (_strokes.isEmpty) return;
    setState(() {
      _strokes = [];
    });
    _notifyChanged();
  }

  void _startStroke(Offset position) {
    setState(() {
      _strokes = [..._strokes, [position]];
    });
  }

  void _extendStroke(Offset position) {
    if (_strokes.isEmpty) return;
    setState(() {
      final lastStroke = List<Offset>.from(_strokes.last)..add(position);
      _strokes = [
        ..._strokes.sublist(0, _strokes.length - 1),
        lastStroke,
      ];
    });
  }

  void _endStroke() {
    _notifyChanged();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = widget.height;

        if (!widget.readOnly && width > 0 && height > 0) {
          _canvasSize = Size(width, height);
        }

        final signatureValue = FormSignatureValue(
          strokes: _strokes,
          canvasSize: widget.readOnly ? widget.value.canvasSize : _canvasSize,
        );

        final child = CustomPaint(
          painter: _SignaturePainter(
            value: signatureValue,
            strokeColor: FormSignaturePad.inkColor,
          ),
          size: Size(width, height),
        );

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: FormSignaturePad.canvasColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: FormSignaturePad.canvasBorderColor,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: widget.readOnly
              ? child
              : GestureDetector(
                  onPanStart: (details) =>
                      _startStroke(details.localPosition),
                  onPanUpdate: (details) =>
                      _extendStroke(details.localPosition),
                  onPanEnd: (_) => _endStroke(),
                  child: child,
                ),
        );
      },
    );
  }
}

class _SignaturePainter extends CustomPainter {
  _SignaturePainter({
    required this.value,
    required this.strokeColor,
  });

  final FormSignatureValue value;
  final Color strokeColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (value.strokes.isEmpty) return;

    final sourceSize = value.canvasSize;
    final scaleX = sourceSize.width > 0 ? size.width / sourceSize.width : 1;
    final scaleY = sourceSize.height > 0 ? size.height / sourceSize.height : 1;

    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final stroke in value.strokes) {
      if (stroke.length < 2) continue;

      final path = Path()..moveTo(
        stroke.first.dx * scaleX,
        stroke.first.dy * scaleY,
      );

      for (var index = 1; index < stroke.length; index++) {
        final point = stroke[index];
        path.lineTo(point.dx * scaleX, point.dy * scaleY);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.strokeColor != strokeColor;
  }
}
