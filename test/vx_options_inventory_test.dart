import 'package:test/test.dart';
import 'package:validomix/validomix.dart';

void main() {
  group('VxOptionsInventory', () {
    late VxOptionsInventory inventory;

    setUp(() {
      inventory = VxOptionsInventory();
    });

    test('should add and retrieve a key successfully', () {
      final id = inventory.addKey('TestKey', ['desc1', 'desc2']);
      final key = inventory.getKey(id);

      expect(key.name, equals('TestKey'));
      expect(key.descriptors, containsAll(['desc1', 'desc2']));
    });

    test('should throw an exception when adding a key with a duplicate name',
        () {
      inventory.addKey('DuplicateKey', ['desc1']);

      expect(
          () => inventory.addKey('DuplicateKey', ['desc2']), throwsException);
    });

    test(
        'should throw a FormatException when retrieving a key with an invalid id',
        () {
      expect(() => inventory.getKey(999), throwsFormatException);
    });

    test('should handle adding a key with an empty descriptors list', () {
      final id = inventory.addKey('EmptyDescKey', []);
      final key = inventory.getKey(id);

      expect(key.name, equals('EmptyDescKey'));
      expect(key.descriptors, isEmpty);
    });

    test(
        'should return an empty list when calling toList on an empty inventory',
        () {
      final keys = inventory.toList();
      expect(keys, isEmpty);
    });

    test('should return keys sorted by name in ascending order', () {
      inventory.addKey('Charlie', ['desc1']);
      inventory.addKey('Bravo', ['desc1']);
      inventory.addKey('Alpha', ['desc1']);

      final keys = inventory.toList();

      expect(keys[0].name, equals('Alpha'));
      expect(keys[1].name, equals('Bravo'));
      expect(keys[2].name, equals('Charlie'));
    });

    test('should handle a large number of keys', () {
      const int largeNumber = 1000;
      for (int i = 0; i < largeNumber; i++) {
        inventory.addKey('Key$i', ['desc$i']);
      }
      for (int i = 0; i < largeNumber; i++) {
        final key = inventory.getKey(inventory.cipher.encrypt(i));
        expect(key.name, equals('Key$i'));
        expect(key.descriptors, contains('desc$i'));
      }
      expect(inventory.toList().length, equals(largeNumber));
    });

    test(
        'should throw a FormatException when trying to retrieve a key with a negative id',
        () {
      expect(() => inventory.getKey(-1), throwsFormatException);
    });
  });
}
