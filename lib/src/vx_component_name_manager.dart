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
    _validateComponentName(name, config.componentSeparator);
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
    _validateFullOptionKey(fullOptionKey, config.mandatoryOptionSeparator,
        config.optionalOptionSeparator);
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
    _validateFullOptionKey(fullOptionKey, config.mandatoryOptionSeparator,
        config.optionalOptionSeparator);
    int separatorIndex = fullOptionKey.indexOf(config.mandatoryOptionSeparator);
    if (separatorIndex == -1) {
      separatorIndex = fullOptionKey.indexOf(config.optionalOptionSeparator);
    }
    if (separatorIndex == -1) return null;
    return fullOptionKey.substring(separatorIndex + 1);
  }

  /// Determines if a given component name is the root.
  ///
  /// Throws an [ArgumentError] if the component name is invalid.
  static bool isRoot(String name,
      [VxComponentManagerConfig config =
          VxComponentManagerConfig.defaultConfig]) {
    _validateComponentName(name, config.componentSeparator);
    return !name.contains(config.componentSeparator);
  }

  /// Constructs a full option key from a component name and an option.
  ///
  /// Throws an [ArgumentError] if the component name or option name is invalid.
  static String getFullOptionKey(String name, String option,
      [VxComponentManagerConfig config =
          VxComponentManagerConfig.defaultConfig]) {
    _validateComponentName(name, config.componentSeparator);
    _validateOptionName(option);
    return '$name${config.mandatoryOptionSeparator}$option';
  }

  /// Adds a child component to a parent component.
  ///
  /// Throws an [ArgumentError] if the parent or child component name is invalid.
  static String createChild(String parentName, String childName,
      [VxComponentManagerConfig config =
          VxComponentManagerConfig.defaultConfig]) {
    _validateComponentName(parentName, config.componentSeparator);
    _validateComponentName(childName, config.componentSeparator);
    return '$parentName${config.componentSeparator}$childName';
  }

  /// Combines two component paths.
  ///
  /// Throws an [ArgumentError] if either component path is invalid.
  static String joinPaths(String componentPath1, String componentPath2,
      [VxComponentManagerConfig config =
          VxComponentManagerConfig.defaultConfig]) {
    _validateComponentName(componentPath1, config.componentSeparator);
    _validateComponentName(componentPath2, config.componentSeparator);
    return '$componentPath1${config.componentSeparator}$componentPath2';
  }

  /// Validation for component names
  static void _validateComponentName(String name, String componentSeparator) {
    if (name.isEmpty ||
        name.contains(componentSeparator) ||
        name.trim() != name) {
      throw ArgumentError('Invalid component name: $name');
    }
  }

  /// Validation for option names
  static void _validateOptionName(String option) {
    if (option.isEmpty || option.trim() != option) {
      throw ArgumentError('Invalid option name: $option');
    }
  }

  /// Validation for full option keys
  static void _validateFullOptionKey(String fullOptionKey,
      String mandatoryOptionSeparator, String optionalOptionSeparator) {
    if (fullOptionKey.isEmpty ||
        fullOptionKey.contains(mandatoryOptionSeparator) &&
            fullOptionKey.contains(optionalOptionSeparator)) {
      throw ArgumentError('Invalid full option key: $fullOptionKey');
    }
  }
}
