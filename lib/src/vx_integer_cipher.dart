import 'dart:math';

/// A class that provides a reversible pseudo-random number generation
/// based on XOR cipher. Given an integer and a seed, it can produce
/// a pseudo-random number and reverse it back to the original integer.
class VxIntegerCipher {
  final int _seed;

  /// Creates an instance of [VxIntegerCipher] with the provided seed.
  ///
  /// If no seed is provided, a random seed will be generated.
  ///
  /// The [seed] is used for the XOR cipher operations.
  VxIntegerCipher([int? seed]) : _seed = seed ?? Random().nextInt(1 << 32);

  /// Generates a pseudo-random number from the given integer [n].
  ///
  /// The [n] is XORed with the seed to produce a pseudo-random number.
  /// This operation is reversible using the [decrypt] method.
  ///
  /// Returns the pseudo-random number.
  int encrypt(int n) {
    return n ^ _seed;
  }

  /// Reverses the pseudo-random number [prn] back to the original integer.
  ///
  /// The [prn] (pseudo-random number) is XORed with the seed to retrieve
  /// the original integer. This operation is the reverse of the [encrypt] method.
  ///
  /// Returns the original integer.
  int decrypt(int prn) {
    return prn ^ _seed;
  }

  /// Returns the current seed used for the XOR cipher operations.
  int get seed => _seed;
}
