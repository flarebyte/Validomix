import 'package:validomix/src/vx_model.dart';

/// A formatter that trims spaces from the value.
class TrimSpacesFormatter extends VxBaseFormatter {
  @override
  String get name => 'TrimSpaces';

  @override
  String format(Map<String, String> options, String value,
      [String? formatting]) {
    return value.trim();
  }
}

/// A formatter that transforms the value to uppercase.
class UpperCaseFormatter extends VxBaseFormatter {
  @override
  String get name => 'UpperCase';

  @override
  String format(Map<String, String> options, String value,
      [String? formatting]) {
    return value.toUpperCase();
  }
}

/// A formatter that transforms the value to lowercase.
class LowerCaseFormatter extends VxBaseFormatter {
  @override
  String get name => 'LowerCase';

  @override
  String format(Map<String, String> options, String value,
      [String? formatting]) {
    return value.toLowerCase();
  }
}

/// A formatter that capitalizes the first letter of the value but leaves other letters unchanged.
class CapitalizeFirstLetterFormatter extends VxBaseFormatter {
  @override
  String get name => 'CapitalizeFirstLetter';

  @override
  String format(Map<String, String> options, String value,
      [String? formatting]) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }
}

/// A static class that provides factory methods for different formatters.
class VxFormatters {
  /// Constructs an instance of [TrimSpacesFormatter].
  static TrimSpacesFormatter trimSpaces() {
    return TrimSpacesFormatter();
  }

  /// Constructs an instance of [UpperCaseFormatter].
  static UpperCaseFormatter upperCase() {
    return UpperCaseFormatter();
  }

  /// Constructs an instance of [LowerCaseFormatter].
  static LowerCaseFormatter lowerCase() {
    return LowerCaseFormatter();
  }

  /// Constructs an instance of [CapitalizeFirstLetterFormatter].
  static CapitalizeFirstLetterFormatter capitalizeFirstLetter() {
    return CapitalizeFirstLetterFormatter();
  }
}
