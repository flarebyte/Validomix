import 'package:eagleyeix/metric.dart';
import 'package:test/test.dart';
import 'package:validomix/validomix.dart';

typedef Message = String;

void main() {
  group('VxListRules - greaterThan', () {
    var successMessage = 'Success: Condition met.';
    final successProducer = SimpleMessageProducer(successMessage);
    var failureMessage = 'Failure: Condition not met.';
    final failureProducer = SimpleMessageProducer(failureMessage);
    late ExMetricStoreHolder metricStoreHolder;
    late VxListRule<Message, String> rule;
    late VxOptionsInventory optionsInventory;

    setUp(() {
      metricStoreHolder = ExMetricStoreHolder();
      optionsInventory = VxOptionsInventory();
      rule = VxListRules.greaterThan<Message, String>(
          name: 'example',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
          stringParser: DotStringParser(),
          itemValidator: AlwaysPassValidator(),
          areSuccessfulMessages: AreStringAllSuccess(),
          successProducer: successProducer,
          failureProducer: failureProducer);
    });

    test('value is greater than threshold', () {
      final options = {'example#minSize': '15'};
      final result = rule.validate(options, createSentences(20));
      expect(result, [successMessage]);
    });

    test('value is equal to threshold', () {
      final options = {'example#eqSize': '15'};
      final result = rule.validate(options, createSentences(15));
      expect(result, [successMessage]);
    });

    test('value is less than threshold', () {
      final options = {'example#minSize': '15'};
      final result = rule.validate(options, createSentences(10));
      expect(result, [failureMessage]);
    });

    test('threshold key not found in options', () {
      final result = rule.validate({}, createSentences(20));
      expect(result, [successMessage]);
      final count = ExMetricAggregations.count();
      final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

      expect(aggregatedMetrics.first.toJson(), {
        'key': {
          'name': ['get-option-value'],
          'dimensions': {
            'package': 'validomix',
            'class': 'VxListRule',
            'class-specialisation': 'greater-than',
            'method': 'validate',
            'name': 'example#minSize',
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
      final options = {'example#minSize': 'invalid'};
      final result = rule.validate(options, createSentences(20));
      expect(result, [successMessage]);
      final count = ExMetricAggregations.count();
      final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

      expect(aggregatedMetrics.first.toJson(), {
        'key': {
          'name': ['get-option-value'],
          'dimensions': {
            'package': 'validomix',
            'class': 'VxListRule',
            'class-specialisation': 'greater-than',
            'method': 'validate',
            'name': 'example#minSize',
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

  group('VxListRules - other comparators', () {
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
    test('greaterThanOrEqual - value is greater than or equal to threshold',
        () {
      final rule = VxListRules.greaterThanOrEqual<Message, String>(
          name: 'example',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
          stringParser: DotStringParser(),
          itemValidator: AlwaysPassValidator(),
          areSuccessfulMessages: AreStringAllSuccess(),
          successProducer: successProducer,
          failureProducer: failureProducer);
      final options = {'example#minSize': '15'};
      final result = rule.validate(options, createSentences(15));
      expect(result, [successMessage]);
    });

    test('lessThan - value is less than threshold', () {
      final rule = VxListRules.lessThan<Message, String>(
          name: 'example',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
          stringParser: DotStringParser(),
          itemValidator: AlwaysPassValidator(),
          areSuccessfulMessages: AreStringAllSuccess(),
          successProducer: successProducer,
          failureProducer: failureProducer);
      final options = {'example#maxSize': '15'};
      final result = rule.validate(options, createSentences(10));
      expect(result, [successMessage]);
    });

    test('lessThanOrEqual - value is less than or equal to threshold', () {
      final rule = VxListRules.lessThanOrEqual<Message, String>(
          name: 'example',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
          stringParser: DotStringParser(),
          itemValidator: AlwaysPassValidator(),
          areSuccessfulMessages: AreStringAllSuccess(),
          successProducer: successProducer,
          failureProducer: failureProducer);
      final options = {'example#maxSize': '15'};
      final result = rule.validate(options, createSentences(15));
      expect(result, [successMessage]);
    });

    test('equalTo - value is equal to threshold', () {
      final rule = VxListRules.equalTo<Message, String>(
          name: 'example',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
          stringParser: DotStringParser(),
          itemValidator: AlwaysPassValidator(),
          areSuccessfulMessages: AreStringAllSuccess(),
          successProducer: successProducer,
          failureProducer: failureProducer);
      final options = {'example#eqSize': '15'};
      final result = rule.validate(options, createSentences(15));
      expect(result, [successMessage]);
    });
  });
}

class DotStringParser extends VxStringParser<List<String>> {
  @override
  List<String>? parseString(String value) {
    if (value.length < 3) return null;
    return value.split('.');
  }
}

class SimpleMessageProducer implements VxMessageProducer<String, String> {
  final String message;
  SimpleMessageProducer(this.message);
  @override
  String produce(Map<String, String> options, String value) => message;
}

String createSentences(int n) {
  return List.generate(n, (index) => 'best of words$index').join('.');
}

class AlwaysPassValidator extends VxBaseValidator<String, String> {
  @override
  List<String> validate(Map<String, String> options, String value) {
    return ['Success'];
  }
}

class AlwaysFailValidator extends VxBaseValidator<String, String> {
  @override
  List<String> validate(Map<String, String> options, String value) {
    return ['Validation failed'];
  }
}

class AreStringAllSuccess extends VxMatchingMessages<Message> {
  @override
  bool isMatching(List<Message> messages) {
    for (var message in messages) {
      if (!message.startsWith('Success')) {
        return false;
      }
    }
    return true;
  }
}
