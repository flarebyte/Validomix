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
    var secureFailureMessage = 'Failure: Secure Condition not met.';
    final secureFailureProducer = SimpleMessageProducer(secureFailureMessage);
    var domainFailureMessage = 'Failure: Domain Condition not met.';
    final domainFailureProducer = SimpleMessageProducer(domainFailureMessage);
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
      for (var supported in [
        'http://website.com',
        'http://website.com/service',
        'https://website.com/service'
      ]) {
        expect(rule.validate({}, supported), [successMessage]);
      }
      expect(rule.validate({}, 'http://website.com'), [successMessage]);
      for (var notSupported in [
        'random string',
        'a/bc/c',
        'ftp://website.com',
        'http://example.com/data.csv#row=4',
        'http://website.com/service?param1=value1',
        'http://website.com:8080/service',
        'http://username:password@example.com/'
      ]) {
        expect(rule.validate({}, notSupported), [failureMessage]);
      }
      expect(optionsInventory.toList().map((i) => i.name), [
        'test~allowDomains',
        'test~allowFragment',
        'test~allowQuery',
        'test~secure'
      ]);
    });

    test('validate domains', () {
      final rule = VxUrlRule<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
          successProducer: successProducer,
          failureProducer: failureProducer,
          domainFailureProducer: domainFailureProducer);
      const allowDomains = {'test~allowDomains': 'en.wikipedia.org dart.dev'};

      expect(
          rule.validate(allowDomains,
              'https://api.dart.dev/stable/3.4.4/dart-core/Uri-class.html'),
          [successMessage]);
      expect(
          rule.validate(
              allowDomains, 'https://en.wikipedia.org/wiki/Henry_VIII'),
          [successMessage]);
      expect(
          rule.validate(
              allowDomains, 'https://en.wikipedia.com/wiki/Henry_VIII'),
          [domainFailureMessage]);
      expect(rule.validate(allowDomains, 'https:/abc.com/wiki/Henry_VIII'),
          [domainFailureMessage]);
    });

    test('allow fragment', () {
      final rule = VxUrlRule<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
          successProducer: successProducer,
          failureProducer: failureProducer);

      expect(
          rule.validate({'test~allowFragment': 'true'},
              'http://example.com/data.csv#row=4'),
          [successMessage]);
    });

    test('allow query', () {
      final rule = VxUrlRule<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
          successProducer: successProducer,
          failureProducer: failureProducer);

      expect(
          rule.validate(
              {'test~allowQuery': 'true'}, 'http://example.com/data.csv?row=4'),
          [successMessage]);
    });

    test('secure should ensure https', () {
      final rule = VxUrlRule<String>(
          name: 'test',
          metricStoreHolder: metricStoreHolder,
          optionsInventory: optionsInventory,
          successProducer: successProducer,
          secureFailureProducer: secureFailureProducer);

      var options = {'test~secure': 'true'};
      expect(rule.validate(options, 'https://example.com/data.csv'),
          [successMessage]);
      expect(rule.validate(options, 'http://example.com/data.csv'),
          [secureFailureMessage]);
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
