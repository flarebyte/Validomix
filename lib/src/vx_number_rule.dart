import 'package:eagleyeix/metric.dart';
import 'package:validomix/src/vx_component_name_manager.dart';

import 'vx_model.dart';
import 'vx_number_comparator.dart';
import 'vx_options_inventory.dart';
import 'vx_options_map.dart';

/// The default should try to be generous
final numberDefaultSize = {
  VxNumberComparators.lessThan.name: 10000,
  VxNumberComparators.lessThanOrEqual.name: 10000,
  VxNumberComparators.greaterThan.name: 0,
  VxNumberComparators.greaterThanOrEqual.name: 0,
  VxNumberComparators.equalTo.name: 0,
  VxNumberComparators.notEqualTo.name: 0,
};

/// The default name for each comparator
final numberDefaultName = {
  VxNumberComparators.lessThan.name: 'maxNum',
  VxNumberComparators.lessThanOrEqual.name: 'maxNum',
  VxNumberComparators.greaterThan.name: 'minNum',
  VxNumberComparators.greaterThanOrEqual.name: 'minNum',
  VxNumberComparators.equalTo.name: 'eqNum',
  VxNumberComparators.notEqualTo.name: 'neqNum',
};

/// Validates that a number meets a specified comparison threshold obtained from the options.
class VxNumberRule<MSG> extends VxBaseValidator<MSG, num> {
  final VxNumberComparator numberComparator;
  final String name;
  final ExMetricStoreHolder metricStoreHolder;
  final VxMessageProducer<MSG, num>? successProducer;
  final VxMessageProducer<MSG, num>? failureProducer;
  final VxComponentManagerConfig componentManagerConfig;
  final VxOptionsInventory optionsInventory;
  late VxOptionsMap optionsMap;
  late int thresholdKey;

  VxNumberRule({
    required this.name,
    required this.metricStoreHolder,
    required this.numberComparator,
    required this.optionsInventory,
    this.componentManagerConfig = VxComponentManagerConfig.defaultConfig,
    this.successProducer,
    this.failureProducer,
  }) {
    optionsMap = VxOptionsMap(
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        ownerClassName: 'VxNumberRule',
        classSpecialisation: numberComparator.name.replaceAll(' ', '-'),
        componentManagerConfig: componentManagerConfig);
    thresholdKey = optionsInventory.addKey(
        VxComponentNameManager.getFullOptionKey(
            name, numberDefaultName[numberComparator.name] ?? 'thresholdNum'),
        [VxOptionsInventoryDescriptors.numeric]);
  }

  @override
  List<MSG> validate(Map<String, String> options, num value) {
    final thresholdNum = optionsMap
        .getNumber(
            options: options,
            id: thresholdKey,
            defaultValue: numberDefaultSize[numberComparator.name] ?? 0)
        .value;

    return _evaluate(value, thresholdNum, options);
  }

  List<MSG> _produceSuccess(Map<String, String> options, num value) {
    return successProducer == null
        ? []
        : [successProducer!.produce(options, value)];
  }

  List<MSG> _produceFailure(Map<String, String> options, num value) {
    return failureProducer == null
        ? []
        : [failureProducer!.produce(options, value)];
  }

  List<MSG> _evaluate(num value, num threshold, Map<String, String> options) {
    if (numberComparator.compare(value, threshold)) {
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

/// Validates that a number is a multiple of a specified value obtained from the options.
class VxNumberMultipleOf<MSG> extends VxBaseValidator<MSG, num> {
  final String name;
  final ExMetricStoreHolder metricStoreHolder;
  final VxMessageProducer<MSG, num>? successProducer;
  final VxMessageProducer<MSG, num>? failureProducer;
  final VxComponentManagerConfig componentManagerConfig;
  final VxOptionsInventory optionsInventory;
  late VxOptionsMap optionsMap;
  late int nultipleOfKey;
  VxNumberMultipleOf({
    required this.name,
    required this.metricStoreHolder,
    required this.optionsInventory,
    this.componentManagerConfig = VxComponentManagerConfig.defaultConfig,
    this.successProducer,
    this.failureProducer,
  }) {
    optionsMap = VxOptionsMap(
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        ownerClassName: 'VxNumberMultipleOf',
        componentManagerConfig: componentManagerConfig);
    nultipleOfKey = optionsInventory.addKey(
        VxComponentNameManager.getFullOptionKey(name, 'multipleOf'),
        [VxOptionsInventoryDescriptors.numeric]);
  }

  @override
  List<MSG> validate(Map<String, String> options, num value) {
    final multipleOf = optionsMap
        .getNumber(options: options, id: nultipleOfKey, defaultValue: 2)
        .value;

    return _evaluate(value, multipleOf, options);
  }

  List<MSG> _produceSuccess(Map<String, String> options, num value) {
    return successProducer == null
        ? []
        : [successProducer!.produce(options, value)];
  }

  List<MSG> _produceFailure(Map<String, String> options, num value) {
    return failureProducer == null
        ? []
        : [failureProducer!.produce(options, value)];
  }

  List<MSG> _evaluate(num value, num multipleOf, Map<String, String> options) {
    if (value % multipleOf == 0) {
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

/// A static class providing methods to instantiate various number validation rules.
class VxNumberRules {
  static VxNumberRule<MSG> greaterThan<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      VxMessageProducer<MSG, num>? successProducer,
      VxMessageProducer<MSG, num>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxNumberRule<MSG>(
        name: name,
        numberComparator: VxNumberComparators.greaterThan,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  static VxNumberRule<MSG> greaterThanOrEqual<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      VxMessageProducer<MSG, num>? successProducer,
      VxMessageProducer<MSG, num>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxNumberRule<MSG>(
        name: name,
        numberComparator: VxNumberComparators.greaterThanOrEqual,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  static VxNumberRule<MSG> lessThan<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      VxMessageProducer<MSG, num>? successProducer,
      VxMessageProducer<MSG, num>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxNumberRule<MSG>(
        name: name,
        numberComparator: VxNumberComparators.lessThan,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  static VxNumberRule<MSG> lessThanOrEqual<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      VxMessageProducer<MSG, num>? successProducer,
      VxMessageProducer<MSG, num>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxNumberRule<MSG>(
        name: name,
        numberComparator: VxNumberComparators.lessThanOrEqual,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  static VxNumberRule<MSG> equalTo<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      VxMessageProducer<MSG, num>? successProducer,
      VxMessageProducer<MSG, num>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxNumberRule<MSG>(
        name: name,
        numberComparator: VxNumberComparators.equalTo,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  static VxNumberRule<MSG> notEqualTo<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      VxMessageProducer<MSG, num>? successProducer,
      VxMessageProducer<MSG, num>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxNumberRule<MSG>(
        name: name,
        numberComparator: VxNumberComparators.notEqualTo,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }

  static VxNumberMultipleOf<MSG> multipleOf<MSG>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      VxMessageProducer<MSG, num>? successProducer,
      VxMessageProducer<MSG, num>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxNumberMultipleOf<MSG>(
        name: name,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }
}
