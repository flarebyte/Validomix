import 'package:test/test.dart';
import 'package:validomix/validomix.dart';

import 'vx_fixtures.dart';

void main() {
  group('VxLengthEqual', () {
    test('should return true when length is equal to threshold', () {
      var list = IterableFixtures.createIntList(5);
      var comparator = VxIterableLengthComparators.equal;
      expect(comparator.compare(list, 5), isTrue);
    });

    test('should return false when length is not equal to threshold', () {
      var list = IterableFixtures.createIntList(4);
      var comparator = VxIterableLengthComparators.equal;
      expect(comparator.compare(list, 5), isFalse);
    });
  });

  group('VxLengthGreaterThan', () {
    test('should return true when length is greater than threshold', () {
      var list = IterableFixtures.createIntList(6);
      var comparator = VxIterableLengthComparators.greaterThan;
      expect(comparator.compare(list, 5), isTrue);
    });

    test('should return false when length is not greater than threshold', () {
      var list = IterableFixtures.createIntList(4);
      var comparator = VxIterableLengthComparators.greaterThan;
      expect(comparator.compare(list, 5), isFalse);
    });
  });

  group('VxLengthLessThan', () {
    test('should return true when length is less than threshold', () {
      var list = IterableFixtures.createIntList(4);
      var comparator = VxIterableLengthComparators.lessThan;
      expect(comparator.compare(list, 5), isTrue);
    });

    test('should return false when length is not less than threshold', () {
      var list = IterableFixtures.createIntList(5);
      var comparator = VxIterableLengthComparators.lessThan;
      expect(comparator.compare(list, 5), isFalse);
    });
  });

  group('VxLengthGreaterThanOrEqual', () {
    test('should return true when length is greater than or equal to threshold',
        () {
      var list = IterableFixtures.createIntList(5);
      var comparator = VxIterableLengthComparators.greaterThanOrEqual;
      expect(comparator.compare(list, 5), isTrue);
    });

    test(
        'should return false when length is not greater than or equal to threshold',
        () {
      var list = IterableFixtures.createIntList(4);
      var comparator = VxIterableLengthComparators.greaterThanOrEqual;
      expect(comparator.compare(list, 5), isFalse);
    });
  });

  group('VxLengthLessThanOrEqual', () {
    test('should return true when length is less than or equal to threshold',
        () {
      var list = IterableFixtures.createIntList(5);
      var comparator = VxIterableLengthComparators.lessThanOrEqual;
      expect(comparator.compare(list, 5), isTrue);
    });

    test(
        'should return false when length is not less than or equal to threshold',
        () {
      var list = IterableFixtures.createIntList(6);
      var comparator = VxIterableLengthComparators.lessThanOrEqual;
      expect(comparator.compare(list, 5), isFalse);
    });
  });
}
