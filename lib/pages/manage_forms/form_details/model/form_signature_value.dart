import 'dart:ui';

class FormSignatureValue {
  FormSignatureValue({
    List<List<Offset>>? strokes,
    this.canvasSize = Size.zero,
  }) : strokes = strokes ?? [];

  final List<List<Offset>> strokes;
  final Size canvasSize;

  bool get isEmpty {
    if (strokes.isEmpty) return true;
    return strokes.every((stroke) => stroke.length < 2);
  }

  bool get isNotEmpty => !isEmpty;

  FormSignatureValue copy() {
    return FormSignatureValue(
      strokes: strokes
          .map((stroke) => List<Offset>.from(stroke))
          .toList(growable: false),
      canvasSize: canvasSize,
    );
  }
}
