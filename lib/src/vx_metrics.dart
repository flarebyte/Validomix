import 'package:eagleyeix/metric.dart';

/// A static factory for metrics for the Validomix package.
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

  static ExMetricKey getKeyNotFound(
      {required String className,
      required String name,
      String? specialisation}) {
    final maybeSpecialisation =
        specialisation == null ? {} : {'class-specialisation': specialisation};
    return ExMetricKey(name: [
      'get-option-value'
    ], dimensions: {
      ...lib,
      'class': className,
      ...maybeSpecialisation,
      'method': 'validate',
      'name': name,
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimStatus.key: ExMetricDimStatus.notFound,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getKeyValueBlank(
      {required String className,
      required String name,
      String? specialisation}) {
    final maybeSpecialisation =
        specialisation == null ? {} : {'class-specialisation': specialisation};
    return ExMetricKey(name: [
      'get-option-value'
    ], dimensions: {
      ...lib,
      'class': className,
      ...maybeSpecialisation,
      'method': 'validate',
      'name': name,
      'expected': 'not-blank',
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimDartErr.key: ExMetricDimDartErr.formatException,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getKeyValueNotInt(
      {required String className,
      required String name,
      String? specialisation}) {
    final maybeSpecialisation =
        specialisation == null ? {} : {'class-specialisation': specialisation};
    return ExMetricKey(name: [
      'get-option-value'
    ], dimensions: {
      ...lib,
      'class': className,
      ...maybeSpecialisation,
      'method': 'validate',
      'name': name,
      'expected': 'integer',
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimDartErr.key: ExMetricDimDartErr.formatException,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getKeyValueNotInDeclaration(
      {required String className,
      required String name,
      required String expected,
      String? specialisation}) {
    final maybeSpecialisation =
        specialisation == null ? {} : {'class-specialisation': specialisation};
    return ExMetricKey(name: [
      'get-option-value'
    ], dimensions: {
      ...lib,
      'class': className,
      ...maybeSpecialisation,
      'method': 'validate',
      'name': name,
      'expected': expected,
      "problem": 'not-in-declaration',
      ExMetricDimLevel.key: ExMetricDimLevel.warn,
      ExMetricDimDartErr.key: ExMetricDimDartErr.formatException,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getKeyValueNotNum(
      {required String className,
      required String name,
      String? specialisation}) {
    final maybeSpecialisation =
        specialisation == null ? {} : {'class-specialisation': specialisation};
    return ExMetricKey(name: [
      'get-option-value'
    ], dimensions: {
      ...lib,
      'class': className,
      ...maybeSpecialisation,
      'method': 'validate',
      'name': name,
      'expected': 'numeric',
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimDartErr.key: ExMetricDimDartErr.formatException,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getKeyValueNotBool(
      {required String className,
      required String name,
      String? specialisation}) {
    final maybeSpecialisation =
        specialisation == null ? {} : {'class-specialisation': specialisation};
    return ExMetricKey(name: [
      'get-option-value'
    ], dimensions: {
      ...lib,
      'class': className,
      ...maybeSpecialisation,
      'method': 'validate',
      'name': name,
      'expected': 'boolean',
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimDartErr.key: ExMetricDimDartErr.formatException,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }

  static ExMetricKey getKeyValueNotPositive(
      {required String className,
      required String name,
      String? specialisation}) {
    final maybeSpecialisation =
        specialisation == null ? {} : {'class-specialisation': specialisation};
    return ExMetricKey(name: [
      'get-option-value'
    ], dimensions: {
      ...lib,
      'class': className,
      ...maybeSpecialisation,
      'method': 'validate',
      'name': name,
      'expected': 'positive number',
      ExMetricDimLevel.key: ExMetricDimLevel.error,
      ExMetricDimDartErr.key: ExMetricDimDartErr.formatException,
      ExMetricDimUnit.key: ExMetricDimUnit.count
    });
  }
}
