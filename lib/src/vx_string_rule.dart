import 'vx_model.dart';

/// Validates that the number of characters in a string is less than a specified limit.
class VxCharsLessThanRule<MSG> extends VxBaseRule<MSG> {
  final VxMessageProducer<MSG, String>? successProducer;
  final VxMessageProducer<MSG, String>? failureProducer;
  final int maxChars;

  /// Constructs a `VxCharsLessThanRule`.
  ///
  /// - [maxChars]: The maximum number of characters allowed.
  /// - [successProducer]: The producer for success messages.
  /// - [failureProducer]: The producer for failure messages.
  VxCharsLessThanRule(this.maxChars,
      {this.successProducer, this.failureProducer});

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    if (value.length < maxChars) {
      if (successProducer != null) {
        return [successProducer!.produce(options, value)];
      }
    } else {
      if (failureProducer != null) {
        return [failureProducer!.produce(options, value)];
      }
    }
    return [];
  }
}

/// Validates that the number of characters in a string is more than a specified limit.
class VxCharsMoreThanRule<MSG> extends VxBaseRule<MSG> {
  final VxMessageProducer<MSG, String>? successProducer;
  final VxMessageProducer<MSG, String>? failureProducer;
  final int minChars;

  /// Constructs a `VxCharsMoreThanRule`.
  ///
  /// - [minChars]: The minimum number of characters required.
  /// - [successProducer]: The producer for success messages.
  /// - [failureProducer]: The producer for failure messages.
  VxCharsMoreThanRule(this.minChars,
      {this.successProducer, this.failureProducer});

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    if (value.length > minChars) {
      if (successProducer != null) {
        return [successProducer!.produce(options, value)];
      }
    } else {
      if (failureProducer != null) {
        return [failureProducer!.produce(options, value)];
      }
    }
    return [];
  }
}

/// Validates that the number of characters in a string is less than or equal to a specified limit.
class VxCharsLessThanOrEqualRule<MSG> extends VxBaseRule<MSG> {
  final VxMessageProducer<MSG, String>? successProducer;
  final VxMessageProducer<MSG, String>? failureProducer;
  final int maxChars;

  /// Constructs a `VxCharsLessThanOrEqualRule`.
  ///
  /// - [maxChars]: The maximum number of characters allowed.
  /// - [successProducer]: The producer for success messages.
  /// - [failureProducer]: The producer for failure messages.
  VxCharsLessThanOrEqualRule(this.maxChars,
      {this.successProducer, this.failureProducer});

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    if (value.length <= maxChars) {
      if (successProducer != null) {
        return [successProducer!.produce(options, value)];
      }
    } else {
      if (failureProducer != null) {
        return [failureProducer!.produce(options, value)];
      }
    }
    return [];
  }
}

/// Validates that the number of characters in a string is more than or equal to a specified limit.
class VxCharsMoreThanOrEqualRule<MSG> extends VxBaseRule<MSG> {
  final VxMessageProducer<MSG, String>? successProducer;
  final VxMessageProducer<MSG, String>? failureProducer;
  final int minChars;

  /// Constructs a `VxCharsMoreThanOrEqualRule`.
  ///
  /// - [minChars]: The minimum number of characters required.
  /// - [successProducer]: The producer for success messages.
  /// - [failureProducer]: The producer for failure messages.
  VxCharsMoreThanOrEqualRule(this.minChars,
      {this.successProducer, this.failureProducer});

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    if (value.length >= minChars) {
      if (successProducer != null) {
        return [successProducer!.produce(options, value)];
      }
    } else {
      if (failureProducer != null) {
        return [failureProducer!.produce(options, value)];
      }
    }
    return [];
  }
}

/// Validates that the number of words in a string is less than a specified limit.
class VxWordsLessThanRule<MSG> extends VxBaseRule<MSG> {
  final VxMessageProducer<MSG, String>? successProducer;
  final VxMessageProducer<MSG, String>? failureProducer;
  final int maxWords;

  /// Constructs a `VxWordsLessThanRule`.
  ///
  /// - [maxWords]: The maximum number of words allowed.
  /// - [successProducer]: The producer for success messages.
  /// - [failureProducer]: The producer for failure messages.
  VxWordsLessThanRule(this.maxWords,
      {this.successProducer, this.failureProducer});

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final wordCount = value.split(' ').length;
    if (wordCount < maxWords) {
      if (successProducer != null) {
        return [successProducer!.produce(options, value)];
      }
    } else {
      if (failureProducer != null) {
        return [failureProducer!.produce(options, value)];
      }
    }
    return [];
  }
}

/// Validates that the number of words in a string is more than a specified limit.
class VxWordsMoreThanRule<MSG> extends VxBaseRule<MSG> {
  final VxMessageProducer<MSG, String>? successProducer;
  final VxMessageProducer<MSG, String>? failureProducer;
  final int minWords;

  /// Constructs a `VxWordsMoreThanRule`.
  ///
  /// - [minWords]: The minimum number of words required.
  /// - [successProducer]: The producer for success messages.
  /// - [failureProducer]: The producer for failure messages.
  VxWordsMoreThanRule(this.minWords,
      {this.successProducer, this.failureProducer});

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final wordCount = value.split(' ').length;
    if (wordCount > minWords) {
      if (successProducer != null) {
        return [successProducer!.produce(options, value)];
      }
    } else {
      if (failureProducer != null) {
        return [failureProducer!.produce(options, value)];
      }
    }
    return [];
  }
}

