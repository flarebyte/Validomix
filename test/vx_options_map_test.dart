import 'dart:math';

import 'package:eagleyeix/metric.dart';
import 'package:test/test.dart';
import 'package:validomix/validomix.dart';

import 'vx_test_utils.dart';

void main() {
  late ExMetricStoreHolder metricStoreHolder;
  late VxOptionsInventory optionsInventory;
  late VxOptionsMap vxOptionsMap;
  late int key1;
  late int key2;
  late int key3;
  late int key4;
  late int key5;
  late int key10;
  late int key11;

  setUp(() {
    metricStoreHolder = ExMetricStoreHolder();
    optionsInventory = VxOptionsInventory();
    key1 = optionsInventory
        .addKey("ex#key1", [VxOptionsInventoryDescriptors.notBlank]);
    key2 = optionsInventory.addKey("ex#key2", []);
    key3 = optionsInventory.addKey(
        "ex#key3", VxOptionsInventoryDescriptors.positiveInt);
    key4 = optionsInventory
        .addKey("ex#key4", [VxOptionsInventoryDescriptors.boolean]);
    key5 = optionsInventory
        .addKey("ex#key5", [VxOptionsInventoryDescriptors.numeric]);
    key10 = optionsInventory
        .addKey("ex~key10", [VxOptionsInventoryDescriptors.notBlank]);
    key11 = optionsInventory.addKey("ex#key11", []);
    vxOptionsMap = VxOptionsMap(
        ownerClassName: 'OwnerClassName',
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        classSpecialisation: 'classSpecialisation');
  });

  group('VxOptionsMap Tests', () {
    test('getString returns value from options', () {
      final options = {'ex#key1': 'value1'};
      final result = vxOptionsMap.getString(options: options, id: key1);
      expect(result.value, 'value1');
      expect(result.status, VxMapValueStatus.ok);
      expect(metricStoreHolder.store.isEmpty, true);
    });

    test('getString returns default value when key is missing', () {
      final options = {'ex#key1': 'value1'};
      final result = vxOptionsMap.getString(
          options: options, id: key2, defaultValue: 'default');
      expect(result.value, 'default');
      expect(result.status, VxMapValueStatus.ko);
      expectMetricError(
          metricStoreHolder: metricStoreHolder,
          expectations: [ExMetricDimStatus.notFound]);
    });

    test('getString returns default value when optional key is missing', () {
      final options = {'other': 'value1'};
      final result = vxOptionsMap.getString(
          options: options, id: key10, defaultValue: 'default');
      expect(result.value, 'default');
      expect(result.status, VxMapValueStatus.fallback);
      expect(metricStoreHolder.store.isEmpty, true);
    });

    test('getInt returns value from options', () {
      final options = {'ex#key1': '42'};
      final result = vxOptionsMap.getInt(options: options, id: key1);
      expect(result.value, 42);
      expect(result.status, VxMapValueStatus.ok);
      expect(metricStoreHolder.store.isEmpty, true);
    });

    test('getInt positive returns value from options', () {
      final options = {'ex#key3': '42'};
      final result = vxOptionsMap.getInt(options: options, id: key3);
      expect(result.status, VxMapValueStatus.ok);
      expect(metricStoreHolder.store.isEmpty, true);
    });

    test('getInt positive should return default if value is not positive', () {
      final options = {'ex#key3': '-42'};
      final result = vxOptionsMap.getInt(options: options, id: key3);
      expect(result.status, VxMapValueStatus.ko);
      expectMetricError(
          metricStoreHolder: metricStoreHolder,
          expectations: ['positive number']);
    });

    test('getNumber positive should return default if value is not positive',
        () {
      final options = {'ex#key3': '-42'};
      final result = vxOptionsMap.getNumber(options: options, id: key3);
      expect(result.status, VxMapValueStatus.ko);
      expectMetricError(
          metricStoreHolder: metricStoreHolder,
          expectations: ['positive number']);
    });

    test('getInt returns default value when key is missing', () {
      final options = {'ex#key1': '42'};
      final result =
          vxOptionsMap.getInt(options: options, id: key2, defaultValue: 99);
      expect(result.value, 99);
      expect(result.status, VxMapValueStatus.ko);
      expectMetricError(
          metricStoreHolder: metricStoreHolder,
          expectations: [ExMetricDimStatus.notFound]);
    });

    test('getInt postive returns default value when key is negative', () {
      final options = {'ex#key3': '-42'};
      final result =
          vxOptionsMap.getInt(options: options, id: key2, defaultValue: 99);
      expect(result.value, 99);
      expect(result.status, VxMapValueStatus.ko);
      expect(metricStoreHolder.store.length, 1);
    });

    test('getNumber returns value from options', () {
      final options = {'ex#key5': '3.14'};
      final result = vxOptionsMap.getNumber(options: options, id: key5);
      expect(result.value, 3.14);
      expect(result.status, VxMapValueStatus.ok);
      expect(metricStoreHolder.store.isEmpty, true);
    });

    test('getNumber returns default value when key is missing', () {
      final options = {'ex#key1': '3.14'};
      final result = vxOptionsMap.getNumber(
          options: options, id: key2, defaultValue: 99.99);
      expect(result.value, 99.99);
      expect(result.status, VxMapValueStatus.ko);
      expectMetricError(
          metricStoreHolder: metricStoreHolder,
          expectations: [ExMetricDimStatus.notFound]);
    });

    test('getBool returns value from options', () {
      final options = {'ex#key4': 'true'};
      final result = vxOptionsMap.getBoolean(options: options, id: key4);
      expect(result.value, true);
      expect(result.status, VxMapValueStatus.ok);
      expect(metricStoreHolder.store.isEmpty, true);
    });

    test('getBool returns default value when key is missing', () {
      final options = {'ex#key1': '3.14'};
      final result = vxOptionsMap.getBoolean(
          options: options, id: key4, defaultValue: false);
      expect(result.value, false);
      expect(result.status, VxMapValueStatus.ko);
      expectMetricError(
          metricStoreHolder: metricStoreHolder,
          expectations: [ExMetricDimStatus.notFound]);
    });

    test('getStringList returns value from options', () {
      final options = {'ex#key11': 'value1,value2'};
      final result = vxOptionsMap.getStringList(
          options: options, id: key11, separator: ',');
      expect(result.status, VxMapValueStatus.ok);
      expect(metricStoreHolder.store.isEmpty, true);
      expect(result.value, ['value1', 'value2']);
    });

    test('getStringList returns default value when key is missing', () {
      final options = {'ex-no-key11': 'value1'};
      final result = vxOptionsMap.getStringList(
          options: options, id: key11, defaultValue: ['default']);
      expect(result.status, VxMapValueStatus.ko);
      expectMetricError(
          metricStoreHolder: metricStoreHolder,
          expectations: [ExMetricDimStatus.notFound]);
      expect(result.value, ['default']);
    });
  });
}
