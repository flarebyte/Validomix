import 'vx_model.dart';

/// A comparator that checks if the length of an iterable is equal to a threshold.
class VxLengthEqual extends VxIterableLengthComparator {
  @override
  final String name = 'length equal';

  @override
  bool compare(Iterable values, int threshold) {
    return values.length == threshold;
  }
}

/// A comparator that checks if the length of an iterable is greater than a threshold.
class VxLengthGreaterThan extends VxIterableLengthComparator {
  @override
  final String name = 'length greater than';

  @override
  bool compare(Iterable values, int threshold) {
    return values.length > threshold;
  }
}

/// A comparator that checks if the length of an iterable is less than a threshold.
class VxLengthLessThan extends VxIterableLengthComparator {
  @override
  final String name = 'length less than';

  @override
  bool compare(Iterable values, int threshold) {
    return values.length < threshold;
  }
}

/// A comparator that checks if the length of an iterable is greater than or equal to a threshold.
class VxLengthGreaterThanOrEqual extends VxIterableLengthComparator {
  @override
  final String name = 'length greater than or equal';

  @override
  bool compare(Iterable values, int threshold) {
    return values.length >= threshold;
  }
}

/// A comparator that checks if the length of an iterable is less than or equal to a threshold.
class VxLengthLessThanOrEqual extends VxIterableLengthComparator {
  @override
  final String name = 'length less than or equal';

  @override
  bool compare(Iterable values, int threshold) {
    return values.length <= threshold;
  }
}

/// A static class containing instances of iterable length comparators.
class VxIterableLengthComparators {
  // Prevents instantiation of the class.
  VxIterableLengthComparators._();

  /// A comparator that checks if the length of an iterable is equal to a threshold.
  static final VxLengthEqual equal = VxLengthEqual();

  /// A comparator that checks if the length of an iterable is greater than a threshold.
  static final VxLengthGreaterThan greaterThan = VxLengthGreaterThan();

  /// A comparator that checks if the length of an iterable is less than a threshold.
  static final VxLengthLessThan lessThan = VxLengthLessThan();

  /// A comparator that checks if the length of an iterable is greater than or equal to a threshold.
  static final VxLengthGreaterThanOrEqual greaterThanOrEqual =
      VxLengthGreaterThanOrEqual();

  /// A comparator that checks if the length of an iterable is less than or equal to a threshold.
  static final VxLengthLessThanOrEqual lessThanOrEqual =
      VxLengthLessThanOrEqual();
}
