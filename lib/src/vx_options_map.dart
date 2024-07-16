import 'package:eagleyeix/metric.dart';

import 'vx_component_name_manager.dart';
import 'vx_metrics.dart';
import 'vx_options_inventory.dart';

class VxOptionsMap {
  final VxComponentManagerConfig componentManagerConfig;
  final ExMetricStoreHolder metricStoreHolder;
  final VxOptionsInventory optionsInventory;
  final String ownerClassName;
  VxOptionsMap(
      {required this.componentManagerConfig,
      required this.metricStoreHolder,
      required this.optionsInventory,
      required this.ownerClassName});

  /// Returns the value of the option with the given id, or the default
  String getString(
      {required Map<String, String> options,
      required int id,
      String defaultValue = ''}) {
    final key = optionsInventory.getKey(id);
    final missingMandatoryKey =
        VxComponentNameManager.hasMandatoryOption(key.name) &&
            (!options.containsKey(key.name));
    if (missingMandatoryKey) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getKeyNotFound(ownerClassName, key.name), 1);
      return defaultValue;
    }
    final value = options[key.name] ?? defaultValue;
    final shouldNotBeEmpty =
        key.descriptors.contains(VxOptionsInventoryDescriptors.notBlank) &&
            value.trim() == '';
    if (shouldNotBeEmpty) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getKeyValueBlank(ownerClassName, key.name), 1);
      return defaultValue;
    }
    return value;
  }

  /// Returns the integer value of the option with the given id, or the default
  int getInt(
      {required Map<String, String> options,
      required int id,
      int defaultValue = 0}) {
    final key = optionsInventory.getKey(id);
    final missingMandatoryKey =
        VxComponentNameManager.hasMandatoryOption(key.name) &&
            (!options.containsKey(key.name));
    if (missingMandatoryKey) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getKeyNotFound(ownerClassName, key.name), 1);
      return defaultValue;
    }
    final value = options[key.name] ?? "$defaultValue";
    final intValue = int.tryParse(value);
    if (intValue == null) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getKeyValueNotInt(ownerClassName, key.name), 1);
      return defaultValue;
    }

    final shouldbePositive =
        key.descriptors.contains(VxOptionsInventoryDescriptors.positive) &&
            intValue < 0;
    if (shouldbePositive) {
      metricStoreHolder.store.addMetric(
          VxMetrics.getKeyValueNotPositive(ownerClassName, key.name), 1);
      return defaultValue;
    }
    return intValue;
  }

  ///   Returns the number value of the option with the given id, or the default
  num getNumber(
      {required Map<String, String> options,
      required int id,
      int defaultValue = 0}) {
    final key = optionsInventory.getKey(id);
    final missingMandatoryKey =
        VxComponentNameManager.hasMandatoryOption(key.name) &&
            (!options.containsKey(key.name));
    if (missingMandatoryKey) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getKeyNotFound(ownerClassName, key.name), 1);
      return defaultValue;
    }
    final value = options[key.name] ?? "$defaultValue";
    final intValue = num.tryParse(value);
    if (intValue == null) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getKeyValueNotNum(ownerClassName, key.name), 1);
      return defaultValue;
    }

    final shouldbePositive =
        key.descriptors.contains(VxOptionsInventoryDescriptors.positive) &&
            intValue < 0;
    if (shouldbePositive) {
      metricStoreHolder.store.addMetric(
          VxMetrics.getKeyValueNotPositive(ownerClassName, key.name), 1);
      return defaultValue;
    }
    return intValue;
  }

  ///   Returns the boolean value of the option with the given id, or the default
  bool getBoolean(
      {required Map<String, String> options,
      required int id,
      bool defaultValue = false}) {
    final key = optionsInventory.getKey(id);
    final missingMandatoryKey =
        VxComponentNameManager.hasMandatoryOption(key.name) &&
            (!options.containsKey(key.name));
    if (missingMandatoryKey) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getKeyNotFound(ownerClassName, key.name), 1);
      return defaultValue;
    }
    final value = options[key.name] ?? "$defaultValue";
    final boolValue = bool.tryParse(value);
    if (boolValue == null) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getKeyValueNotNum(ownerClassName, key.name), 1);
      return defaultValue;
    }

    return boolValue;
  }

  static const List<String> emptyList = [];

  /// Returns the value of the option with the given id, or the default
  List<String> getStringList(
      {required Map<String, String> options,
      required int id,
      String separator = ' ',
      List<String> defaultValue = emptyList}) {
    final key = optionsInventory.getKey(id);
    final missingMandatoryKey =
        VxComponentNameManager.hasMandatoryOption(key.name) &&
            (!options.containsKey(key.name));
    if (missingMandatoryKey) {
      metricStoreHolder.store
          .addMetric(VxMetrics.getKeyNotFound(ownerClassName, key.name), 1);
      return defaultValue;
    }
    final value = options[key.name] ?? '';
    final stringsValue = value.split(separator);
    return stringsValue;
  }
}
