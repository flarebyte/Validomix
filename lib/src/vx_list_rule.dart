


import 'package:eagleyeix/metric.dart';

import 'vx_metrics.dart';
import 'vx_model.dart';

class VxListRuleMetricHandler {
  // see https://github.com/flarebyte/eagleyeix
  final ExMetricStoreHolder metricStoreHolder;
  final VxIterableLengthComparator lenthComparator;
  final String ruleName;

  VxListRuleMetricHandler({required this.metricStoreHolder, required this.lenthComparator, required this.ruleName });

  int getLimit(Map<String, String> options, int defaultLimit) {
    final limitKey = '$ruleName-threshold';
    final limit = int.tryParse(options[limitKey] ?? '');

    if (!options.containsKey(limitKey)) {
      metricStoreHolder.store.addMetric(
          VxMetrics.getNumberThresholdKeyNotFound(lenthComparator.name, ruleName),
          1);
      return defaultLimit;
    }

    if (limit == null) {
     metricStoreHolder.store.addMetric(
          VxMetrics.getNumberThresholdKeyInvalid(lenthComparator.name, ruleName),
          1);
      return defaultLimit;
    }

    return limit;
  }
}

//TODO

/// Validates that a number meets a specified comparison threshold obtained from the options.
class VxListRule<MSG, V> extends VxBaseValidator<MSG, V> {
  final VxIterableLengthComparator lengthComparator;
}