import 'package:eagleyeix/metric.dart';
import 'package:test/test.dart';
import 'package:validomix/validomix.dart';

void main() {
  late ExMetricStoreHolder metricStoreHolder;
  late VxOptionsInventory optionsInventory;
  late VxOptionsMap vxOptionsMap;
  late int key1;
  late int key2;

  setUp(() {
    metricStoreHolder = ExMetricStoreHolder();
    optionsInventory = VxOptionsInventory();
    key1 = optionsInventory.addKey("key1", []);
    key2 = optionsInventory.addKey("key2", []);
    vxOptionsMap = VxOptionsMap(
        ownerClassName: 'OwnerClassName',
        metricStoreHolder: metricStoreHolder,
        optionsInventory: optionsInventory,
        classSpecialisation: 'classSpecialisation');
  });

  group('VxOptionsMap Tests', () {
    test('getString returns value from options', () {
      final options = {'key1': 'value1'};
      final result = vxOptionsMap.getString(options: options, id: key1);
      expect(result.value, 'value1');
      expect(result.status, VxMapValueStatus.ok);
    });

    test('getString returns default value when key is missing', () {
      final options = {'key1': 'value1'};
      final result = vxOptionsMap.getString(
          options: options, id: key2, defaultValue: 'default');
      expect(result.value, 'default');
      expect(result.status, VxMapValueStatus.fallback);
    });

    test('getInt returns value from options', () {
      final options = {'key1': '42'};
      final result = vxOptionsMap.getInt(options: options, id: key1);
      expect(result.value, 42);
      expect(result.status, VxMapValueStatus.ok);
    });

    test('getInt returns default value when key is missing', () {
      final options = {'key1': '42'};
      final result =
          vxOptionsMap.getInt(options: options, id: key2, defaultValue: 99);
      expect(result.value, 99);
      expect(result.status, VxMapValueStatus.fallback);
    });

    test('getNumber returns value from options', () {
      final options = {'key1': '3.14'};
      final result = vxOptionsMap.getNumber(options: options, id: key1);
      expect(result.value, 3.14);
      expect(result.status, VxMapValueStatus.ok);
    });

    test('getNumber returns default value when key is missing', () {
      final options = {'key1': '3.14'};
      final result = vxOptionsMap.getNumber(
          options: options, id: key2, defaultValue: 99.99);
      expect(result.value, 99.99);
      expect(result.status, VxMapValueStatus.fallback);
    });
  });
}
