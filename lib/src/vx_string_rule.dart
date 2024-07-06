import 'package:eagleyeix/metric.dart';

import 'vx_metrics.dart';
import 'vx_model.dart';

/// Validates that the number of characters in a string is less than a specified limit obtained from the options.
class VxCharsLessThanRule<MSG> extends VxBaseRule<MSG> {
  final VxMessageProducer<MSG, String>? successProducer;
  final VxMessageProducer<MSG, String>? failureProducer;
  final String name;
  final ExMetricStoreHolder metricStoreHolder;
  final int defaultMaxChars;

  VxCharsLessThanRule(this.name, this.metricStoreHolder, this.defaultMaxChars,
      {this.successProducer, this.failureProducer});

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final maxCharsKey = '$name-maxChars';
    final maxChars = int.tryParse(options[maxCharsKey] ?? '');

    if (!options.containsKey(maxCharsKey)) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getMaxCharsKeyNotFound(name), 1);
      return _evaluate(value, defaultMaxChars, options);
    }

    if (maxChars == null) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getMaxCharsKeyInvalid(name), 1);
      return _evaluate(value, defaultMaxChars, options);
    }

    return _evaluate(value, maxChars, options);
  }

  List<MSG> _evaluate(String value, int maxChars, Map<String, String> options) {
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

/// Validates that the number of characters in a string is more than a specified limit obtained from the options.
class VxCharsMoreThanRule<MSG> extends VxBaseRule<MSG> {
  final VxMessageProducer<MSG, String>? successProducer;
  final VxMessageProducer<MSG, String>? failureProducer;
  final String name;
  final ExMetricStoreHolder metricStoreHolder;
  final int defaultMinChars;

  VxCharsMoreThanRule(this.name, this.metricStoreHolder, this.defaultMinChars,
      {this.successProducer, this.failureProducer});

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final minCharsKey = '$name-minChars';
    final minChars = int.tryParse(options[minCharsKey] ?? '');

    if (!options.containsKey(minCharsKey)) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getMinCharsKeyNotFound(name), 1);
      return _evaluate(value, defaultMinChars, options);
    }

    if (minChars == null) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getMinCharsKeyInvalid(name), 1);
      return _evaluate(value, defaultMinChars, options);
    }

    return _evaluate(value, minChars, options);
  }

  List<MSG> _evaluate(String value, int minChars, Map<String, String> options) {
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

/// Validates that the number of characters in a string is less than or equal to a specified limit obtained from the options.
class VxCharsLessThanOrEqualRule<MSG> extends VxBaseRule<MSG> {
  final VxMessageProducer<MSG, String>? successProducer;
  final VxMessageProducer<MSG, String>? failureProducer;
  final String name;
  final ExMetricStoreHolder metricStoreHolder;
  final int defaultMaxChars;

  VxCharsLessThanOrEqualRule(
      this.name, this.metricStoreHolder, this.defaultMaxChars,
      {this.successProducer, this.failureProducer});

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final maxCharsKey = '$name-maxChars';
    final maxChars = int.tryParse(options[maxCharsKey] ?? '');

    if (!options.containsKey(maxCharsKey)) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getMaxCharsKeyNotFound(name), 1);
      return _evaluate(value, defaultMaxChars, options);
    }

    if (maxChars == null) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getMaxCharsKeyInvalid(name), 1);
      return _evaluate(value, defaultMaxChars, options);
    }

    return _evaluate(value, maxChars, options);
  }

  List<MSG> _evaluate(String value, int maxChars, Map<String, String> options) {
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

/// Validates that the number of characters in a string is more than or equal to a specified limit obtained from the options.
class VxCharsMoreThanOrEqualRule<MSG> extends VxBaseRule<MSG> {
  final VxMessageProducer<MSG, String>? successProducer;
  final VxMessageProducer<MSG, String>? failureProducer;
  final String name;
  final ExMetricStoreHolder metricStoreHolder;
  final int defaultMinChars;

  VxCharsMoreThanOrEqualRule(
      this.name, this.metricStoreHolder, this.defaultMinChars,
      {this.successProducer, this.failureProducer});

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final minCharsKey = '$name-minChars';
    final minChars = int.tryParse(options[minCharsKey] ?? '');

    if (!options.containsKey(minCharsKey)) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getMinCharsKeyNotFound(name), 1);
      return _evaluate(value, defaultMinChars, options);
    }

    if (minChars == null) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getMinCharsKeyInvalid(name), 1);
      return _evaluate(value, defaultMinChars, options);
    }

    return _evaluate(value, minChars, options);
  }

  List<MSG> _evaluate(String value, int minChars, Map<String, String> options) {
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

/// Validates that the number of words in a string is less than a specified limit obtained from the options.
class VxWordsLessThanRule<MSG> extends VxBaseRule<MSG> {
  final VxMessageProducer<MSG, String>? successProducer;
  final VxMessageProducer<MSG, String>? failureProducer;
  final String name;
  final ExMetricStoreHolder metricStoreHolder;
  final int defaultMaxWords;

  VxWordsLessThanRule(this.name, this.metricStoreHolder, this.defaultMaxWords,
      {this.successProducer, this.failureProducer});

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final maxWordsKey = '$name-maxWords';
    final maxWords = int.tryParse(options[maxWordsKey] ?? '');

    if (!options.containsKey(maxWordsKey)) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getMaxWordsKeyNotFound(name), 1);
      return _evaluate(value, defaultMaxWords, options);
    }

    if (maxWords == null) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getMaxWordsKeyInvalid(name), 1);
      return _evaluate(value, defaultMaxWords, options);
    }

    return _evaluate(value, maxWords, options);
  }

  List<MSG> _evaluate(String value, int maxWords, Map<String, String> options) {
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

/// Validates that the number of words in a string is more than a specified limit obtained from the options.
class VxWordsMoreThanRule<MSG> extends VxBaseRule<MSG> {
  final VxMessageProducer<MSG, String>? successProducer;
  final VxMessageProducer<MSG, String>? failureProducer;
  final String name;
  final ExMetricStoreHolder metricStoreHolder;
  final int defaultMinWords;

  VxWordsMoreThanRule(this.name, this.metricStoreHolder, this.defaultMinWords,
      {this.successProducer, this.failureProducer});

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final minWordsKey = '$name-minWords';
    final minWords = int.tryParse(options[minWordsKey] ?? '');

    if (!options.containsKey(minWordsKey)) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getMinWordsKeyNotFound(name), 1);
      return _evaluate(value, defaultMinWords, options);
    }

    if (minWords == null) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getMinWordsKeyInvalid(name), 1);
      return _evaluate(value, defaultMinWords, options);
    }

    return _evaluate(value, minWords, options);
  }

  List<MSG> _evaluate(String value, int minWords, Map<String, String> options) {
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

/// Validates that the number of words in a string is more than or equal to a specified limit obtained from the options.
class VxWordsMoreThanOrEqualRule<MSG> extends VxBaseRule<MSG> {
  final VxMessageProducer<MSG, String>? successProducer;
  final VxMessageProducer<MSG, String>? failureProducer;
  final String name;
  final ExMetricStoreHolder metricStoreHolder;
  final int defaultMinWords;

  /// Constructs a `VxWordsMoreThanOrEqualRule`.
  ///
  /// - [name]: The name used to retrieve the minimum word count from the options.
  /// - [metricStoreHolder]: The holder for the metric store to record metrics.
  /// - [defaultMinWords]: The default minimum word count if the option is not found or invalid.
  /// - [successProducer]: The producer for success messages.
  /// - [failureProducer]: The producer for failure messages.
  VxWordsMoreThanOrEqualRule(
      this.name, this.metricStoreHolder, this.defaultMinWords,
      {this.successProducer, this.failureProducer});

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final minWordsKey = '$name-minWords';
    final minWords = int.tryParse(options[minWordsKey] ?? '');

    if (!options.containsKey(minWordsKey)) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getMinWordsKeyNotFound(name), 1);
      return _evaluate(value, defaultMinWords, options);
    }

    if (minWords == null) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getMinWordsKeyInvalid(name), 1);
      return _evaluate(value, defaultMinWords, options);
    }

    return _evaluate(value, minWords, options);
  }

  List<MSG> _evaluate(String value, int minWords, Map<String, String> options) {
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

/// Validates that the number of words in a string is less than or equal to a specified limit obtained from the options.
class VxWordsLessThanOrEqualRule<MSG> extends VxBaseRule<MSG> {
  final VxMessageProducer<MSG, String>? successProducer;
  final VxMessageProducer<MSG, String>? failureProducer;
  final String name;
  final ExMetricStoreHolder metricStoreHolder;
  final int defaultMaxWords;

  VxWordsLessThanOrEqualRule(
      this.name, this.metricStoreHolder, this.defaultMaxWords,
      {this.successProducer, this.failureProducer});

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final maxWordsKey = '$name-maxWords';
    final maxWords = int.tryParse(options[maxWordsKey] ?? '');

    if (!options.containsKey(maxWordsKey)) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getMaxWordsKeyNotFound(name), 1);
      return _evaluate(value, defaultMaxWords, options);
    }

    if (maxWords == null) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getMaxWordsKeyInvalid(name), 1);
      return _evaluate(value, defaultMaxWords, options);
    }

    return _evaluate(value, maxWords, options);
  }

  List<MSG> _evaluate(String value, int maxWords, Map<String, String> options) {
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

class VxStringRules {
  static VxCharsLessThanRule<MSG> charsLessThan<MSG>(
    String name,
    ExMetricStoreHolder metricStoreHolder,
    int defaultMaxChars, {
    VxMessageProducer<MSG, String>? successProducer,
    VxMessageProducer<MSG, String>? failureProducer,
  }) {
    return VxCharsLessThanRule<MSG>(name, metricStoreHolder, defaultMaxChars,
        successProducer: successProducer, failureProducer: failureProducer);
  }

  static VxCharsMoreThanRule<MSG> charsMoreThan<MSG>(
    String name,
    ExMetricStoreHolder metricStoreHolder,
    int defaultMinChars, {
    VxMessageProducer<MSG, String>? successProducer,
    VxMessageProducer<MSG, String>? failureProducer,
  }) {
    return VxCharsMoreThanRule<MSG>(name, metricStoreHolder, defaultMinChars,
        successProducer: successProducer, failureProducer: failureProducer);
  }

  static VxCharsLessThanOrEqualRule<MSG> charsLessThanOrEqual<MSG>(
    String name,
    ExMetricStoreHolder metricStoreHolder,
    int defaultMaxChars, {
    VxMessageProducer<MSG, String>? successProducer,
    VxMessageProducer<MSG, String>? failureProducer,
  }) {
    return VxCharsLessThanOrEqualRule<MSG>(
        name, metricStoreHolder, defaultMaxChars,
        successProducer: successProducer, failureProducer: failureProducer);
  }

  static VxCharsMoreThanOrEqualRule<MSG> charsMoreThanOrEqual<MSG>(
    String name,
    ExMetricStoreHolder metricStoreHolder,
    int defaultMinChars, {
    VxMessageProducer<MSG, String>? successProducer,
    VxMessageProducer<MSG, String>? failureProducer,
  }) {
    return VxCharsMoreThanOrEqualRule<MSG>(
        name, metricStoreHolder, defaultMinChars,
        successProducer: successProducer, failureProducer: failureProducer);
  }

  static VxWordsLessThanRule<MSG> wordsLessThan<MSG>(
    String name,
    ExMetricStoreHolder metricStoreHolder,
    int defaultMaxWords, {
    VxMessageProducer<MSG, String>? successProducer,
    VxMessageProducer<MSG, String>? failureProducer,
  }) {
    return VxWordsLessThanRule<MSG>(name, metricStoreHolder, defaultMaxWords,
        successProducer: successProducer, failureProducer: failureProducer);
  }

  static VxWordsMoreThanRule<MSG> wordsMoreThan<MSG>(
    String name,
    ExMetricStoreHolder metricStoreHolder,
    int defaultMinWords, {
    VxMessageProducer<MSG, String>? successProducer,
    VxMessageProducer<MSG, String>? failureProducer,
  }) {
    return VxWordsMoreThanRule<MSG>(name, metricStoreHolder, defaultMinWords,
        successProducer: successProducer, failureProducer: failureProducer);
  }

  static VxWordsLessThanOrEqualRule<MSG> wordsLessThanOrEqual<MSG>(
    String name,
    ExMetricStoreHolder metricStoreHolder,
    int defaultMaxWords, {
    VxMessageProducer<MSG, String>? successProducer,
    VxMessageProducer<MSG, String>? failureProducer,
  }) {
    return VxWordsLessThanOrEqualRule<MSG>(
        name, metricStoreHolder, defaultMaxWords,
        successProducer: successProducer, failureProducer: failureProducer);
  }

  static VxWordsMoreThanOrEqualRule<MSG> wordsMoreThanOrEqual<MSG>(
    String name,
    ExMetricStoreHolder metricStoreHolder,
    int defaultMinWords, {
    VxMessageProducer<MSG, String>? successProducer,
    VxMessageProducer<MSG, String>? failureProducer,
  }) {
    return VxWordsMoreThanOrEqualRule<MSG>(
        name, metricStoreHolder, defaultMinWords,
        successProducer: successProducer, failureProducer: failureProducer);
  }
}
