import 'package:eagleyeix/metric.dart';

import 'vx_component_name_manager.dart';
import 'vx_metrics.dart';
import 'vx_model.dart';
import 'vx_number_comparator.dart';
import 'vx_options_inventory.dart';
import 'vx_options_map.dart';

/// The default should try to be generous
final charsDefaultSize = {
  VxNumberComparators.lessThan.name: 10000,
  VxNumberComparators.lessThanOrEqual.name: 10000,
  VxNumberComparators.greaterThan.name: 0,
  VxNumberComparators.greaterThanOrEqual.name: 0,
};

/// The default name for each comparator
final charsDefaultName = {
  VxNumberComparators.lessThan.name: 'maxChars',
  VxNumberComparators.lessThanOrEqual.name: 'maxChars',
  VxNumberComparators.greaterThan.name: 'minChars',
  VxNumberComparators.greaterThanOrEqual.name: 'minChars',
};

/// The default should try to be generous
final wordsDefaultSize = {
  VxNumberComparators.lessThan.name: 1000,
  VxNumberComparators.lessThanOrEqual.name: 1000,
  VxNumberComparators.greaterThan.name: 0,
  VxNumberComparators.greaterThanOrEqual.name: 0,
};

/// The default name for each comparator
final wordsDefaultName = {
  VxNumberComparators.lessThan.name: 'maxWords',
  VxNumberComparators.lessThanOrEqual.name: 'maxWords',
  VxNumberComparators.greaterThan.name: 'minWords',
  VxNumberComparators.greaterThanOrEqual.name: 'minWords',
};

/// Validates that the number of characters in a string is less than a specified limit obtained from the options.
class VxCharsRule<MSG> extends VxBaseRule<MSG> {
  final VxMessageProducer<MSG, String>? successProducer;
  final VxMessageProducer<MSG, String>? failureProducer;
  final VxNumberComparator numberComparator;
  final String name;
  final ExMetricStoreHolder metricStoreHolder;
  final int defaultMaxChars;
  final VxComponentManagerConfig componentManagerConfig;
  final VxOptionsInventory optionsInventory;
  late VxOptionsMap optionsMap;
  late int thresholdCharsKey;

  VxCharsRule(
      {required this.numberComparator,
      required this.name,
      required this.metricStoreHolder,
      required this.optionsInventory,
      required this.defaultMaxChars,
      this.successProducer,
      this.failureProducer,
      this.componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    optionsMap = VxOptionsMap(
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        ownerClassName: 'VxCharsRule',
        classSpecialisation: numberComparator.name.replaceAll(' ', '-'),
        componentManagerConfig: componentManagerConfig);
    thresholdCharsKey = optionsInventory.addKey(
        VxComponentNameManager.getFullOptionKey(
            name, charsDefaultName[numberComparator.name] ?? 'thresholdChars'),
        VxOptionsInventoryDescriptors.positiveInt);
  }

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final thresholdChars = optionsMap
        .getInt(
            options: options,
            id: thresholdCharsKey,
            defaultValue: charsDefaultSize[numberComparator.name] ?? 0)
        .value;
    return _evaluate(value, thresholdChars, options);
  }

