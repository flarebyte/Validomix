import 'package:validomix/validomix.dart';

/// A class providing example rules for testing purposes.
class VxRuleFixtures {
  /// Creates an example rule that validates non-empty strings.
  ///
  /// This rule returns an error if the string is empty.
  static VxBaseRule<String> nonEmptyRule() {
    return _NonEmptyRule();
  }

  /// Creates an example rule that validates email format.
  ///
  /// This rule returns an error if the string is not in a valid email format.
  static VxBaseRule<String> emailRule() {
    return _EmailRule();
  }

  /// Creates an example rule that validates minimum length.
  ///
  /// This rule returns an error if the string's length is less than [minLength].
  static VxBaseRule<String> minLengthRule(int minLength) {
    return _MinLengthRule(minLength);
  }
}

class _NonEmptyRule extends VxBaseRule<String> {
  @override
  List<String> validate(Map<String, String> options, String value) {
    if (value.isEmpty) {
      return ['Value cannot be empty'];
    }
    return [];
  }
}

class _EmailRule extends VxBaseRule<String> {
  @override
  List<String> validate(Map<String, String> options, String value) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return ['Invalid email format'];
    }
    return [];
  }
}

class _MinLengthRule extends VxBaseRule<String> {
  final int minLength;

  _MinLengthRule(this.minLength);

  @override
  List<String> validate(Map<String, String> options, String value) {
    if (value.length < minLength) {
      return ['Value must be at least $minLength characters long'];
    }
    return [];
  }
}
