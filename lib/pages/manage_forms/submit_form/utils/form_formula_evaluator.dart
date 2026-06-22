import 'package:belcka/pages/manage_forms/submit_form/model/form_field_model.dart';
import 'package:belcka/pages/manage_forms/submit_form/model/form_field_type.dart';
import 'package:belcka/utils/string_helper.dart';

class FormFormulaEvaluator {
  const FormFormulaEvaluator._();

  static double? evaluate({
    required String expression,
    required List<FormFieldModel> allFields,
    required double? Function(FormFieldModel field, Set<String> visiting)
        getFieldNumericValue,
  }) {
    final trimmed = expression.trim();
    if (StringHelper.isEmptyString(trimmed)) return null;

    final sourceFields = _collectFormulaSourceFields(allFields);
    final substituted = _substituteFieldLabels(
      expression: trimmed,
      sourceFields: sourceFields,
      getFieldNumericValue: getFieldNumericValue,
    );

    return _evaluateMathExpression(substituted);
  }

  static String formatResult(double? value) {
    if (value == null || !value.isFinite) return '0';
    final normalized = (value * 1000000).round() / 1000000;
    if (normalized == normalized.roundToDouble()) {
      return normalized.round().toString();
    }
    return normalized.toString();
  }

  static List<FormFieldModel> _collectFormulaSourceFields(
    List<FormFieldModel> fieldList,
  ) {
    final result = <FormFieldModel>[];
    for (final field in fieldList) {
      if (field.normalizedType == FormFieldType.group) {
        result.addAll(_collectFormulaSourceFields(field.fields ?? []));
        continue;
      }
      if (_isFormulaSourceField(field)) {
        result.add(field);
      }
    }
    return result;
  }

  static bool _isFormulaSourceField(FormFieldModel field) {
    final type = field.normalizedType;
    return type == FormFieldType.number ||
        type == FormFieldType.numbersSlider ||
        type == FormFieldType.formula;
  }

  static String _substituteFieldLabels({
    required String expression,
    required List<FormFieldModel> sourceFields,
    required double? Function(FormFieldModel field, Set<String> visiting)
        getFieldNumericValue,
  }) {
    final labels = sourceFields
        .map((field) => field.label?.trim() ?? '')
        .where((label) => label.isNotEmpty)
        .toSet()
        .toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    var result = expression;

    for (final label in labels) {
      final field = sourceFields.firstWhere(
        (item) => (item.label ?? '').trim() == label,
      );
      final value = getFieldNumericValue(field, const {}) ?? 0;
      result = result.replaceAll(label, _formatOperand(value));
    }

    return result;
  }

  static String _formatOperand(double value) {
    if (value == value.roundToDouble()) {
      return value.round().toString();
    }
    return value.toString();
  }

  static double? _evaluateMathExpression(String expression) {
    final sanitized = expression.replaceAll(' ', '');
    if (sanitized.isEmpty) return null;
    if (!RegExp(r'^[\d.+\-*/()]+$').hasMatch(sanitized)) return null;

    try {
      return _MathParser(sanitized).parse();
    } catch (_) {
      return null;
    }
  }
}

class _MathParser {
  _MathParser(this._input);

  final String _input;
  int _pos = 0;

  double parse() {
    final result = _parseAddSub();
    _skipWhitespace();
    if (_pos < _input.length) {
      throw const FormatException('Unexpected trailing input');
    }
    return result;
  }

  double _parseAddSub() {
    var result = _parseMulDiv();
    while (true) {
      _skipWhitespace();
      if (_match('+')) {
        result += _parseMulDiv();
      } else if (_match('-')) {
        result -= _parseMulDiv();
      } else {
        break;
      }
    }
    return result;
  }

  double _parseMulDiv() {
    var result = _parseUnary();
    while (true) {
      _skipWhitespace();
      if (_match('*')) {
        result *= _parseUnary();
      } else if (_match('/')) {
        final divisor = _parseUnary();
        if (divisor == 0) throw const FormatException('Division by zero');
        result /= divisor;
      } else {
        break;
      }
    }
    return result;
  }

  double _parseUnary() {
    _skipWhitespace();
    if (_match('-')) return -_parseUnary();
    if (_match('+')) return _parseUnary();
    return _parsePrimary();
  }

  double _parsePrimary() {
    _skipWhitespace();
    if (_match('(')) {
      final result = _parseAddSub();
      if (!_match(')')) {
        throw const FormatException('Missing closing parenthesis');
      }
      return result;
    }
    return _parseNumber();
  }

  double _parseNumber() {
    _skipWhitespace();
    final start = _pos;
    while (_pos < _input.length) {
      final char = _input[_pos];
      if ((char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57) || char == '.') {
        _pos++;
        continue;
      }
      break;
    }
    if (start == _pos) {
      throw const FormatException('Expected number');
    }
    return double.parse(_input.substring(start, _pos));
  }

  void _skipWhitespace() {
    while (_pos < _input.length && _input[_pos] == ' ') {
      _pos++;
    }
  }

  bool _match(String char) {
    if (_pos < _input.length && _input[_pos] == char) {
      _pos++;
      return true;
    }
    return false;
  }
}
