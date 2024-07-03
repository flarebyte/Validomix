import 'vx_model.dart';

/// A class that composes validation rules, parsing a string and applying validators.
///
/// [MSG] is the type of the message that validators will return.
/// [W] is the type of the value that validators will validate after parsing.
class VxRuleComposer<MSG, W> extends VxBaseRule<MSG> {
  /// The string parser used to parse the input string.
  final VxStringParser<W> stringParser;

  /// The list of validators applied to the parsed value.
  final List<VxBaseValidator<MSG, W>> validators;

  /// The default error message returned when parsing fails.
  final MSG defaultParsingErrMsg;

  /// A flag indicating whether to stop validation at the first encountered error.
  final bool failFast;

  /// Constructs a [VxRuleComposer] with the given parameters.
  ///
  /// [stringParser]: The string parser used to parse the input string.
  /// [validators]: The list of validators applied to the parsed value.
  /// [defaultParsingErrMsg]: The default error message returned when parsing fails.
  /// [failFast]: A flag indicating whether to stop validation at the first encountered error.
  VxRuleComposer({
    required this.stringParser,
    required this.validators,
    required this.defaultParsingErrMsg,
    this.failFast = false,
  });

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final W? parsedValue = stringParser.parseString(value);
    if (parsedValue == null) {
      return [defaultParsingErrMsg];
    }

    final List<MSG> messages = [];

    for (final validator in validators) {
      final List<MSG> result = validator.validate(options, parsedValue);
      messages.addAll(result);
      if (failFast && result.isNotEmpty) {
        break;
      }
    }

    return messages;
  }
}
