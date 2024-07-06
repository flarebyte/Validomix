import 'package:eagleyeix/metric.dart';
import 'package:test/test.dart';
import 'package:validomix/validomix.dart';

class SimpleMessageProducer implements VxMessageProducer<String, String> {
  final String message;
  SimpleMessageProducer(this.message);
  @override
  String produce(Map<String, String> options, String value) => message;
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
            'test', metricStoreHolder, 10,
            successProducer: successProducer, failureProducer: failureProducer);
        expect(rule.validate({}, 'short'), ['Success: Condition met.']);
        expect(rule.validate({}, 'this is a long string'),
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
  });
}
