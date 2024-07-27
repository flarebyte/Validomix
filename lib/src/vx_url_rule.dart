import 'package:eagleyeix/metric.dart';

import '../validomix.dart';

/// Validates that the number of characters in a string is less than a specified limit obtained from the options.
class VxUrlRule<MSG> extends VxBaseRule<MSG> {
  final VxMessageProducer<MSG, String>? successProducer;
  final VxMessageProducer<MSG, String>? failureProducer;
  final String name;
  final ExMetricStoreHolder metricStoreHolder;
  final VxComponentManagerConfig componentManagerConfig;
  final VxOptionsInventory optionsInventory;
  late VxOptionsMap optionsMap;
  late int allowFragmentKey;
  late int allowQueryKey;
  late int allowDomainsKey;

  VxUrlRule(
      {required this.name,
      required this.metricStoreHolder,
      required this.optionsInventory,
      this.successProducer,
      this.failureProducer,
      this.componentManagerConfig = VxComponentManagerConfig.defaultConfig}) {
    optionsMap = VxOptionsMap(
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        ownerClassName: 'VxUrlRule',
        componentManagerConfig: componentManagerConfig);
    allowQueryKey = optionsInventory.addKey(
        VxComponentNameManager.getFullOptionKey(name, 'allowFragment',
            optional: true),
        [VxOptionsInventoryDescriptors.boolean]);
    allowFragmentKey = optionsInventory.addKey(
        VxComponentNameManager.getFullOptionKey(name, 'allowQuery',
            optional: true),
        [VxOptionsInventoryDescriptors.boolean]);
    allowDomainsKey = optionsInventory.addKey(
        VxComponentNameManager.getFullOptionKey(name, 'allowDomains',
            optional: true),
        VxOptionsInventoryDescriptors.stringList);
  }

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final uri = Uri.tryParse(value);

    if (uri == null) {
      return [failureProducer!.produce(options, value)];
    }
    if (!(uri.isScheme('http') || uri.isScheme('https'))) {
      return [failureProducer!.produce(options, value)];
    }
    if (uri.hasPort) {
      return [failureProducer!.produce(options, value)];
    }
    if (uri.userInfo.isNotEmpty) {
      return [failureProducer!.produce(options, value)];
    }
    final allowFragment = optionsMap
        .getBoolean(options: options, id: allowFragmentKey, defaultValue: false)
        .value;
    if (!allowFragment && uri.hasFragment) {
      return [failureProducer!.produce(options, value)];
    }
    final allowQuery = optionsMap
        .getBoolean(options: options, id: allowQueryKey, defaultValue: false)
        .value;
    if (!allowQuery && uri.hasQuery) {
      return [failureProducer!.produce(options, value)];
    }
    final allowDomains =
        optionsMap.getStringList(options: options, id: allowDomainsKey).value;

    return [successProducer!.produce(options, value)];
  }
}
