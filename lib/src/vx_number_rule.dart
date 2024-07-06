import 'package:eagleyeix/metric.dart';

import 'vx_metrics.dart';
import 'vx_model.dart';
import 'vx_number_comparator.dart';

/// Validates that a number meets a specified comparison threshold obtained from the options.
class VxNumberRule<MSG> extends VxBaseValidator<MSG, num> {
  final VxNumberComparator numberComparator;
  final String name;
  final ExMetricStoreHolder metricStoreHolder;
  final VxMessageProducer<MSG, num>? successProducer;
  final VxMessageProducer<MSG, num>? failureProducer;
  final num defaultThreshold;

  VxNumberRule(
    this.name,
    this.metricStoreHolder,
    this.numberComparator,
    this.defaultThreshold, {
    this.successProducer,
    this.failureProducer,
  });

  @override
  List<MSG> validate(Map<String, String> options, num value) {
    final thresholdKey = '$name-threshold';
    final threshold = num.tryParse(options[thresholdKey] ?? '');

    if (!options.containsKey(thresholdKey)) {
      metricStoreHolder.store.addMetric(
          VxMetrics.getNumberThresholdKeyNotFound(numberComparator.name, name),
          1);
      return _evaluate(value, defaultThreshold, options);
    }

    if (threshold == null) {
      metricStoreHolder.store.addMetric(
          VxMetrics.getNumberThresholdKeyInvalid(numberComparator.name, name),
          1);
      return _evaluate(value, defaultThreshold, options);
    }

    return _evaluate(value, threshold, options);
  }

  List<MSG> _evaluate(num value, num threshold, Map<String, String> options) {
    if (numberComparator.compare(value, threshold)) {
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

/// Validates that a number is a multiple of a specified value obtained from the options.
class VxNumberMultipleOf<MSG> extends VxBaseValidator<MSG, num> {
  final String name;
  final ExMetricStoreHolder metricStoreHolder;
  final VxMessageProducer<MSG, num>? successProducer;
  final VxMessageProducer<MSG, num>? failureProducer;
  final num defaultMultipleOf;

  VxNumberMultipleOf(
    this.name,
    this.metricStoreHolder,
    this.defaultMultipleOf, {
    this.successProducer,
    this.failureProducer,
  });

  @override
  List<MSG> validate(Map<String, String> options, num value) {
    final multipleOfKey = '$name-multipleOf';
    final multipleOf = num.tryParse(options[multipleOfKey] ?? '');

    if (!options.containsKey(multipleOfKey)) {
      metricStoreHolder.store.addMetric(
          VxMetrics.getNumberMultipleOfKeyNotFound('VxNumberMultipleOf', name),
          1);
      return _evaluate(value, defaultMultipleOf, options);
    }

    if (multipleOf == null) {
      metricStoreHolder.store.addMetric(
          VxMetrics.getNumberMultipleOfKeyInvalid('VxNumberMultipleOf', name),
          1);
      return _evaluate(value, defaultMultipleOf, options);
    }

    return _evaluate(value, multipleOf, options);
  }

  List<MSG> _evaluate(num value, num multipleOf, Map<String, String> options) {
    if (value % multipleOf == 0) {
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

/// A static class providing methods to instantiate various number validation rules.
class VxNumberRules {
  static VxNumberRule<MSG> greaterThan<MSG>(
    String name,
    ExMetricStoreHolder metricStoreHolder,
    num defaultThreshold, {
    VxMessageProducer<MSG, num>? successProducer,
    VxMessageProducer<MSG, num>? failureProducer,
  }) {
    return VxNumberRule<MSG>(
      name,
      metricStoreHolder,
      VxNumberComparators.greaterThan,
      defaultThreshold,
      successProducer: successProducer,
      failureProducer: failureProducer,
    );
  }

  static VxNumberRule<MSG> greaterThanOrEqual<MSG>(
    String name,
    ExMetricStoreHolder metricStoreHolder,
    num defaultThreshold, {
    VxMessageProducer<MSG, num>? successProducer,
    VxMessageProducer<MSG, num>? failureProducer,
  }) {
    return VxNumberRule<MSG>(
      name,
      metricStoreHolder,
      VxNumberComparators.greaterThanOrEqual,
      defaultThreshold,
      successProducer: successProducer,
      failureProducer: failureProducer,
    );
  }

  static VxNumberRule<MSG> lessThan<MSG>(
    String name,
    ExMetricStoreHolder metricStoreHolder,
    num defaultThreshold, {
    VxMessageProducer<MSG, num>? successProducer,
    VxMessageProducer<MSG, num>? failureProducer,
  }) {
    return VxNumberRule<MSG>(
      name,
      metricStoreHolder,
      VxNumberComparators.lessThan,
      defaultThreshold,
      successProducer: successProducer,
      failureProducer: failureProducer,
    );
  }

  static VxNumberRule<MSG> lessThanOrEqual<MSG>(
    String name,
    ExMetricStoreHolder metricStoreHolder,
    num defaultThreshold, {
    VxMessageProducer<MSG, num>? successProducer,
    VxMessageProducer<MSG, num>? failureProducer,
  }) {
    return VxNumberRule<MSG>(
      name,
      metricStoreHolder,
      VxNumberComparators.lessThanOrEqual,
      defaultThreshold,
      successProducer: successProducer,
      failureProducer: failureProducer,
    );
  }

  static VxNumberRule<MSG> equalTo<MSG>(
    String name,
    ExMetricStoreHolder metricStoreHolder,
    num defaultThreshold, {
    VxMessageProducer<MSG, num>? successProducer,
    VxMessageProducer<MSG, num>? failureProducer,
  }) {
    return VxNumberRule<MSG>(
      name,
      metricStoreHolder,
      VxNumberComparators.equalTo,
      defaultThreshold,
      successProducer: successProducer,
      failureProducer: failureProducer,
    );
  }

  static VxNumberRule<MSG> notEqualTo<MSG>(
    String name,
    ExMetricStoreHolder metricStoreHolder,
    num defaultThreshold, {
    VxMessageProducer<MSG, num>? successProducer,
    VxMessageProducer<MSG, num>? failureProducer,
  }) {
    return VxNumberRule<MSG>(
      name,
      metricStoreHolder,
      VxNumberComparators.notEqualTo,
      defaultThreshold,
      successProducer: successProducer,
      failureProducer: failureProducer,
    );
  }

  static VxNumberMultipleOf<MSG> multipleOf<MSG>(
    String name,
    ExMetricStoreHolder metricStoreHolder,
    num defaultMultipleOf, {
    VxMessageProducer<MSG, num>? successProducer,
    VxMessageProducer<MSG, num>? failureProducer,
  }) {
    return VxNumberMultipleOf<MSG>(
      name,
      metricStoreHolder,
      defaultMultipleOf,
      successProducer: successProducer,
      failureProducer: failureProducer,
    );
  }
}
