import 'package:eagleyeix/metric.dart';

import 'vx_component_name_manager.dart';
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
  VxNumberComparators.lessThan.name: 'maxSize',
  VxNumberComparators.lessThanOrEqual.name: 'maxSize',
  VxNumberComparators.greaterThan.name: 'minSize',
  VxNumberComparators.greaterThanOrEqual.name: 'minSize',
  VxNumberComparators.equalTo.name: 'eqSize',
  VxNumberComparators.notEqualTo.name: 'neqSize',
};

/// Validates that a number meets a specified comparison threshold obtained from the options.
class VxListRule<MSG, W> extends VxBaseRule<MSG> {
  final VxNumberComparator lengthComparator;
  final VxStringParser<List<W>> stringParser;
  final String name;
  final ExMetricStoreHolder metricStoreHolder;
  final VxMessageProducer<MSG, String>? successProducer;
  final VxMessageProducer<MSG, String>? failureProducer;
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
        VxComponentNameManager.getFullOptionKey(
            name, numberDefaultName[lengthComparator.name] ?? 'listThreshold'),
        [VxOptionsInventoryDescriptors.numeric]);
  }

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final List<W>? parsedValue = stringParser.parseString(value);
    if (parsedValue == null) {
      return [failureProducer!.produce(options, value)];
    }
    final thresholdNum = optionsMap
        .getInt(
            options: options,
            id: thresholdKey,
            defaultValue: numberDefaultSize[lengthComparator.name] ?? 0)
        .value;

    return _evaluate(parsedValue, thresholdNum, options, value);
  }

  List<MSG> _evaluate(List<W> values, int threshold,
      Map<String, String> options, String value) {
    if (lengthComparator.compare(values.length, threshold)) {
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

/// A static class providing methods to instantiate various string list validation rules.
class VxListRules {
  static VxListRule<MSG, W> greaterThan<MSG, W>(
      {required String name,
      required ExMetricStoreHolder metricStoreHolder,
      required VxOptionsInventory optionsInventory,
      required VxStringParser<List<W>> stringParser,
      VxMessageProducer<MSG, String>? successProducer,
      VxMessageProducer<MSG, String>? failureProducer,
      componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    return VxListRule<MSG, W>(
        name: name,
        lengthComparator: VxNumberComparators.greaterThan,
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        stringParser: stringParser,
        successProducer: successProducer,
        failureProducer: failureProducer,
        componentManagerConfig: componentManagerConfig);
  }
}
