import 'package:test/test.dart';
import 'package:validomix/validomix.dart';

void main() {
  group('VxGreaterThanComparator', () {
    test('value is greater than threshold', () {
      expect(VxNumberComparators.greaterThan.compare(20, 18), isTrue);
    });

    test('value is equal to threshold', () {
      expect(VxNumberComparators.greaterThan.compare(18, 18), isFalse);
    });

    test('value is less than threshold', () {
      expect(VxNumberComparators.greaterThan.compare(17, 18), isFalse);
    });
  });

  group('VxGreaterThanOrEqualComparator', () {
    test('value is greater than threshold', () {
      expect(VxNumberComparators.greaterThanOrEqual.compare(20, 18), isTrue);
    });

    test('value is equal to threshold', () {
      expect(VxNumberComparators.greaterThanOrEqual.compare(18, 18), isTrue);
    });

    test('value is less than threshold', () {
      expect(VxNumberComparators.greaterThanOrEqual.compare(17, 18), isFalse);
    });
  });

  group('VxLessThanComparator', () {
    test('value is less than threshold', () {
      expect(VxNumberComparators.lessThan.compare(17, 18), isTrue);
    });

    test('value is equal to threshold', () {
      expect(VxNumberComparators.lessThan.compare(18, 18), isFalse);
    });

    test('value is greater than threshold', () {
      expect(VxNumberComparators.lessThan.compare(19, 18), isFalse);
    });
  });

  group('VxLessThanOrEqualComparator', () {
    test('value is less than threshold', () {
      expect(VxNumberComparators.lessThanOrEqual.compare(17, 18), isTrue);
    });

    test('value is equal to threshold', () {
      expect(VxNumberComparators.lessThanOrEqual.compare(18, 18), isTrue);
    });

    test('value is greater than threshold', () {
      expect(VxNumberComparators.lessThanOrEqual.compare(19, 18), isFalse);
    });
  });

  group('VxEqualToComparator', () {
    test('value is equal to threshold', () {
      expect(VxNumberComparators.equalTo.compare(18, 18), isTrue);
    });

    test('value is not equal to threshold (greater)', () {
      expect(VxNumberComparators.equalTo.compare(19, 18), isFalse);
    });

    test('value is not equal to threshold (less)', () {
      expect(VxNumberComparators.equalTo.compare(17, 18), isFalse);
    });
  });

  group('VxNotEqualToComparator', () {
    test('value is not equal to threshold (greater)', () {
      expect(VxNumberComparators.notEqualTo.compare(19, 18), isTrue);
    });

    test('value is not equal to threshold (less)', () {
      expect(VxNumberComparators.notEqualTo.compare(17, 18), isTrue);
    });

    test('value is equal to threshold', () {
      expect(VxNumberComparators.notEqualTo.compare(18, 18), isFalse);
    });
  });

  group('Edge Cases', () {
    test('boundary value (threshold)', () {
      expect(VxNumberComparators.greaterThan.compare(100, 100), isFalse);
      expect(VxNumberComparators.greaterThan.compare(100.01, 100), isTrue);
      expect(VxNumberComparators.lessThan.compare(99.99, 100), isTrue);
    });

    test('negative numbers', () {
      expect(VxNumberComparators.lessThan.compare(-1, 0), isTrue);
      expect(VxNumberComparators.greaterThan.compare(-1, -2), isTrue);
    });

    test('zero values', () {
      expect(VxNumberComparators.equalTo.compare(0, 0), isTrue);
      expect(VxNumberComparators.notEqualTo.compare(0, 0), isFalse);
    });

    test('large numbers', () {
      num largeValue = 1e308;
      num largerValue = 1e309;
      expect(VxNumberComparators.lessThan.compare(largeValue, largerValue),
          isTrue);
      expect(VxNumberComparators.greaterThan.compare(largerValue, largeValue),
          isTrue);
    });

    test('decimal values', () {
      expect(VxNumberComparators.lessThan.compare(0.1, 0.2), isTrue);
      expect(VxNumberComparators.greaterThan.compare(0.2, 0.1), isTrue);
    });
  });
}
