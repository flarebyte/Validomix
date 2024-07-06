import 'vx_model.dart';

/// Comparator for checking if a value is greater than a threshold.
class VxGreaterThanComparator extends VxNumberComparator {
  @override
  String get name => 'greater than';

  @override
  bool compare(num value, num threshold) {
    return value > threshold;
  }
}

/// Comparator for checking if a value is greater than or equal to a threshold.
class VxGreaterThanOrEqualComparator extends VxNumberComparator {
  @override
  String get name => 'greater than or equal';

  @override
  bool compare(num value, num threshold) {
    return value >= threshold;
  }
}

/// Comparator for checking if a value is less than a threshold.
class VxLessThanComparator extends VxNumberComparator {
  @override
  String get name => 'less than';

  @override
  bool compare(num value, num threshold) {
    return value < threshold;
  }
}

/// Comparator for checking if a value is less than or equal to a threshold.
class VxLessThanOrEqualComparator extends VxNumberComparator {
  @override
  String get name => 'less than or equal';

  @override
  bool compare(num value, num threshold) {
    return value <= threshold;
  }
}

/// Comparator for checking if a value is equal to a threshold.
class VxEqualToComparator extends VxNumberComparator {
  @override
  String get name => 'equal to';

  @override
  bool compare(num value, num threshold) {
    return value == threshold;
  }
}

/// Comparator for checking if a value is not equal to a threshold.
class VxNotEqualToComparator extends VxNumberComparator {
  @override
  String get name => 'not equal to';

  @override
  bool compare(num value, num threshold) {
    return value != threshold;
  }
}

/// A static class providing access to various number comparators.
class VxNumberComparators {
  static final VxNumberComparator greaterThan = VxGreaterThanComparator();
  static final VxNumberComparator greaterThanOrEqual =
      VxGreaterThanOrEqualComparator();
  static final VxNumberComparator lessThan = VxLessThanComparator();
  static final VxNumberComparator lessThanOrEqual =
      VxLessThanOrEqualComparator();
  static final VxNumberComparator equalTo = VxEqualToComparator();
  static final VxNumberComparator notEqualTo = VxNotEqualToComparator();
}
