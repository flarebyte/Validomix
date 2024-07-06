abstract class VxBaseValidator<MSG, V> {
  List<MSG> validate(Map<String, String> options, V value);
}

abstract class VxBaseRule<MSG> extends VxBaseValidator<MSG, String> {}

abstract class VxStringParser<V> {
  V? parseString(String value);
}

/// Produce a message, using an error message, after possibly interpolating the options and the value
abstract class VxMessageProducer<MSG, V> {
  MSG produce(Map<String, String> options, V value);
}

/// An abstract class defining the interface for number comparison.
abstract class VxNumberComparator {
  /// Compares the given [value] against a [threshold].
  ///
  /// Returns `true` if the comparison meets the criteria, otherwise `false`.
  bool compare(num value, num threshold);
}
