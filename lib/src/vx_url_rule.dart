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

  bool _endsWithAnyDomain(String host, List<String> allowedEndings) {
    return allowedEndings.any((ending) => host.endsWith(ending));
  }

  @override
  List<MSG> validate(Map<String, String> options, String value) {
    final uri = Uri.tryParse(value);

    if (uri == null) {
      return _produceFailure(options, value);
    }
    if (!(uri.isScheme('http') || uri.isScheme('https'))) {
      return _produceFailure(options, value);
    }
    if (uri.hasPort) {
      return _produceFailure(options, value);
    }
    if (uri.userInfo.isNotEmpty) {
      return _produceFailure(options, value);
    }
    final allowFragment = optionsMap
        .getBoolean(options: options, id: allowFragmentKey, defaultValue: false)
        .value;
    if (!allowFragment && uri.hasFragment) {
      return _produceFailure(options, value);
    }
    final allowQuery = optionsMap
        .getBoolean(options: options, id: allowQueryKey, defaultValue: false)
        .value;
    if (!allowQuery && uri.hasQuery) {
      return _produceFailure(options, value);
    }
    final allowDomains =
        optionsMap.getStringList(options: options, id: allowDomainsKey).value;
    if (allowDomains.isNotEmpty &&
        !_endsWithAnyDomain(uri.host, allowDomains)) {
      return _produceFailure(options, value);
    }

    return _produceSuccess(options, value);
  }
}
