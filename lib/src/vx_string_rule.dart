import 'package:eagleyeix/metric.dart';

import 'vx_component_name_manager.dart';
import 'vx_model.dart';
import 'vx_number_comparator.dart';
import 'vx_options_inventory.dart';
import 'vx_options_map.dart';

/// The default should try to be generous
final _charsDefaultSize = {
  VxNumberComparators.lessThan.name: 10000,
  VxNumberComparators.lessThanOrEqual.name: 10000,
  VxNumberComparators.greaterThan.name: 0,
  VxNumberComparators.greaterThanOrEqual.name: 0,
};

/// The default name for each comparator
final _charsDefaultName = {
  VxNumberComparators.lessThan.name: 'maxChars',
  VxNumberComparators.lessThanOrEqual.name: 'maxChars',
  VxNumberComparators.greaterThan.name: 'minChars',
  VxNumberComparators.greaterThanOrEqual.name: 'minChars',
};

/// The default should try to be generous
final _wordsDefaultSize = {
  VxNumberComparators.lessThan.name: 1000,
  VxNumberComparators.lessThanOrEqual.name: 1000,
  VxNumberComparators.greaterThan.name: 0,
  VxNumberComparators.greaterThanOrEqual.name: 0,
};

/// The default name for each comparator
final _wordsDefaultName = {
  VxNumberComparators.lessThan.name: 'maxWords',
  VxNumberComparators.lessThanOrEqual.name: 'maxWords',
  VxNumberComparators.greaterThan.name: 'minWords',
  VxNumberComparators.greaterThanOrEqual.name: 'minWords',
};

/// Validates that the number of characters in a string is less than a specified limit obtained from the options.
class VxCharsRule<MSG> extends VxBaseRule<MSG> {
  final List<VxMessageProducer<MSG, String>>? successProducer;
  final List<VxMessageProducer<MSG, String>>? failureProducer;
  final VxNumberComparator numberComparator;
  final String name;
  final ExMetricStoreHolder metricStoreHolder;
  final VxComponentManagerConfig componentManagerConfig;
  final VxOptionsInventory optionsInventory;
  late VxOptionsMap optionsMap;
  late int thresholdCharsKey;

  VxCharsRule(
      {required this.numberComparator,
      required this.name,
      required this.metricStoreHolder,
      required this.optionsInventory,
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
            name, _charsDefaultName[numberComparator.name] ?? 'thresholdChars'),
        VxOptionsInventoryDescriptors.positiveInt);
  }

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final thresholdChars = optionsMap
        .getInt(
            options: options,
            id: thresholdCharsKey,
            defaultValue: _charsDefaultSize[numberComparator.name] ?? 0)
        .value;
    return _evaluate(value, thresholdChars, options);
  }

  List<MSG> _produceSuccess(Map<String, String> options, String value) {
    return successProducer == null
        ? []
        : successProducer!.map((prod) => prod.produce(options, value)).toList();
  }

  List<MSG> _produceFailure(Map<String, String> options, String value) {
    return failureProducer == null
        ? []
        : failureProducer!.map((prod) => prod.produce(options, value)).toList();
  }

  List<MSG> _evaluate(
      String value, int thresholdChars, Map<String, String> options) {
    if (numberComparator.compare(value.length, thresholdChars)) {
      if (successProducer != null) {
        return _produceSuccess(options, value);
      }
    } else {
      if (failureProducer != null) {
        return _produceFailure(options, value);
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
  final VxComponentManagerConfig componentManagerConfig;
  final VxOptionsInventory optionsInventory;
  late VxOptionsMap optionsMap;
  late int thresholdWordsKey;

  VxWordsRule(
      {required this.numberComparator,
      required this.name,
      required this.metricStoreHolder,
      required this.optionsInventory,
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
            name, _wordsDefaultName[numberComparator.name] ?? 'thresholdWords'),
        VxOptionsInventoryDescriptors.positiveInt);
  }
  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final thresholdWords = optionsMap
        .getInt(
            options: options,
            id: thresholdWordsKey,
            defaultValue: _wordsDefaultSize[numberComparator.name] ?? 0)
        .value;
    return _evaluate(value, thresholdWords, options);
  }

  List<MSG> _produceSuccess(Map<String, String> options, String value) {
    return successProducer == null
        ? []
        : [successProducer!.produce(options, value)];
  }

  List<MSG> _produceFailure(Map<String, String> options, String value) {
    return failureProducer == null
        ? []
        : [failureProducer!.produce(options, value)];
  }

  List<MSG> _evaluate(String value, int maxWords, Map<String, String> options) {
    final wordCount = value.split(' ').length;
    if (numberComparator.compare(wordCount, maxWords)) {
      if (successProducer != null) {
        return _produceSuccess(options, value);
      }
    } else {
      if (failureProducer != null) {
        return _produceFailure(options, value);
      }
    }
    return [];
  }
}