  List<MSG> _evaluate(
      String value, int thresholdChars, Map<String, String> options) {
    if (numberComparator.compare(value.length, thresholdChars)) {
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
class VxWordsRule<MSG> extends VxBaseRule<MSG> {
  final VxMessageProducer<MSG, String>? successProducer;
  final VxMessageProducer<MSG, String>? failureProducer;
  final VxNumberComparator numberComparator;
  final String name;
  final ExMetricStoreHolder metricStoreHolder;
  final int defaultMaxChars;
  final VxComponentManagerConfig componentManagerConfig;
  final VxOptionsInventory optionsInventory;
  late VxOptionsMap optionsMap;
  late int thresholdWordsKey;

  VxWordsRule(
      {required this.numberComparator,
      required this.name,
      required this.metricStoreHolder,
      required this.optionsInventory,
      required this.defaultMaxChars,
      this.successProducer,
      this.failureProducer,
      this.componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    optionsMap = VxOptionsMap(
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        ownerClassName: 'VxWordsRule',
        classSpecialisation: numberComparator.name.replaceAll(' ', '-'),
        componentManagerConfig: componentManagerConfig);
    thresholdWordsKey = optionsInventory.addKey(
        VxComponentNameManager.getFullOptionKey(
            name, wordsDefaultName[numberComparator.name] ?? 'thresholdWords'),
        VxOptionsInventoryDescriptors.positiveInt);
  }
  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final thresholdWords = optionsMap
        .getInt(
            options: options,
            id: thresholdWordsKey,
            defaultValue: wordsDefaultSize[numberComparator.name] ?? 0)
        .value;
    return _evaluate(value, thresholdWords, options);
  }

  List<MSG> _evaluate(String value, int maxWords, Map<String, String> options) {
    final wordCount = value.split(' ').length;
    if (numberComparator.compare(wordCount, maxWords)) {
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
      metricStoreHolder.store.addMetric(
          VxMetrics.getMinWordsKeyNotFound('VxWordsMoreThanRule', name), 1);
      return _evaluate(value, defaultMinWords, options);
    }

    if (minWords == null) {
      metricStoreHolder.store.addMetric(
          VxMetrics.getMinWordsKeyInvalid('VxWordsMoreThanRule', name), 1);
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
      metricStoreHolder.store.addMetric(
          VxMetrics.getMinWordsKeyNotFound('VxWordsMoreThanOrEqualRule', name),
          1);
      return _evaluate(value, defaultMinWords, options);
    }

    if (minWords == null) {
      metricStoreHolder.store.addMetric(
          VxMetrics.getMinWordsKeyInvalid('VxWordsMoreThanOrEqualRule', name),
          1);
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
      metricStoreHolder.store.addMetric(
          VxMetrics.getMaxWordsKeyNotFound('VxWordsLessThanOrEqualRule', name),
          1);
      return _evaluate(value, defaultMaxWords, options);
    }

    if (maxWords == null) {
      metricStoreHolder.store.addMetric(
          VxMetrics.getMaxWordsKeyInvalid('VxWordsLessThanOrEqualRule', name),
          1);
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
  static VxCharsRule<MSG> charsLessThan<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      required int defaultMaxChars,
      VxMessageProducer<MSG, String>? successProducer,
      VxMessageProducer<MSG, String>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxCharsRule<MSG>(
        name: name,
        numberComparator: VxNumberComparators.lessThan,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        defaultMaxChars: defaultMaxChars,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  static VxCharsRule<MSG> charsMoreThan<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      required int defaultMaxChars,
      VxMessageProducer<MSG, String>? successProducer,
      VxMessageProducer<MSG, String>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxCharsRule<MSG>(
        name: name,
        numberComparator: VxNumberComparators.greaterThan,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        defaultMaxChars: defaultMaxChars,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  static VxCharsRule<MSG> charsLessThanOrEqual<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      required int defaultMaxChars,
      VxMessageProducer<MSG, String>? successProducer,
      VxMessageProducer<MSG, String>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxCharsRule<MSG>(
        name: name,
        numberComparator: VxNumberComparators.lessThanOrEqual,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        defaultMaxChars: defaultMaxChars,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  static VxCharsRule<MSG> charsMoreThanOrEqual<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      required int defaultMaxChars,
      VxMessageProducer<MSG, String>? successProducer,
      VxMessageProducer<MSG, String>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxCharsRule<MSG>(
        name: name,
        numberComparator: VxNumberComparators.greaterThanOrEqual,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        defaultMaxChars: defaultMaxChars,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  static VxWordsRule<MSG> wordsLessThan<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      required int defaultMaxChars,
      VxMessageProducer<MSG, String>? successProducer,
      VxMessageProducer<MSG, String>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxWordsRule<MSG>(
        name: name,
        numberComparator: VxNumberComparators.lessThan,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        defaultMaxChars: defaultMaxChars,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  static VxWordsRule<MSG> wordsMoreThan<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      required int defaultMaxChars,
      VxMessageProducer<MSG, String>? successProducer,
      VxMessageProducer<MSG, String>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxWordsRule<MSG>(
        name: name,
        numberComparator: VxNumberComparators.greaterThan,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        defaultMaxChars: defaultMaxChars,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  static VxWordsRule<MSG> wordsLessThanOrEqual<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      required int defaultMaxChars,
      VxMessageProducer<MSG, String>? successProducer,
      VxMessageProducer<MSG, String>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxWordsRule<MSG>(
        name: name,
        numberComparator: VxNumberComparators.lessThanOrEqual,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        defaultMaxChars: defaultMaxChars,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  static VxWordsRule<MSG> wordsMoreThanOrEqual<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      required int defaultMaxChars,
      VxMessageProducer<MSG, String>? successProducer,
      VxMessageProducer<MSG, String>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxWordsRule<MSG>(
        name: name,
        numberComparator: VxNumberComparators.greaterThanOrEqual,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        defaultMaxChars: defaultMaxChars,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }
}
