import 'package:eagleyeix/metric.dart';

/// A simple example of metrics.
class VxMetrics {
  static final lib = {'package': 'validomix'};

  static ExMetricKey getRuleSetNotFound(String id) {
    return ExMetricKey(name: [
      'get-rule-set'
    ], dimensions: {
      ...lib,
      'method': 'getRuleDefinition',
      'id': id,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimStatus.key: ExMetricDimStatus.notFound,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getRuleDefinitionNotFound(String id) {
    return ExMetricKey(name: [
      'get-rule-definition'
    ], dimensions: {
      ...lib,
      'method': 'getRuleDefinition',
      'id': id,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimStatus.key: ExMetricDimStatus.notFound,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }
}
