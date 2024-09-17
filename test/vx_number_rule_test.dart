import 'package:eagleyeix/metric.dart';
import 'package:test/test.dart';
import 'package:validomix/validomix.dart';

void main() {
  group('VxNumberRules - greaterThan', () {
    final successProducer = MySuccessProducer();
    final failureProducer = MyFailureProducer();
    late ExMetricStoreHolder metricStoreHolder;
    late VxNumberRule<String> rule;
    late VxOptionsInventory optionsInventory;

    setUp(() {
      metricStoreHolder = ExMetricStoreHolder();
      optionsInventory = VxOptionsInventory();
      rule = VxNumberRules.greaterThan<String>(
          name: 'example',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
          successProducers: [successProducer],
          failureProducers: [failureProducer]);
    });

    test('value is greater than threshold', () {
      final options = {'example#minNum': '15'};
      final result = rule.validate(options, 20);
      expect(result, ['Success: 20 is valid.']);
    });

    test('value is equal to threshold', () {
      final options = {'example#minNum': '15'};
      final result = rule.validate(options, 15);
      expect(result, ['Failure: 15 is not valid.']);
    });

    test('value is less than threshold', () {
      final options = {'example#minNum': '15'};
      final result = rule.validate(options, 10);
      expect(result, ['Failure: 10 is not valid.']);
    });

    test('threshold key not found in options', () {
      final result = rule.validate({}, 20);
      expect(result, ['Success: 20 is valid.']);
      final count = ExMetricAggregations.count();
      final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

      expect(aggregatedMetrics.first.toJson(), {
        'key': {
          'name': ['get-option-value'],
          'dimensions': {
            'package': 'validomix',
            'class': 'VxNumberRule',
            'class-specialisation': 'greater-than',
            'method': 'validate',
            'name': 'example#minNum',
            'level': 'ERROR',
            'status': 'not-found',
            'unit': 'count',
            'aggregation': 'count'
          }
        },
        'value': 1.0
      });
    });

    test('threshold key is invalid in options', () {
      final options = {'example#minNum': 'invalid'};
      final result = rule.validate(options, 20);
      expect(result, ['Success: 20 is valid.']);
      final count = ExMetricAggregations.count();
      final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

      expect(aggregatedMetrics.first.toJson(), {
        'key': {
          'name': ['get-option-value'],
          'dimensions': {
            'package': 'validomix',
            'class': 'VxNumberRule',
            'class-specialisation': 'greater-than',
            'method': 'validate',
            'name': 'example#minNum',
            'expected': 'integer',
            'level': 'ERROR',
            'error': 'format-exception',
            'unit': 'count',
            'aggregation': 'count'
          }
        },
        'value': 1.0
      });
    });

    test('edge case: value just above threshold', () {
      final options = {'example#minNum': '15'};
      final result = rule.validate(options, 15.01);
      expect(metricStoreHolder.store.length, 0);
      expect(result, ['Success: 15.01 is valid.']);
    });

    test('edge case: value just below threshold', () {
      final options = {'example#minNum': '15'};
      final result = rule.validate(options, 14.99);
      expect(metricStoreHolder.store.length, 0);
      expect(result, ['Failure: 14.99 is not valid.']);
    });

    test('edge case: negative numbers', () {
      final options = {'example#minNum': '-5'};
      final result = rule.validate(options, -3);
      expect(metricStoreHolder.store.length, 0);
      expect(result, ['Success: -3 is valid.']);
    });

    test('edge case: zero value', () {
      final options = {'example#minNum': '0'};
      final result = rule.validate(options, 0);
      expect(result, ['Failure: 0 is not valid.']);
    });

    test('edge case: large numbers', () {
      final options = {'example#minNum': '1000000000'};
      final result = rule.validate(options, 1000000001);
      expect(result, ['Success: 1000000001 is valid.']);
    });

    test('edge case: decimal values', () {
      final options = {'example#minNum': '0.1'};
      final result = rule.validate(options, 0.2);
      expect(result, ['Success: 0.2 is valid.']);
    });
  });

  group('VxNumberRules - other comparators', () {
    final successProducer = MySuccessProducer();
    final failureProducer = MyFailureProducer();
    late ExMetricStoreHolder metricStoreHolder;
    late VxOptionsInventory optionsInventory;

    setUp(() {
      metricStoreHolder = ExMetricStoreHolder();
      optionsInventory = VxOptionsInventory();
    });
    test('greaterThanOrEqual - value is greater than or equal to threshold',
        () {
      final rule = VxNumberRules.greaterThanOrEqual<String>(
          name: 'example',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
          successProducers: [successProducer],
          failureProducers: [failureProducer]);
      final options = {'example#minNum': '15'};
      final result = rule.validate(options, 15);
      expect(result, ['Success: 15 is valid.']);
    });

    test('lessThan - value is less than threshold', () {
      final rule = VxNumberRules.lessThan<String>(
          name: 'example',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
          successProducers: [successProducer],
          failureProducers: [failureProducer]);
      final options = {'example#maxNum': '15'};
      final result = rule.validate(options, 10);
      expect(result, ['Success: 10 is valid.']);
    });

    test('lessThanOrEqual - value is less than or equal to threshold', () {
      final rule = VxNumberRules.lessThanOrEqual<String>(
          name: 'example',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
          successProducers: [successProducer],
          failureProducers: [failureProducer]);
      final options = {'example#maxNum': '15'};
      final result = rule.validate(options, 15);
      expect(result, ['Success: 15 is valid.']);
    });

    test('equalTo - value is equal to threshold', () {
      final rule = VxNumberRules.equalTo<String>(
          name: 'example',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
          successProducers: [successProducer],
          failureProducers: [failureProducer]);
      final options = {'example#eqNum': '15'};
      final result = rule.validate(options, 15);
      expect(result, ['Success: 15 is valid.']);
    });

    test('notEqualTo - value is not equal to threshold', () {
      final rule = VxNumberRules.notEqualTo<String>(
          name: 'example',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
          successProducers: [successProducer],
          failureProducers: [failureProducer]);
      final options = {'example#neqNum': '15'};
      final result = rule.validate(options, 10);
      expect(result, ['Success: 10 is valid.']);
    });
  });

  group('VxNumberRules - multipleOf', () {
    final successProducer = MySuccessProducer();
    final failureProducer = MyFailureProducer();

    late ExMetricStoreHolder metricStoreHolder;
    late VxOptionsInventory optionsInventory;
    late VxNumberMultipleOf rule;

    setUp(() {
      metricStoreHolder = ExMetricStoreHolder();
      optionsInventory = VxOptionsInventory();
      rule = VxNumberRules.multipleOf<String>(
          name: 'example',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
          successProducers: [successProducer],
          failureProducers: [failureProducer]);
    });

    test('value is multiple of specified number', () {
      final options = {'example#multipleOf': '3'};
      final result = rule.validate(options, 9);
      expect(result, ['Success: 9 is valid.']);
    });

    test('value is not a multiple of specified number', () {
      final options = {'example#multipleOf': '4'};
      final result = rule.validate(options, 9);
      expect(result, ['Failure: 9 is not valid.']);
    });

    test('multipleOf key not found in options', () {
      final result = rule.validate({}, 10);
      expect(result, ['Success: 10 is valid.']);
      final count = ExMetricAggregations.count();
      final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

      expect(aggregatedMetrics.first.toJson(), {
        'key': {
          'name': ['get-option-value'],
          'dimensions': {
            'package': 'validomix',
            'class': 'VxNumberMultipleOf',
            'method': 'validate',
            'name': 'example#multipleOf',
            'level': 'ERROR',
            'status': 'not-found',
            'unit': 'count',
            'aggregation': 'count'
          }
        },
        'value': 1.0
      });
    });

    test('multipleOf key is invalid in options', () {
      final options = {'example#multipleOf': 'invalid'};
      final result = rule.validate(options, 10);
      expect(result, ['Success: 10 is valid.']);
      final count = ExMetricAggregations.count();
      final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

      expect(aggregatedMetrics.first.toJson(), {
        'key': {
          'name': ['get-option-value'],
          'dimensions': {
            'package': 'validomix',
            'class': 'VxNumberMultipleOf',
            'method': 'validate',
            'name': 'example#multipleOf',
            'expected': 'integer',
            'level': 'ERROR',
            'error': 'format-exception',
            'unit': 'count',
            'aggregation': 'count'
          }
        },
        'value': 1.0
      });
    });

    test('edge case: value is zero', () {
      final options = {'example#multipleOf': '3'};
      final result = rule.validate(options, 0);
      expect(result, ['Success: 0 is valid.']);
    });

    test('edge case: negative numbers', () {
      final options = {'example#multipleOf': '3'};
      final result = rule.validate(options, -9);
      expect(result, ['Success: -9 is valid.']);
    });

    test('edge case: large numbers', () {
      final options = {'example#multipleOf': '1000000'};
      final result = rule.validate(options, 10000000);
      expect(result, ['Success: 10000000 is valid.']);
    });

    test('edge case: decimal values (not a multiple)', () {
      final options = {'example#multipleOf': '0.1'};
      final result = rule.validate(options, 0.15);
      expect(result, ['Failure: 0.15 is not valid.']);
    });

    test('edge case: decimal values (is a multiple)', () {
      final options = {'example#multipleOf': '0.1'};
      final result = rule.validate(options, 0.2);
      expect(result, ['Success: 0.2 is valid.']);
    });
  });
}

class MySuccessProducer implements VxMessageProducer<String, num> {
  @override
  String produce(Map<String, String> options, num value) {
    return 'Success: $value is valid.';
  }
}

class MyFailureProducer implements VxMessageProducer<String, num> {
  @override
  String produce(Map<String, String> options, num value) {
    return 'Failure: $value is not valid.';
  }
}
