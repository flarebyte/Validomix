import 'package:eagleyeix/metric.dart';
import 'package:test/test.dart';
import 'package:validomix/validomix.dart';

import 'vx_fixtures.dart';

void main() {
  group('VxRuleLocator', () {
    late VxRuleLocator<String> ruleLocator;
    late ExMetricStoreHolder metricStoreHolder;

    setUp(() {
      metricStoreHolder = ExMetricStoreHolder();
      ruleLocator = VxRuleLocator<String>(
        defaultRule: VxRuleFixtures.nonEmptyRule(),
        metricStoreHolder: metricStoreHolder,
      );
    });

    test('should register and retrieve a rule by id', () {
      final emailRule = VxRuleFixtures.emailRule();
      ruleLocator.registerRule('email', emailRule);

      final retrievedRule = ruleLocator.getRule('email');
      expect(retrievedRule, equals(emailRule));
    });

    test('should return default rule and log metric when rule is not found',
        () {
      final defaultRule = ruleLocator.getRule('nonExistent');

      expect(defaultRule.validate({}, ''), ['Value cannot be empty']);

      final count = ExMetricAggregations.count();
      final aggregatedMetrics = metricStoreHolder.store.aggregateAll(count);

      expect(aggregatedMetrics.first.toJson(), {
        'key': {
          'name': ['get-rule'],
          'dimensions': {
            'package': 'validomix',
            'class': 'VxRuleLocator',
            'method': 'getRule',
            'id': 'nonExistent',
            'level': 'ERROR',
            'status': 'not-found',
            'unit': 'count',
            'aggregation': 'count'
          }
        },
        'value': 1.0
      });
    });

    test('should overwrite an existing rule with the same id', () {
      final minLengthRule = VxRuleFixtures.minLengthRule(5);
      ruleLocator.registerRule('minLength', minLengthRule);

      final newMinLengthRule = VxRuleFixtures.minLengthRule(10);
      ruleLocator.registerRule('minLength', newMinLengthRule);

      final retrievedRule = ruleLocator.getRule('minLength');
      expect(retrievedRule, equals(newMinLengthRule));
    });

    test('should handle multiple rules correctly', () {
      final emailRule = VxRuleFixtures.emailRule();
      final minLengthRule = VxRuleFixtures.minLengthRule(5);

      ruleLocator.registerRule('email', emailRule);
      ruleLocator.registerRule('minLength', minLengthRule);

      final retrievedEmailRule = ruleLocator.getRule('email');
      final retrievedMinLengthRule = ruleLocator.getRule('minLength');

      expect(retrievedEmailRule, equals(emailRule));
      expect(retrievedMinLengthRule, equals(minLengthRule));
    });
  });
}
