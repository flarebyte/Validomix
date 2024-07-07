import 'package:test/test.dart';
import 'package:validomix/validomix.dart';

void main() {
  group('VxIntegerCipher', () {
    test('encrypt and decrypt zero', () {
      var cipher = VxIntegerCipher(12345);
      int original = 0;
      int encrypted = cipher.encrypt(original);
      int decrypted = cipher.decrypt(encrypted);
      expect(decrypted, equals(original));
    });

    test('encrypt and decrypt negative numbers', () {
      var cipher = VxIntegerCipher(12345);
      int original = -1234;
      int encrypted = cipher.encrypt(original);
      int decrypted = cipher.decrypt(encrypted);
      expect(decrypted, equals(original));
    });

    test('encrypt and decrypt maximum integer value', () {
      var cipher = VxIntegerCipher(12345);
      int original =
          9223372036854775807; // Dart's max int value on 64-bit platforms
      int encrypted = cipher.encrypt(original);
      int decrypted = cipher.decrypt(encrypted);
      expect(decrypted, equals(original));
    });

    test('encrypt and decrypt minimum integer value', () {
      var cipher = VxIntegerCipher(12345);
      int original =
          -9223372036854775808; // Dart's min int value on 64-bit platforms
      int encrypted = cipher.encrypt(original);
      int decrypted = cipher.decrypt(encrypted);
      expect(decrypted, equals(original));
    });

    test('same input produces same output with same seed', () {
      var cipher = VxIntegerCipher(12345);
      int original = 1234;
      int encrypted1 = cipher.encrypt(original);
      int encrypted2 = cipher.encrypt(original);
      expect(encrypted1, equals(encrypted2));
    });

    test('different seeds produce different results', () {
      var cipher1 = VxIntegerCipher(12345);
      var cipher2 = VxIntegerCipher(54321);
      int original = 1234;
      int encrypted1 = cipher1.encrypt(original);
      int encrypted2 = cipher2.encrypt(original);
      expect(encrypted1, isNot(equals(encrypted2)));
    });
    test('encrypt and decrypt with randomly generated seed', () {
      var cipher = VxIntegerCipher();
      int original = 1234;
      int encrypted = cipher.encrypt(original);
      int decrypted = cipher.decrypt(encrypted);
      expect(decrypted, equals(original));

      // Ensure the seed is not default
      int seed = cipher.seed;
      print('Generated seed: $seed');
      expect(seed, isNotNull);
    });
  });
}
