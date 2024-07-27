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
  group('VxUrlRule', () {
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
    test('validate with producers', () {
      final rule = VxUrlRule<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
          successProducer: successProducer,
          failureProducer: failureProducer);
      expect(rule.validate({}, 'http://website.com'), [successMessage]);
      expect(rule.validate({}, 'ftp://website.com'), [failureMessage]);
      expect(optionsInventory.toList().length, 3);
    });

    test('validate without producers', () {
      final ruleWithoutProducers = VxUrlRule<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory);
      expect(ruleWithoutProducers.validate({}, 'http://website.com'), []);
      expect(ruleWithoutProducers.validate({}, 'ftp://website.com'), []);
    });
  });
}