/// Validates that the number of words in a string is less than or equal to a specified limit.
class VxWordsLessThanOrEqualRule<MSG> extends VxBaseRule<MSG> {
  final VxMessageProducer<MSG, String>? successProducer;
  final VxMessageProducer<MSG, String>? failureProducer;
  final int maxWords;

  /// Constructs a `VxWordsLessThanOrEqualRule`.
  ///
  /// - [maxWords]: The maximum number of words allowed.
  /// - [successProducer]: The producer for success messages.
  /// - [failureProducer]: The producer for failure messages.
  VxWordsLessThanOrEqualRule(this.maxWords,
      {this.successProducer, this.failureProducer});

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final wordCount = value.split(' ').length;
    if (wordCount <= maxWords) {
      if (successProducer != null) {
        return [successProducer!.produce(options, value)];
      }
    } else {
      if (failureProducer != null) {
        return [failureProducer!.produce(options, value)];
      }
    }
    return [];
  }
}

/// Validates that the number of words in a string is more than or equal to a specified limit.
class VxWordsMoreThanOrEqualRule<MSG> extends VxBaseRule<MSG> {
  final VxMessageProducer<MSG, String>? successProducer;
  final VxMessageProducer<MSG, String>? failureProducer;
  final int minWords;

  /// Constructs a `VxWordsMoreThanOrEqualRule`.
  ///
  /// - [minWords]: The minimum number of words required.
  /// - [successProducer]: The producer for success messages.
  /// - [failureProducer]: The producer for failure messages.
  VxWordsMoreThanOrEqualRule(this.minWords,
      {this.successProducer, this.failureProducer});

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final wordCount = value.split(' ').length;
    if (wordCount >= minWords) {
      if (successProducer != null) {
        return [successProducer!.produce(options, value)];
      }
    } else {
      if (failureProducer != null) {
        return [failureProducer!.produce(options, value)];
      }
    }
    return [];
  }
}

class VxStringRules {
  /// Creates a `VxCharsLessThanRule` instance.
  static VxCharsLessThanRule<MSG> charsLessThan<MSG>(
    int maxChars, {
    VxMessageProducer<MSG, String>? successProducer,
    VxMessageProducer<MSG, String>? failureProducer,
  }) {
    return VxCharsLessThanRule<MSG>(maxChars,
        successProducer: successProducer, failureProducer: failureProducer);
  }

  /// Creates a `VxCharsMoreThanRule` instance.
  static VxCharsMoreThanRule<MSG> charsMoreThan<MSG>(
    int minChars, {
    VxMessageProducer<MSG, String>? successProducer,
    VxMessageProducer<MSG, String>? failureProducer,
  }) {
    return VxCharsMoreThanRule<MSG>(minChars,
        successProducer: successProducer, failureProducer: failureProducer);
  }

  /// Creates a `VxCharsLessThanOrEqualRule` instance.
  static VxCharsLessThanOrEqualRule<MSG> charsLessThanOrEqual<MSG>(
    int maxChars, {
    VxMessageProducer<MSG, String>? successProducer,
    VxMessageProducer<MSG, String>? failureProducer,
  }) {
    return VxCharsLessThanOrEqualRule<MSG>(maxChars,
        successProducer: successProducer, failureProducer: failureProducer);
  }

  /// Creates a `VxCharsMoreThanOrEqualRule` instance.
  static VxCharsMoreThanOrEqualRule<MSG> charsMoreThanOrEqual<MSG>(
    int minChars, {
    VxMessageProducer<MSG, String>? successProducer,
    VxMessageProducer<MSG, String>? failureProducer,
  }) {
    return VxCharsMoreThanOrEqualRule<MSG>(minChars,
        successProducer: successProducer, failureProducer: failureProducer);
  }

  /// Creates a `VxWordsLessThanRule` instance.
  static VxWordsLessThanRule<MSG> wordsLessThan<MSG>(
    int maxWords, {
    VxMessageProducer<MSG, String>? successProducer,
    VxMessageProducer<MSG, String>? failureProducer,
  }) {
    return VxWordsLessThanRule<MSG>(maxWords,
        successProducer: successProducer, failureProducer: failureProducer);
  }

  /// Creates a `VxWordsMoreThanRule` instance.
  static VxWordsMoreThanRule<MSG> wordsMoreThan<MSG>(
    int minWords, {
    VxMessageProducer<MSG, String>? successProducer,
    VxMessageProducer<MSG, String>? failureProducer,
  }) {
    return VxWordsMoreThanRule<MSG>(minWords,
        successProducer: successProducer, failureProducer: failureProducer);
  }

  /// Creates a `VxWordsLessThanOrEqualRule` instance.
  static VxWordsLessThanOrEqualRule<MSG> wordsLessThanOrEqual<MSG>(
    int maxWords, {
    VxMessageProducer<MSG, String>? successProducer,
    VxMessageProducer<MSG, String>? failureProducer,
  }) {
    return VxWordsLessThanOrEqualRule<MSG>(maxWords,
        successProducer: successProducer, failureProducer: failureProducer);
  }

  /// Creates a `VxWordsMoreThanOrEqualRule` instance.
  static VxWordsMoreThanOrEqualRule<MSG> wordsMoreThanOrEqual<MSG>(
    int minWords, {
    VxMessageProducer<MSG, String>? successProducer,
    VxMessageProducer<MSG, String>? failureProducer,
  }) {
    return VxWordsMoreThanOrEqualRule<MSG>(minWords,
        successProducer: successProducer, failureProducer: failureProducer);
  }
}
