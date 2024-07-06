import 'package:eagleyeix/metric.dart';
import 'package:test/test.dart';
import 'package:validomix/validomix.dart';

class SimpleMessageProducer implements VxMessageProducer<String, String> {
  final String message;
  SimpleMessageProducer(this.message);
  @override
  String produce(Map<String, String> options, String value) => message;
}

String createString(int n) {
  return List.generate(n, (index) => 'X').join();
}

void main() {
  group('VxStringRules', () {
    final successProducer = SimpleMessageProducer('Success: Condition met.');
    final failureProducer =
        SimpleMessageProducer('Failure: Condition not met.');
    late ExMetricStoreHolder metricStoreHolder;

    setUp(() {
      metricStoreHolder = ExMetricStoreHolder();
    });

    group('VxCharsLessThanRule', () {
      test('validate with producers', () {
        final rule = VxStringRules.charsLessThan<String>(
            'test', metricStoreHolder, 1,
            successProducer: successProducer, failureProducer: failureProducer);
        expect(rule.validate({'test-maxChars': "10"}, 'short'),
            ['Success: Condition met.']);
        expect(rule.validate({'test-maxChars': "10"}, 'this is a long string'),
            ['Failure: Condition not met.']);
      });

      test('validate without producers', () {
        final ruleWithoutProducers =
            VxStringRules.charsLessThan<String>('test', metricStoreHolder, 10);
        expect(ruleWithoutProducers.validate({}, 'short'), []);
        expect(ruleWithoutProducers.validate({}, 'this is a long string'), []);
      });

      test('KeyNotFound metric logging', () {
        final ruleWithoutProducers =
            VxStringRules.charsLessThan<String>('test', metricStoreHolder, 10);
        ruleWithoutProducers.validate({}, 'this is a long string');

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-max-chars'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxCharsLessThanRule',
              'method': 'validate',
              'name': 'test',
              'level': 'ERROR',
              'status': 'not-found',
              'unit': 'count',
              'aggregation': 'count'
            }
          },
          'value': 1.0
        });
      });
      test('KeyInvalid metric logging', () {
        final ruleWithoutProducers =
            VxStringRules.charsLessThan<String>('test', metricStoreHolder, 10);
        ruleWithoutProducers
            .validate({'test-maxChars': 'invalid'}, 'this is a long string');

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-max-chars'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxCharsLessThanRule',
              'method': 'validate',
              'name': 'test',
              'level': 'ERROR',
              'error': 'format-exception',
              'unit': 'count',
              'aggregation': 'count'
            }
          },
          'value': 1.0
        });
      });
    });
    group('VxCharsLessThanOrEqualRule', () {
      test('validate with producers', () {
        final rule = VxStringRules.charsLessThanOrEqual<String>(
            'test', metricStoreHolder, 1,
            successProducer: successProducer, failureProducer: failureProducer);
        expect(rule.validate({'test-maxChars': "10"}, createString(10)),
            ['Success: Condition met.']);
        expect(
            rule.validate({'test-maxChars': "10"},
                '${createString(10)}this is a long string'),
            ['Failure: Condition not met.']);
      });

      test('validate without producers', () {
        final ruleWithoutProducers = VxStringRules.charsLessThanOrEqual<String>(
            'test', metricStoreHolder, 10);
        expect(ruleWithoutProducers.validate({}, 'short'), []);
        expect(ruleWithoutProducers.validate({}, 'this is a long string'), []);
      });

      test('KeyNotFound metric logging', () {
        final ruleWithoutProducers = VxStringRules.charsLessThanOrEqual<String>(
            'test', metricStoreHolder, 10);
        ruleWithoutProducers.validate({}, 'this is a long string');

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-max-chars'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxCharsLessThanRule',
              'method': 'validate',
              'name': 'test',
              'level': 'ERROR',
              'status': 'not-found',
              'unit': 'count',
              'aggregation': 'count'
            }
          },
          'value': 1.0
        });
      });
      test('KeyInvalid metric logging', () {
        final ruleWithoutProducers = VxStringRules.charsLessThanOrEqual<String>(
            'test', metricStoreHolder, 10);
        ruleWithoutProducers
            .validate({'test-maxChars': 'invalid'}, 'this is a long string');

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-max-chars'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxCharsLessThanRule',
              'method': 'validate',
              'name': 'test',
              'level': 'ERROR',
              'error': 'format-exception',
              'unit': 'count',
              'aggregation': 'count'
            }
          },
          'value': 1.0
        });
      });
    });

    group('VxCharsMoreThanRule', () {
      test('validate with producers', () {
        final rule = VxStringRules.charsMoreThan<String>(
            'test', metricStoreHolder, 10,
            successProducer: successProducer, failureProducer: failureProducer);
        expect(rule.validate({'test-minChars': '10'}, 'this is a long string'),
            ['Success: Condition met.']);
        expect(rule.validate({'test-minChars': '10'}, 'short'),
            ['Failure: Condition not met.']);
      });

      test('validate without producers', () {
        final ruleWithoutProducers =
            VxStringRules.charsMoreThan<String>('test', metricStoreHolder, 10);
        expect(ruleWithoutProducers.validate({}, 'this is a long string'), []);
        expect(ruleWithoutProducers.validate({}, 'short'), []);
      });

      test('KeyNotFound metric logging', () {
        final ruleWithoutProducers =
            VxStringRules.charsMoreThan<String>('test', metricStoreHolder, 10);
        ruleWithoutProducers.validate({}, 'short');

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-min-chars'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxCharsMoreThanRule',
              'method': 'validate',
              'name': 'test',
              'level': 'ERROR',
              'status': 'not-found',
              'unit': 'count',
              'aggregation': 'count'
            }
          },
          'value': 1.0
        });
      });
      test('KeyInvalid metric logging', () {
        final ruleWithoutProducers =
            VxStringRules.charsMoreThan<String>('test', metricStoreHolder, 10);
        ruleWithoutProducers.validate({'test-minChars': 'invalid'}, 'short');

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-min-chars'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxCharsMoreThanRule',
              'method': 'validate',
              'name': 'test',
              'level': 'ERROR',
              'error': 'format-exception',
              'unit': 'count',
              'aggregation': 'count'
            }
          },
          'value': 1.0
        });
      });
    });
    group('VxCharsMoreThanOrEqualRule', () {
      test('validate with producers', () {
        final rule = VxStringRules.charsMoreThanOrEqual<String>(
            'test', metricStoreHolder, 10,
            successProducer: successProducer, failureProducer: failureProducer);
        expect(rule.validate({'test-minChars': '10'}, createString(10)),
            ['Success: Condition met.']);
        expect(rule.validate({'test-minChars': '10'}, 'short'),
            ['Failure: Condition not met.']);
      });

      test('validate without producers', () {
        final ruleWithoutProducers = VxStringRules.charsMoreThanOrEqual<String>(
            'test', metricStoreHolder, 10);
        expect(ruleWithoutProducers.validate({}, 'this is a long string'), []);
        expect(ruleWithoutProducers.validate({}, 'short'), []);
      });

      test('KeyNotFound metric logging', () {
        final ruleWithoutProducers = VxStringRules.charsMoreThanOrEqual<String>(
            'test', metricStoreHolder, 10);
        ruleWithoutProducers.validate({}, 'short');

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-min-chars'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxCharsMoreThanRule',
              'method': 'validate',
              'name': 'test',
              'level': 'ERROR',
              'status': 'not-found',
              'unit': 'count',
              'aggregation': 'count'
            }
          },
          'value': 1.0
        });
      });
      test('KeyInvalid metric logging', () {
        final ruleWithoutProducers = VxStringRules.charsMoreThanOrEqual<String>(
            'test', metricStoreHolder, 10);
        ruleWithoutProducers.validate({'test-minChars': 'invalid'}, 'short');

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-min-chars'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxCharsMoreThanRule',
              'method': 'validate',
              'name': 'test',
              'level': 'ERROR',
              'error': 'format-exception',
              'unit': 'count',
              'aggregation': 'count'
            }
          },
          'value': 1.0
        });
      });
    });
  });
}
