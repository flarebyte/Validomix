import 'package:eagleyeix/metric.dart';
import 'package:validomix/validomix.dart';

class SimpleMessageProducer implements VxMessageProducer<String, String> {
  final String message;
  SimpleMessageProducer(this.message);
  @override
  String produce(Map<String, String> options, String value) => message;
}

void main() {
  final metricStoreHolder = ExMetricStoreHolder();
  final optionsInventory = VxOptionsInventory();
  final rule = VxStringRules.charsLessThan<String>(
      name: 'test',
      metricStoreHolder: metricStoreHolder,
      optionsInventory: optionsInventory,
      successProducer: SimpleMessageProducer('Success'),
      failureProducer: SimpleMessageProducer('Too many characters'));
  final hello = rule.validate({'test#maxChars': "10"}, 'hello');
  final wayTooLong = rule.validate({'test#maxChars': "10"},
      'This is a long string that is more than 10 characters');
  print('Hello: $hello');
  // Hello: [Success]
  print('Way Too Long: $wayTooLong');
  // Way Too Long: [Too many characters]
  for (var inventory in optionsInventory.toList()) {
    print("${inventory.name}->${inventory.descriptors}");
    // test#maxChars->[integer, positive]
  }
}
