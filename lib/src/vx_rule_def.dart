/// Immutable rule definition class.
class VxRuleDefinition {
  final String id;
  final String validatorName;
  final Map<String, String> options;

  /// Constructs a [VxRuleDefinition].
  const VxRuleDefinition({
    required this.id,
    required this.validatorName,
    required this.options,
  });

  /// Serializes [VxRuleDefinition] to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'validatorName': validatorName,
      'options': options,
    };
  }

  /// Deserializes [VxRuleDefinition] from JSON.
  factory VxRuleDefinition.fromJson(Map<String, dynamic> json) {
    return VxRuleDefinition(
      id: json['id'],
      validatorName: json['validatorName'],
      options: Map<String, String>.from(json['options']),
    );
  }
}

/// Immutable rules set class.
class VxRulesSet {
  final String id;
  final List<VxRuleDefinition> rules;

  /// Constructs a [VxRulesSet].
  const VxRulesSet({
    required this.id,
    required this.rules,
  });

  /// Serializes [VxRulesSet] to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rules': rules.map((rule) => rule.toJson()).toList(),
    };
  }

  /// Deserializes [VxRulesSet] from JSON.
  factory VxRulesSet.fromJson(Map<String, dynamic> json) {
    return VxRulesSet(
      id: json['id'],
      rules: (json['rules'] as List)
          .map((ruleJson) => VxRuleDefinition.fromJson(ruleJson))
          .toList(),
    );
  }
}

/// Class to manage VxRulesSet instances.
class VxRuleDefinitionLocator {
  final Map<String, VxRulesSet> _rulesSets = {};
  final VxRuleDefinition defaultRuleDef;

  /// Constructs a [VxRuleDefinitionLocator].
  VxRuleDefinitionLocator({required this.defaultRuleDef});

  /// Registers a [VxRulesSet].
  void registerRulesSet(VxRulesSet rulesSet) {
    _rulesSets[rulesSet.id] = rulesSet;
  }

  /// Retrieves a [VxRuleDefinition] by [rulesSetId] and [ruleDefId].
  /// Returns [defaultRuleDef] if the rule is not found.
  VxRuleDefinition getRuleDefinition({
    required String rulesSetId,
    required String ruleDefId,
  }) {
    final rulesSet = _rulesSets[rulesSetId];
    if (rulesSet == null) return defaultRuleDef;
    return rulesSet.rules.firstWhere(
      (rule) => rule.id == ruleDefId,
      orElse: () => defaultRuleDef,
    );
  }

  /// Clears all registered [VxRulesSet] instances.
  void clearAll() {
    _rulesSets.clear();
  }
}
