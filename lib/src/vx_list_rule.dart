import 'package:eagleyeix/metric.dart';

import 'vx_component_name_manager.dart';
import 'vx_model.dart';
import 'vx_number_comparator.dart';
import 'vx_options_inventory.dart';
import 'vx_options_map.dart';

/// The default should try to be generous
final _numberDefaultListSize = {
  VxNumberComparators.lessThan.name: 10000,
  VxNumberComparators.lessThanOrEqual.name: 10000,
  VxNumberComparators.greaterThan.name: 0,
  VxNumberComparators.greaterThanOrEqual.name: 0,
  VxNumberComparators.equalTo.name: 0,
  VxNumberComparators.notEqualTo.name: 0,
};

/// The default name for each comparator
final _numberDefaultListName = {
  VxNumberComparators.lessThan.name: 'maxSize',
  VxNumberComparators.lessThanOrEqual.name: 'maxSize',
  VxNumberComparators.greaterThan.name: 'minSize',
  VxNumberComparators.greaterThanOrEqual.name: 'minSize',
  VxNumberComparators.equalTo.name: 'eqSize',
  VxNumberComparators.notEqualTo.name: 'neqSize',
};

/// Validates that a list size meets a specified comparison threshold obtained from the options.
class VxListRule<MSG, W> extends VxBaseRule<MSG> {
  final VxNumberComparator lengthComparator;
  final VxStringParser<List<W>> stringParser;
  final String name;
  final ExMetricStoreHolder metricStoreHolder;
  final VxBaseValidator<MSG, W> itemValidator;
  final VxMatchingMessages areSuccessfulMessages;
  final List<VxMessageProducer<MSG, String>>? successProducer;
  final List<VxMessageProducer<MSG, String>>? failureProducer;
  final VxComponentManagerConfig componentManagerConfig;
  final VxOptionsInventory optionsInventory;
  late VxOptionsMap optionsMap;
  late int thresholdKey;

  VxListRule({
    required this.name,
    required this.metricStoreHolder,
    required this.lengthComparator,
    required this.optionsInventory,
    required this.stringParser,
    required this.itemValidator,
    required this.areSuccessfulMessages,
    this.componentManagerConfig = VxComponentManagerConfig.defaultConfig,
    this.successProducer,
    this.failureProducer,
  }) {
    optionsMap = VxOptionsMap(
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        ownerClassName: 'VxListRule',
        classSpecialisation: lengthComparator.name.replaceAll(' ', '-'),
        componentManagerConfig: componentManagerConfig);
    thresholdKey = optionsInventory.addKey(
        VxComponentNameManager.getFullOptionKey(name,
            _numberDefaultListName[lengthComparator.name] ?? 'listThreshold'),
        [VxOptionsInventoryDescriptors.numeric]);
  }

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final List<W>? parsedValue = stringParser.parseString(value);
    if (parsedValue == null) {
      return failureProducer!
          .map((prod) => prod.produce(options, value))
          .toList();
    }
    final thresholdNum = optionsMap
        .getInt(
            options: options,
            id: thresholdKey,
            defaultValue: _numberDefaultListSize[lengthComparator.name] ?? 0)
        .value;

    return _evaluate(parsedValue, thresholdNum, options, value);
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

  List<MSG> _evaluate(List<W> values, int threshold,
      Map<String, String> options, String value) {
    if (lengthComparator.compare(values.length, threshold)) {
      if (successProducer != null) {
        List<MSG> itemMessages = [];
        for (var itemValue in values) {
          itemMessages += itemValidator.validate(options, itemValue);
        }
        return areSuccessfulMessages.isMatching(itemMessages)
            ? _produceSuccess(options, value)
            : itemMessages;
      }
    } else {
      if (failureProducer != null) {
        return _produceFailure(options, value);
      }
    }
    return [];
  }
}

/// A static class providing methods to instantiate various string list validation rules.
class VxListRules {
  /// Instantiates a [VxListRule] that validates that the number of elements in a list is greater than a threshold.
  static VxListRule<MSG, W> greaterThan<MSG, W>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      required VxStringParser<List<W>> stringParser,
      required VxBaseValidator<MSG, W> itemValidator,
      required VxMatchingMessages areSuccessfulMessages,
      List<VxMessageProducer<MSG, String>>? successProducer,
      List<VxMessageProducer<MSG, String>>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxListRule<MSG, W>(
        name: name,
        lengthComparator: VxNumberComparators.greaterThan,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        stringParser: stringParser,
        itemValidator: itemValidator,
        areSuccessfulMessages: areSuccessfulMessages,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  /// Instantiates a [VxListRule] that validates that the number of elements in a list is greater than or equal a threshold.
  static VxListRule<MSG, W> greaterThanOrEqual<MSG, W>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      required VxStringParser<List<W>> stringParser,
      required VxBaseValidator<MSG, W> itemValidator,
      required VxMatchingMessages areSuccessfulMessages,
      List<VxMessageProducer<MSG, String>>? successProducer,
      List<VxMessageProducer<MSG, String>>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxListRule<MSG, W>(
        name: name,
        lengthComparator: VxNumberComparators.greaterThanOrEqual,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        stringParser: stringParser,
        itemValidator: itemValidator,
        areSuccessfulMessages: areSuccessfulMessages,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  /// Instantiates a [VxListRule] that validates that the number of elements in a list is less than a threshold.
  static VxListRule<MSG, W> lessThan<MSG, W>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      required VxStringParser<List<W>> stringParser,
      required VxBaseValidator<MSG, W> itemValidator,
      required VxMatchingMessages areSuccessfulMessages,
      List<VxMessageProducer<MSG, String>>? successProducer,
      List<VxMessageProducer<MSG, String>>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxListRule<MSG, W>(
        name: name,
        lengthComparator: VxNumberComparators.lessThan,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        stringParser: stringParser,
        itemValidator: itemValidator,
        areSuccessfulMessages: areSuccessfulMessages,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  /// Instantiates a [VxListRule] that validates that the number of elements in a list is less than or equal to a threshold.
  static VxListRule<MSG, W> lessThanOrEqual<MSG, W>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      required VxStringParser<List<W>> stringParser,
      required VxBaseValidator<MSG, W> itemValidator,
      required VxMatchingMessages areSuccessfulMessages,
      List<VxMessageProducer<MSG, String>>? successProducer,
      List<VxMessageProducer<MSG, String>>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxListRule<MSG, W>(
        name: name,
        lengthComparator: VxNumberComparators.lessThanOrEqual,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        stringParser: stringParser,
        itemValidator: itemValidator,
        areSuccessfulMessages: areSuccessfulMessages,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  /// Instantiates a [VxListRule] that validates that the number of elements in a list is equal to a threshold.
  static VxListRule<MSG, W> equalTo<MSG, W>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      required VxStringParser<List<W>> stringParser,
      required VxBaseValidator<MSG, W> itemValidator,
      required VxMatchingMessages areSuccessfulMessages,
      List<VxMessageProducer<MSG, String>>? successProducer,
      List<VxMessageProducer<MSG, String>>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxListRule<MSG, W>(
        name: name,
        lengthComparator: VxNumberComparators.equalTo,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        stringParser: stringParser,
        itemValidator: itemValidator,
        areSuccessfulMessages: areSuccessfulMessages,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }
}
