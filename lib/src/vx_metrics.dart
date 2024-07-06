import 'package:eagleyeix/metric.dart';

/// A simple example of metrics.
class VxMetrics {
  static final lib = {'package': 'validomix'};

  static ExMetricKey getRuleSetNotFound(String id) {
    return ExMetricKey(name: [
      'get-rule-set'
    ], dimensions: {
      ...lib,
      'class': 'VxRuleDefinitionLocator',
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
      'class': 'VxRuleDefinitionLocator',
      'method': 'getRuleDefinition',
      'id': id,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimStatus.key: ExMetricDimStatus.notFound,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getRuleNotFound(String id) {
    return ExMetricKey(name: [
      'get-rule'
    ], dimensions: {
      ...lib,
      'class': 'VxRuleLocator',
      'method': 'getRule',
      'id': id,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimStatus.key: ExMetricDimStatus.notFound,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getMaxCharsKeyNotFound(String className, String name) {
    return ExMetricKey(name: [
      'get-max-chars'
    ], dimensions: {
      ...lib,
      'class': className,
      'method': 'validate',
      'name': name,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimStatus.key: ExMetricDimStatus.notFound,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getMaxCharsKeyInvalid(String className, String name) {
    return ExMetricKey(name: [
      'get-max-chars'
    ], dimensions: {
      ...lib,
      'class': className,
      'method': 'validate',
      'name': name,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimDartErr.key: ExMetricDimDartErr.formatException,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getMinCharsKeyNotFound(String className, String name) {
    return ExMetricKey(name: [
      'get-min-chars'
    ], dimensions: {
      ...lib,
      'class': className,
      'method': 'validate',
      'name': name,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimStatus.key: ExMetricDimStatus.notFound,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getMinCharsKeyInvalid(String className, String name) {
    return ExMetricKey(name: [
      'get-min-chars'
    ], dimensions: {
      ...lib,
      'class': className,
      'method': 'validate',
      'name': name,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimDartErr.key: ExMetricDimDartErr.formatException,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getMaxWordsKeyNotFound(String className, String name) {
    return ExMetricKey(name: [
      'get-max-words'
    ], dimensions: {
      ...lib,
      'class': className,
      'method': 'validate',
      'name': name,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimStatus.key: ExMetricDimStatus.notFound,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getMaxWordsKeyInvalid(String className, String name) {
    return ExMetricKey(name: [
      'get-max-words'
    ], dimensions: {
      ...lib,
      'class': className,
      'method': 'validate',
      'name': name,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimDartErr.key: ExMetricDimDartErr.formatException,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getMinWordsKeyNotFound(String className, String name) {
    return ExMetricKey(name: [
      'get-min-words'
    ], dimensions: {
      ...lib,
      'class': className,
      'method': 'validate',
      'name': name,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimStatus.key: ExMetricDimStatus.notFound,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getMinWordsKeyInvalid(String className, String name) {
    return ExMetricKey(name: [
      'get-min-words'
    ], dimensions: {
      ...lib,
      'class': className,
      'method': 'validate',
      'name': name,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimDartErr.key: ExMetricDimDartErr.formatException,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }
}
