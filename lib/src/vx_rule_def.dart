// Immutable RuleDefinition Class
class RuleDefinition {
  final String id;
  final String validatorName;
  final Map<String, String> options;

  const RuleDefinition({
    required this.id,
    required this.validatorName,
    required this.options,
  });

  // Serialize RuleDefinition to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'validatorName': validatorName,
      'options': options,
    };
  }

  // Deserialize RuleDefinition from JSON
  factory RuleDefinition.fromJson(Map<String, dynamic> json) {
    return RuleDefinition(
      id: json['id'],
      validatorName: json['validatorName'],
      options: Map<String, String>.from(json['options']),
    );
  }
}

// Immutable RulesSet Class
class RulesSet {
  final String id;
  final List<RuleDefinition> rules;

  const RulesSet({
    required this.id,
    required this.rules,
  });

  // Serialize RulesSet to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rules': rules.map((rule) => rule.toJson()).toList(),
    };
  }

  // Deserialize RulesSet from JSON
  factory RulesSet.fromJson(Map<String, dynamic> json) {
    return RulesSet(
      id: json['id'],
      rules: (json['rules'] as List)
          .map((ruleJson) => RuleDefinition.fromJson(ruleJson))
          .toList(),
    );
  }
}

// RuleDefinitionLocator Class
class RuleDefinitionLocator {
  final Map<String, RulesSet> _rulesSets = {};

  // Register a RulesSet
  void registerRulesSet(RulesSet rulesSet) {
    _rulesSets[rulesSet.id] = rulesSet;
  }

  // Retrieve a RuleDefinition by RulesSet ID and RuleDefinition ID
  RuleDefinition? getRuleDefinition(String rulesSetId, String ruleDefId) {
    final rulesSet = _rulesSets[rulesSetId];
    if (rulesSet == null) return null;
    return rulesSet.rules.firstWhere(
      (rule) => rule.id == ruleDefId,
      orElse: () => null,
    );
  }

  // Clear all RulesSets
  void clearAll() {
    _rulesSets.clear();
  }
}
