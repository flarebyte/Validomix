import 'package:test/test.dart';
import 'package:validomix/validomix.dart';

void main() {
  group('TrimSpacesFormatter', () {
    test('trims leading and trailing spaces', () {
      final formatter = VxFormatters.trimSpaces();
      expect(formatter.format({}, '  hello  ', null), 'hello');
    });

    test('handles empty string', () {
      final formatter = VxFormatters.trimSpaces();
      expect(formatter.format({}, ''), '');
    });

    test('handles string with no spaces', () {
      final formatter = VxFormatters.trimSpaces();
      expect(formatter.format({}, 'hello'), 'hello');
    });
  });

  group('UpperCaseFormatter', () {
    test('converts to uppercase', () {
      final formatter = VxFormatters.upperCase();
      expect(formatter.format({}, 'hello'), 'HELLO');
    });

    test('handles empty string', () {
      final formatter = VxFormatters.upperCase();
      expect(formatter.format({}, ''), '');
    });

    test('handles already uppercase string', () {
      final formatter = VxFormatters.upperCase();
      expect(formatter.format({}, 'HELLO'), 'HELLO');
    });
  });

  group('LowerCaseFormatter', () {
    test('converts to lowercase', () {
      final formatter = VxFormatters.lowerCase();
      expect(formatter.format({}, 'HELLO'), 'hello');
    });

    test('handles empty string', () {
      final formatter = VxFormatters.lowerCase();
      expect(formatter.format({}, ''), '');
    });

    test('handles already lowercase string', () {
      final formatter = VxFormatters.lowerCase();
      expect(formatter.format({}, 'hello'), 'hello');
    });
  });

  group('CapitalizeFirstLetterFormatter', () {
    test('capitalizes the first letter', () {
      final formatter = VxFormatters.capitalizeFirstLetter();
      expect(formatter.format({}, 'hello'), 'Hello');
    });

    test('handles empty string', () {
      final formatter = VxFormatters.capitalizeFirstLetter();
      expect(formatter.format({}, ''), '');
    });

    test('leaves other letters unchanged', () {
      final formatter = VxFormatters.capitalizeFirstLetter();
      expect(formatter.format({}, 'hELLO'), 'HELLO');
    });

    test('handles single character string', () {
      final formatter = VxFormatters.capitalizeFirstLetter();
      expect(formatter.format({}, 'h'), 'H');
    });
  });
}
