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

String createWords(int n) {
  return List.generate(n, (index) => 'word$index').join(' ');
}

void main() {
  group('VxStringRules', () {
    var successMessage = 'Success: Condition met.';
    final successProducer = SimpleMessageProducer(successMessage);
    var failureMessage = 'Failure: Condition not met.';
    final failureProducer = SimpleMessageProducer(failureMessage);
    late ExMetricStoreHolder metricStoreHolder;
    late VxOptionsInventory optionsInventory;

    setUp(() {
      metricStoreHolder = ExMetricStoreHolder();
      optionsInventory = VxOptionsInventory();
    });

    group('VxCharsLessThanRule', () {
      test('validate with producers', () {
        final rule = VxStringRules.charsLessThan<String>(
            name: 'test',
            metricStoreHolder: metricStoreHolder,
            optionsInventory: optionsInventory,
            defaultMaxChars: 1,
            successProducer: successProducer,
            failureProducer: failureProducer);
        expect(rule.validate({'test#thresholdChars': "10"}, 'short'),
            [successMessage]);
        expect(
            rule.validate(
                {'test#thresholdChars': "10"}, 'this is a long string'),
            [failureMessage]);
        expect(optionsInventory.toList().length, 1);
        expect(optionsInventory.toList().first.name, 'test#thresholdChars');
      });

      test('validate without producers', () {
        final ruleWithoutProducers = VxStringRules.charsLessThan<String>(
            name: 'test',
            metricStoreHolder: metricStoreHolder,
            optionsInventory: optionsInventory,
            defaultMaxChars: 10);
        expect(ruleWithoutProducers.validate({}, 'short'), []);
        expect(ruleWithoutProducers.validate({}, 'this is a long string'), []);
        expect(optionsInventory.toList().length, 1);
      });

      test('KeyNotFound metric logging', () {
        final ruleWithoutProducers = VxStringRules.charsLessThan<String>(
            name: 'test',
            metricStoreHolder: metricStoreHolder,
            optionsInventory: optionsInventory,
            defaultMaxChars: 10);
        ruleWithoutProducers.validate({}, 'this is a long string');

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-option-value'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxCharsRule',
              'class-specialisation': 'less-than',
              'method': 'validate',
              'name': 'test#thresholdChars',
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
        final ruleWithoutProducers = VxStringRules.charsLessThan<String>(
            name: 'test',
            metricStoreHolder: metricStoreHolder,
            optionsInventory: optionsInventory,
            defaultMaxChars: 10);
        ruleWithoutProducers
            .validate({'test#maxChars': 'invalid'}, 'this is a long string');

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-option-value'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxCharsRule',
              'class-specialisation': 'less-than',
              'method': 'validate',
              'name': 'test#thresholdChars',
              'level': 'ERROR',
              'status': 'not-found',
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
            [successMessage]);
        expect(
            rule.validate({'test-maxChars': "10"},
                '${createString(10)}this is a long string'),
            [failureMessage]);
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
              'class': 'VxCharsLessThanOrEqualRule',
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
              'class': 'VxCharsLessThanOrEqualRule',
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
            [successMessage]);
        expect(
            rule.validate({'test-minChars': '10'}, 'short'), [failureMessage]);
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
            [successMessage]);
        expect(
            rule.validate({'test-minChars': '10'}, 'short'), [failureMessage]);
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
              'class': 'VxCharsMoreThanOrEqualRule',
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
              'class': 'VxCharsMoreThanOrEqualRule',
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

    group('VxWordsLessThanRule', () {
      test('validate with producers', () {
        final rule = VxStringRules.wordsLessThan<String>(
            'test', metricStoreHolder, 1,
            successProducer: successProducer, failureProducer: failureProducer);
        expect(rule.validate({'test-maxWords': '3'}, createWords(2)),
            [successMessage]);
        expect(rule.validate({'test-maxWords': '3'}, createWords(3)),
            [failureMessage]);
      });

      test('validate without producers', () {
        final ruleWithoutProducers =
            VxStringRules.wordsLessThan<String>('test', metricStoreHolder, 3);
        expect(ruleWithoutProducers.validate({}, createWords(2)), []);
        expect(ruleWithoutProducers.validate({}, createWords(3)), []);
      });

      test('KeyNotFound metric logging', () {
        final ruleWithoutProducers =
            VxStringRules.wordsLessThan<String>('test', metricStoreHolder, 3);
        ruleWithoutProducers.validate({}, createWords(3));

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-max-words'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxWordsLessThanRule',
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
            VxStringRules.wordsLessThan<String>('test', metricStoreHolder, 3);
        ruleWithoutProducers
            .validate({'test-maxWords': 'invalid'}, createWords(3));

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-max-words'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxWordsLessThanRule',
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
    group('VxWordsLessThanOrEqualRule', () {
      test('validate with producers', () {
        final rule = VxStringRules.wordsLessThanOrEqual<String>(
            'test', metricStoreHolder, 1,
            successProducer: successProducer, failureProducer: failureProducer);
        expect(rule.validate({'test-maxWords': '3'}, createWords(3)),
            [successMessage]);
        expect(rule.validate({'test-maxWords': '3'}, createWords(4)),
            [failureMessage]);
      });

      test('validate without producers', () {
        final ruleWithoutProducers = VxStringRules.wordsLessThanOrEqual<String>(
            'test', metricStoreHolder, 3);
        expect(ruleWithoutProducers.validate({}, createWords(3)), []);
        expect(ruleWithoutProducers.validate({}, createWords(4)), []);
      });

      test('KeyNotFound metric logging', () {
        final ruleWithoutProducers = VxStringRules.wordsLessThanOrEqual<String>(
            'test', metricStoreHolder, 3);
        ruleWithoutProducers.validate({}, createWords(3));

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-max-words'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxWordsLessThanOrEqualRule',
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
        final ruleWithoutProducers = VxStringRules.wordsLessThanOrEqual<String>(
            'test', metricStoreHolder, 3);
        ruleWithoutProducers
            .validate({'test-maxWords': 'invalid'}, createWords(3));

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-max-words'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxWordsLessThanOrEqualRule',
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
    group('VxWordsMoreThanRule', () {
      test('validate with producers', () {
        final rule = VxStringRules.wordsMoreThan<String>(
            'test', metricStoreHolder, 3,
            successProducer: successProducer, failureProducer: failureProducer);
        expect(rule.validate({'test-minWords': '3'}, createWords(4)),
            [successMessage]);
        expect(rule.validate({'test-minWords': '3'}, createWords(2)),
            [failureMessage]);
      });

      test('validate without producers', () {
        final ruleWithoutProducers =
            VxStringRules.wordsMoreThan<String>('test', metricStoreHolder, 3);
        expect(ruleWithoutProducers.validate({}, createWords(4)), []);
        expect(ruleWithoutProducers.validate({}, createWords(2)), []);
      });

      test('KeyNotFound metric logging', () {
        final ruleWithoutProducers =
            VxStringRules.wordsMoreThan<String>('test', metricStoreHolder, 3);
        ruleWithoutProducers.validate({}, createWords(2));

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-min-words'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxWordsMoreThanRule',
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
            VxStringRules.wordsMoreThan<String>('test', metricStoreHolder, 3);
        ruleWithoutProducers
            .validate({'test-minWords': 'invalid'}, createWords(2));

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-min-words'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxWordsMoreThanRule',
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
    group('VxWordsMoreThanOrEqualRule', () {
      test('validate with producers', () {
        final rule = VxStringRules.wordsMoreThanOrEqual<String>(
            'test', metricStoreHolder, 10,
            successProducer: successProducer, failureProducer: failureProducer);
        expect(rule.validate({'test-minWords': '3'}, createWords(3)),
            [successMessage]);
        expect(rule.validate({'test-minWords': '3'}, createWords(2)),
            [failureMessage]);
      });

      test('validate without producers', () {
        final ruleWithoutProducers = VxStringRules.wordsMoreThanOrEqual<String>(
            'test', metricStoreHolder, 3);
        expect(ruleWithoutProducers.validate({}, createWords(4)), []);
        expect(ruleWithoutProducers.validate({}, createWords(2)), []);
      });

      test('KeyNotFound metric logging', () {
        final ruleWithoutProducers = VxStringRules.wordsMoreThanOrEqual<String>(
            'test', metricStoreHolder, 3);
        ruleWithoutProducers.validate({}, createWords(2));

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-min-words'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxWordsMoreThanOrEqualRule',
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
        final ruleWithoutProducers = VxStringRules.wordsMoreThanOrEqual<String>(
            'test', metricStoreHolder, 3);
        ruleWithoutProducers
            .validate({'test-minWords': 'invalid'}, createWords(2));

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-min-words'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxWordsMoreThanOrEqualRule',
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
