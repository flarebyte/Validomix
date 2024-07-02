import 'package:eagleyeix/metric.dart';

/// A simple example of metrics.
class VxMetrics {
  static final getRuleSetNotFound = ExMetricKey(name: [
    'validomix',
    'getRuleDefinition'
        'get-rule-set'
  ], dimensions: {
    ExMetricDimLevel.key: ExMetricDimLevel.error,
    ExMetricDimStatus.key: ExMetricDimStatus.notFound,
    ExMetricDimUnit.key: ExMetricDimUnit.count
  });
  static final getRuleDefinitionNotFound = ExMetricKey(name: [
    'validomix',
    'getRuleDefinition'
        'get-rule-definition'
  ], dimensions: {
    ExMetricDimLevel.key: ExMetricDimLevel.error,
    ExMetricDimStatus.key: ExMetricDimStatus.notFound,
    ExMetricDimUnit.key: ExMetricDimUnit.count
  });
}