/// Validates that the number of characters in a string is less than a specified limit obtained from the options.
class VxStringFormatterRule<MSG> extends VxBaseRule<MSG> {
  final VxMessageProducer<MSG, String>? successProducer;
  final VxMessageProducer<MSG, String>? failureProducer;
  final String name;
  final ExMetricStoreHolder metricStoreHolder;
  final VxComponentManagerConfig componentManagerConfig;
  final VxOptionsInventory optionsInventory;
  final VxBaseFormatter formatter;
  late VxOptionsMap optionsMap;
  late int formattingKey;
  VxStringFormatterRule(
      {required this.name,
      required this.metricStoreHolder,
      required this.optionsInventory,
      required this.formatter,
      this.successProducer,
      this.failureProducer,
      this.componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    optionsMap = VxOptionsMap(
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        ownerClassName: 'VxStringFormatterRule',
        classSpecialisation: formatter.name.replaceAll(' ', '-'),
        componentManagerConfig: componentManagerConfig);
    formattingKey = optionsInventory.addKey(
        VxComponentNameManager.getFullOptionKey(name, 'formatting',
            optional: true),
        [VxOptionsInventoryDescriptors.string]);
  }

  List<MSG> _produceSuccess(Map<String, String> options, String value) {
    return successProducer == null
        ? []
        : [successProducer!.produce(options, value)];
  }

  List<MSG> _produceFailure(Map<String, String> options, String value) {
    return failureProducer == null
        ? []
        : [failureProducer!.produce(options, value)];
  }

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final formatting =
        optionsMap.getString(options: options, id: formattingKey).value;
    final formatted = formatter.format(options, value, formatting);
    if (formatted == value) {
      if (successProducer != null) {
        return _produceSuccess(options, value);
      }
    } else {
      if (failureProducer != null) {
        return _produceFailure(options, value);
      }
    }
    return [];
  }
}

/// Static class for chars and words rules
class VxStringRules {
  /// Rule for validating that a string has less characters than the threshold.
  static VxCharsRule<MSG> charsLessThan<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      List<VxMessageProducer<MSG, String>>? successProducer,
      List<VxMessageProducer<MSG, String>>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxCharsRule<MSG>(
        name: name,
        numberComparator: VxNumberComparators.lessThan,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  /// Rule for validating that a string has more characters than the threshold.
  static VxCharsRule<MSG> charsMoreThan<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      List<VxMessageProducer<MSG, String>>? successProducer,
      List<VxMessageProducer<MSG, String>>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxCharsRule<MSG>(
        name: name,
        numberComparator: VxNumberComparators.greaterThan,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  /// Rule for validating that a string has less characters than the threshold.
  static VxCharsRule<MSG> charsLessThanOrEqual<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      List<VxMessageProducer<MSG, String>>? successProducer,
      List<VxMessageProducer<MSG, String>>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxCharsRule<MSG>(
        name: name,
        numberComparator: VxNumberComparators.lessThanOrEqual,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  /// Rule for validating that a string has more characters than the threshold.
  static VxCharsRule<MSG> charsMoreThanOrEqual<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      List<VxMessageProducer<MSG, String>>? successProducer,
      List<VxMessageProducer<MSG, String>>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxCharsRule<MSG>(
        name: name,
        numberComparator: VxNumberComparators.greaterThanOrEqual,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  /// Rule for validating that a string has less words than the threshold.
  static VxWordsRule<MSG> wordsLessThan<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      VxMessageProducer<MSG, String>? successProducer,
      VxMessageProducer<MSG, String>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxWordsRule<MSG>(
        name: name,
        numberComparator: VxNumberComparators.lessThan,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  /// Rule for validating that a string has more words than the threshold.
  static VxWordsRule<MSG> wordsMoreThan<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      VxMessageProducer<MSG, String>? successProducer,
      VxMessageProducer<MSG, String>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxWordsRule<MSG>(
        name: name,
        numberComparator: VxNumberComparators.greaterThan,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  /// Rule for validating that a string has less words than the threshold.
  static VxWordsRule<MSG> wordsLessThanOrEqual<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      VxMessageProducer<MSG, String>? successProducer,
      VxMessageProducer<MSG, String>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxWordsRule<MSG>(
        name: name,
        numberComparator: VxNumberComparators.lessThanOrEqual,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  /// Rule for validating that a string has more words than the threshold.
  static VxWordsRule<MSG> wordsMoreThanOrEqual<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      VxMessageProducer<MSG, String>? successProducer,
      VxMessageProducer<MSG, String>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxWordsRule<MSG>(
        name: name,
        numberComparator: VxNumberComparators.greaterThanOrEqual,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  /// Rule for validating that a string follows a specific format
  static VxStringFormatterRule<MSG> followFormat<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      required VxBaseFormatter formatter,
      VxMessageProducer<MSG, String>? successProducer,
      VxMessageProducer<MSG, String>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxStringFormatterRule<MSG>(
      name: name,
      metricStoreHolder: metricStoreHolder,
      optionsInventory: optionsInventory,
      formatter: formatter,
      successProducer: successProducer,
      failureProducer: failureProducer,
      componentManagerConfig: componentManagerConfig,
    );
  }
}
