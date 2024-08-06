/// A base class for validators.
abstract class VxBaseValidator<MSG, V> {
  List<MSG> validate(Map<String, String> options, V value);
}

/// A base class for rules.
abstract class VxBaseRule<MSG> extends VxBaseValidator<MSG, String> {}

/// A base class for parsers.
abstract class VxStringParser<V> {
  V? parseString(String value);
}

/// Produce a message, using an error message, after possibly interpolating the options and the value
abstract class VxMessageProducer<MSG, V> {
  MSG produce(Map<String, String> options, V value);
}

/// A base class for matching messages.
abstract class VxMatchingMessages<MSG> {
  bool isMatching(List<MSG> messages);
}

/// An abstract class defining the interface for number comparison.
abstract class VxNumberComparator {
  /// The name of the comparator.
  String get name;

  /// Compares the given [value] against a [threshold].
  ///
  /// Returns `true` if the comparison meets the criteria, otherwise `false`.
  bool compare(num value, num threshold);
}

// An abstract class defining the interface for comparison of the length of iterables.
abstract class VxIterableLengthComparator<V> {
  /// The name of the comparator.
  String get name;

  /// Compares the given the length of [values] against a [threshold].
  ///
  /// Returns `true` if the comparison meets the criteria, otherwise `false`.
  bool compare(Iterable<V> values, int threshold);
}

/// An abstract class defining the interface for formatting a value
abstract class VxBaseFormatter {
  /// The name of the comparator.
  String get name;

  String format(Map<String, String> options, String value,
      [String? formatting]);
}
