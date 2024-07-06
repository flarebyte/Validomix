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

  static ExMetricKey getMaxCharsKeyNotFound(String name) {
    return ExMetricKey(name: [
      'get-max-chars'
    ], dimensions: {
      ...lib,
      'class': 'VxCharsLessThanRule',
      'method': 'validate',
      'name': name,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimStatus.key: ExMetricDimStatus.notFound,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getMaxCharsKeyInvalid(String name) {
    return ExMetricKey(name: [
      'get-max-chars'
    ], dimensions: {
      ...lib,
      'class': 'VxCharsLessThanRule',
      'method': 'validate',
      'name': name,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimDartErr.key: ExMetricDimDartErr.formatException,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getMinCharsKeyNotFound(String name) {
    return ExMetricKey(name: [
      'get-min-chars'
    ], dimensions: {
      ...lib,
      'class': 'VxCharsMoreThanRule',
      'method': 'validate',
      'name': name,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimStatus.key: ExMetricDimStatus.notFound,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getMinCharsKeyInvalid(String name) {
    return ExMetricKey(name: [
      'get-min-chars'
    ], dimensions: {
      ...lib,
      'class': 'VxCharsMoreThanRule',
      'method': 'validate',
      'name': name,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimDartErr.key: ExMetricDimDartErr.formatException,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getMaxWordsKeyNotFound(String name) {
    return ExMetricKey(name: [
      'get-max-words'
    ], dimensions: {
      ...lib,
      'class': 'VxWordsLessThanRule',
      'method': 'validate',
      'name': name,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimStatus.key: ExMetricDimStatus.notFound,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getMaxWordsKeyInvalid(String name) {
    return ExMetricKey(name: [
      'get-max-words'
    ], dimensions: {
      ...lib,
      'class': 'VxWordsLessThanRule',
      'method': 'validate',
      'name': name,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimDartErr.key: ExMetricDimDartErr.formatException,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getMinWordsKeyNotFound(String name) {
    return ExMetricKey(name: [
      'get-min-words'
    ], dimensions: {
      ...lib,
      'class': 'VxWordsMoreThanOrEqualRule',
      'method': 'validate',
      'name': name,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimStatus.key: ExMetricDimStatus.notFound,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getMinWordsKeyInvalid(String name) {
    return ExMetricKey(name: [
      'get-min-words'
    ], dimensions: {
      ...lib,
      'class': 'VxWordsMoreThanOrEqualRule',
      'method': 'validate',
      'name': name,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimDartErr.key: ExMetricDimDartErr.formatException,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }
}
