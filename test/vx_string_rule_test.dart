import 'package:eagleyeix/metric.dart';
import 'package:test/test.dart';
import 'package:validomix/validomix.dart';

import 'vx_fixtures.dart';

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
      const threshold = 10;
      test('validate with producers', () {
        final rule = VxStringRules.charsLessThan<String>(
            name: 'test',
            metricStoreHolder: metricStoreHolder,
            optionsInventory: optionsInventory,
            successProducers: [successProducer],
            failureProducers: [failureProducer]);
        expect(
            rule.validate({'test#maxChars': "$threshold"},
                StringFixture.createString(threshold - 1)),
            [successMessage]);
        expect(
            rule.validate({'test#maxChars': "$threshold"},
                StringFixture.createString(threshold)),
            [failureMessage]);
        expect(
            rule.validate({'test#maxChars': "$threshold"},
                StringFixture.createString(threshold + 1)),
            [failureMessage]);
        expect(optionsInventory.toList().length, 1);
        expect(optionsInventory.toList().first.name, 'test#maxChars');
      });

      test('validate without producers', () {
        final ruleWithoutProducers = VxStringRules.charsLessThan<String>(
            name: 'test',
            metricStoreHolder: metricStoreHolder,
            optionsInventory: optionsInventory);
        shouldNotProduceMessage(
            ruleWithoutProducers, threshold, optionsInventory);
      });

      test('KeyNotFound metric logging', () {
        final ruleWithoutProducers = VxStringRules.charsLessThan<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
        );
        ruleWithoutProducers
            .validate({}, StringFixture.createString(threshold));

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
              'name': 'test#maxChars',
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
        );
        ruleWithoutProducers.validate({'test#maxChars': 'invalid'},
            StringFixture.createString(threshold));

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
              'name': 'test#maxChars',
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
    });
    group('VxCharsLessThanOrEqualRule', () {
      const threshold = 10;
      test('validate with producers', () {
        final rule = VxStringRules.charsLessThanOrEqual<String>(
            name: 'test',
            metricStoreHolder: metricStoreHolder,
            optionsInventory: optionsInventory,
            successProducers: [successProducer],
            failureProducers: [failureProducer]);
        expect(
            rule.validate({'test#maxChars': "$threshold"},
                StringFixture.createString(threshold - 1)),
            [successMessage]);
        expect(
            rule.validate({'test#maxChars': "$threshold"},
                StringFixture.createString(threshold)),
            [successMessage]);
        expect(
            rule.validate({'test#maxChars': "$threshold"},
                StringFixture.createString(threshold + 1)),
            [failureMessage]);
        expect(optionsInventory.toList().length, 1);
        expect(optionsInventory.toList().first.name, 'test#maxChars');
      });

      test('validate without producers', () {
        final ruleWithoutProducers = VxStringRules.charsLessThanOrEqual<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
        );
        shouldNotProduceMessage(
            ruleWithoutProducers, threshold, optionsInventory);
      });

      test('KeyNotFound metric logging', () {
        final ruleWithoutProducers = VxStringRules.charsLessThanOrEqual<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
        );
        ruleWithoutProducers
            .validate({}, StringFixture.createString(threshold));

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-option-value'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxCharsRule',
              'class-specialisation': 'less-than-or-equal',
              'method': 'validate',
              'name': 'test#maxChars',
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
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
        );
        ruleWithoutProducers.validate({'test#maxChars': 'invalid'},
            StringFixture.createString(threshold));

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-option-value'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxCharsRule',
              'class-specialisation': 'less-than-or-equal',
              'method': 'validate',
              'name': 'test#maxChars',
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
    });

    group('VxCharsMoreThanRule', () {
      const threshold = 10;
      test('validate with producers', () {
        final rule = VxStringRules.charsMoreThan<String>(
            name: 'test',
            metricStoreHolder: metricStoreHolder,
            optionsInventory: optionsInventory,
            successProducers: [successProducer],
            failureProducers: [failureProducer]);
        expect(
            rule.validate({'test#minChars': "$threshold"},
                StringFixture.createString(threshold + 1)),
            [successMessage]);
        expect(
            rule.validate({'test#minChars': "$threshold"},
                StringFixture.createString(threshold)),
            [failureMessage]);
        expect(
            rule.validate({'test#minChars': "$threshold"},
                StringFixture.createString(threshold - 1)),
            [failureMessage]);
        expect(optionsInventory.toList().length, 1);
        expect(optionsInventory.toList().first.name, 'test#minChars');
      });

      test('validate without producers', () {
        final ruleWithoutProducers = VxStringRules.charsMoreThan<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
        );
        shouldNotProduceMessage(
            ruleWithoutProducers, threshold, optionsInventory);
      });

      test('KeyNotFound metric logging', () {
        final ruleWithoutProducers = VxStringRules.charsMoreThan<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
        );
        ruleWithoutProducers
            .validate({}, StringFixture.createString(threshold));

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-option-value'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxCharsRule',
              'class-specialisation': 'greater-than',
              'method': 'validate',
              'name': 'test#minChars',
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
        final ruleWithoutProducers = VxStringRules.charsMoreThan<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
        );
        ruleWithoutProducers.validate({'test#minChars': 'invalid'},
            StringFixture.createString(threshold));

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-option-value'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxCharsRule',
              'class-specialisation': 'greater-than',
              'method': 'validate',
              'name': 'test#minChars',
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
    });
    group('VxCharsMoreThanOrEqualRule', () {
      const threshold = 10;
      test('validate with producers', () {
        final rule = VxStringRules.charsMoreThanOrEqual<String>(
            name: 'test',
            metricStoreHolder: metricStoreHolder,
            optionsInventory: optionsInventory,
            successProducers: [successProducer],
            failureProducers: [failureProducer]);
        expect(
            rule.validate({'test#minChars': "$threshold"},
                StringFixture.createString(threshold + 1)),
            [successMessage]);
        expect(
            rule.validate({'test#minChars': "$threshold"},
                StringFixture.createString(threshold)),
            [successMessage]);
        expect(
            rule.validate({'test#minChars': "$threshold"},
                StringFixture.createString(threshold - 1)),
            [failureMessage]);
        expect(optionsInventory.toList().length, 1);
        expect(optionsInventory.toList().first.name, 'test#minChars');
      });

      test('validate without producers', () {
        final ruleWithoutProducers = VxStringRules.charsMoreThanOrEqual<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
        );
        shouldNotProduceMessage(
            ruleWithoutProducers, threshold, optionsInventory);
      });

      test('KeyNotFound metric logging', () {
        final ruleWithoutProducers = VxStringRules.charsMoreThanOrEqual<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
        );
        ruleWithoutProducers
            .validate({}, StringFixture.createString(threshold));

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-option-value'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxCharsRule',
              'class-specialisation': 'greater-than-or-equal',
              'method': 'validate',
              'name': 'test#minChars',
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
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
        );
        ruleWithoutProducers.validate({'test#minChars': 'invalid'},
            StringFixture.createString(threshold));

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-option-value'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxCharsRule',
              'class-specialisation': 'greater-than-or-equal',
              'method': 'validate',
              'name': 'test#minChars',
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
    });
    group('VxWordsLessThanRule', () {
      const threshold = 10;
      test('validate with producers', () {
        final rule = VxStringRules.wordsLessThan<String>(
            name: 'test',
            metricStoreHolder: metricStoreHolder,
            optionsInventory: optionsInventory,
            successProducers: [successProducer],
            failureProducers: [failureProducer]);
        expect(
            rule.validate(
                {'test#maxWords': "$threshold"}, createWords(threshold - 1)),
            [successMessage]);
        expect(
            rule.validate(
                {'test#maxWords': "$threshold"}, createWords(threshold)),
            [failureMessage]);
        expect(
            rule.validate(
                {'test#maxWords': "$threshold"}, createWords(threshold + 1)),
            [failureMessage]);
        expect(optionsInventory.toList().length, 1);
        expect(optionsInventory.toList().first.name, 'test#maxWords');
      });

      test('validate without producers', () {
        final ruleWithoutProducers = VxStringRules.wordsLessThan<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
        );
        wordsShouldNotProduceMessage(
            ruleWithoutProducers, threshold, optionsInventory);
      });

      test('KeyNotFound metric logging', () {
        final ruleWithoutProducers = VxStringRules.wordsLessThan<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
        );
        ruleWithoutProducers.validate({}, createWords(threshold));

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-option-value'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxWordsRule',
              'class-specialisation': 'less-than',
              'method': 'validate',
              'name': 'test#maxWords',
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
        final ruleWithoutProducers = VxStringRules.wordsLessThan<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
        );
        ruleWithoutProducers
            .validate({'test#maxWords': 'invalid'}, createWords(threshold));

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-option-value'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxWordsRule',
              'class-specialisation': 'less-than',
              'method': 'validate',
              'name': 'test#maxWords',
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
    });
    group('VxWordsLessThanOrEqualRule', () {
      const threshold = 10;
      test('validate with producers', () {
        final rule = VxStringRules.wordsLessThanOrEqual<String>(
            name: 'test',
            metricStoreHolder: metricStoreHolder,
            optionsInventory: optionsInventory,
            successProducers: [successProducer],
            failureProducers: [failureProducer]);
        expect(
            rule.validate(
                {'test#maxWords': "$threshold"}, createWords(threshold - 1)),
            [successMessage]);
        expect(
            rule.validate(
                {'test#maxWords': "$threshold"}, createWords(threshold)),
            [successMessage]);
        expect(
            rule.validate(
                {'test#maxWords': "$threshold"}, createWords(threshold + 1)),
            [failureMessage]);
        expect(optionsInventory.toList().length, 1);
        expect(optionsInventory.toList().first.name, 'test#maxWords');
      });

      test('validate without producers', () {
        final ruleWithoutProducers = VxStringRules.wordsLessThanOrEqual<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
        );
        wordsShouldNotProduceMessage(
            ruleWithoutProducers, threshold, optionsInventory);
      });

      test('KeyNotFound metric logging', () {
        final ruleWithoutProducers = VxStringRules.wordsLessThanOrEqual<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
        );
        ruleWithoutProducers.validate({}, createWords(threshold));

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-option-value'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxWordsRule',
              'class-specialisation': 'less-than-or-equal',
              'method': 'validate',
              'name': 'test#maxWords',
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
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
        );
        ruleWithoutProducers
            .validate({'test#maxWords': 'invalid'}, createWords(threshold));

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-option-value'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxWordsRule',
              'class-specialisation': 'less-than-or-equal',
              'method': 'validate',
              'name': 'test#maxWords',
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
    });
    group('VxWordsMoreThanRule', () {
      const threshold = 10;
      test('validate with producers', () {
        final rule = VxStringRules.wordsMoreThan<String>(
            name: 'test',
            metricStoreHolder: metricStoreHolder,
            optionsInventory: optionsInventory,
            successProducers: [successProducer],
            failureProducers: [failureProducer]);
        expect(
            rule.validate(
                {'test#minWords': "$threshold"}, createWords(threshold + 1)),
            [successMessage]);
        expect(
            rule.validate(
                {'test#minWords': "$threshold"}, createWords(threshold)),
            [failureMessage]);
        expect(
            rule.validate(
                {'test#minWords': "$threshold"}, createWords(threshold - 1)),
            [failureMessage]);
        expect(optionsInventory.toList().length, 1);
        expect(optionsInventory.toList().first.name, 'test#minWords');
      });

      test('validate without producers', () {
        final ruleWithoutProducers = VxStringRules.wordsMoreThan<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
        );
        wordsShouldNotProduceMessage(
            ruleWithoutProducers, threshold, optionsInventory);
      });

      test('KeyNotFound metric logging', () {
        final ruleWithoutProducers = VxStringRules.wordsMoreThan<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
        );
        ruleWithoutProducers.validate({}, createWords(threshold));

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-option-value'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxWordsRule',
              'class-specialisation': 'greater-than',
              'method': 'validate',
              'name': 'test#minWords',
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
        final ruleWithoutProducers = VxStringRules.wordsMoreThan<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
        );
        ruleWithoutProducers
            .validate({'test#minWords': 'invalid'}, createWords(threshold));

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-option-value'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxWordsRule',
              'class-specialisation': 'greater-than',
              'method': 'validate',
              'name': 'test#minWords',
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
    });
    group('VxWordsMoreThanOrEqualRule', () {
      const threshold = 10;
      test('validate with producers', () {
        final rule = VxStringRules.wordsMoreThanOrEqual<String>(
            name: 'test',
            metricStoreHolder: metricStoreHolder,
            optionsInventory: optionsInventory,
            successProducers: [successProducer],
            failureProducers: [failureProducer]);
        expect(
            rule.validate(
                {'test#minWords': "$threshold"}, createWords(threshold + 1)),
            [successMessage]);
        expect(
            rule.validate(
                {'test#minWords': "$threshold"}, createWords(threshold)),
            [successMessage]);
        expect(
            rule.validate(
                {'test#minWords': "$threshold"}, createWords(threshold - 1)),
            [failureMessage]);
        expect(optionsInventory.toList().length, 1);
        expect(optionsInventory.toList().first.name, 'test#minWords');
      });

      test('validate without producers', () {
        final ruleWithoutProducers = VxStringRules.wordsMoreThanOrEqual<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
        );
        wordsShouldNotProduceMessage(
            ruleWithoutProducers, threshold, optionsInventory);
      });

      test('KeyNotFound metric logging', () {
        final ruleWithoutProducers = VxStringRules.wordsMoreThanOrEqual<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
        );
        ruleWithoutProducers.validate({}, createWords(threshold));

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-option-value'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxWordsRule',
              'class-specialisation': 'greater-than-or-equal',
              'method': 'validate',
              'name': 'test#minWords',
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
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
        );
        ruleWithoutProducers
            .validate({'test#minWords': 'invalid'}, createWords(threshold));

        final count = ExMetricAggregations.count();
        final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

        expect(aggregatedMetrics.first.toJson(), {
          'key': {
            'name': ['get-option-value'],
            'dimensions': {
              'package': 'validomix',
              'class': 'VxWordsRule',
              'class-specialisation': 'greater-than-or-equal',
              'method': 'validate',
              'name': 'test#minWords',
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
    });
    group('VxStringFormatterRule', () {
      const threshold = 10;
      test('validate with producers', () {
        final rule = VxStringRules.followFormat<String>(
            name: 'test',
            metricStoreHolder: metricStoreHolder,
            optionsInventory: optionsInventory,
            formatter: CollapseFormatter(),
            successProducers: [successProducer],
            failureProducers: [failureProducer]);
        expect(rule.validate({'test~formatting': "/"}, 'no-slash'),
            [successMessage]);
        expect(rule.validate({'test~formatting': "/"}, 'some/slash/'),
            [failureMessage]);
        expect(optionsInventory.toList().length, 1);
        expect(optionsInventory.toList().first.name, 'test~formatting');
      });

      test('validate without producers', () {
        final ruleWithoutProducers = VxStringRules.followFormat<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
          formatter: CollapseFormatter(),
        );
        expect(ruleWithoutProducers.validate({}, "no-space"), []);
        expect(ruleWithoutProducers.validate({}, "some space"), []);
        expect(optionsInventory.toList().length, 1);
      });
    });
  });
}

class CollapseFormatter extends VxBaseFormatter {
  @override
  String format(Map<String, String> options, String value,
      [String? formatting]) {
    return value.replaceAll(formatting ?? ' ', '');
  }

  @override
  String get name => 'CollapseFormatter';
}

void shouldNotProduceMessage(VxCharsRule<String> ruleWithoutProducers,
    int threshold, VxOptionsInventory optionsInventory) {
  expect(
      ruleWithoutProducers
          .validate({}, StringFixture.createString(threshold - 1)),
      []);
  expect(
      ruleWithoutProducers
          .validate({}, StringFixture.createString(threshold + 1)),
      []);
  expect(optionsInventory.toList().length, 1);
}

void wordsShouldNotProduceMessage(VxWordsRule<String> ruleWithoutProducers,
    int threshold, VxOptionsInventory optionsInventory) {
  expect(
      ruleWithoutProducers
          .validate({}, StringFixture.createString(threshold - 1)),
      []);
  expect(
      ruleWithoutProducers
          .validate({}, StringFixture.createString(threshold + 1)),
      []);
  expect(optionsInventory.toList().length, 1);
}
