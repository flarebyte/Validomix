import 'package:eagleyeix/metric.dart';
import 'package:test/test.dart';
import 'package:validomix/src/vx_rule_def.dart';

void main() {
  group('VxRuleDefinition Tests', () {
    test('Serialization and Deserialization', () {
      final rule = VxRuleDefinition(
        id: 'rule1',
        validatorName: 'lengthCheck',
        options: {'min': '5', 'max': '10'},
      );

      final json = rule.toJson();
      expect(json['id'], 'rule1');
      expect(json['validatorName'], 'lengthCheck');
      expect(json['options']['min'], '5');
      expect(json['options']['max'], '10');

      final deserializedRule = VxRuleDefinition.fromJson(json);
      expect(deserializedRule.id, 'rule1');
      expect(deserializedRule.validatorName, 'lengthCheck');
      expect(deserializedRule.options['min'], '5');
      expect(deserializedRule.options['max'], '10');
    });
  });

  group('VxRulesSet Tests', () {
    test('Serialization and Deserialization', () {
      final rule = VxRuleDefinition(
        id: 'rule1',
        validatorName: 'lengthCheck',
        options: {'min': '5', 'max': '10'},
      );

      final rulesSet = VxRulesSet(
        id: 'rulesSet1',
        rules: [rule],
      );

      final json = rulesSet.toJson();
      expect(json['id'], 'rulesSet1');
      expect((json['rules'] as List).length, 1);
      expect(json['rules'][0]['id'], 'rule1');

      final deserializedRulesSet = VxRulesSet.fromJson(json);
      expect(deserializedRulesSet.id, 'rulesSet1');
      expect(deserializedRulesSet.rules.length, 1);
      expect(deserializedRulesSet.rules[0].id, 'rule1');
    });
  });

  group('VxRuleDefinitionLocator Tests', () {
    late VxRuleDefinition defaultRule;
    late VxRuleDefinition rule1;
    late VxRulesSet rulesSet;
    late VxRuleDefinitionLocator locator;
    late ExMetricStoreHolder metricStoreHolder;
    final count = ExMetricAggregations.count();

    setUp(() {
      defaultRule = VxRuleDefinition(
        id: 'default',
        validatorName: 'defaultValidator',
        options: {'defaultOption': 'defaultValue'},
      );

      rule1 = VxRuleDefinition(
        id: 'rule1',
        validatorName: 'lengthCheck',
        options: {'min': '5', 'max': '10'},
      );

      rulesSet = VxRulesSet(
        id: 'rulesSet1',
        rules: [rule1],
      );
      metricStoreHolder = ExMetricStoreHolder();
      locator = VxRuleDefinitionLocator(
          defaultRuleDef: defaultRule, metricStoreHolder: metricStoreHolder);
    });

    test('Register and Retrieve RuleDefinition', () {
      locator.registerRulesSet(rulesSet);

      final retrievedRule = locator.getRuleDefinition(
        rulesSetId: 'rulesSet1',
        ruleDefId: 'rule1',
      );
      expect(retrievedRule.id, 'rule1');
      expect(metricStoreHolder.store.isEmpty, true);
    });

    test('Retrieve Non-Existent RuleDefinition', () {
      locator.registerRulesSet(rulesSet);

      final retrievedRule = locator.getRuleDefinition(
        rulesSetId: 'rulesSet1',
        ruleDefId: 'nonExistentRule',
      );
      expect(retrievedRule.id, 'default');
      expect(metricStoreHolder.store.length, 1);
      expect(metricStoreHolder.store.aggregateAll(count).first.toJson(), {
        'key': {
          'name': ['get-rule-definition'],
          'dimensions': {
            'package': 'validomix',
            'method': 'getRuleDefinition',
            'id': 'nonExistentRule',
            'level': 'ERROR',
            'status': 'not-found',
            'unit': 'count',
            'aggregation': 'count'
          }
        },
        'value': 1.0
      });
    });

    test('Retrieve Non-Existent RuleSet', () {
      locator.registerRulesSet(rulesSet);
      locator.clearAll();

      final retrievedRule = locator.getRuleDefinition(
        rulesSetId: 'nonExistentrulesSet',
        ruleDefId: 'rule1',
      );
      expect(retrievedRule.id, 'default');
      expect(metricStoreHolder.store.length, 1);
      expect(metricStoreHolder.store.aggregateAll(count).first.toJson(), {
        'key': {
          'name': ['get-rule-set'],
          'dimensions': {
            'package': 'validomix',
            'method': 'getRuleDefinition',
            'id': 'nonExistentrulesSet',
            'level': 'ERROR',
            'status': 'not-found',
            'unit': 'count',
            'aggregation': 'count'
          }
        },
        'value': 1.0
      });
    });

    test('Clear All RulesSets', () {
      locator.registerRulesSet(rulesSet);
      locator.clearAll();

      final retrievedRule = locator.getRuleDefinition(
        rulesSetId: 'rulesSet1',
        ruleDefId: 'rule1',
      );
      expect(retrievedRule.id, 'default');
    });
  });
}
