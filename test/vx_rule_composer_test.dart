import 'package:test/test.dart';
import 'package:validomix/validomix.dart';

class MockStringParser extends VxStringParser<int> {
  @override
  int? parseString(String value) {
    if (value == 'valid') return 42;
    return null;
  }
}

class AlwaysPassValidator extends VxBaseValidator<String, int> {
  @override
  List<String> validate(Map<String, String> options, int value) {
    return [];
  }
}

class AlwaysFailValidator extends VxBaseValidator<String, int> {
  @override
  List<String> validate(Map<String, String> options, int value) {
    return ['Validation failed'];
  }
}

void main() {
  group('VxRuleComposer', () {
    test('returns default parsing error message when parsing fails', () {
      final composer = VxRuleComposer<String, int>(
        stringParser: MockStringParser(),
        validators: [AlwaysPassValidator()],
        defaultParsingErrMsg: 'Parsing error',
      );

      final result = composer.validate({}, 'invalid');
      expect(result, ['Parsing error']);
    });

    test('validates successfully parsed value with all validators', () {
      final composer = VxRuleComposer<String, int>(
        stringParser: MockStringParser(),
        validators: [AlwaysPassValidator()],
        defaultParsingErrMsg: 'Parsing error',
      );

      final result = composer.validate({}, 'valid');
      expect(result, isEmpty);
    });

    test('collects all validation messages', () {
      final composer = VxRuleComposer<String, int>(
        stringParser: MockStringParser(),
        validators: [AlwaysFailValidator()],
        defaultParsingErrMsg: 'Parsing error',
      );

      final result = composer.validate({}, 'valid');
      expect(result, ['Validation failed']);
    });

    test('stops at first error when failFast is true', () {
      final composer = VxRuleComposer<String, int>(
        stringParser: MockStringParser(),
        validators: [
          AlwaysFailValidator(),
          AlwaysPassValidator(),
        ],
        defaultParsingErrMsg: 'Parsing error',
        failFast: true,
      );

      final result = composer.validate({}, 'valid');
      expect(result, ['Validation failed']);
    });

    test('continues validation when failFast is false', () {
      final composer = VxRuleComposer<String, int>(
        stringParser: MockStringParser(),
        validators: [
          AlwaysFailValidator(),
          AlwaysFailValidator(),
        ],
        defaultParsingErrMsg: 'Parsing error',
        failFast: false,
      );

      final result = composer.validate({}, 'valid');
      expect(result, ['Validation failed', 'Validation failed']);
    });
  });
}
