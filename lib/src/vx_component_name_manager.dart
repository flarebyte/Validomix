class VxComponentManagerConfig {
  final String componentSeparator;
  final String mandatoryOptionSeparator;
  final String optionalOptionSeparator;

  const VxComponentManagerConfig({
    this.componentSeparator = '/',
    this.mandatoryOptionSeparator = '#',
    this.optionalOptionSeparator = '~',
  });

  String getComponentSeparator([String? separator]) =>
      separator ?? componentSeparator;
  String getMandatoryOptionSeparator([String? separator]) =>
      separator ?? mandatoryOptionSeparator;
  String getOptionalOptionSeparator([String? separator]) =>
      separator ?? optionalOptionSeparator;

  static const defaultConfig = VxComponentManagerConfig();
}

class VxComponentNameManager {
  /// Retrieves the parent component from a given component name.
  ///
  /// Throws an [ArgumentError] if the component name is invalid.
  static String? getParent(String name,
      [VxComponentManagerConfig config =
          VxComponentManagerConfig.defaultConfig]) {
    _validateHierarchicalComponentName(name, config);
    int lastIndex = name.lastIndexOf(config.componentSeparator);
    if (lastIndex == -1) return null;
    return name.substring(0, lastIndex);
  }

  /// Extracts the component name from a full option key.
  ///
  /// Throws an [ArgumentError] if the full option key is invalid.
  static String getComponentName(String fullOptionKey,
      [VxComponentManagerConfig config =
          VxComponentManagerConfig.defaultConfig]) {
    _validateFullOptionKey(fullOptionKey, config);
    int separatorIndex = fullOptionKey.indexOf(config.mandatoryOptionSeparator);
    if (separatorIndex == -1) {
      separatorIndex = fullOptionKey.indexOf(config.optionalOptionSeparator);
    }
    if (separatorIndex == -1) return fullOptionKey;
    return fullOptionKey.substring(0, separatorIndex);
  }

  /// Extracts the option name from a full option key.
  ///
  /// Returns `null` if no option is found. Throws an [ArgumentError] if the full option key is invalid.
  static String? getOptionName(String fullOptionKey,
      [VxComponentManagerConfig config =
          VxComponentManagerConfig.defaultConfig]) {
    _validateFullOptionKey(fullOptionKey, config);
    int separatorIndex = fullOptionKey.indexOf(config.mandatoryOptionSeparator);
    if (separatorIndex == -1) {
      separatorIndex = fullOptionKey.indexOf(config.optionalOptionSeparator);
    }
    if (separatorIndex == -1) return null;
    return fullOptionKey.substring(separatorIndex + 1);
  }

  /// Determines if a given component name is the root.
  static bool isRoot(String name,
      [VxComponentManagerConfig config =
          VxComponentManagerConfig.defaultConfig]) {
    return !name.contains(config.componentSeparator);
  }

  /// Constructs a full option key from a component name and an option.
  ///
  /// Throws an [ArgumentError] if the component name or option name is invalid.
  static String getFullOptionKey(String name, String option,
      [VxComponentManagerConfig config =
          VxComponentManagerConfig.defaultConfig]) {
    _validateHierarchicalComponentName(name, config);
    _validateOptionName(option, config);
    return '$name${config.mandatoryOptionSeparator}$option';
  }

  /// Adds a child component to a parent component.
  ///
  /// Throws an [ArgumentError] if the parent or child component name is invalid.
  static String createChild(String parentName, String childName,
      [VxComponentManagerConfig config =
          VxComponentManagerConfig.defaultConfig]) {
    _validateHierarchicalComponentName(parentName, config);
    _validateComponentName(childName, config);
    return '$parentName${config.componentSeparator}$childName';
  }

  /// Combines two component paths.
  ///
  /// Throws an [ArgumentError] if either component path is invalid.
  static String joinPaths(String componentPath1, String componentPath2,
      [VxComponentManagerConfig config =
          VxComponentManagerConfig.defaultConfig]) {
    _validateHierarchicalComponentName(componentPath1, config);
    _validateHierarchicalComponentName(componentPath2, config);
    return '$componentPath1${config.componentSeparator}$componentPath2';
  }

  /// Validation for single component names
  static void _validateComponentName(
      String name, VxComponentManagerConfig config) {
    if (name.isEmpty ||
        name.contains(config.componentSeparator) ||
        name.contains(config.mandatoryOptionSeparator) ||
        name.contains(config.optionalOptionSeparator) ||
        name.trim() != name) {
      throw ArgumentError('Invalid component name: $name');
    }
  }

  /// Validation for hierarchical component names
  static void _validateHierarchicalComponentName(
      String name, VxComponentManagerConfig config) {
    if (name.isEmpty ||
        name.trim() != name ||
        name.contains(config.mandatoryOptionSeparator) ||
        name.contains(config.optionalOptionSeparator) ||
        name.startsWith(config.componentSeparator) ||
        name.endsWith(config.componentSeparator) ||
        name.contains(config.componentSeparator + config.componentSeparator)) {
      throw ArgumentError('Invalid hierarchical component name: $name');
    }
  }

  /// Validation for option names
  static void _validateOptionName(
      String option, VxComponentManagerConfig config) {
    if (option.isEmpty ||
        option.trim() != option ||
        option.contains(config.componentSeparator) ||
        option.contains(config.mandatoryOptionSeparator) ||
        option.contains(config.optionalOptionSeparator)) {
      throw ArgumentError('Invalid option name: $option');
    }
  }

  /// Validation for full option keys
  static void _validateFullOptionKey(
      String fullOptionKey, VxComponentManagerConfig config) {
    final isSpaceSeparator = config.componentSeparator == '';
    if (fullOptionKey.isEmpty ||
        (!isSpaceSeparator && fullOptionKey.contains(' ')) ||
        config.mandatoryOptionSeparator.allMatches(fullOptionKey).length > 1 ||
        config.optionalOptionSeparator.allMatches(fullOptionKey).length > 1 ||
        fullOptionKey.endsWith(config.mandatoryOptionSeparator) ||
        fullOptionKey.endsWith(config.optionalOptionSeparator) ||
        fullOptionKey.startsWith(config.mandatoryOptionSeparator) ||
        fullOptionKey.startsWith(config.optionalOptionSeparator) ||
        (fullOptionKey.contains(config.mandatoryOptionSeparator) &&
            fullOptionKey.contains(config.optionalOptionSeparator))) {
      throw ArgumentError('Invalid full option key: $fullOptionKey');
    }
  }
}
