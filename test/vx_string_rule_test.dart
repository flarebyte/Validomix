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

    test('charsLessThan', () {
      final rule = VxStringRules.charsLessThan<String>(10,
          successProducer: successProducer, failureProducer: failureProducer);

      expect(rule.validate({}, 'short'), ['Success: Condition met.']);
      expect(rule.validate({}, 'this is a long string'),
          ['Failure: Condition not met.']);

      final ruleWithoutProducers = VxStringRules.charsLessThan<String>(10);
      expect(ruleWithoutProducers.validate({}, 'short'), []);
      expect(ruleWithoutProducers.validate({}, 'this is a long string'), []);
    });

    test('charsMoreThan', () {
      final rule = VxStringRules.charsMoreThan<String>(10,
          successProducer: successProducer, failureProducer: failureProducer);

      expect(rule.validate({}, 'this is a long string'),
          ['Success: Condition met.']);
      expect(rule.validate({}, 'short'), ['Failure: Condition not met.']);

      final ruleWithoutProducers = VxStringRules.charsMoreThan<String>(10);
      expect(ruleWithoutProducers.validate({}, 'this is a long string'), []);
      expect(ruleWithoutProducers.validate({}, 'short'), []);
    });

    test('charsLessThanOrEqual', () {
      final rule = VxStringRules.charsLessThanOrEqual<String>(10,
          successProducer: successProducer, failureProducer: failureProducer);

      expect(rule.validate({}, 'short'), ['Success: Condition met.']);
      expect(rule.validate({}, 'ten chars!'), ['Success: Condition met.']);
      expect(rule.validate({}, 'this is a long string'),
          ['Failure: Condition not met.']);

      final ruleWithoutProducers =
          VxStringRules.charsLessThanOrEqual<String>(10);
      expect(ruleWithoutProducers.validate({}, 'short'), []);
      expect(ruleWithoutProducers.validate({}, 'ten chars!'), []);
      expect(ruleWithoutProducers.validate({}, 'this is a long string'), []);
    });

    test('charsMoreThanOrEqual', () {
      final rule = VxStringRules.charsMoreThanOrEqual<String>(10,
          successProducer: successProducer, failureProducer: failureProducer);

      expect(rule.validate({}, 'this is a long string'),
          ['Success: Condition met.']);
      expect(rule.validate({}, 'ten chars!'), ['Success: Condition met.']);
      expect(rule.validate({}, 'short'), ['Failure: Condition not met.']);

      final ruleWithoutProducers =
          VxStringRules.charsMoreThanOrEqual<String>(10);
      expect(ruleWithoutProducers.validate({}, 'this is a long string'), []);
      expect(ruleWithoutProducers.validate({}, 'ten chars!'), []);
      expect(ruleWithoutProducers.validate({}, 'short'), []);
    });

    test('wordsLessThan', () {
      final rule = VxStringRules.wordsLessThan<String>(3,
          successProducer: successProducer, failureProducer: failureProducer);

      expect(rule.validate({}, 'two words'), ['Success: Condition met.']);
      expect(rule.validate({}, 'this is three words'),
          ['Failure: Condition not met.']);

      final ruleWithoutProducers = VxStringRules.wordsLessThan<String>(3);
      expect(ruleWithoutProducers.validate({}, 'two words'), []);
      expect(ruleWithoutProducers.validate({}, 'this is three words'), []);
    });

    test('wordsMoreThan', () {
      final rule = VxStringRules.wordsMoreThan<String>(3,
          successProducer: successProducer, failureProducer: failureProducer);

      expect(rule.validate({}, 'this is more than three words'),
          ['Success: Condition met.']);
      expect(rule.validate({}, 'two words'), ['Failure: Condition not met.']);

      final ruleWithoutProducers = VxStringRules.wordsMoreThan<String>(3);
      expect(ruleWithoutProducers.validate({}, 'this is more than three words'),
          []);
      expect(ruleWithoutProducers.validate({}, 'two words'), []);
    });

    test('wordsLessThanOrEqual', () {
      final rule = VxStringRules.wordsLessThanOrEqual<String>(3,
          successProducer: successProducer, failureProducer: failureProducer);

      expect(rule.validate({}, 'two words'), ['Success: Condition met.']);
      expect(rule.validate({}, 'this is three'), ['Success: Condition met.']);
      expect(rule.validate({}, 'this is more than three words'),
          ['Failure: Condition not met.']);

      final ruleWithoutProducers =
          VxStringRules.wordsLessThanOrEqual<String>(3);
      expect(ruleWithoutProducers.validate({}, 'two words'), []);
      expect(ruleWithoutProducers.validate({}, 'this is three'), []);
      expect(ruleWithoutProducers.validate({}, 'this is more than three words'),
          []);
    });

    test('wordsMoreThanOrEqual', () {
      final rule = VxStringRules.wordsMoreThanOrEqual<String>(3,
          successProducer: successProducer, failureProducer: failureProducer);

      expect(rule.validate({}, 'this is more than three words'),
          ['Success: Condition met.']);
      expect(rule.validate({}, 'this is three'), ['Success: Condition met.']);
      expect(rule.validate({}, 'two words'), ['Failure: Condition not met.']);

      final ruleWithoutProducers =
          VxStringRules.wordsMoreThanOrEqual<String>(3);
      expect(ruleWithoutProducers.validate({}, 'this is more than three words'),
          []);
      expect(ruleWithoutProducers.validate({}, 'this is three'), []);
      expect(ruleWithoutProducers.validate({}, 'two words'), []);
    });
  });
}
