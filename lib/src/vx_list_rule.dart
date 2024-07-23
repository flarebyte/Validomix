import 'package:eagleyeix/metric.dart';

import 'vx_component_name_manager.dart';
import 'vx_metrics.dart';
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
class VxListRule<MSG, W> extends VxBaseRule<MSG> {
  final VxIterableLengthComparator numberComparator;
  final VxStringParser<List<String>> stringParser;
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
    required this.numberComparator,
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
        classSpecialisation: numberComparator.name.replaceAll(' ', '-'),
        componentManagerConfig: componentManagerConfig);
    thresholdKey = optionsInventory.addKey(
        VxComponentNameManager.getFullOptionKey(
            name, numberDefaultName[numberComparator.name] ?? 'listThreshold'),
        [VxOptionsInventoryDescriptors.numeric]);
  }

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final List<String>? parsedValue = stringParser.parseString(value);
    if (parsedValue == null) {
      return [failureProducer!.produce(options, value)];
    }
    final thresholdNum = optionsMap
        .getInt(
            options: options,
            id: thresholdKey,
            defaultValue: numberDefaultSize[numberComparator.name] ?? 0)
        .value;

    return _evaluate(parsedValue, thresholdNum, options);
  }

  List<MSG> _evaluate(List<String> values, int threshold,
      Map<String, String> options, String value) {
    if (numberComparator.compare(values, threshold)) {
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
